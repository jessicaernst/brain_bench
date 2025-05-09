import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A widget that represents the content of a CupertinoPicker.
///
/// This widget displays a list of items in a scrollable picker view. It allows the user to select an item and confirms the selection when the done button is pressed.
class CupertinoPickerContent<T> extends StatefulWidget {
  final List<T> items;
  final T? initialSelectedItem;
  final String Function(T item) itemDisplayNameBuilder;
  final ValueChanged<T> onConfirmed;
  final AppLocalizations localizations;
  final Color doneButtonColor;
  final Color backgroundColor;
  final Color? selectedItemHighlightColor;

  const CupertinoPickerContent({
    super.key,
    required this.items,
    this.initialSelectedItem,
    required this.itemDisplayNameBuilder,
    required this.onConfirmed,
    required this.localizations,
    required this.doneButtonColor,
    required this.backgroundColor,
    this.selectedItemHighlightColor,
  });

  @override
  State<CupertinoPickerContent<T>> createState() =>
      _CupertinoPickerContentState<T>();
}

class _CupertinoPickerContentState<T> extends State<CupertinoPickerContent<T>> {
  late T _tempSelectedItem;

  @override
  void initState() {
    super.initState();
    final T? initialItem = widget.initialSelectedItem;
    if (initialItem != null && widget.items.contains(initialItem)) {
      _tempSelectedItem = initialItem;
    } else if (widget.items.isNotEmpty) {
      _tempSelectedItem = widget.items.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return Container(
        height: 300,
        color: widget.backgroundColor,
        child: Center(
          child: Text(widget.localizations.homeActualCategoryNoCategories),
        ),
      );
    }

    int currentPickerIndex = widget.items.indexOf(_tempSelectedItem);
    if (currentPickerIndex == -1 && widget.items.isNotEmpty) {
      currentPickerIndex = 0;
      _tempSelectedItem = widget.items.first;
    }

    // TextStyle for non-selected items
    final TextStyle bodyMediumStyle =
        Theme.of(context).textTheme.bodyMedium ?? const TextStyle();
    // TextStyle for the selected item
    final TextStyle bodyLargeStyle =
        Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 20) ??
        bodyMediumStyle;

    final Color overlayBackgroundColor =
        widget.selectedItemHighlightColor ??
        Theme.of(context).primaryColor.withAlpha((0.1 * 255).toInt());
    final Widget selectionOverlayWidget =
        CupertinoPickerDefaultSelectionOverlay(
          background: overlayBackgroundColor,
        );

    return Container(
      height: 300,
      color: widget.backgroundColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CupertinoButton(
                child: Text(
                  widget.localizations.pickerDoneButton,
                  style: TextStyle(
                    color: widget.doneButtonColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  widget.onConfirmed(_tempSelectedItem);
                },
              ),
            ],
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: CupertinoPicker(
                magnification: 1.22,
                squeeze: 1.2,
                useMagnifier: true,
                selectionOverlay: selectionOverlayWidget,
                itemExtent: 32.0,
                scrollController: FixedExtentScrollController(
                  initialItem: currentPickerIndex,
                ),
                onSelectedItemChanged: (int index) {
                  setState(() {
                    _tempSelectedItem = widget.items[index];
                  });
                },
                children:
                    widget.items.map((item) {
                      final bool isSelected = item == _tempSelectedItem;
                      final TextStyle currentItemTextStyle =
                          isSelected ? bodyLargeStyle : bodyMediumStyle;
                      return Center(
                        child: Text(
                          widget.itemDisplayNameBuilder(item),
                          style: currentItemTextStyle,
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
