import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../Home/home_class.dart';

class AddToCartProvider extends ChangeNotifier {
  final Map<int, int> _cartItems = {}; // Store item ID with quantity
  final List<Item> _cartItemList = []; // Store full item details
  final Set<int> _selectedItemIds = {}; // Track selected items for order

  List<Item> get cartItems => _cartItemList;
  List<Item> get selectedItems => _cartItemList.where((item) => _selectedItemIds.contains(item.id)).toList();

  AddToCartProvider() {
    _loadCartItems();
  }

  void addItem(Item item, int quantity) {
    if (_cartItems.containsKey(item.id)) {
      _cartItems[item.id] = (_cartItems[item.id]! + quantity);
    } else {
      _cartItems[item.id] = quantity;
      _cartItemList.add(item); // Store the item details
    }
    _saveToPrefs();
    notifyListeners();
  }

  void removeItem(Item item) {
    _cartItems.remove(item.id);
    _cartItemList.removeWhere((cartItem) => cartItem.id == item.id);
    _selectedItemIds.remove(item.id); // Remove from selected items as well
    _saveToPrefs();
    notifyListeners();
  }

  void removeSelectedItems() {
    _cartItems.removeWhere((id, _) => _selectedItemIds.contains(id));
    _cartItemList.removeWhere((item) => _selectedItemIds.contains(item.id));
    _selectedItemIds.clear(); // Clear the selected items after removing them
    _saveToPrefs();
    notifyListeners();
  }

  void updateQuantity(Item item, int quantity) {
    if (_cartItems.containsKey(item.id)) {
      _cartItems[item.id] = quantity;
      _saveToPrefs();
      notifyListeners();
    }
  }

  void clearItems() {
    _cartItems.clear();
    _cartItemList.clear();
    _selectedItemIds.clear(); // Clear selected items
    _saveToPrefs();
    notifyListeners();
  }

  int getQuantity(Item item) {
    return _cartItems[item.id] ?? 1;
  }

  bool isItemAdded(Item item) {
    return _cartItems.containsKey(item.id);
  }

  void toggleSelection(Item item) {
    if (_selectedItemIds.contains(item.id)) {
      _selectedItemIds.remove(item.id);
    } else {
      _selectedItemIds.add(item.id);
    }
    notifyListeners();
  }

  bool isSelected(Item item) {
    return _selectedItemIds.contains(item.id);
  }

  double get totalSelectedPrice {
    return selectedItems.fold(0, (sum, item) => sum + (item.price * getQuantity(item)));
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = _cartItems.entries.map((entry) {
      return {
        'id': entry.key,
        'quantity': entry.value,
      };
    }).toList();
    prefs.setString('cartItems', json.encode(cartData));

    final itemData = _cartItemList.map((item) => item.toJson()).toList();
    prefs.setString('cartItemList', json.encode(itemData));
  }

  Future<void> _loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cartItems');
    final itemData = prefs.getString('cartItemList');

    if (cartData != null && itemData != null) {
      List<dynamic> decodedCart = json.decode(cartData);
      List<dynamic> decodedItems = json.decode(itemData);

      _cartItems.clear();
      _cartItemList.clear();

      for (var entry in decodedCart) {
        _cartItems[entry['id']] = entry['quantity'];
      }

      for (var entry in decodedItems) {
        _cartItemList.add(Item.fromJson(entry));
      }
    }
    notifyListeners();
  }
}
