import 'package:e_commerce/screen/Home/home_class.dart';
import 'package:e_commerce/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../build_widget.dart';
import '../Account/acc_class.dart';

class HomeScreen extends StatefulWidget {
  final List<UserAcc> data_userAcc;
  const HomeScreen({super.key, required this.data_userAcc});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> item = [];
  List<int> savedItemIds = [];
  int amount = 0;

  @override
  void initState() {
    super.initState();
    getItem();
    fetchSavedItems();
  }

  Future<void> getItem() async {
    final response = await http.get(Uri.parse('${apiEndpoint}fetch_product.php'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        item = jsonData.map((item) => Item.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<void> fetchSavedItems() async {
    String email = widget.data_userAcc[0].email;
    String password = widget.data_userAcc[0].password;

    final response = await http.post(
      Uri.parse('${apiEndpoint}item_fetch.php'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        savedItemIds = data.map<int>((item) => int.parse(item['itemID'].toString())).toList();
      });
    } else {
      print('Failed to fetch saved items');
    }
  }

  Future<void> saveAndRemoveItem(Item item, bool isSaved) async {
    String email = widget.data_userAcc[0].email;
    String password = widget.data_userAcc[0].password;

    try {
      if (isSaved) {
        // Remove the item from saved items
        final response = await http.post(
          Uri.parse('${apiEndpoint}item_remove.php'),
          body: {
            'email': email,
            'password': password,
            'productId': item.id.toString(),
          },
        );
        debugPrint('Trying to remove productId: ${item.id}');

        if (response.statusCode == 200) {
          setState(() {
            savedItemIds.remove(item.id);
          });
        } else {
          showCustomSnackBar(
            context: context,
            message: 'Failed to remove item from save list.',
            bgColor: Colors.red,
          );
        }
      } else {
        // Add the item to saved items
        final response = await http.post(
            Uri.parse(
              '${apiEndpoint}item_insert.php',
            ),
            body: {
              'email': email,
              'password': password,
              'productId': item.id.toString(),
            });
        debugPrint('Trying to insert productId: ${item.id}');

        if (response.statusCode == 200) {
          setState(() {
            savedItemIds.add(item.id); // Add the item to the saved items list
          });
        } else {
          showCustomSnackBar(
            context: context,
            message: 'Failed to add item to save list.',
            bgColor: Colors.red,
          );
        }
      }
    } catch (e) {
      showCustomSnackBar(
        context: context,
        message: 'An error occurred: $e',
        bgColor: Colors.red,
      );
    }
  }

  Future<void> addToCart(int itemIndex, String itemName) async {
    final response = await http.post(
      Uri.parse('${apiEndpoint}cart_insert.php'),
      body: {
        'email': widget.data_userAcc[0].email,
        'password': widget.data_userAcc[0].password,
        'productId': itemIndex.toString(),
        'quantity': '1',
      },
    );

    final result = json.decode(response.body);
    if (result['status'] == 'success') {
      showCustomSnackBar(
        context: context,
        message: '${itemName} has been added to Cart!',
        bgColor: Colors.green,
      );
    } else {
      showCustomSnackBar(
        context: context,
        message: result['message'],
        bgColor: Colors.red,
      );
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
        toolbarHeight: 60,
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            style: GoogleFonts.merriweather(),
            cursorColor: Colors.grey,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: "\tSearch Item...",
              hintStyle: GoogleFonts.merriweather(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
              labelStyle: GoogleFonts.merriweather(),
              // prefixIcon: const Icon(Icons.search),
              suffixIcon: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    FontAwesomeIcons.solidImage,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.mic_rounded),
                  SizedBox(width: 5),
                ],
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
            ),
          ),
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.75,
        ),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(15),
        itemCount: item.length,
        itemBuilder: (context, index) {
          bool isSaved = savedItemIds.contains(item[index].id);
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[50],
                  border: Border.all(
                    color: cSecondary,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        image: DecorationImage(
                          image: NetworkImage('http://192.168.0.127:80/e-commerce-assignment-mba-images/${item[index].image}'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      height: 125,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item[index].name,
                      style: GoogleFonts.merriweather(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '\$${item[index].price.toString()}',
                                style: GoogleFonts.merriweather(
                                  fontSize: 20,
                                  color: cPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${item[index].sold} sold',
                                    style: GoogleFonts.merriweather(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  InkWell(
                                    onTap: () {
                                      addToCart(
                                        item[index].id,
                                        item[index].name,
                                      );
                                    },
                                    child: const FaIcon(
                                      FontAwesomeIcons.cartShopping,
                                      color: cPrimary,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 15,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: FaIcon(
                    FontAwesomeIcons.solidHeart,
                    size: 14,
                    color: isSaved ? Colors.red : Colors.grey,
                  ),
                  onTap: () {
                    if (isSaved) {
                      saveAndRemoveItem(item[index], isSaved);
                      showCustomSnackBar(
                        context: context,
                        message: 'Item has been removed from save list.',
                        bgColor: Colors.red,
                      );
                    } else {
                      saveAndRemoveItem(item[index], isSaved);
                      showCustomSnackBar(
                        context: context,
                        message: 'Item has been added to save list.',
                        bgColor: Colors.green,
                      );
                    }
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
