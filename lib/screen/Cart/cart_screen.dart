import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../build_widget.dart';
import '../../theme.dart';
import '../Account/acc_class.dart';
import 'add_to_cart_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBGColor,
      appBar: AppBar(title: Text('Cart')),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: cartItem.length,
          itemBuilder: (context, index) {
            return Card(
              child: Row(
                children: [
                  Image.network(
                    'http://192.168.0.127:80/e-commerce-assignment-mba-images/${cartItem[index].itemImage}',
                    height: 75,
                    fit: BoxFit.fill,
                  ),
                  Column(
                    children: [
                      Text(cartItem[index].itemImage),
                      Text(cartItem[index].itemSold),
                      Text(cartItem[index].itemPrice.toString()),
                      Row(
                        children: [
                          const Icon(Icons.remove, size: 14),
                          Text(cartItem[index].quantity.toString()),
                          const Icon(Icons.add, size: 14),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
  // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   flexibleSpace: Container(
      //     decoration: const BoxDecoration(
      //       gradient: LinearGradient(
      //         colors: [
      //           cPrimary,
      //           cBGColor,
      //         ],
      //         begin: Alignment.topCenter,
      //         end: Alignment.bottomCenter,
      //       ),
      //     ),
      //   ),
      //   title: Text(
      //     'Cart',
      //     style: GoogleFonts.merriweather(
      //       color: cSecondary,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   backgroundColor: cPrimary,
      //   actions: [
      //     InkWell(
      //       highlightColor: Colors.transparent,
      //       splashColor: Colors.transparent,
      //       onTap: () {
      //         final addToCartProvider = Provider.of<AddToCartProvider>(context, listen: false);
      //         if (addToCartProvider.cartItems.isEmpty) {
      //           showCustomSnackBar(
      //             context: context,
      //             message: 'No item left to be removed.',
      //             bgColor: Colors.red,
      //           );
      //         } else {
      //           addToCartProvider.clearItems();
      //           WidgetsBinding.instance.addPostFrameCallback((_) {
      //             showCustomSnackBar(
      //               context: context,
      //               message: 'Every item has been removed from cart.',
      //               bgColor: Colors.red,
      //             );
      //           });
      //         }
      //       },
      //       child: Container(
      //         decoration: const BoxDecoration(shape: BoxShape.circle),
      //         child: const CircleAvatar(
      //           radius: 15,
      //           backgroundColor: cWhite,
      //           child: FaIcon(
      //             FontAwesomeIcons.trashCan,
      //             size: 14,
      //             color: cSecondary,
      //           ),
      //         ),
      //       ),
      //     ),
      //     const SizedBox(width: 15),
      //   ],
      // ),
     
      // body: Stack(
      //   children: [
      //     ListView.builder(
      //       padding: const EdgeInsets.only(bottom: 100),
      //       physics: const BouncingScrollPhysics(),
      //       itemCount: cartItem.length,
      //       itemBuilder: (context, index) {
      //         var isLastIndex = index == cartItem.length - 1;
      //         return Stack(
      //           children: [
      //             Container(
      //               decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(10),
      //                 color: Colors.grey[50],
      //                 border: Border.all(
      //                   color: cSecondary,
      //                   width: 1.75,
      //                 ),
      //               ),
      //               margin: EdgeInsets.fromLTRB(15, 15, 15, isLastIndex ? 15 : 0),
      //               child: Row(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Container(
      //                     width: 150,
      //                     height: 150,
      //                     decoration: BoxDecoration(
      //                       borderRadius: const BorderRadius.only(
      //                         topLeft: Radius.circular(10),
      //                         bottomLeft: Radius.circular(10),
      //                       ),
      //                       image: DecorationImage(
      //                         image: NetworkImage('http://192.168.0.127:80/e-commerce-assignment-mba-images/${cartItem[index].itemImage}'),
      //                         fit: BoxFit.fill,
      //                       ),
      //                     ),
      //                   ),
      //                   Expanded(
      //                     child: Container(
      //                       padding: const EdgeInsets.fromLTRB(10, 15, 15, 15),
      //                       height: 150,
      //                       child: Column(
      //                         crossAxisAlignment: CrossAxisAlignment.start,
      //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                         children: [
      //                           Column(
      //                             crossAxisAlignment: CrossAxisAlignment.start,
      //                             children: [
      //                               Text(
      //                                 cartItem[index].itemName,
      //                                 style: GoogleFonts.merriweather(
      //                                   fontSize: 20,
      //                                   fontWeight: FontWeight.bold,
      //                                 ),
      //                               ),
      //                               Text(
      //                                 '${cartItem[index].itemSold} sold',
      //                                 style: GoogleFonts.merriweather(
      //                                   color: Colors.grey[700],
      //                                   fontSize: 16,
      //                                 ),
      //                               ),
      //                             ],
      //                           ),
      //                           Row(
      //                             crossAxisAlignment: CrossAxisAlignment.end,
      //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                             children: [
      //                               Text(
      //                                 '\$${cartItem[index].itemPrice * cartItem[index].quantity}',
      //                                 style: GoogleFonts.merriweather(
      //                                   fontSize: 24,
      //                                   color: cPrimary,
      //                                   fontWeight: FontWeight.bold,
      //                                 ),
      //                               ),
      //                               Column(
      //                                 crossAxisAlignment: CrossAxisAlignment.center,
      //                                 children: [
      //                                   Row(
      //                                     children: [
      //                                       InkWell(
      //                                           child: const Icon(
      //                                             Icons.remove,
      //                                             size: 16,
      //                                           ),
      //                                           onTap: () {
                                                  // setState(() {
                                                  //   if (cartItem[index].quantity > 1) {
                                                  //     cartItem[index].quantity == 0;
                                                  //   } else {
                                                  //     cartItem[index].quantity -= 1;
                                                  //   }
                                                  // });
      //                                           }),
      //                                       Text(cartItem[index].quantity.toString()),
      //                                       InkWell(
      //                                         child: const Icon(
      //                                           Icons.add,
      //                                           size: 16,
      //                                         ),
      //                                         onTap: () {
      //                                           // setState(() {
      //                                           //   cartItem[index].quantity += 1;
      //                                           // });
      //                                         },
      //                                       ),
      //                                     ],
      //                                   ),
      //                                   const SizedBox(height: 5),
      //                                   InkWell(
      //                                     onTap: () {},
      //                                     child: Container(
      //                                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
      //                                       decoration: BoxDecoration(
      //                                         borderRadius: BorderRadius.circular(10),
      //                                         color: cBGColor,
      //                                       ),
      //                                       child: Text(
      //                                         'Order',
      //                                         style: GoogleFonts.merriweather(
      //                                           fontSize: 12,
      //                                           fontWeight: FontWeight.bold,
      //                                         ),
      //                                       ),
      //                                     ),
      //                                   )
      //                                 ],
      //                               ),
      //                             ],
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         );
      //       },
      //     ),
          // Positioned(
          //   bottom: 0,
          //   right: 0,
          //   left: 0,
          //   child: InkWell(
          //     splashColor: Colors.transparent,
          //     highlightColor: Colors.transparent,
          //     onTap: () {
                // setState(() {
                //   selectedItems.isEmpty
                //       ? showCustomSnackBar(
                //           context: context,
                //           message: 'Please select items to place an order',
                //           bgColor: Colors.red,
                //         )
                //       : showCustomSnackBar(
                //           context: context,
                //           message: 'You have ordered all of the items above.',
                //           bgColor: Colors.green,
                //         );
                //   removeSelectedItems();
                // });
          //     },
          //     child: Container(
          //       margin: const EdgeInsets.all(15),
          //       height: 75,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10),
          //         color: cWhite,
          //         border: Border.all(
          //           color: cSecondary,
          //           width: 1.5,
          //         ),
          //       ),
          //       alignment: Alignment.center,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceAround,
          //         children: [
          //           Text(
          //             '\$',
          //             style: GoogleFonts.merriweather(
          //               fontSize: 20,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //           Text(
          //             'Place Total Order',
          //             style: GoogleFonts.merriweather(
          //               fontSize: 20,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
      //   ],
      // ),
    