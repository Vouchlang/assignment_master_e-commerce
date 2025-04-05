import 'package:e_commerce/theme.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Account/acc_class.dart';
import 'Account/acc_screen.dart';
import 'Cart/cart_screen.dart';
import 'Home/home_screen.dart';
import 'Save/save_screen.dart';

class BottomBar extends StatefulWidget {
  final List<UserAcc> data_userAcc;
  final int currentIndex;
  const BottomBar({
    super.key,
    required this.data_userAcc,
    this.currentIndex = 0,
  });

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
  }

  late List<Widget> pages = [
    HomeScreen(data_userAcc: widget.data_userAcc),
    SaveScreen(data_userAcc: widget.data_userAcc),
    CartScreen(data_userAcc: widget.data_userAcc),
    AccountScreen(data_userAcc: widget.data_userAcc),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: cBGColor,
        color: cWhite,
        buttonBackgroundColor: cWhite,
        animationDuration: const Duration(milliseconds: 300),
        index: currentIndex,
        height: 60,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          FaIcon(
            FontAwesomeIcons.house,
            color: cPrimary,
            size: 16,
          ),
          FaIcon(
            FontAwesomeIcons.solidHeart,
            color: cPrimary,
            size: 16,
          ),
          FaIcon(
            FontAwesomeIcons.cartShopping,
            color: cPrimary,
            size: 16,
          ),
          FaIcon(
            FontAwesomeIcons.solidUser,
            color: cPrimary,
            size: 16,
          ),
        ],
      ),
    );
  }
}
