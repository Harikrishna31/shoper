import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cartauth.dart';
// Assuming you have a CartProvider class

class CartPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          var cartItems = cartProvider.items;

          if (cartItems.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Padding(
                    padding: EdgeInsets.only(
                      right: 320,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios_new),
                    )),
                SizedBox(
                  height: 370,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('No items in the cart ')],
                )
              ],
            );
          }

          return Column(
            children: [
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var cartItem = cartItems[index];

                    return ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.red.shade100,
                        backgroundImage: NetworkImage(cartItem.productImage),
                      ),
                      title: Text(
                        cartItem.productName,
                        style: TextStyle(fontSize: 15),
                      ),
                      subtitle: Row(
                        children: [
                          Text('Quantity: ${cartItem.quantity}'),
                          SizedBox(width: 10),
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              cartProvider.updateItemQuantity(
                                index,
                                cartItem.quantity - 1,
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              cartProvider.updateItemQuantity(
                                index,
                                cartItem.quantity + 1,
                              );
                            },
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '\$${(cartItem.quantity * cartItem.price).toStringAsFixed(2)}',
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              cartProvider.removeItem(index);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Total Amount: \$${cartProvider.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
