import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled4/otp_screen.dart';
import 'package:untitled4/routes.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final GlobalKey<FormState> formKey = GlobalKey();

  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: SafeArea(
            child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 88, horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IntroText(),
                    SizedBox(
                      height: 70,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${generateCountryFlag()}+20',
                              style: TextStyle(
                                fontSize: 18,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: TextFormField(
                              controller: phoneController,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'Enter your number',
                                border: InputBorder.none,
                              ),
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 11) {
                                  return 'Please enter your valid number';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                phoneController.text = newValue!;
                                print(phoneController.text);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: '+2${phoneController.text}',
                              verificationCompleted:
                                  (PhoneAuthCredential credential) {},
                              verificationFailed: (FirebaseAuthException e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(e.code),
                                  backgroundColor: Colors.red,
                                ));
                              },
                              codeSent:
                                  (String verificationId, int? resendToken) {
                                Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => OtpScreen(
                                      verificationId: verificationId,
                                      phone: phoneController.text),
                                ));
                              },
                              timeout: const Duration(seconds: 10),
                              codeAutoRetrievalTimeout:
                                  (String verificationId) {},
                            );
                          }
                        },
                        child: const Text(
                          "Next",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(110, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                            primary: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )));
  }
}

Widget IntroText() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'What is your phone number ?',
        style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 30),
      Text('Please enter your phone number to get started.',
          style: TextStyle(
            fontSize: 18,
          ))
    ],
  );
}

String generateCountryFlag() {
  String countryCode = 'eg';

  String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
      (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));

  return flag;
}
