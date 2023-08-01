import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:untitled4/error_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.verificationId, required this.phone});
  final String verificationId;
  final String phone;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String x = ' ';


  var verifyController = TextEditingController();

  Widget buildIntroTextOip() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verify your phone number',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            child: RichText(
                text: TextSpan(
                    text: 'Enter your 6 digit number sent to ',
                    style: const TextStyle(
                        color: Colors.black, fontSize: 18, height: 2),
                    children: <TextSpan>[
                  TextSpan(
                      text:widget.phone,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                      ))
                ]))),
      ],
    );
  }

  Widget buildPinCodeFields(BuildContext context) {
    return PinCodeTextField(
        autoFocus: true,
        cursorColor: Colors.black,
        keyboardType: TextInputType.number,
        controller: verifyController,
        appContext: context,
        length: 6,
        obscureText: false,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 40,
            borderWidth: 1,
            activeFillColor: const Color(0xffE5EFFD),
            inactiveColor: Colors.blue,
            inactiveFillColor: Colors.white,
            selectedFillColor: Colors.white,
            activeColor: Colors.blue),
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Colors.white,
        enableActiveFill: true,

        onCompleted: (v) {
          print("Completed");
        },
        onChanged: (value) {
          x = value;
          print(value);
          print("Changed x= $x");
        });
  }

  Widget buildVerifyButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () async {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: widget.verificationId,
              smsCode: verifyController.text);

          // Sign the user in (or link) with the credential
          await auth.signInWithCredential(credential);

          if (auth.currentUser != null) {
            Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) =>  MapScreen(),
            ));
          }
        },
        child: Text(
          "Verify",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
            minimumSize: Size(110, 50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            primary: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              margin: const EdgeInsets.symmetric(vertical: 88, horizontal: 32),
              child: Column(children: [
                buildIntroTextOip(),
                const SizedBox(height: 88),
                buildPinCodeFields(context),
                const SizedBox(height: 50),
                buildVerifyButton(),
              ]),
            )));
  }
  FirebaseAuth auth = FirebaseAuth.instance;
}
