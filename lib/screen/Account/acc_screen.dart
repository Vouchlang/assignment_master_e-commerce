import 'package:e_commerce/build_widget.dart';
import 'package:e_commerce/login_form.dart';
import 'package:e_commerce/screen/Account/edit_acc_screen.dart';
import 'package:e_commerce/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'acc_class.dart';
import 'account_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AccountScreen extends StatefulWidget {
  final List<UserAcc> data_userAcc;
  const AccountScreen({super.key, required this.data_userAcc});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List<UserAcc> dataUser = [];

  final List<String> _languageList = ['English', 'Khmer', 'Chinese'];
  String _languageType = 'English';

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _passwordController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController(text: widget.data_userAcc[0].password);
    _emailController = TextEditingController(text: widget.data_userAcc[0].email);
    getData();
  }

  Future<void> getData() async {
    try {
      final response = await http.post(
        Uri.parse('${apiEndpoint}user_login.php'),
        body: {
          'email': widget.data_userAcc[0].email,
          'password': widget.data_userAcc[0].password,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null) {
          final studentUserData = data['user'];
          for (var item in studentUserData) {
            UserAcc userModel = UserAcc(
              userId: int.parse(item['id'].toString()),
              username: item['username'],
              email: item['email'],
              password: item['password'],
              gender: item['gender'],
              address: item['address'],
              mobile: item['mobile'],
            );
            dataUser.add(userModel);
          }
        }
      }
    } catch (error) {
      return;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getData();
  }

  Future<void> _deleteProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final response = await http.post(
        Uri.parse('${apiEndpoint}user_delete.php'),
        body: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody['status'] == 'success') {
        showCustomSnackBar(
          context: context,
          message: responseBody['message'],
          bgColor: Colors.green,
        );
      } else {
        showCustomSnackBar(
          context: context,
          message: responseBody['message'],
          bgColor: Colors.red,
        );
      }
    } catch (error) {
      showCustomSnackBar(
        context: context,
        message: 'Failed to update profile. Try again.',
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
        title: Text(
          'Account',
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
              showDialog(
                context: context,
                builder: (BuildContext buildContext) {
                  return Dialog(
                    backgroundColor: cWhite,
                    elevation: 50,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 25),
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Log Out',
                                style: GoogleFonts.merriweather(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Are you sure, You want to logout?',
                                style: GoogleFonts.merriweather(fontSize: 14),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  await prefs.clear();
                                  Get.off(() => const LoginForm());
                                },
                                child: Text(
                                  'Yes',
                                  style: GoogleFonts.merriweather(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 75),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'No',
                                  style: GoogleFonts.merriweather(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                radius: 15,
                backgroundColor: cWhite,
                child: FaIcon(
                  FontAwesomeIcons.arrowRightFromBracket,
                  size: 14,
                  color: cSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        child: buildLabelText('Username'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        child: buildLabelText('Gender'),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: buildTextBox(
                        text: widget.data_userAcc[0].username,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: buildTextBox(
                        text: widget.data_userAcc[0].gender,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                buildLabelText('Email'),
                buildTextBox(
                  text: widget.data_userAcc[0].email,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: buildLabelText('Address'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        child: buildLabelText('Mobile Number'),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: buildTextBox(
                        text: widget.data_userAcc[0].address,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: buildTextBox(
                        text: widget.data_userAcc[0].mobile,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                buildLabelText('Language Perference'),
                buildDropDown(
                  width: MediaQuery.of(context).size.width / 1.13,
                  value: _languageType,
                  valueList: _languageList,
                  function: (value) {
                    setState(() {
                      _languageType = value!;
                    });
                  },
                ),
                const SizedBox(height: 15),
                buildLabelText('Support'),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: cSecondary), color: cWhite),
                  child: Column(
                    children: [
                      buildSpp('Rate this App'),
                      const SizedBox(height: 5),
                      buildSpp('Privacy Policy'),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'FAQ & Guide',
                              style: GoogleFonts.merriweather(),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext buildContext) {
                              return Dialog(
                                backgroundColor: cWhite,
                                elevation: 50,
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 25),
                                  height: 165,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            'Delete Account',
                                            style: GoogleFonts.merriweather(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'Are you sure, You want to delete this account?',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.merriweather(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              _deleteProfile();
                                              Get.off(() => const LoginForm());
                                            },
                                            child: Text(
                                              'Yes',
                                              style: GoogleFonts.merriweather(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 75),
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'No',
                                              style: GoogleFonts.merriweather(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black87,
                            border: Border.all(color: cWhite),
                          ),
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: Text(
                            'Delete this Account',
                            style: GoogleFonts.merriweather(
                              color: cWhite,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Get.to(
                            () => EditAccScreen(
                              data_userAcc: dataUser,
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black87,
                            border: Border.all(color: cWhite),
                          ),
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: Text(
                            'Edit Profile',
                            style: GoogleFonts.merriweather(
                              color: cWhite,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<DropdownMenuItem> dropDown(List items) {
  return items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList();
}
