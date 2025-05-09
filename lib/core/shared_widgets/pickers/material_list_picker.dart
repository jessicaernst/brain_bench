import 'package:flutter/material.dart';

/// A material design list picker widget that allows the user to select an item from a list.
class MaterialListPicker<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final String Function(T item) itemDisplayNameBuilder;
  final ValueChanged<T> onItemSelected;
  final Color? selectedTileColor;
  final Color? backgroundColor;
  final bool Function(T? currentSelectedItem, T listItem)? itemEqualityComparer;

  /// Creates a [MaterialListPicker] widget.
  ///
  /// The [items] parameter is a list of items to display in the picker.
  /// The [selectedItem] parameter is the currently selected item.
  /// The [itemDisplayNameBuilder] parameter is a function that returns the display name for an item.
  /// The [onItemSelected] parameter is a callback function that is called when an item is selected.
  /// The [selectedTileColor] parameter is the color of the selected item tile.
  /// The [backgroundColor] parameter is the background color of the picker.
  /// The [itemEqualityComparer] parameter is a function that determines if two items are equal.
  const MaterialListPicker({
    super.key,
    required this.items,
    this.selectedItem,
    required this.itemDisplayNameBuilder,
    required this.onItemSelected,
    this.selectedTileColor,
    this.backgroundColor,
    this.itemEqualityComparer,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle defaultTextStyle =
        Theme.of(context).textTheme.bodyMedium ?? const TextStyle();

    return Container(
      color:
          backgroundColor ?? Theme.of(context).bottomSheetTheme.backgroundColor,
      child: SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            final item = items[index];
            bool isActuallySelected;
            if (itemEqualityComparer != null) {
              isActuallySelected = itemEqualityComparer!(selectedItem, item);
            } else {
              isActuallySelected = selectedItem == item;
            }
            return ListTile(
              title: Text(
                itemDisplayNameBuilder(item),
                style: defaultTextStyle,
              ),
              onTap: () => onItemSelected(item),
              selected: isActuallySelected,
              selectedTileColor:
                  selectedTileColor ??
                  Theme.of(context).primaryColor.withAlpha((0.1 * 255).toInt()),
            );
          },
        ),
      ),
    );
  }
}
