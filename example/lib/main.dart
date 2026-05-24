import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:select_searchable_list/select_searchable_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF006874));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
          ),
          filled: true,
          fillColor: colorScheme.surface,
        ),
        bottomSheetTheme: const BottomSheetThemeData(showDragHandle: true),
      ),
      home: const SelectSearchableListExample(),
    );
  }
}

class SelectSearchableListExample extends StatefulWidget {
  const SelectSearchableListExample({super.key});

  @override
  State<SelectSearchableListExample> createState() => _SelectSearchableListExampleState();
}

class _SelectSearchableListExampleState extends State<SelectSearchableListExample> {
  /// This is list of city which will pass to the drop down.

  /// This is register text field controllers.
  final TextEditingController _productNameTextEditingController = TextEditingController();
  final TextEditingController _categoryTextEditingController = TextEditingController();
  final TextEditingController _colorsTextEditingController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<DropDownTextFieldState> _dropDownKey = GlobalKey<DropDownTextFieldState>();

  late Map<dynamic, String> _listCategories = {};
  late List<dynamic> _selectedCategoryValue = [];

  late Map<dynamic, String> _listColors = {};
  late List<dynamic> _selectedColorValues = [];

  @override
  void initState() {
    super.initState();

    _listColors = {1: 'Black', 2: 'Blue', 3: 'Brown', 4: 'Gold', 5: 'Green', 6: 'Grey', 7: 'Orange', 8: 'Pink', 9: 'Purple', 10: 'Red'};

    _listCategories = {1: 'Boot', '2': 'Casual', 3: 'Flat', 4: 'Flip', 5: 'Lace up', 6: 'Loafer', 7: 'Slip-on', 8: 'Moccasins'};

    _selectedColorValues = [2, 4];
    _selectedCategoryValue = [2];

    if (kDebugMode) {
      print('Categories loaded');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _productNameTextEditingController.dispose();
    _categoryTextEditingController.dispose();
    _colorsTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Select Searchable List')),
      body: SafeArea(child: _bodyApp()),
    );
  }

  /// This is Main Body widget.
  Widget _bodyApp() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product Details', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16.0),

            /// Product name field
            TextFormField(
              controller: _productNameTextEditingController,
              decoration: const InputDecoration(labelText: 'Product Name', hintText: 'Type a product name'),
            ),
            const SizedBox(height: 16.0),

            // ####### Category Select List
            DropDownTextField(
              key: _dropDownKey,
              //style: const TextStyle(height: 0.85, fontSize: 14.0, color: Colors.deepOrangeAccent), //initial
              textEditingController: _categoryTextEditingController,
              title: 'Category',
              hint: 'Select Category',
              options: _listCategories,
              selectedOptions: _selectedCategoryValue,

              onChanged: (selectedIds) {
                setState(() {
                  _selectedCategoryValue = List<dynamic>.from(selectedIds ?? const <dynamic>[]);
                });
              },
              // isRequired: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select category';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            // ####### Colors Select List
            DropDownTextField(
              textEditingController: _colorsTextEditingController,
              title: 'Colors',
              hint: 'Select Colors',
              options: _listColors,
              selectedOptions: _selectedColorValues,
              onChanged: (selectedIds) {
                // setState(() => selectedIds);
                // print(selectedIds);

                // For Form
                /*
                  setState(() {
                  _selectedCategoryValue = selectedIds!;
                });
                  */
                setState(() {
                  _selectedColorValues = List<dynamic>.from(selectedIds ?? const <dynamic>[]);
                });
              },
              multiple: true,
            ),
            const SizedBox(height: 20.0),
            FilledButton.icon(
              onPressed: () {
                // Check validator
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  if (kDebugMode) {
                    print('Update button pressed');
                  }
                } else {
                  // Programmatically tap the drop down field
                  _dropDownKey.currentState?.onTextFieldTap();
                }
              },
              icon: const Icon(Icons.save_outlined),
              label: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
