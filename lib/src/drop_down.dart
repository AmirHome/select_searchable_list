import 'package:flutter/material.dart';

import 'app_text_field.dart';

/// Searchable and Popup showModal list of Options

class DropDown {
  /// This will give the list of data.
  final Map<int, String> options;

  // This will give the the selected items from data.
  final List<int>? selectedOptions;

  /// This will give the call back to the selected items from list.
  final Function(List<dynamic>)? selectedItems;

  /// [listBuilder] will gives [index] as a function parameter and you can return your own widget based on [index].
  final Widget Function(int index)? listBuilder;

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
    this.dropDownBackgroundColor = Colors.transparent,
  });
}

class DropDownState {
  DropDown dropDown;

  DropDownState(this.dropDown);

  /// This gives the bottom sheet widget.
  void showModal(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return MainBody(dropDown: dropDown);
          },
        );
      },
    );
  }
}

/// This is main class to display the bottom sheet body.
class MainBody extends StatefulWidget {
  final DropDown dropDown;

  const MainBody({required this.dropDown, Key? key}) : super(key: key);

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  /// This list will set when the list of data is not available.
  Map<int, String> mainList = {};
  late List<int> selectedList;

  @override
  void initState() {
    super.initState();
    mainList = widget.dropDown.options;
    selectedList = widget.dropDown.selectedOptions ?? [];
    _setSearchWidgetListener();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.13,
      maxChildSize: 0.9,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Bottom sheet title text
                  Expanded(
                      child: widget.dropDown.bottomSheetTitle ?? Container()),

                  /// Done button
                  Visibility(
                    visible: widget.dropDown.enableMultipleSelection,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Material(
                        child: ElevatedButton(
                          onPressed: () {
                            widget.dropDown.selectedItems?.call(selectedList);
                            _onUnFocusKeyboardAndPop();
                          },
                          child: widget.dropDown.submitButtonChild ??
                              const Text('Done'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// A [TextField] that displays a list of suggestions as the user types with clear button.
            Visibility(
              visible: widget.dropDown.isSearchVisible,
              child: widget.dropDown.searchWidget ??
                  AppTextField(
                    dropDown: widget.dropDown,
                    onTextChanged: _buildSearchList,
                  ),
            ),

            /// Listview (list of data with check box for multiple selection & on tile tap single selection)
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: mainList.length,
                itemBuilder: (context, index) {
                  final mainListKeys = mainList.keys.toList();
                  final mainListValues = mainList.values.toList();

                  bool isSelected = selectedList.contains(mainListKeys[index]);

                  return InkWell(
                    onTap: widget.dropDown.enableMultipleSelection
                        ? null
                        : () {
                            widget.dropDown.selectedItems
                                ?.call([mainListKeys[index]]);
                            _onUnFocusKeyboardAndPop();
                          },
                    child: Container(
                      color: widget.dropDown.dropDownBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: ListTile(
                          title: widget.dropDown.listBuilder?.call(index) ??
                              Text(
                                mainListValues[index],
                              ),
                          trailing: widget.dropDown.enableMultipleSelection
                              ? GestureDetector(
                                  onTap: () {
                                    !isSelected
                                        ? selectedList.add(mainListKeys[index])
                                        : selectedList
                                            .remove(mainListKeys[index]);
                                    setState(() {
                                      //selectedList;
                                    });
                                  },
                                  child: isSelected
                                      ? const Icon(Icons.check_box)
                                      : const Icon(
                                          Icons.check_box_outline_blank),
                                )
                              : const SizedBox(
                                  height: 0.0,
                                  width: 0.0,
                                ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// This helps when search enabled & show the filtered data in list.
  _buildSearchList(String userSearchTerm) {
    // ####### Clone of options
    final results = Map<int, String>.from(widget.dropDown.options);
    results.removeWhere((id, value) =>
        !value.toLowerCase().contains(userSearchTerm.toLowerCase()));

    if (userSearchTerm.isEmpty) {
      mainList = widget.dropDown.options;
    } else {
      mainList = results;
    }
    setState(() {});
  }

  /// This helps to UnFocus the keyboard & pop from the bottom sheet.
  _onUnFocusKeyboardAndPop() {
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
