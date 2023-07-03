import 'package:flutter/material.dart';

void main() {
  runApp(ShoppingListApp());
}

class ShoppingListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Segoe Print',
      ),
      home: ShoppingListScreen(),
    );
  }
}

class ShoppingListScreen extends StatefulWidget {
  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final List<Product> sampleProducts = [
    Product(name: 'Apple', price: 1.99),
    Product(name: 'Banana', price: 0.99),
    Product(name: 'Orange', price: 1.49),
    Product(name: 'Mango', price: 2.99),
    Product(name: 'Strawberry', price: 2.49),
    Product(name: 'Grapes', price: 3.99),
    Product(name: 'Pineapple', price: 4.49),
    Product(name: 'Watermelon', price: 5.99),
    Product(name: 'Blueberries', price: 3.49),
    Product(name: 'Peach', price: 2.79),
  ];

  String? selectedProduct;
  int selectedQuantity = 1;

  List<ShoppingListItem> shoppingList = [];
  double total = 0;

  final productSelectController = TextEditingController();

  @override
  void dispose() {
    productSelectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping List App  🛒',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: DropdownButton<String>(
                  value: selectedProduct,
                  onChanged: (newValue) {
                    setState(() {
                      selectedProduct = newValue;
                    });
                  },
                  items: sampleProducts.map((Product product) {
                    return DropdownMenuItem<String>(
                      value: product.name,
                      child: Text(
                        '${product.name} - \$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                width: 150.0,
                child: Row(
                  children: [
                    Text(
                      'Quantity: ',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Expanded(
                      child: DropdownButton<int>(
                        value: selectedQuantity,
                        onChanged: (newValue) {
                          setState(() {
                            selectedQuantity = newValue!;
                          });
                        },
                        items: List.generate(10, (index) {
                          return DropdownMenuItem<int>(
                            value: index + 1,
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(fontSize: 18.0),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  if (selectedProduct != null) {
                    setState(() {
                      final product = sampleProducts.firstWhere(
                          (element) => element.name == selectedProduct);
                      final shoppingListItem = ShoppingListItem(
                        product: product,
                        quantity: selectedQuantity,
                        checked: false,
                      );
                      shoppingList.add(shoppingListItem);
                      total += product.price * selectedQuantity;
                      selectedProduct = null;
                      selectedQuantity = 1;
                    });
                  }
                },
                child: Text('Add to List'),
              ),
            ),
            SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'My Shopping List:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: shoppingList.length,
                itemBuilder: (BuildContext context, int index) {
                  final shoppingListItem = shoppingList[index];
                  return Dismissible(
                    key: Key(shoppingListItem.product.name),
                    onDismissed: (direction) {
                      setState(() {
                        total -= shoppingListItem.product.price *
                            shoppingListItem.quantity;
                        shoppingList.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '${shoppingListItem.product.name} removed from the shopping list.'),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Checkbox(
                        value: shoppingListItem.checked,
                        onChanged: (value) {
                          setState(() {
                            shoppingListItem.checked = value!;
                            if (value) {
                              total -= shoppingListItem.product.price *
                                  shoppingListItem.quantity;
                            } else {
                              total += shoppingListItem.product.price *
                                  shoppingListItem.quantity;
                            }
                          });
                        },
                      ),
                      title: Text(
                        '${shoppingListItem.product.name} - \$${shoppingListItem.product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16.0,
                          decoration: shoppingListItem.checked
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              int newQuantity = shoppingListItem.quantity;
                              return AlertDialog(
                                title: Text('Edit Quantity'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'Quantity',
                                      ),
                                      onChanged: (value) {
                                        newQuantity = int.tryParse(value) ?? 0;
                                      },
                                    ),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        total -=
                                            shoppingListItem.product.price *
                                                shoppingListItem.quantity;
                                        shoppingListItem.quantity = newQuantity;
                                        total +=
                                            shoppingListItem.product.price *
                                                shoppingListItem.quantity;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Save'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          'Quantity: ${shoppingListItem.quantity}',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 50.0),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Total: \$${total.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final double price;

  Product({required this.name, required this.price});
}

class ShoppingListItem {
  final Product product;
  int quantity;
  bool checked;

  ShoppingListItem({
    required this.product,
    required this.quantity,
    this.checked = false,
  });
}
