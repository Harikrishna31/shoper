import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CartProvider with ChangeNotifier {
  late Database _database;
  List<CartItem> _items = [];
  double _totalAmount = 0.0;

  CartProvider() {
    _initDatabase();
  }

  void _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'cart_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE cart_items(id INTEGER PRIMARY KEY, productId INTEGER, productName TEXT, quantity INTEGER, price REAL, productImage TEXT)",
        );
      },
      version: 1,
    );
    await _loadCartFromDatabase();
  }

  Future<void> _loadCartFromDatabase() async {
    final List<Map<String, dynamic>> cartItems =
        await _database.query('cart_items');
    _items = List.generate(
      cartItems.length,
      (index) {
        return CartItem(
          productId: cartItems[index]['productId'],
          productName: cartItems[index]['productName'],
          quantity: cartItems[index]['quantity'],
          price: cartItems[index]['price'],
          productImage: cartItems[index]['productImage'],
        );
      },
    );
    _updateTotal();
    notifyListeners();
  }

  Future<void> _saveCartToDatabase() async {
    await _database.delete('cart_items');
    for (var item in _items) {
      await _database.insert(
        'cart_items',
        item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  List<CartItem> get items => _items;
  int get itemCount => _items.length;
  double get totalAmount => _totalAmount;

  void _updateTotal() {
    _totalAmount =
        _items.fold(0.0, (total, item) => total + item.price * item.quantity);
  }

  void updateItemQuantity(int index, int newQuantity) {
    if (index >= 0 && index < _items.length) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
      _updateTotal();
      notifyListeners();
      _saveCartToDatabase();
    } else {
      print('Invalid index: $index');
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      _updateTotal();
      notifyListeners();
      _saveCartToDatabase();
    } else {
      print('Invalid index: $index');
    }
  }

  void addToCart(CartItem item) {
    var existingItemIndex =
        _items.indexWhere((cartItem) => cartItem.productId == item.productId);

    if (existingItemIndex != -1) {
      _items[existingItemIndex].quantity += item.quantity;
    } else {
      _items.add(item);
    }

    notifyListeners();
    _updateTotal();
    _saveCartToDatabase();
  }
}

class CartItem {
  final int productId;
  final String productName;
  int quantity;
  final double price;
  final String productImage;

  CartItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.productImage,
  });

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productName': productName,
        'quantity': quantity,
        'price': price,
        'productImage': productImage,
      };
}
