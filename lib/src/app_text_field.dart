import 'package:flutter/material.dart';

import 'drop_down.dart';

/// This is search text field class.
/*
The AppTextField class is a Flutter widget that displays a search text field with a clear button. The AppTextField widget has two required parameters: dropDown and onTextChanged. The dropDown parameter is an instance of the DropDown class, which is used to specify the list of options to display in the dropdown, and the onTextChanged parameter is a callback function that is called whenever the text in the text field changes.

The AppTextField widget is implemented using a TextFormField widget and a TextEditingController. The TextFormField widget is used to display the text field, and the TextEditingController is used to manage the state of the text field. The AppTextField widget also has a clear button that can be used to clear the text field and reset the list of options in the dropdown.
* */
class AppTextField extends StatefulWidget {
  final DropDown dropDown;
  final Function(String) onTextChanged;

  const AppTextField(
      {required this.dropDown, required this.onTextChanged, Key? key})
      : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        controller: _editingController,
        cursorColor: Colors.black,
        onChanged: (value) {
          widget.onTextChanged(value);
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black12,
          contentPadding:
              const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 15),
          hintText: 'Search',
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          prefixIcon: const IconButton(
            icon: Icon(Icons.search),
            onPressed: null,
          ),
          suffixIcon: GestureDetector(
            onTap: onClearTap,
            child: const Icon(
              Icons.cancel,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  /// Clear search box and reset list options
  void onClearTap() {
    _editingController.clear();
    widget.onTextChanged('');
  }
}
