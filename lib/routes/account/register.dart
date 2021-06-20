import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfinancial/constant/colors.dart';
import 'package:myfinancial/constant/string.dart';
import 'package:myfinancial/model/user_account.dart';
import 'package:myfinancial/routes/account/otp_verification.dart';
import 'package:myfinancial/util/util.dart';
import 'package:myfinancial/util/widget/loading.dart';
import 'package:nb_utils/nb_utils.dart';
// import'package:booking/hairSalon/utils/BHColors.dart';
// import'package:booking/hairSalon/utils/BHConstants.dart';
// import 'package:nb_utils/nb_utils.dart';
// import'package:booking/hairSalon/utils/BHImages.dart';
// import'package:booking/main/utils/AppWidget.dart';

class RegisterScreen extends StatefulWidget {
  static String tag = '/NewRegistrationScreen';

  @override
  NewRegistrationScreenState createState() => NewRegistrationScreenState();
}

class NewRegistrationScreenState extends State<RegisterScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _showPassword = false;
  bool _showCPassword = false;
  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController cPasswordCont = TextEditingController();
  TextEditingController frontNameCont = TextEditingController();
  TextEditingController backNameCont = TextEditingController();

  TextEditingController addressCont = TextEditingController();
  TextEditingController noKtpCont = TextEditingController();
  TextEditingController noHpCont = TextEditingController();

  FocusNode frontNameFocusNode = FocusNode();
  FocusNode backNameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode cPasswordFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode dobFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode noKtpFocusNode = FocusNode();
  FocusNode noHpFocusNode = FocusNode();


  bool isLoading = false;

  final dbRef = FirebaseDatabase.instance.reference().child("users");



  @override
  void dispose() {
    super.dispose();
    frontNameFocusNode.dispose();
    backNameFocusNode.dispose();
    passwordFocusNode.dispose();
    emailFocusNode.dispose();
    dobFocusNode.dispose();
    addressFocusNode.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // _apiRequest = APIRequest.create(context);
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(COLOR_PRIMARY);

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: COLOR_PRIMARY,
        body: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 24),
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                    "assets/icon_splash.png", height: 200, width: 200),
                // child: SvgPicture.asset("assets/ic_facebook.svg", color: white.withOpacity(0.8), height: 150, width: 150),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 200),
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(15),
                    topLeft: Radius.circular(15)),
                color: whiteColor,
              ),
              child: isLoading ? CommonLoading() : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: frontNameCont,
                      focusNode: frontNameFocusNode,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(backNameFocusNode);
                      },
                      style: TextStyle(color: blackColor),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: COLOR_DIVIDER)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: COLOR_YELLOW)),
                        labelText: "Front Name",
                        labelStyle: TextStyle(color: COLOR_GREY, fontSize: 14),
                      ),
                    ),
                    TextFormField(
                      controller: backNameCont,
                      focusNode: backNameFocusNode,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(passwordFocusNode);
                      },
                      style: TextStyle(color: blackColor),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: COLOR_DIVIDER)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: COLOR_YELLOW)),
                        labelText: "Back Name",
                        labelStyle: TextStyle(color: COLOR_GREY, fontSize: 14),
                      ),
                    ),
                    TextFormField(
                      controller: passwordCont,
                      focusNode: passwordFocusNode,
                      obscureText: !_showPassword,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: blackColor),
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(color: COLOR_GREY, fontSize: 14),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          child: Icon(_showPassword ? Icons.visibility : Icons
                              .visibility_off, color: COLOR_YELLOW, size: 20),
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: COLOR_DIVIDER)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: COLOR_YELLOW)),
                      ),
                    ),
                    TextFormField(
                      controller: cPasswordCont,
                      focusNode: cPasswordFocusNode,
                      obscureText: !_showPassword,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: blackColor),
                      decoration: InputDecoration(
                        labelText: "Confirmation Password",
                        labelStyle: TextStyle(color: COLOR_GREY, fontSize: 14),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showCPassword = !_showCPassword;
                            });
                          },
                          child: Icon(_showCPassword ? Icons.visibility : Icons
                              .visibility_off, color: COLOR_YELLOW, size: 20),
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: COLOR_DIVIDER)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: COLOR_YELLOW)),
                      ),
                    ),
                    TextFormField(
                      controller: emailCont,
                      focusNode: emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(dobFocusNode);
                      },
                      style: TextStyle(color: blackColor),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: COLOR_DIVIDER)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: COLOR_YELLOW)),
                        labelText: "Email",
                        labelStyle: TextStyle(color: COLOR_GREY, fontSize: 14),
                      ),
                    ),
                    TextFormField(
                      controller: addressCont,
                      focusNode: addressFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      style: TextStyle(color: blackColor),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: COLOR_DIVIDER)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: COLOR_YELLOW)),
                        labelText: "Address",
                        suffixIcon: Icon(
                            Icons.location_on, color: COLOR_YELLOW, size: 18),
                        labelStyle: TextStyle(color: COLOR_GREY, fontSize: 14),
                      ),
                    ),
                    // TextFormField(
                    //   controller: noKtpCont,
                    //   focusNode: noKtpFocusNode,
                    //   textInputAction: TextInputAction.next,
                    //   keyboardType: TextInputType.number,
                    //   // maxLines: 2,
                    //   style: TextStyle(color: blackColor),
                    //   decoration: InputDecoration(
                    //     enabledBorder: UnderlineInputBorder(
                    //         borderSide: BorderSide(color: COLOR_DIVIDER)),
                    //     focusedBorder: UnderlineInputBorder(
                    //         borderSide: BorderSide(color: COLOR_YELLOW)),
                    //     labelText: "No. KTP",
                    //     suffixIcon: Icon(
                    //         Icons.assignment, color: COLOR_YELLOW, size: 18),
                    //     labelStyle: TextStyle(color: COLOR_GREY, fontSize: 14),
                    //   ),
                    // ),
                    TextFormField(
                      controller: noHpCont,
                      focusNode: noHpFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      // maxLines: 2,
                      style: TextStyle(color: blackColor),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: COLOR_DIVIDER)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: COLOR_YELLOW)),
                        labelText: "Phone Number",
                        suffixIcon: Icon(
                            Icons.phone, color: COLOR_YELLOW, size: 18),
                        labelStyle: TextStyle(color: COLOR_GREY, fontSize: 14),
                      ),
                    ),
                    16.height,
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: RaisedButton(
                        padding: EdgeInsets.all(12),
                        onPressed: () {
                          //finish(context);
                          setState(() {
                            isLoading = true;
                          });
                          validateData();
                        },
                        color: COLOR_YELLOW,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius
                            .circular(10.0)),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: whiteColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    24.height,
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          finish(context);
                        },
                        child: Text.rich(
                          TextSpan(
                            text: "$str_already_have_account",
                            style: TextStyle(color: COLOR_TEXTCOLORSECONDARY),
                            children: <TextSpan>[
                              TextSpan(text: "Sign In",
                                  style: TextStyle(color: COLOR_YELLOW))
                            ],
                          ),
                        ),
                      ),
                    ),
                    8.height,
                  ],
                ),
              ),
            ),
            //Icon(Icons.arrow_back_ios, color: Colors.white,),
            BackButton(color: Colors.white),
          ],
        ),
      ),
    );
  }

  void validateData() {
    if (emailCont.text.isEmpty) {
      Utils.showToast(context, "Email cannot empty!");
      setState(() {
        isLoading = false;
      });
      // emailFocusNode.
      return;
    }

    if (passwordCont.text.isEmpty) {
      Utils.showToast(context, "Password cannot empty!");
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (cPasswordCont.text.isEmpty) {
      Utils.showToast(context, "Confirmation password cannot empty!");
      setState(() {
        isLoading = false;
      });
      //Utils.showToast(context, "Confirmation password cannot empty!");
      return;
    }

    if (frontNameCont.text.isEmpty) {
      Utils.showToast(context, "Front name cannot empty");
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (backNameCont.text.isEmpty) {
      Utils.showToast(context, "Backname cannot empty");
      setState(() {
        isLoading = false;
      });
      return;
    }


    if (noHpCont.text.isEmpty) {
      Utils.showToast(context, "Phone number cannot empty!");
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (passwordCont.text != cPasswordCont.text) {
     Utils.showToast(context, "Password & Confirmation not same! please check again");
      setState(() {
        isLoading = false;
      });
      return;
    }


    String emailValidator = Utils.emailValidator(emailCont.text);
    if(emailValidator!=null){
      Utils.showToast(context, emailValidator);
      return ;
    }


    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users
        .add({
      "frontName": frontNameCont.text,
      "backName": backNameCont.text,
      "password": passwordCont.text,
      "email": emailCont.text,
      "address": addressCont.text,
      "phoneNumber": noHpCont.text,
      "isValidate" : "false"
    })
        .then((value) {
          UserAccount userAccount = new UserAccount(
          phoneNumber: noHpCont.text,
          isValidate: 'false',
          email: emailCont.text,
          password: passwordCont.text,
          frontName: frontNameCont.text,
          backName: backNameCont.text,
          address: addressCont.text
      );
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(userAccount: userAccount,)));

    })
        .catchError((error) {
      print("Failed to add user: $error");
    });





  }
}
