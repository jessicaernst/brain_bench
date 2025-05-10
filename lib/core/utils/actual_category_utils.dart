import 'dart:io' show Platform;

import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/shared_widgets/pickers/cupertino_picker_content.dart';
import 'package:brain_bench/core/shared_widgets/pickers/material_list_picker.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/data/infrastructure/settings/shared_prefs_provider.dart';
import 'package:brain_bench/data/models/category/category.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:brain_bench/presentation/home/models/displayed_category_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger('ActualCategoryUtils');

/// Determines the initial category based on the loaded last selected ID from preferences,
/// the automatic category, the backend categories, the current user, the language code,
/// and the widget reference.
/// Returns the determined category.
Future<Category?> determineInitialCategory({
  required String? loadedLastSelectedIdFromPrefs,
  required List<Category> backendCategories,
  required AppUser? currentUser,
  required String languageCode,
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

  final List<Category> allAvailablePickerItems = [
    if (welcomeCategoryFromDB != null) welcomeCategoryFromDB,
    ...backendCategories,
  ];

  if (lastSelectedId != null) {
    try {
      categoryToSet = allAvailablePickerItems.firstWhere(
        (cat) => cat.id == lastSelectedId,
      );
      _logger.info(
        'Category to set from SharedPreferences (via Repo): ${categoryToSet.id} - ${languageCode == 'de' ? categoryToSet.nameDe : categoryToSet.nameEn}',
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
          'Category to set from last played (user data): ${categoryToSet.id} - ${languageCode == 'de' ? categoryToSet.nameDe : categoryToSet.nameEn}',
        );
      } catch (e) {
        _logger.warning(
          'Last played category ID "$lastPlayedIdFromUser" from user data not found in current backend categories.',
        );
      }
    }
    // Default to welcome category from DB if available, otherwise null (caller should handle)
    categoryToSet ??= welcomeCategoryFromDB;
    _logger.info(
      'Category to set (after fallbacks): ${categoryToSet?.id} - ${languageCode == 'de' ? categoryToSet?.nameDe : categoryToSet?.nameEn}',
    );
  }
  return categoryToSet;
}

/// Shows the actual category picker.
/// Requires the build context, current categories, automatic category, current selected category,
/// language code, localizations, isDarkMode flag, and the onCategorySelected callback.
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

  // Find the "welcome" category from the backend list to potentially place it first
  Category? welcomeCategoryFromDB;
  // Create a mutable copy to avoid modifying the original list from the provider
  final List<Category> otherCategories = List.from(currentCategories);
  try {
    welcomeCategoryFromDB = otherCategories.firstWhere(
      (cat) => cat.id == 'welcome',
    );
    // Remove it from otherCategories to avoid duplication if found
    otherCategories.removeWhere((cat) => cat.id == 'welcome');
  } catch (e) {
    _logger.finer(
      'Welcome category not found in currentCategories for picker.',
    );
  }

  final List<Category> pickerItems = [
    if (welcomeCategoryFromDB != null) welcomeCategoryFromDB,
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
                (Category cat) =>
                    languageCode == 'de' ? cat.nameDe : cat.nameEn,
            onConfirmed: (Category cat) {
              _logger.info(
                'Category selected via iOS picker: ${cat.id} - ${languageCode == 'de' ? cat.nameDe : cat.nameEn}',
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
              (Category cat) => languageCode == 'de' ? cat.nameDe : cat.nameEn,
          onItemSelected: (Category cat) {
            _logger.info(
              'Category selected via Android picker: ${cat.id} - ${languageCode == 'de' ? cat.nameDe : cat.nameEn}',
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

/// Retrieves the displayed category information based on the selected category value,
/// automatic category, current user, localizations, and language code.
/// Returns the displayed category information.
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

  // Find the "welcome" category from the backend list
  Category? welcomeCategoryFromDB;
  try {
    welcomeCategoryFromDB = backendCategories.firstWhere(
      (cat) => cat.id == 'welcome',
    );
  } catch (e) {
    _logger.finer('Welcome category not found for display info generation.');
  }

  if (selectedCategoryValue == null) {
    name = localizations.statusLoadingLabel;
    description = localizations.homeActualCategoryDescriptionPrompt;
    progress = 0.0;
  } else if (selectedCategoryValue.id == 'welcome' &&
      welcomeCategoryFromDB != null) {
    name =
        languageCode == 'de'
            ? welcomeCategoryFromDB.nameDe
            : welcomeCategoryFromDB.nameEn;
    description =
        languageCode == 'de'
            ? welcomeCategoryFromDB.descriptionDe
            : welcomeCategoryFromDB.descriptionEn;
    progress = 0.0;
  } else {
    name =
        languageCode == 'de'
            ? selectedCategoryValue.nameDe
            : selectedCategoryValue.nameEn;
    description =
        languageCode == 'de'
            ? selectedCategoryValue.descriptionDe
            : selectedCategoryValue.descriptionEn;
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
