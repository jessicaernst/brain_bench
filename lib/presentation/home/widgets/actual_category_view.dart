import 'dart:io' show Platform;

import 'package:brain_bench/core/extensions/responsive_context.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/shared_widgets/pickers/cupertino_picker_content.dart';
import 'package:brain_bench/core/shared_widgets/pickers/material_list_picker.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/data/infrastructure/settings/shared_prefs_provider.dart'; // Importiere deinen Provider
import 'package:brain_bench/data/infrastructure/quiz/category_providers.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/category/category.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/models/user/user_model_state.dart';
import 'package:brain_bench/presentation/home/widgets/actual_category_content_row.dart';
import 'package:brain_bench/presentation/home/widgets/actual_category_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger('ActualCategoryView');

/// A widget that displays the actual category view.
class ActualCategoryView extends HookConsumerWidget {
  const ActualCategoryView({super.key, required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Retrieve the current language code and localizations from the context
    final String languageCode = Localizations.localeOf(context).languageCode;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    // Retrieve the async categories and user model state using hooks
    final asyncCategories = ref.watch(categoriesProvider(languageCode));
    final userModelState = ref.watch(currentUserModelProvider);
    final selectedCategory = useState<Category?>(null);

    // Determine the size and spacing based on the screen size
    final bool isSmallScreenValue = context.isSmallScreen;
    final double dashSize = isSmallScreenValue ? 90 : 118;
    final double verticalSpacing = isSmallScreenValue ? 8 : 16;
    final int descriptionMaxLines = isSmallScreenValue ? 2 : 3;

    // Update the selected category
    // Define and memoize the "Automatic" category option
    final automaticCategory = useMemoized(() {
      return Category(
        id: '___automatic___',
        nameEn: localizations.pickerOptionAutomatic,
        nameDe: localizations.pickerOptionAutomatic,
        descriptionEn: localizations.pickerOptionAutomaticDescription,
        descriptionDe: localizations.pickerOptionAutomaticDescription,
        subtitleEn: '',
        subtitleDe: '',
      );
    }, [localizations]); // Re-memoize if localizations change

    // Update the selected category and save its ID using SettingsRepository
    void updateSelectedCategory(Category category) async {
      selectedCategory.value = category;
      try {
        final settingsRepo = ref.read(settingsRepositoryProvider);
        await settingsRepo.saveLastSelectedCategoryId(category.id);
        _logger.info(
          'Saved last selected category ID via Repository: ${category.id}',
        );
      } catch (e) {
        _logger.warning(
          'Failed to save last selected category ID via Repository: $e',
        );
      }
    }

    // Show the category picker
    void showCategoryPicker(BuildContext context, List<Category> categories) {
      _logger.finer('Category picker opened.');
      // Prepend the "Automatic" option to the list of categories
      final List<Category> pickerItems = [automaticCategory, ...categories];

      final Color pickerBackgroundColor =
          isDarkMode ? BrainBenchColors.deepDive : BrainBenchColors.cloudCanvas;
      final Color pickerDoneButtonColor =
          isDarkMode
              ? BrainBenchColors.flutterSky
              : BrainBenchColors.blueprintBlue;

      if (Platform.isIOS) {
        showCupertinoModalPopup<void>(
          context: context,
          builder:
              (BuildContext popupContext) => CupertinoPickerContent<Category>(
                // Use pickerItems
                items: pickerItems,
                initialSelectedItem: selectedCategory.value,
                itemDisplayNameBuilder:
                    (Category cat) =>
                        languageCode == 'de' ? cat.nameDe : cat.nameEn,
                onConfirmed: (Category cat) {
                  _logger.info(
                    'Category selected via iOS picker: ${cat.id} - ${languageCode == 'de' ? cat.nameDe : cat.nameEn}',
                  );
                  updateSelectedCategory(cat);
                  Navigator.pop(popupContext);
                },
                localizations: localizations,
                doneButtonColor: pickerDoneButtonColor,
                backgroundColor: pickerBackgroundColor,
              ),
        );
      } else {
        showModalBottomSheet<void>(
          context: context,
          backgroundColor: pickerBackgroundColor,
          builder: (BuildContext sheetContext) {
            return MaterialListPicker<Category>(
              items: pickerItems, // Use pickerItems
              selectedItem: selectedCategory.value,
              itemDisplayNameBuilder:
                  (Category cat) =>
                      languageCode == 'de' ? cat.nameDe : cat.nameEn,
              onItemSelected: (Category cat) {
                _logger.info(
                  'Category selected via Android picker: ${cat.id} - ${languageCode == 'de' ? cat.nameDe : cat.nameEn}',
                );
                updateSelectedCategory(cat);
                Navigator.pop(sheetContext);
              },
              itemEqualityComparer: (Category? selectedCat, Category listCat) {
                if (selectedCat == null) return false;
                return selectedCat.id == listCat.id;
              },
            );
          },
        );
      }
    }

    // Handle loading and error states
    if (asyncCategories.isLoading || userModelState.isLoading) {
      _logger.finer('Loading categories or user data...');
      return SizedBox(
        height: dashSize + 80,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (asyncCategories.hasError) {
      // Log the detailed error internally
      _logger.severe(
        'Error loading categories in ActualCategoryView',
        asyncCategories.error,
        asyncCategories.stackTrace,
      );
      return Center(
        // Log the detailed error internally
        child: Text(localizations.genericErrorMessage),
      );
    }

    // Retrieve the categories and current user
    final List<Category> categories = asyncCategories.value ?? [];
    final AppUser? currentUser = switch (userModelState) {
      AsyncData(value: UserModelData(:final user)) => user,
      _ => null,
    };

    // Initialize selectedCategory when categories are first loaded and no category is selected yet.
    useEffect(
      () {
        // This effect runs when the component mounts or its dependencies change.
        // It sets an initial category if `selectedCategory.value` is currently null.
        if (selectedCategory.value == null) {
          // Define an async function to perform the loading and state update
          Future<void> loadAndSetInitialCategory() async {
            if (!context.mounted) return; // Check mounted at the beginning

            Category? categoryToSet;
            final settingsRepo = ref.read(settingsRepositoryProvider);
            final String? lastSelectedId =
                await settingsRepo.loadLastSelectedCategoryId();

            // Create a combined list of all available categories for lookup
            // This includes "Automatic" and categories from the backend
            final List<Category> allAvailablePickerItems = [
              automaticCategory,
              ...categories, // categories from asyncCategories.value
            ];

            if (lastSelectedId != null) {
              try {
                categoryToSet = allAvailablePickerItems.firstWhere(
                  (cat) => cat.id == lastSelectedId,
                );
                _logger.info(
                  'Initial category set from SharedPreferences (via Repo): ${categoryToSet.id} - ${languageCode == 'de' ? categoryToSet.nameDe : categoryToSet.nameEn}',
                );
              } catch (e) {
                _logger.warning(
                  'Last selected category ID "$lastSelectedId" from SharedPreferences (via Repo) not found in current picker items. Clearing pref.',
                );
                await settingsRepo.clearLastSelectedCategoryId(); // Clean up
              }
            }

            // Fallback logic if not found in SharedPreferences
            if (categoryToSet == null) {
              // Optional: Fallback to lastPlayedCategoryId from currentUser
              final String? lastPlayedIdFromUser =
                  currentUser?.lastPlayedCategoryId;
              if (lastPlayedIdFromUser != null && categories.isNotEmpty) {
                // only search in backend categories
                try {
                  categoryToSet = categories.firstWhere(
                    (cat) => cat.id == lastPlayedIdFromUser,
                  );
                  _logger.info(
                    'Initial category set from last played (user data): ${categoryToSet.id} - ${languageCode == 'de' ? categoryToSet.nameDe : categoryToSet.nameEn}',
                  );
                } catch (e) {
                  _logger.warning(
                    'Last played category ID "$lastPlayedIdFromUser" from user data not found in current backend categories.',
                  );
                }
              }
              // If still no category, default to "Automatic"
              categoryToSet ??= automaticCategory;
              _logger.info(
                'Initial category (after fallbacks) set to: ${categoryToSet.id} - ${languageCode == 'de' ? categoryToSet.nameDe : categoryToSet.nameEn}',
              );
            }

            // Final check before setting state
            if (context.mounted && selectedCategory.value == null) {
              selectedCategory.value = categoryToSet;
            }
          }

          loadAndSetInitialCategory();
        }
        return null; // No cleanup needed for this effect.
      },
      [
        selectedCategory.value,
        automaticCategory,
        categories, // Re-evaluate if backend categories change
        currentUser, // Re-evaluate if user (and thus lastPlayedCategoryId) changes
        ref, // To ensure ref.read can be safely used if the effect re-runs
      ], // Add automaticCategory to dependencies
    ); // Re-run if categories or selectedCategory.value changes

    _logger.finest(
      'Building ActualCategoryView with selected category: ${selectedCategory.value?.id ?? "none"}',
    );

    // Log if backend categories are empty, but don't return early
    if (categories.isEmpty) {
      _logger.warning(
        'No categories available from backend (excluding "Automatic" option). Picker will only show "Automatic".',
      );
    }

    // Retrieve the displayed category name, description, and progress
    String displayedCategoryName;
    String displayedDescription;
    double displayedProgress;

    if (selectedCategory.value == null) {
      displayedCategoryName = localizations.statusLoadingLabel;
      displayedDescription = localizations.homeActualCategoryDescriptionPrompt;
      displayedProgress = 0.0;
    } else if (selectedCategory.value!.id == automaticCategory.id) {
      displayedCategoryName =
          languageCode == 'de'
              ? automaticCategory.nameDe
              : automaticCategory.nameEn;
      displayedDescription =
          languageCode == 'de'
              ? automaticCategory.descriptionDe
              : automaticCategory.descriptionEn;
      displayedProgress = 0.0;
    } else {
      displayedCategoryName =
          languageCode == 'de'
              ? selectedCategory.value!.nameDe
              : selectedCategory.value!.nameEn;
      displayedDescription =
          languageCode == 'de'
              ? selectedCategory.value!.descriptionDe
              : selectedCategory.value!.descriptionEn;
      displayedProgress =
          (currentUser != null)
              ? (currentUser.categoryProgress[selectedCategory.value!.id] ??
                  0.0)
              : 0.0;
    }

    // Build the actual category view
    return Column(
      children: [
        ActualCategoryHeader(
          localizations: localizations,
          verticalSpacing: verticalSpacing,
          isDarkMode: isDarkMode,
        ),
        SizedBox(height: verticalSpacing),
        ActualCategoryContentRow(
          displayedProgress: displayedProgress,
          dashSize: dashSize,
          displayedCategoryName: displayedCategoryName,
          displayedDescription: displayedDescription,
          descriptionMaxLines: descriptionMaxLines,
          isDarkMode: isDarkMode,
          onSwitchCategoryPressed:
              () => showCategoryPicker(context, categories),
        ),
      ],
    );
  }
}
