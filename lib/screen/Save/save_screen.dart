import 'package:e_commerce/screen/Home/home_class.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../build_widget.dart';
import '../../theme.dart';
import '../Account/acc_class.dart';

class SaveScreen extends StatefulWidget {
  final List<UserAcc> data_userAcc;

  const SaveScreen({super.key, required this.data_userAcc});

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  int amount = 0;
  bool isSaved = true;
  @override
  Widget build(BuildContext context) {
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
              setState(
                () {
                  isSaved == false
                      ? showCustomSnackBar(
                          context: context,
                          message: 'No item left to be removed.',
                          bgColor: Colors.red,
                        )
                      : showCustomSnackBar(
                          context: context,
                          message: 'Every item has been removed from save list.',
                          bgColor: Colors.red,
                        );
                  isSaved = false;
                },
              );
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
                                Text(
                                  '\$${itemList[index].price.toString()}',
                                  style: GoogleFonts.merriweather(
                                    fontSize: 22,
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
                                          onTap: () {
                                            setState(() {
                                              amount == 0 ? amount : amount -= 1;
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
                                    const SizedBox(height: 3),
                                    const FaIcon(
                                      FontAwesomeIcons.cartShopping,
                                      color: cPrimary,
                                      size: 20,
                                    ),
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
                top: 25,
                right: 30,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isSaved = !isSaved;
                      isSaved
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
                    });
                  },
                  child: FaIcon(
                    FontAwesomeIcons.solidHeart,
                    color: isSaved ? Colors.red : Colors.grey,
                    size: 16,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
