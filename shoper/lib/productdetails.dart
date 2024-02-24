import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cartauth.dart';


class ProductDetailPage extends StatelessWidget {
  final int productId;
  final String productName;
  final double productPrice;
  final String productImage;

  ProductDetailPage({
    required this.productImage,
    required this.productId,
    required this.productName,
    required this.productPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(productName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              productImage,
              height: 250,
            ),
            Text(
              'Product Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Product Name: $productName',
            ),
            Text(
              'Product Price: \$${productPrice.toStringAsFixed(2)}',
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<CartProvider>().addToCart(
                      CartItem(
                        productId: productId,
                        productName: productName,
                        quantity: 1,
                        price: productPrice,
                        productImage: productImage,
                      ),
                    );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Product added to the cart'),
                  ),
                );
              },
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
