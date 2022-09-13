import 'package:flutter/material.dart';
import 'package:otp_verification/res/theme.dart';
import 'package:otp_verification/verification_code.dart';
import 'package:twilio_phone_verify/twilio_phone_verify.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var noHpController = TextEditingController();
  late TwilioPhoneVerify twilioPhoneVerify;

  @override
  void initState() {
    super.initState();
    //replace here
    twilioPhoneVerify = TwilioPhoneVerify(
        accountSid: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
        serviceSid: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
        authToken: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    //until here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lupa Kata Sandi',
              style: TextStyle(color: Colors.black)),
          centerTitle: true,
          leading: const BackButton(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: ListView(padding: const EdgeInsets.only(top: 75), children: [
            Image.asset(
              "images/illustrations4.png",
              width: 262,
              height: 158,
            ),
            Container(
              margin: const EdgeInsets.all(16.0),
              child: const Text(
                'Kami akan mengirimkan link ke nomor ponsel Anda untuk mereset kata sandi',
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 4.0, left: 16.0),
              child: const Text(
                'Nomor Ponsel',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: TextField(
                controller: noHpController,
                keyboardType: TextInputType.number,
                // inputFormatters: <TextInputFormatter>[
                //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                //   FilteringTextInputFormatter.digitsOnly
                // ],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan nomor ponsel Anda',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16.0),
              width: double.infinity,
              height: 48,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: ElevatedButton(
                  onPressed: () {
                    verify();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: pomegranate,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    "Kirim",
                    style: blackTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ));
  }

  Future<void> verify() async {
    var noHp = noHpController.text.trim();
    if (noHp.isNotEmpty && noHp.length >= 11) {
      print(noHp);

      TwilioResponse twilioResponse =
      await twilioPhoneVerify.sendSmsCode(noHp);

      if (twilioResponse.successful!) {
        print("send code success");
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VerificationScreen(noHp: noHp)));
      } else {
        print("send code failed : ${twilioResponse.errorMessage}");
      }

    } else {
      print("Field tidak valid");
    }
  }
}
