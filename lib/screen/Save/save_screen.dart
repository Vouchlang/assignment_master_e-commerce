import 'package:e_commerce/screen/Home/home_class.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../build_widget.dart';
import '../../theme.dart';
import '../Account/acc_class.dart';
import '../Cart/add_to_cart_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SaveScreen extends StatefulWidget {
  final List<UserAcc> data_userAcc;

  const SaveScreen({super.key, required this.data_userAcc});

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  List<Item> savedItems = [];
  List<int> savedItemIds = [];

  int amount = 0;
  @override
  void initState() {
    super.initState();
    fetchSavedItems();
  }

  Future<void> fetchSavedItems() async {
    try {
      final response = await http.post(
        Uri.parse('${apiEndpoint}item_fetch.php'),
        body: {
          'email': widget.data_userAcc[0].email,
          'password': widget.data_userAcc[0].password,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          savedItems = data.map((item) => Item.fromJson(item)).toList();
          savedItemIds = savedItems.map((item) => item.id).toList();
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

  Future<void> removeSavedItem(Item item) async {
    try {
      final response = await http.post(
        Uri.parse('${apiEndpoint}item_remove.php'),
        body: {
          'email': widget.data_userAcc[0].email,
          'password': widget.data_userAcc[0].password,
          'productId': item.id.toString(),
        },
      );

      debugPrint('Trying to remove productId: ${item.id}');

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseData['status'] == 'success') {
          setState(() {
            savedItems.removeWhere((i) => i.id == item.id);
            savedItemIds.remove(item.id);
          });
          showCustomSnackBar(
            context: context,
            message: 'Item has been removed from save list.',
            bgColor: Colors.red,
          );
        } else if (responseData['message'] == 'Item not found in saved list') {
          showCustomSnackBar(
            context: context,
            message: 'This item is not in your save list.',
            bgColor: Colors.orange,
          );
        } else {
          showCustomSnackBar(
            context: context,
            message: responseData['message'] ?? 'Failed to remove item.',
            bgColor: Colors.red,
          );
        }
      } else {
        throw Exception('Failed to remove item');
      }
    } catch (e) {
      showCustomSnackBar(
        context: context,
        message: 'Error: $e',
        bgColor: Colors.red,
      );
    }
  }

  Future<void> removeAllSavedItems() async {
    try {
      final response = await http.post(
        Uri.parse('${apiEndpoint}item_remove_all.php'),
        body: {
          'email': widget.data_userAcc[0].email,
          'password': widget.data_userAcc[0].password,
        },
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result['status'] == 'success') {
        setState(() {
          savedItems.clear();
          savedItemIds.clear();
        });
      } else {
        showCustomSnackBar(
          context: context,
          message: result['message'] ?? 'Something went wrong',
          bgColor: Colors.orange,
        );
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
    final addToCartProvider = Provider.of<AddToCartProvider>(context);

    return Scaffold(
      backgroundColor: cBGColor,
      appBar: AppBar(
        backgroundColor: cPrimary,
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
          'Save',
          style: GoogleFonts.merriweather(
            color: cSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              if (savedItems.isEmpty) {
                showCustomSnackBar(
                  context: context,
                  message: 'No item left to be removed.',
                  bgColor: Colors.red,
                );
              } else {
                removeAllSavedItems();
                showCustomSnackBar(
                  context: context,
                  message: 'Every item has been removed from save list.',
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
      body: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: savedItems.length,
        itemBuilder: (context, index) {
          var isLastIndex = index == savedItems.length - 1;
          bool isSaved = savedItemIds.contains(savedItems[index].id);
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
                          image: NetworkImage('http://192.168.0.127:80/e-commerce-assignment-mba-images/${savedItems[index].image}'),
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
                                  savedItems[index].name,
                                  style: GoogleFonts.merriweather(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${savedItems[index].sold} sold',
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
                                  '\$${savedItems[index].price.toString()}',
                                  style: GoogleFonts.merriweather(
                                    fontSize: 24,
                                    color: cPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    addToCartProvider.addItem(savedItems[index], 1);
                                    showCustomSnackBar(
                                      context: context,
                                      message: 'Your Item has added to Cart!',
                                      bgColor: Colors.green,
                                    );
                                  },
                                  child: const FaIcon(
                                    FontAwesomeIcons.cartShopping,
                                    color: cPrimary,
                                    size: 22,
                                  ),
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
                top: 25,
                right: 30,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: FaIcon(
                    FontAwesomeIcons.solidHeart,
                    size: 14,
                    color: isSaved ? Colors.red : Colors.grey,
                  ),
                  onTap: () {
                    removeSavedItem(savedItems[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
