import 'package:brain_bench/business_logic/home/home_providers.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/utils/home/actual_category_utils.dart';
import 'package:brain_bench/data/models/category/category.dart';
import 'package:brain_bench/data/models/user/app_user.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('useDeterminedInitialCategory');

/// Determines the initial category based on the provided parameters.
///
/// This hook retrieves the last selected category ID from preferences and uses it to determine the initial category.
/// It takes into account the backend categories, the current user, the language code, and the localizations.
/// The determined category is then set as the value of the [determinedCategoryState] state.
/// Additionally, it updates the selected home category provider with the initial category ID.
///
/// Parameters:
/// - [ref]: The [WidgetRef] used for dependency injection.
/// - [asyncLastSelectedIdFromPrefs]: An [AsyncValue] representing the last selected category ID retrieved from preferences.
/// - [categories]: A list of [Category] objects representing the backend categories.
/// - [currentUser]: An [AppUser] object representing the current user.
/// - [languageCode]: A [String] representing the language code.
/// - [localizations]: An [AppLocalizations] object representing the localizations.
///
/// Returns:
/// The determined initial [Category] or `null` if it couldn't be determined.
/// This hook is useful for initializing the selected category in a widget.
Category? useDeterminedInitialCategory({
  required WidgetRef ref,
  required AsyncValue<String?> asyncLastSelectedIdFromPrefs,
  required List<Category> categories,
  required AppUser? currentUser,
  required String languageCode,
  required AppLocalizations localizations,
}) {
  final determinedCategoryState = useState<Category?>(null);

  final context = useContext();

  useEffect(
    () {
      asyncLastSelectedIdFromPrefs.whenData((loadedLastSelectedIdFromPrefs) {
        determineInitialCategory(
          loadedLastSelectedIdFromPrefs: loadedLastSelectedIdFromPrefs,
          backendCategories: categories,
          currentUser: currentUser,
          languageCode: languageCode,
          localizations: localizations,
          ref: ref,
        ).then((categoryToSet) {
          if (!context.mounted) return;

          if (categoryToSet != null) {
            if (determinedCategoryState.value?.id != categoryToSet.id) {
              _logger.finer(
                'Hook: Aktualisiere determinedCategoryState.value auf: ${categoryToSet.id}',
              );
              determinedCategoryState.value = categoryToSet;
            }

            final currentGlobalCategoryId = ref.read(
              selectedHomeCategoryProvider,
            );
            if (currentGlobalCategoryId != categoryToSet.id) {
              ref
                  .read(selectedHomeCategoryProvider.notifier)
                  .update(categoryToSet.id);
              _logger.info(
                'Hook: selectedHomeCategoryProvider mit initialer ID aktualisiert: ${categoryToSet.id}',
              );
            }
          }
        });
      });
      return null;
    },
    [
      asyncLastSelectedIdFromPrefs,
      categories,
      currentUser,
      languageCode,
      localizations,
      ref,
      context,
    ],
  );

  return determinedCategoryState.value;
}
