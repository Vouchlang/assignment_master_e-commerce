import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../build_widget.dart';
import '../../theme.dart';
import '../Account/acc_class.dart';
import 'cart_class.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartScreen extends StatefulWidget {
  final List<UserAcc> data_userAcc;

  const CartScreen({super.key, required this.data_userAcc});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItem = [];
  List<bool> isSelected = [];
  List<int> selectedIndexes = []; // to track selected item indexes
  Set<int> selectedProductIds = {};

  @override
  void initState() {
    super.initState();
    fetchSavedItems();
  }

  Future<void> fetchSavedItems() async {
    try {
      final response = await http.post(
        Uri.parse('${apiEndpoint}cart_fetch.php'),
        body: {
          'email': widget.data_userAcc[0].email,
          'password': widget.data_userAcc[0].password,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          cartItem = data.map((item) => CartItem.fromJson(item)).toList();
          isSelected = List<bool>.filled(cartItem.length, false);
        });
      }
    } catch (e) {
      showCustomSnackBar(
        context: context,
        message: 'Error: $e',
        bgColor: Colors.red,
      );
    }
  }

  Future<void> _removeItem(CartItem item) async {
    final response = await http.post(
      Uri.parse('${apiEndpoint}cart_remove.php'),
      body: {
        'email': widget.data_userAcc[0].email,
        'password': widget.data_userAcc[0].password,
        'productId': item.productId.toString(),
      },
    );
    debugPrint('Trying to remove productId: ${item.productId}');

    final result = json.decode(response.body);
    if (result['status'] == 'success') {
      setState(() {
        cartItem.removeWhere((i) => i.productId == item.productId);
      });
    } else {
      showCustomSnackBar(
        context: context,
        message: result['message'],
        bgColor: Colors.red,
      );
    }
  }

  Future<void> _removeAllItem() async {
    final response = await http.post(
      Uri.parse('${apiEndpoint}cart_remove_all.php'),
      body: {
        'email': widget.data_userAcc[0].email,
        'password': widget.data_userAcc[0].password,
      },
    );

    final result = json.decode(response.body);
    if (result['status'] == 'success') {
      setState(() {
        cartItem.clear();
      });
    } else {
      showCustomSnackBar(
        context: context,
        message: result['message'],
        bgColor: Colors.red,
      );
    }
  }

  Future<void> _updateQuantity(int index, int newQuantity, String itemName) async {
    final response = await http.post(
      Uri.parse('${apiEndpoint}cart_update.php'),
      body: {
        'email': widget.data_userAcc[0].email,
        'password': widget.data_userAcc[0].password,
        'productId': cartItem[index].productId.toString(),
        'quantity': newQuantity.toString(),
      },
    );

    final result = json.decode(response.body);

    if (result['status'] == 'success') {
      setState(() {
        cartItem[index] = CartItem(
          id: cartItem[index].id,
          quantity: newQuantity,
          itemPrice: cartItem[index].itemPrice,
          username: cartItem[index].username,
          itemImage: cartItem[index].itemImage,
          itemName: cartItem[index].itemName,
          itemSold: cartItem[index].itemSold,
          productId: cartItem[index].productId,
        );
      });
    } else {
      showCustomSnackBar(
        context: context,
        message: result['message'],
        bgColor: Colors.red,
      );
    }
  }

  double calculateTotal() {
    return cartItem.where((item) => selectedProductIds.contains(item.productId)).fold(0, (total, item) => total + item.itemPrice * item.quantity);
  }

  Future<void> _removeSelectedItems() async {
    final user = widget.data_userAcc[0];

    // Create a copy to avoid modifying list while iterating
    final List<CartItem> itemsToRemove = cartItem.where((item) => selectedProductIds.contains(item.productId)).toList();

    for (CartItem item in itemsToRemove) {
      final response = await http.post(
        Uri.parse('${apiEndpoint}cart_remove.php'),
        body: {
          'email': user.email,
          'password': user.password,
          'productId': item.productId.toString(),
        },
      );

      final result = json.decode(response.body);
      if (result['status'] == 'success') {
        setState(() {
          cartItem.removeWhere((element) => element.productId == item.productId);
          selectedProductIds.remove(item.productId);
        });
      } else {
        showCustomSnackBar(
          context: context,
          message: result['message'],
          bgColor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBGColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                cPrimary,
                cBGColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: Text(
          'Cart',
          style: GoogleFonts.merriweather(
            color: cSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: cPrimary,
        actions: [
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              if (cartItem.isEmpty) {
                showCustomSnackBar(
                  context: context,
                  message: 'No item left to be removed.',
                  bgColor: Colors.red,
                );
              } else {
                _removeAllItem();
                showCustomSnackBar(
                  context: context,
                  message: 'Every item has been removed from cart.',
                  bgColor: Colors.red,
                );
              }
            },
            child: Container(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: const CircleAvatar(
                radius: 15,
                backgroundColor: cWhite,
                child: FaIcon(
                  FontAwesomeIcons.trashCan,
                  size: 14,
                  color: cSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(bottom: 100),
            physics: const BouncingScrollPhysics(),
            itemCount: cartItem.length,
            itemBuilder: (context, index) {
              var isLastIndex = index == cartItem.length - 1;
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[50],
                      border: Border.all(
                        color: cSecondary,
                        width: 1.75,
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(15, 15, 15, isLastIndex ? 15 : 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: NetworkImage('http://192.168.0.127:80/e-commerce-assignment-mba-images/${cartItem[index].itemImage}'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 15, 15, 15),
                            height: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartItem[index].itemName,
                                      style: GoogleFonts.merriweather(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${cartItem[index].itemSold} sold',
                                      style: GoogleFonts.merriweather(
                                        color: Colors.grey[700],
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${cartItem[index].itemPrice * cartItem[index].quantity}',
                                      style: GoogleFonts.merriweather(
                                        fontSize: 24,
                                        color: cPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            InkWell(
                                                child: const Icon(
                                                  Icons.remove,
                                                  size: 16,
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    int newQuantity = cartItem[index].quantity - 1;
                                                    if (newQuantity > 0) {
                                                      _updateQuantity(
                                                        index,
                                                        newQuantity,
                                                        cartItem[index].itemName,
                                                      );
                                                    } else {
                                                      _removeItem(cartItem[index]);
                                                      showCustomSnackBar(
                                                        context: context,
                                                        message: '${cartItem[index].itemName} has been removed from cart.',
                                                        bgColor: Colors.red,
                                                      );
                                                    }
                                                  });
                                                }),
                                            Text(cartItem[index].quantity.toString()),
                                            InkWell(
                                              child: const Icon(
                                                Icons.add,
                                                size: 16,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  int newQuantity = cartItem[index].quantity + 1;
                                                  _updateQuantity(
                                                    index,
                                                    newQuantity,
                                                    cartItem[index].itemName,
                                                  );
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        InkWell(
                                          onTap: () {
                                            _removeItem(cartItem[index]);
                                            showCustomSnackBar(
                                              context: context,
                                              message: 'You have ordered ${cartItem[index].itemName}',
                                              bgColor: Colors.green,
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: cBGColor,
                                            ),
                                            child: Text(
                                              'Order',
                                              style: GoogleFonts.merriweather(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Checkbox(
                      activeColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      value: selectedProductIds.contains(cartItem[index].productId),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedProductIds.add(cartItem[index].productId);
                          } else {
                            selectedProductIds.remove(cartItem[index].productId);
                          }
                        });
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(
                  () {
                    if (cartItem.isEmpty || selectedProductIds.isEmpty) {
                      showCustomSnackBar(
                        context: context,
                        message: 'Please select items to place an order',
                        bgColor: Colors.red,
                      );
                    } else {
                      _removeSelectedItems();
                      showCustomSnackBar(
                        context: context,
                        message: 'You have ordered all of the selected items above.',
                        bgColor: Colors.green,
                      );
                    }
                  },
                );
              },
              child: Container(
                margin: const EdgeInsets.all(15),
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: cWhite,
                  border: Border.all(
                    color: cSecondary,
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '\$ ${calculateTotal()}',
                      style: GoogleFonts.merriweather(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Place Total Order',
                      style: GoogleFonts.merriweather(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
