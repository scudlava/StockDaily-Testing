import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myfinancial/model/user_account.dart';
import 'package:myfinancial/util/util.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:myfinancial/routes/account/login.dart';
import 'package:myfinancial/routes/home/main_tab.dart';
import 'package:myfinancial/util/widget/otp_screen.dart';

class OtpVerificationScreen extends StatefulWidget{
  UserAccount userAccount;
  OtpVerificationScreen({this.userAccount});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpVerificationScreen>{

  User firebaseUser;
  String status="";

  AuthCredential phoneAuthCredential;
  String verificationId;
  int code;

  void _handleError(e) {
    // print(e.message);
    print(e.toString());
    setState(() {
      // status += e.message + '\n';
      status += e.toString() + '\n';
    });
  }

  Future<void> _submitPhoneNumber() async {

    String newPhoneNumber = "+62 " + widget.userAccount.phoneNumber.substring(1);
    print(newPhoneNumber);

    void verificationCompleted(AuthCredential phoneAuthCredential) {

      print('verificationCompleted');
      setState(() {
        status += 'verificationCompleted\n';
      });
      this.phoneAuthCredential = phoneAuthCredential;
      print(phoneAuthCredential);
    }

    void verificationFailed(Exception error) {
      print('verificationFailed');
      _handleError(error);
    }

    void codeSent(String verificationId, [int code]) {
      print('codeSent');
      this.verificationId = verificationId;
      print(verificationId);
      this.code = code;
      print(code.toString());
      setState(() {
        status += 'Code Sent\n';
      });
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      print('codeAutoRetrievalTimeout');
      setState(() {
        status += 'codeAutoRetrievalTimeout\n';
      });
      print(verificationId);
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      /// Make sure to prefix with your country code
      phoneNumber: newPhoneNumber,

      /// `seconds` didn't work. The underlying implementation code only reads in `millisenconds`
      timeout: Duration(milliseconds: 10000),

      /// If the SIM (with phoneNumber) is in the current device this function is called.
      /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
      /// When this function is called there is no need to enter the OTP, you can click on Login button to sigin directly as the device is now verified
      verificationCompleted: verificationCompleted,

      /// Called when the verification is failed
      verificationFailed: verificationFailed,

      /// This is called after the OTP is sent. Gives a `verificationId` and `code`
      codeSent: codeSent,

      /// After automatic code retrival `tmeout` this function is called
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ); // All the callbacks are above
  }

  Future<bool> _submitOTP(String otp) async{
    /// get the `smsCode` from the user
    String smsCode = otp;

    /// when used different phoneNumber other than the current (running) device
    /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
    this.phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: this.verificationId, smsCode: smsCode);

    bool value = await _login();
    return value;
  }

  Future<bool> _login() async {
    /// This method is used to login the user
    /// `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
    /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
    try {
      await FirebaseAuth.instance
          .signInWithCredential(this.phoneAuthCredential)
          .then((UserCredential authRes) {
        firebaseUser = authRes.user;
        FirebaseFirestore.instance.collection('users').where('phoneNumber', isEqualTo: widget.userAccount.phoneNumber)
            .snapshots().listen(
                (data) {
                  if (data.docs != null) {
                    if (data.docs.isNotEmpty) {
                        // data.docs[0].data().update('isValidate', (value) => true);
                        FirebaseFirestore.instance.collection('users').doc( data.docs[0].id).update({'isValidate': 'true'});
                    }
                  }
                }
        );


        print(firebaseUser.toString());
      }).catchError((e) => _handleError(e));
      setState(() {
        print('Success login by otp');
        UserProfile.save(widget.userAccount).then((value) {
          TabHome().launch(context);

        });

        //status =status+ ' Signed In\n';

      });

      return true;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }



  Future<String> validateOtp(String otp) async {

    bool value = await _submitOTP(otp);

    //await Future.delayed(Duration(milliseconds: 2000));
    if (value) {
      return "";
    } else {
      return "Code that you enter is wrong!";
    }


  }

// action to be performed after OTP validation is success
  void moveToNextScreen(context) {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => LoginScreen()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Firebase.initializeApp().whenComplete(() {
      //   print("completed");
      //   _submitPhoneNumber();
      //   setState(() {});
      // });
      _submitPhoneNumber();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OtpScreen(
        otpLength: 6,
        title: "Verification Code",
        subTitle: "Please enter verification code",
        validateOtp: validateOtp,
        routeCallback: moveToNextScreen,
        titleColor: Colors.black,
        themeColor: Colors.black,
      ),
    );
  }
}
