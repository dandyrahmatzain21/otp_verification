import 'package:flutter/material.dart';
import 'package:otp_verification/res/theme.dart';
import 'package:twilio_phone_verify/twilio_phone_verify.dart';

class VerificationScreen extends StatefulWidget {
  final String noHp;
  const VerificationScreen({Key? key, required this.noHp}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  var otpCodeController = TextEditingController();
  late String noHpUser;
  late TwilioPhoneVerify twilioPhoneVerify;

  @override
  void initState() {
    super.initState();
    noHpUser = widget.noHp;

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
          title: const Text('Verifikasi Kode OTP',
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
              child: Text(
                'Silakan masukan kode OTP yang sudah dikirimkan lewat SMS ke nomor anda : $noHpUser',
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 4.0, left: 16.0),
              child: const Text(
                'Kode OTP',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: TextField(
                controller: otpCodeController,
                keyboardType: TextInputType.number,
                // inputFormatters: <TextInputFormatter>[
                //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                //   FilteringTextInputFormatter.digitsOnly
                // ],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan Kode OTP',
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
                    verifyCode();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: pomegranate,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    "Verify",
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

  Future<void> verifyCode() async {
    var codeOTP = otpCodeController.text.trim();
    if(codeOTP.length == 6) {
      print(codeOTP);

      TwilioResponse twilioResponse = await twilioPhoneVerify.verifySmsCode(
          phone: noHpUser, code: codeOTP);

      if (twilioResponse.successful!) {
        if (twilioResponse.verification?.status == VerificationStatus.approved) {
          print('Phone number is approved');
        } else {
          print('Invalid code');
        }
      } else {
        print(twilioResponse.errorMessage);
      }
    } else {
      print("Kode OTP kurang dari 6");
    }
  }

  Future<void> resendCode() async {
    print(noHpUser);

    TwilioResponse twilioResponse =
    await twilioPhoneVerify.sendSmsCode(noHpUser);

    if (twilioResponse.successful!) {
      print("send code success");
    } else {
      print("send code failed : ${twilioResponse.errorMessage}");
    }

  }
}
