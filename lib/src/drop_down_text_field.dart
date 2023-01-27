import 'package:flutter/material.dart';

import 'drop_down.dart';

/// This is Common App textfiled class.
/// We use this widget for show drop-down for options
/*
The DropDownTextField class is a Flutter widget that displays a text field with a dropdown icon. When the dropdown icon is tapped, a modal bottom sheet is displayed with a list of options. The user can select one or more options from the list, depending on the value of the multiple parameter.

The DropDownTextField widget has a number of parameters that can be set to customize its behavior and appearance. For example, the textEditingController parameter is used to specify a TextEditingController that is used to manage the state of the text field, and the title parameter is used to specify a title for the text field. The hint parameter is used to specify a hint text for the text field, and the options parameter is used to specify the list of options to display in the dropdown.

The DropDownTextField widget also has a selectedOptions parameter that can be used to specify the initially selected options, and an onChanged callback function that is called whenever the selected options change. The multiple parameter can be set to true to enable multiple selection of options, or to false to enable single selection of options.
* */
class DropDownTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String? title;
  final String hint;
  final Map<int, String> options;
  final List<int>? selectedOptions;
  final Function(List<int>?)? onChanged;
  final bool multiple;

  //optional parameters
  final InputDecoration? decoration;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final int? maxLines;
  final int? minLines;

  /// [isSearchVisible] flag use to manage the search widget visibility
  /// by default it is [True] so widget will be visible.
  final bool isSearchVisible;

  const DropDownTextField({
    required this.textEditingController,
    this.title,
    required this.hint,
    required this.options,
    this.selectedOptions,
    this.onChanged,
    this.multiple = false,
    Key? key,

    /// optional parameters
    this.decoration,
    this.textCapitalization,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlign,
    this.textAlignVertical,
    this.maxLines,
    this.minLines,
    this.isSearchVisible = true,
  }) : super(key: key);

  @override
  State<DropDownTextField> createState() => _DropDownTextFieldState();
}

class _DropDownTextFieldState extends State<DropDownTextField> {
  // final TextEditingController _searchTextEditingController = TextEditingController();

  /// This is on text changed method which will display on city text field on changed.
  void onTextFieldTap() {
    DropDownState(
      DropDown(
        bottomSheetTitle: Text(
          widget.title ?? '',
          style: widget.style ??
              const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
        ),
        submitButtonChild: const Text(
          'Done',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        options: widget.options,
        selectedOptions: widget.selectedOptions,
        selectedItems: (List<dynamic> selectedList) {
          widget.textEditingController.text =
              tmpImplode(widget.options, selectedList);
          widget.onChanged?.call(List<int>.from(selectedList));
        },
        enableMultipleSelection: widget.multiple,
        isSearchVisible: widget.isSearchVisible,
      ),
    ).showModal(context);
  }

  @override
  void initState() {
    if (!['', null, false, 0].contains(widget.selectedOptions)) {
      widget.textEditingController.text =
          tmpImplode(widget.options, widget.selectedOptions!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.textEditingController,
          cursorColor: Colors.black,
          keyboardType: TextInputType.none,
          showCursor: false,
          readOnly: true,
          onTap: () {
            FocusScope.of(context).unfocus();
            onTextFieldTap();
          },
          // Optional
          decoration: widget.decoration ??
              InputDecoration(
                // filled: true,
                labelText: widget.title,
                hintText: widget.hint,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0,
                    style: ['', null].contains(widget.title)
                        ? BorderStyle.none
                        : BorderStyle.solid,
                  ),
                ),
                suffixIcon: const Padding(
                  padding:
                      EdgeInsets.only(top: 8), // add padding to adjust icon
                  child: Icon(Icons.keyboard_capslock),
                ),
              ),

          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.none,
          textInputAction: widget.textInputAction,
          style: widget.style,
          strutStyle: widget.strutStyle,
          textDirection: widget.textDirection,
          textAlign: widget.textAlign ?? TextAlign.start,
          textAlignVertical: widget.textAlignVertical,
          maxLines: widget.maxLines ?? 1,
          minLines: widget.minLines,
        ),
      ],
    );
  }

  // Comma separated values of options
  String tmpImplode(Map<int, String> options, List<dynamic> tmpSelectedList) {
    Map<int, String> tmpOptions = Map<int, String>.from(options);

    tmpOptions.removeWhere((id, value) => !tmpSelectedList.contains(id));
    return tmpOptions.values.join(',');
  }
}
