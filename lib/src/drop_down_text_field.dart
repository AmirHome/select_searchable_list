import 'package:flutter/material.dart';

import 'drop_down.dart';

/// This is Common App textfiled class.
/// We use this widget for show drop-down for options
class DropDownTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String? title;
  final String hint;
  final Map<int, String> options;
  final List<int>? selectedOptions;
  final Function(List<int>?)? onChanged;
  final bool multiple;

  const DropDownTextField({
    required this.textEditingController,
    this.title,
    required this.hint,
    required this.options,
    this.selectedOptions,
    this.onChanged,
    this.multiple = false,
    Key? key,
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
          style: const TextStyle(
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
          decoration: InputDecoration(
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
              padding: EdgeInsets.only(top: 15), // add padding to adjust icon
              child: Icon(Icons.keyboard_capslock),
            ),
          ),
        ),
        const SizedBox(
          height: 15.0,
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
