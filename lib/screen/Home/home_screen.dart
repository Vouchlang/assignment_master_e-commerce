import 'package:e_commerce/screen/Home/home_class.dart';
import 'package:e_commerce/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../build_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int amount = 0;
  bool isClicked = false;
  // int getTotalPrice() {
  //   return itemList.fold(0, (sum, item) => sum + item.price);
  // }

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
        itemCount: itemList.length,
        itemBuilder: (context, index) {
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
                          image: AssetImage(itemList[index].image),
                          fit: BoxFit.fill,
                        ),
                      ),
                      height: 125,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      itemList[index].name,
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
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        amount == 0 ? amount : amount -= 1;
                                      });
                                    },
                                    child: const Icon(
                                      Icons.remove,
                                      size: 14,
                                      color: cSecondary,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    amount.toString(),
                                    style: GoogleFonts.merriweather(color: cSecondary),
                                  ),
                                  const SizedBox(width: 5),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        amount = amount += 1;
                                      });
                                    },
                                    child: const Icon(
                                      Icons.add,
                                      size: 14,
                                      color: cSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${itemList[index].sold} sold',
                                style: GoogleFonts.merriweather(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '\$${itemList[index].price.toString()}',
                                style: GoogleFonts.merriweather(
                                  fontSize: 18,
                                  color: cPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showCustomSnackBar(
                                    context: context,
                                    message: 'Your Item has added to Cart!',
                                    bgColor: Colors.green,
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
                    )
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 15,
                child: InkWell(
                  child: FaIcon(
                    FontAwesomeIcons.solidHeart,
                    size: 14,
                    color: isClicked ? Colors.red : Colors.grey,
                  ),
                  onTap: () {
                    setState(
                      () {
                        isClicked = !isClicked;
                        isClicked
                            ? showCustomSnackBar(
                                context: context,
                                message: 'Item has added to save list.',
                                bgColor: Colors.green,
                              )
                            : showCustomSnackBar(
                                context: context,
                                message: 'Item has been removed from save list.',
                                bgColor: Colors.red,
                              );
                      },
                    );
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
