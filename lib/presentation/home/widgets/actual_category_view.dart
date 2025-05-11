import 'package:brain_bench/business_logic/home/home_providers.dart';
import 'package:brain_bench/core/extensions/responsive_context.dart';
import 'package:brain_bench/core/hooks/actual_category_hooks.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/utils/actual_category_utils.dart';
import 'package:brain_bench/data/infrastructure/quiz/category_providers.dart';
import 'package:brain_bench/data/infrastructure/settings/shared_prefs_provider.dart';
import 'package:brain_bench/data/infrastructure/user/user_provider.dart';
import 'package:brain_bench/data/models/category/category.dart';
import 'package:brain_bench/data/models/home/displayed_category_info.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/data/models/user/user_model_state.dart';
import 'package:brain_bench/presentation/home/widgets/actual_category_content_row.dart';
import 'package:brain_bench/presentation/home/widgets/actual_category_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('ActualCategoryView');

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
    final localSelectedCategory = useState<Category?>(null);
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
    void updateSelectedCategory(Category category) async {
      localSelectedCategory.value = category;
      // Update the selected category in the provider
      final currentCategoryId = ref.read(selectedHomeCategoryProvider);
      if (currentCategoryId != category.id) {
        ref.read(selectedHomeCategoryProvider.notifier).update(category.id);
        _logger.info(
          'Updated selectedHomeCategoryProvider with ID: ${category.id}',
        );
      }
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

    final initialCategoryFromHook = useDeterminedInitialCategory(
      ref: ref,
      asyncLastSelectedIdFromPrefs: asyncLastSelectedIdFromPrefs,
      categories: categories,
      currentUser: currentUser,
      languageCode: languageCode,
      localizations: localizations,
    );

    // Set the local selected category based on the hook's result
    useEffect(() {
      if (initialCategoryFromHook != null) {
        // Update the local state only if the ID has changed
        if (localSelectedCategory.value?.id != initialCategoryFromHook.id) {
          _logger.finer(
            'View: Aktualisiere localSelectedCategory.value vom Hook: ${initialCategoryFromHook.id}',
          );
          localSelectedCategory.value = initialCategoryFromHook;
        }
      }
      return null;
    }, [initialCategoryFromHook]);

    _logger.finest(
      'Building ActualCategoryView with selected category: ${localSelectedCategory.value?.id ?? "none"}',
    );

    if (categories.isEmpty) {
      _logger.warning(
        'No categories available from backend (excluding "Automatic" option). Picker will only show "Automatic".',
      );
    }

    final DisplayedCategoryInfo displayInfo = getDisplayedCategoryInfo(
      selectedCategoryValue: localSelectedCategory.value,
      backendCategories: categories,
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
                currentSelectedCategory: localSelectedCategory.value,
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
