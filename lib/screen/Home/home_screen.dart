import 'package:e_commerce/screen/Home/home_class.dart';
import 'package:e_commerce/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int amount = 0;
  bool isClicked = false;

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
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: "\tSearch Item...",
              hintStyle: GoogleFonts.nunito(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
              prefixIcon: const Icon(Icons.search),
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
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
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
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0x3AE9E7E7),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(2, 2),
                      color: cWhite,
                    ),
                    BoxShadow(
                      offset: Offset(-2, -2),
                      color: cWhite,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
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
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                itemList[index].price,
                                style: GoogleFonts.nunito(
                                  fontSize: 18,
                                  color: cPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${itemList[index].sold} sold',
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
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
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    amount.toString(),
                                    style: const TextStyle(
                                      color: Colors.black,
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
                                      size: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        "Your Item has added to Cart!",
                                        style: TextStyle(color: cWhite),
                                      ),
                                      backgroundColor: Colors.green,
                                      duration: const Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
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
                    setState(() {
                      isClicked = !isClicked;
                      isClicked
                          ? ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  "Item has added to Save List.",
                                  style: TextStyle(color: cWhite),
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )
                          : ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  "Item has been removed from Save List.",
                                  style: TextStyle(color: cWhite),
                                ),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                    });
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
