import 'package:brain_bench/core/extensions/responsive_context.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/data/infrastructure/quiz/category_providers.dart';
import 'package:brain_bench/data/infrastructure/settings/shared_prefs_provider.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/category/category.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/models/user/user_model_state.dart';
import 'package:brain_bench/presentation/home/models/displayed_category_info.dart';
import 'package:brain_bench/presentation/home/utils/actual_category_utils.dart';
import 'package:brain_bench/presentation/home/widgets/actual_category_content_row.dart';
import 'package:brain_bench/presentation/home/widgets/actual_category_header.dart';
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
    // Watch the new provider for the ID from SharedPreferences
    final asyncLastSelectedIdFromPrefs = ref.watch(
      lastSelectedCategoryIdFromPrefsProvider,
    );

    // Determine the size and spacing based on the screen size
    final bool isSmallScreenValue = context.isSmallScreen;
    final double dashSize = isSmallScreenValue ? 90 : 118;
    final double verticalSpacing = isSmallScreenValue ? 8 : 16;
    final int descriptionMaxLines = isSmallScreenValue ? 2 : 3;

    // Update the selected category
    final welcomeCategory = useMemoized(() {
      return Category(
        id: '___welcome___',
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

    useEffect(
      () {
        // This effect runs when the component mounts or its dependencies change.
        // It sets an initial category or updates it based on SharedPreferences or user data.
        // Check if the last selected ID from preferences is loaded
        // and if the selected category is not already set.
        asyncLastSelectedIdFromPrefs.whenData((loadedLastSelectedIdFromPrefs) {
          // Call the outsourced logic
          determineInitialCategory(
            // Use the imported function
            loadedLastSelectedIdFromPrefs: loadedLastSelectedIdFromPrefs,
            automaticCategory: welcomeCategory,
            backendCategories: categories,
            currentUser: currentUser,
            languageCode: languageCode,
            ref: ref,
          ).then((categoryToSet) {
            if (!context.mounted) return;
            if (categoryToSet != null) {
              if (selectedCategory.value == null ||
                  selectedCategory.value!.id != categoryToSet.id) {
                _logger.finer(
                  'Updating selectedCategory.value to: ${categoryToSet.id}',
                );
                selectedCategory.value = categoryToSet;
              }
            }
          });
        });
        return null;
      },
      [
        asyncLastSelectedIdFromPrefs,
        welcomeCategory,
        categories,
        currentUser,
        ref,
      ],
    );

    _logger.finest(
      'Building ActualCategoryView with selected category: ${selectedCategory.value?.id ?? "none"}',
    );

    if (categories.isEmpty) {
      _logger.warning(
        'No categories available from backend (excluding "Automatic" option). Picker will only show "Automatic".',
      );
    }

    final DisplayedCategoryInfo displayInfo = getDisplayedCategoryInfo(
      selectedCategoryValue: selectedCategory.value,
      automaticCategory: welcomeCategory,
      currentUser: currentUser,
      localizations: localizations,
      languageCode: languageCode,
    );

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
          displayedProgress: displayInfo.progress,
          dashSize: dashSize,
          displayedCategoryName: displayInfo.name,
          displayedDescription: displayInfo.description,
          descriptionMaxLines: descriptionMaxLines,
          isDarkMode: isDarkMode,
          onSwitchCategoryPressed:
              () => showActualCategoryPicker(
                context: context,
                currentCategories: categories,
                automaticCategory: welcomeCategory,
                currentSelectedCategory: selectedCategory.value,
                languageCode: languageCode,
                localizations: localizations,
                isDarkMode: isDarkMode,
                onCategorySelected: updateSelectedCategory,
              ),
        ),
      ],
    );
  }
}
