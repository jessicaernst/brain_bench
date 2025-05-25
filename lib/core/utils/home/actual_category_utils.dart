import 'dart:io' show Platform;

import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/shared_widgets/pickers/cupertino_picker_content.dart';
import 'package:brain_bench/core/shared_widgets/pickers/material_list_picker.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/data/infrastructure/settings/shared_prefs_provider.dart';
import 'package:brain_bench/data/models/category/category.dart';
import 'package:brain_bench/data/models/category/category_extensions.dart';
import 'package:brain_bench/data/models/home/displayed_category_info.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger('ActualCategoryUtils');

/// Creates a minimal, hardcoded "welcome" category.
///
/// This is used as a fallback if the "welcome" category cannot be loaded
/// from the backend. It uses localized strings provided by [localizations].
Category _createMinimalWelcomeCategory(AppLocalizations localizations) {
  return Category(
    id: 'welcome',
    nameEn: localizations.pickerOptionAutomatic,
    nameDe: localizations.pickerOptionAutomatic,
    descriptionEn: localizations.pickerOptionAutomaticDescription,
    descriptionDe: localizations.pickerOptionAutomaticDescription,
    subtitleEn: 'Your starting point & quiz guide',
    subtitleDe: 'Dein Startpunkt & Quiz-Leitfaden',
  );
}

/// Determines the initial category to be displayed.
///
/// This function prioritizes:
/// 1. The category ID stored in shared preferences ([loadedLastSelectedIdFromPrefs]).
/// 2. The `lastPlayedCategoryId` from the [currentUser].
/// 3. Defaults to an effective "welcome" category, which is either fetched
///    from [backendCategories] or created using [_createMinimalWelcomeCategory]
///    with the provided [localizations].
///
/// Uses [languageCode] for display purposes and [ref] to access repositories if needed.
/// Returns the determined [Category] or `null` if no suitable category can be found
/// (though it aims to always return the effective welcome category as a last resort).
Future<Category?> determineInitialCategory({
  required String? loadedLastSelectedIdFromPrefs,
  required List<Category> backendCategories,
  required AppUser? currentUser,
  required String languageCode,
  required AppLocalizations localizations,
  required WidgetRef ref,
}) async {
  Category? categoryToSet;
  final String? lastSelectedId = loadedLastSelectedIdFromPrefs;

  // Find the "welcome" category from the backend list
  Category? welcomeCategoryFromDB;
  try {
    welcomeCategoryFromDB = backendCategories.firstWhere(
      (cat) => cat.id == 'welcome',
    );
  } catch (e) {
    _logger.warning(
      'Welcome category with ID "welcome" not found in backend categories. This might lead to unexpected behavior if it is expected to always exist.',
    );
  }

  final Category effectiveWelcomeCategory =
      welcomeCategoryFromDB ?? _createMinimalWelcomeCategory(localizations);

  final List<Category> allAvailablePickerItems = [
    effectiveWelcomeCategory,
    ...backendCategories.where((cat) => cat.id != 'welcome'),
  ];

  if (lastSelectedId != null) {
    try {
      categoryToSet = allAvailablePickerItems.firstWhere(
        (cat) => cat.id == lastSelectedId,
      );
      _logger.info(
        'Category to set from SharedPreferences (via Repo): ${categoryToSet.id} - ${categoryToSet.localizedName(languageCode)}',
      );
    } catch (e) {
      final settingsRepo = ref.read(settingsRepositoryProvider);
      _logger.warning(
        'Last selected category ID "$lastSelectedId" from SharedPreferences (via Repo) not found in current picker items. Clearing pref.',
      );
      await settingsRepo.clearLastSelectedCategoryId();
    }
  }

  if (categoryToSet == null) {
    final String? lastPlayedIdFromUser = currentUser?.lastPlayedCategoryId;
    if (lastPlayedIdFromUser != null && backendCategories.isNotEmpty) {
      try {
        categoryToSet = backendCategories.firstWhere(
          (cat) => cat.id == lastPlayedIdFromUser,
        );
        _logger.info(
          'Category to set from last played (user data): ${categoryToSet.id} - ${categoryToSet.localizedName(languageCode)}',
        );
      } catch (e) {
        _logger.warning(
          'Last played category ID "$lastPlayedIdFromUser" from user data not found in current backend categories.',
        );
      }
    }
    // Default to the effective welcome category
    categoryToSet ??= effectiveWelcomeCategory;
    _logger.info(
      'Category to set (after fallbacks): ${categoryToSet.id} - ${categoryToSet.localizedName(languageCode)}',
    );
  }
  return categoryToSet;
}

/// Displays a platform-adaptive category picker.
///
/// Shows a Cupertino-style picker on iOS and a Material-style bottom sheet
/// on other platforms.
/// The picker lists [currentCategories], ensuring the "welcome" category
/// (either from [currentCategories] or a minimal fallback created using [localizations])
/// is always an option, typically at the top.
///
/// - [context]: The build context.
/// - [currentCategories]: The list of categories fetched from the backend.
/// - [currentSelectedCategory]: The category currently selected, to pre-select in the picker.
/// - [languageCode]: The current language code for displaying category names.
/// - [localizations]: For localized strings like "Done" button text.
/// - [isDarkMode]: To style the picker according to the current theme.
/// - [onCategorySelected]: Callback invoked when a category is chosen.
void showActualCategoryPicker({
  required BuildContext context,
  required List<Category> currentCategories,
  required Category? currentSelectedCategory,
  required String languageCode,
  required AppLocalizations localizations,
  required bool isDarkMode,
  required void Function(Category) onCategorySelected,
}) {
  _logger.finer('Category picker opened.');

  Category effectiveWelcomeCategory; // Made non-final
  // Create a mutable copy to avoid modifying the original list from the provider
  final List<Category> otherCategories = List.from(currentCategories);

  try {
    // Try to find the "welcome" category from the provided currentCategories
    final Category welcomeCategoryFromDB = otherCategories.firstWhere(
      (cat) => cat.id == 'welcome',
    );
    // Remove it from otherCategories to avoid duplication if found
    otherCategories.removeWhere((cat) => cat.id == 'welcome');
    effectiveWelcomeCategory = welcomeCategoryFromDB;
  } catch (e) {
    _logger.finer(
      'Welcome category not found in currentCategories for picker.',
    );
    // If not found in DB, we will use a minimal hardcoded one for the picker
    effectiveWelcomeCategory = _createMinimalWelcomeCategory(localizations);
  }

  final List<Category> pickerItems = [
    effectiveWelcomeCategory,
    ...otherCategories,
  ];

  final Color pickerBackgroundColor =
      isDarkMode ? BrainBenchColors.deepDive : BrainBenchColors.cloudCanvas;
  final Color pickerDoneButtonColor =
      isDarkMode ? BrainBenchColors.flutterSky : BrainBenchColors.blueprintBlue;

  if (Platform.isIOS) {
    showCupertinoModalPopup<void>(
      context: context,
      builder:
          (BuildContext popupContext) => CupertinoPickerContent<Category>(
            items: pickerItems,
            initialSelectedItem: currentSelectedCategory,
            itemDisplayNameBuilder:
                (Category cat) => cat.localizedName(languageCode),
            onConfirmed: (Category cat) {
              _logger.info(
                'Category selected via iOS picker: ${cat.id} - ${cat.localizedName(languageCode)}',
              );
              onCategorySelected(cat);
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
          items: pickerItems,
          selectedItem: currentSelectedCategory,
          itemDisplayNameBuilder:
              (Category cat) => cat.localizedName(languageCode),
          onItemSelected: (Category cat) {
            _logger.info(
              'Category selected via Android picker: ${cat.id} - ${cat.localizedName(languageCode)}',
            );
            onCategorySelected(cat);
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

/// Computes display-friendly information for a given category.
///
/// If [selectedCategoryValue] is `null`, it returns loading/prompt information.
/// If [selectedCategoryValue] is the "welcome" category, it uses details from
/// an effective "welcome" category (from [backendCategories] or a minimal fallback
/// created using [localizations]).
/// Otherwise, it uses details from [selectedCategoryValue] and calculates progress
/// based on [currentUser]'s data.
DisplayedCategoryInfo getDisplayedCategoryInfo({
  required Category? selectedCategoryValue,
  required List<Category> backendCategories,
  required AppUser? currentUser,
  required AppLocalizations localizations,
  required String languageCode,
}) {
  String name;
  String description;
  double progress;

  Category effectiveWelcomeCategory;

  try {
    // Try to find the "welcome" category from the backend list
    final Category welcomeCategoryFromDB = backendCategories.firstWhere(
      (cat) => cat.id == 'welcome',
    );
    effectiveWelcomeCategory = welcomeCategoryFromDB; // Use the one from DB
  } catch (e) {
    _logger.finer('Welcome category not found for display info generation.');
    // If not found in DB, we will use a minimal hardcoded one
    effectiveWelcomeCategory = _createMinimalWelcomeCategory(
      localizations,
    ); // Assign fallback here
  }

  if (selectedCategoryValue == null) {
    name = localizations.statusLoadingLabel;
    description = localizations.homeActualCategoryDescriptionPrompt;
    progress = 0.0;
  } else if (selectedCategoryValue.id == 'welcome' &&
      effectiveWelcomeCategory.id == 'welcome') {
    name = effectiveWelcomeCategory.localizedName(languageCode);
    description = effectiveWelcomeCategory.localizedDescription(languageCode);
    progress = 0.0;
  } else {
    name = selectedCategoryValue.localizedName(languageCode);
    description = selectedCategoryValue.localizedDescription(languageCode);
    progress =
        (currentUser != null)
            ? (currentUser.categoryProgress[selectedCategoryValue.id] ?? 0.0)
            : 0.0;
  }
  return DisplayedCategoryInfo(
    name: name,
    description: description,
    progress: progress,
  );
}
