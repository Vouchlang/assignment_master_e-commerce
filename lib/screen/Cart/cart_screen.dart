import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../build_widget.dart';
import '../../theme.dart';
import '../Account/acc_class.dart';
import '../Home/home_class.dart';

class CartScreen extends StatefulWidget {
  final List<UserAcc> data_userAcc;

  const CartScreen({super.key, required this.data_userAcc});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Item> itemList = [];

  int amount = 1;

  bool isSaved = true;
  int getTotalPrice(int amount) {
    return itemList.fold(0, (sum, item) => sum + (item.price * amount));
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
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(bottom: 100),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              var isLastIndex = index == itemList.length - 1;
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
                              image: AssetImage(itemList[index].image),
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
                                      itemList[index].name,
                                      style: GoogleFonts.merriweather(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${itemList[index].sold} sold',
                                      style: GoogleFonts.merriweather(
                                        color: Colors.grey[700],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              amount == 1 ? amount : amount -= 1;
                                            });
                                          },
                                          child: const Icon(
                                            Icons.remove,
                                            size: 18,
                                            color: cSecondary,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          amount.toString(),
                                          style: GoogleFonts.merriweather(
                                            color: cSecondary,
                                            fontSize: 18,
                                          ),
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
                                            size: 18,
                                            color: cSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '\$${(itemList[index].price * amount).toString()}',
                                          style: GoogleFonts.merriweather(
                                            fontSize: 22,
                                            color: cPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        InkWell(
                                          onTap: () {
                                            showCustomSnackBar(
                                              context: context,
                                              message: 'You have ordered this item.',
                                              bgColor: Colors.green,
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: cBGColor,
                                            ),
                                            child: Text(
                                              'Place Order',
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
                ],
              );
            },
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: InkWell(
              onTap: () {
                setState(() {
                  showCustomSnackBar(
                    context: context,
                    message: 'You have ordered all of the items above.',
                    bgColor: Colors.green,
                  );
                });
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
                child: Text(
                  'Total Price: \$${getTotalPrice(amount).toString()}',
                  style: GoogleFonts.merriweather(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
