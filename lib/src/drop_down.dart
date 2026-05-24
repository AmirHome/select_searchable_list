import 'package:flutter/material.dart';

import 'app_text_field.dart';

/// Searchable and Popup showModal list of Options
/*
* This code defines a Flutter widget called DropDown that displays a searchable and popup list of options. The DropDown widget has a number of optional parameters that can be set to customize its behavior and appearance. For example, you can set the options parameter to provide the list of options to display, the selectedOptions parameter to specify which options should be initially selected, and the selectedItems parameter to specify a callback function that will be called when the selected options change.

The DropDown widget also has a number of other optional parameters, such as listBuilder, which allows you to specify a custom widget to display for each option in the list, and enableMultipleSelection, which allows you to enable or disable multiple selection of options.

The DropDownState class is responsible for showing the dropdown as a modal bottom sheet when the showModal method is called. The MainBody widget is the main content of the bottom sheet, and the _MainBodyState class is its stateful implementation. The _MainBodyState class has a number of fields and methods that are used to manage the state of the dropdown, such as the mainList field, which holds the list of options, and the selectedList field, which holds the list of selected options.
*/
class DropDown {
  /// This will give the list of data.
  final Map<dynamic, String> options;

  // This will give the the selected items from data.
  final List<dynamic>? selectedOptions;

  /// This will give the call back to the selected items from list.
  final Function(List<dynamic>)? selectedItems;

  /// [listBuilder] will gives [index] as a function parameter and you can return your own widget based on [index].
  final Widget Function(dynamic index)? listBuilder;

  /// This will give selection choice for single or multiple for list.
  final bool enableMultipleSelection;

  /// This gives the bottom sheet title.
  final Widget? bottomSheetTitle;

  /// You can set your custom submit button when the multiple selection is enabled.
  final Widget? submitButtonChild;

  /// [searchWidget] is use to show the text box for the searching.
  /// If you are passing your own widget then you must have to add [TextEditingController] for the [TextFormField].
  final TextFormField? searchWidget;

  /// [isSearchVisible] flag use to manage the search widget visibility
  /// by default it is [True] so widget will be visible.
  final bool isSearchVisible;
  final String searchHintText;

  /// This will set the background color to the dropdown.
  final Color dropDownBackgroundColor;

  DropDown({
    Key? key,
    required this.options,
    this.selectedOptions,
    this.selectedItems,
    this.listBuilder,
    this.enableMultipleSelection = false,
    this.bottomSheetTitle,
    this.submitButtonChild,
    this.searchWidget,
    this.isSearchVisible = true,
    required this.searchHintText,
    this.dropDownBackgroundColor = Colors.transparent,
  });
}

class DropDownState {
  DropDown dropDown;

  DropDownState(this.dropDown);

  /// This gives the bottom sheet widget.
  void showModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28.0))),
      context: context,
      builder: (context) {
        return MainBody(dropDown: dropDown);
      },
    );
  }
}

/// This is main class to display the bottom sheet body.
class MainBody extends StatefulWidget {
  final DropDown dropDown;

  const MainBody({required this.dropDown, super.key});

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  /// This list will set when the list of data is not available.
  Map<dynamic, String> mainList = {};
  late List<dynamic> selectedList;

  @override
  void initState() {
    super.initState();
    mainList = widget.dropDown.options;
    selectedList = List<dynamic>.from(widget.dropDown.selectedOptions ?? const <dynamic>[]);
    _setSearchWidgetListener();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.13,
      maxChildSize: 0.9,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return SafeArea(
          top: false,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: widget.dropDown.enableMultipleSelection ? 0.0 : 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: widget.dropDown.bottomSheetTitle ?? const SizedBox.shrink()),
                    Visibility(
                      visible: widget.dropDown.enableMultipleSelection,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton(
                          onPressed: () {
                            widget.dropDown.selectedItems?.call(selectedList);
                            _onUnFocusKeyboardAndPop();
                          },
                          child: widget.dropDown.submitButtonChild ?? const Text('Done'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// A [TextField] that displays a list of suggestions as the user types with clear button.
              Visibility(
                visible: widget.dropDown.isSearchVisible,
                child:
                    widget.dropDown.searchWidget ??
                    AppTextField(
                      dropDown: widget.dropDown,
                      onTextChanged: _buildSearchList,
                      searchHintText: widget.dropDown.searchHintText,
                    ),
              ),

              /// Listview (list of data with check box for multiple selection & on tile tap single selection)
              Expanded(
                child: Builder(
                  builder: (context) {
                    final mainListKeys = mainList.keys.toList();
                    final mainListValues = mainList.values.toList();

                    return ListView.builder(
                      controller: scrollController,
                      itemCount: mainListKeys.length,
                      itemBuilder: (context, index) {
                        final itemKey = mainListKeys[index];
                        final isSelected = selectedList.contains(itemKey);

                        return Material(
                          color: widget.dropDown.dropDownBackgroundColor == Colors.transparent
                              ? Colors.transparent
                              : widget.dropDown.dropDownBackgroundColor,
                          child: ListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
                            selected: isSelected,
                            selectedTileColor: colorScheme.secondaryContainer,
                            title: widget.dropDown.listBuilder?.call(index) ?? Text(mainListValues[index]),
                            trailing: widget.dropDown.enableMultipleSelection
                                ? Icon(
                                    isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                                    color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                                  )
                                : (isSelected ? Icon(Icons.check, color: colorScheme.primary) : const SizedBox.shrink()),
                            onTap: () {
                              if (widget.dropDown.enableMultipleSelection) {
                                setState(() {
                                  if (isSelected) {
                                    selectedList.remove(itemKey);
                                  } else {
                                    selectedList.add(itemKey);
                                  }
                                });
                                return;
                              }

                              widget.dropDown.selectedItems?.call([itemKey]);
                              _onUnFocusKeyboardAndPop();
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              if (mainList.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text('No results found', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                ),
            ],
          ),
        );
      },
    );
  }

  /// This helps when search enabled & show the filtered data in list.
  void _buildSearchList(String userSearchTerm) {
    if (userSearchTerm.isEmpty) {
      setState(() {
        mainList = widget.dropDown.options;
      });
      return;
    }

    final lowerTerm = userSearchTerm.toLowerCase();
    final filteredResults = Map<dynamic, String>.fromEntries(
      widget.dropDown.options.entries.where((entry) => entry.value.toLowerCase().contains(lowerTerm)),
    );

    setState(() {
      mainList = filteredResults;
    });
  }

  /// This helps to UnFocus the keyboard & pop from the bottom sheet.
  void _onUnFocusKeyboardAndPop() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  void _setSearchWidgetListener() {
    TextFormField? searchField = widget.dropDown.searchWidget;
    searchField?.controller?.addListener(() {
      _buildSearchList(searchField.controller?.text ?? '');
    });
  }
}
