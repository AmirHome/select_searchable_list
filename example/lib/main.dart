import 'package:flutter/material.dart';
import 'package:select_searchable_list/select_searchable_list.dart';

void main() {
  runApp(
    const MaterialApp(
      home: SelectSearchableListExample(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class SelectSearchableListExample extends StatefulWidget {
  const SelectSearchableListExample({
    Key? key,
  }) : super(key: key);

  @override
  _SelectSearchableListExampleState createState() => _SelectSearchableListExampleState();
}

class _SelectSearchableListExampleState extends State<SelectSearchableListExample> {
  /// This is list of city which will pass to the drop down.
  final Map<int, String> _listCategories = {1:'Boot', 2: 'Casual', 3: 'Flat', 4: 'Flip',  5: 'Lace up', 6: 'Loafer', 7: 'Slip-on', 8: 'Moccasins'};

  final List<int> _selectedCategory = [1];

  final Map<int, String> _listColors = {1:'Black', 2: 'Blue', 3: 'Brown', 4: 'Gold',  5: 'Green', 6: 'Grey', 7: 'Orange', 8: 'Pink', 9: 'Purple', 10: 'Red'};

  final List<int> _selectedColors = [2,4];

  /// This is register text field controllers.
  final TextEditingController _productNameTextEditingController = TextEditingController();
  final TextEditingController _categoryTextEditingController = TextEditingController();
  final TextEditingController _colorsTextEditingController = TextEditingController();

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
      body: SafeArea(
        child: _mainBody(),
      ),
    );
  }

  /// This is Main Body widget.
  Widget _mainBody() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30.0,
          ),
          const Text(
            'Product Details',
            style: TextStyle(
              fontSize: 34.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          TextFormField(
            controller: _productNameTextEditingController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Product Name',
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),

          // ####### Category Select List
          DropDownTextField(
            textEditingController: _categoryTextEditingController,
            title: 'Category',
            hint: 'Select Category',
            options: _listCategories,
            selectedOptions: _selectedCategory,
            onChanged: (selectedIds) {
              // setState(() => add);
            },
          ),

          // ####### Colors Select List
          DropDownTextField(
            textEditingController: _colorsTextEditingController,
            title: 'Colors',
            hint: 'Select Colors',
            options: _listColors,
            selectedOptions: _selectedColors,
            onChanged: (selectedIds) {
              // setState(() => add);
            },
            multiple: true,
          ),

          _AppElevatedButton(),
        ],
      ),
    );
  }
}

/// This is common class for 'REGISTER' elevated button.
class _AppElevatedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 60.0,
      child: ElevatedButton(
        onPressed: () {},
        child: const Text(
          'Update',
          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
        ),
        style: ElevatedButton.styleFrom(

          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}