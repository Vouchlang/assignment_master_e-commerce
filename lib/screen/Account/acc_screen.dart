import 'package:e_commerce/login_form.dart';
import 'package:e_commerce/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'account_model.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final List<String> _genderList = ['Male', 'Female', 'Others'];
  String _genderType = 'Male';
  final List<String> _languageList = ['Khmer', 'English', 'Chinese'];
  String _languageType = 'Khmer';
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _telController = TextEditingController();

  String _username = '';
  String _email = '';
  String _address = '';
  String _tel = '';

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
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext buildContext) {
                    return Dialog(
                      backgroundColor: cWhite,
                      elevation: 50,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        height: 125,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Log Out',
                                  style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Are you sure, You want to logout?',
                                  style: GoogleFonts.nunito(fontSize: 14),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (buildContext) => const LoginForm(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Yes',
                                    style: GoogleFonts.nunito(
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
                                    style: GoogleFonts.nunito(
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
                  });
            },
            child: const CircleAvatar(
              radius: 15,
              backgroundColor: cWhite,
              child: Icon(
                Icons.logout_outlined,
                size: 16,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      child: buildLabelText('Username'),
                    ),
                  ),
                  const SizedBox(width: 15),
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
                    child: buildTextBox(textController: _usernameController, text: _username),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    flex: 1,
                    child: buildDropDown(
                      width: MediaQuery.of(context).size.width / 3.85,
                      value: _genderType,
                      valueList: _genderList,
                      function: (value) {
                        setState(() {
                          _genderType = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              buildLabelText('Email'),
              buildTextBox(
                textController: _emailController,
                text: _email,
              ),
              const SizedBox(height: 15),
              buildLabelText('Address'),
              buildTextBox(
                textController: _addressController,
                text: _address,
              ),
              const SizedBox(height: 15),
              buildLabelText('Mobile Number'),
              buildTextBox(
                textController: _telController,
                text: _tel,
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black54),
                ),
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
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold,
                            ),
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black87,
                ),
                height: 45,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Text(
                  'Delete this Account',
                  style: GoogleFonts.nunito(
                    color: cWhite,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

List<DropdownMenuItem> dropDown(List items) {
  return items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList();
}
