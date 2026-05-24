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
  final String searchHintText;

  const AppTextField({required this.dropDown, required this.onTextChanged, required this.searchHintText, super.key});

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final TextEditingController _editingController = TextEditingController();

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        controller: _editingController,
        cursorColor: colorScheme.primary,
        onChanged: (value) {
          widget.onTextChanged(value);
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest,
          contentPadding: const EdgeInsetsDirectional.only(start: 8, end: 12),
          hintText: widget.searchHintText,
          border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(16.0)), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(16.0)), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            borderSide: BorderSide(color: colorScheme.primary, width: 1.2),
          ),
          prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
          suffixIcon: GestureDetector(
            onTap: onClearTap,
            child: Icon(Icons.cancel, color: colorScheme.onSurfaceVariant),
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
