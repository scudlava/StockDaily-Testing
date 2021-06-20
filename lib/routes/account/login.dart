import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfinancial/model/user_account.dart';
import 'package:myfinancial/routes/home/main_tab.dart';
import 'package:myfinancial/util/util.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:myfinancial/constant/colors.dart';
import 'package:myfinancial/constant/dimens.dart';
import 'package:myfinancial/constant/string.dart';
import 'package:myfinancial/routes/account/register.dart';

import 'otp_verification.dart';

class LoginScreen extends StatefulWidget{
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen>{
  TextEditingController emailCont = new TextEditingController();
  TextEditingController passCont = new TextEditingController();
  bool isShowPass = false;
  FocusNode emailFocusNode = new FocusNode();
  FocusNode passFocusNode = new FocusNode();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isLoading = false;


  void onLogin(){

    if(emailCont.text.isEmpty){
      //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Email tidak boleh kosong!")));
      Fluttertoast.showToast(
          msg: "Email tidak boleh kosong!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      setState(() {
        isLoading = false;
      });
      return ;
    }

    if(passCont.text.isEmpty){
      // _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Password tidak boleh kosong!")));
      Fluttertoast.showToast(

          msg: "Password tidak boleh kosong!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      setState(() {
        isLoading = false;
      });
      return ;
    }

    String emailValidator = Utils.emailValidator(emailCont.text);
    if(emailValidator!=null){
      Utils.showToast(context, emailValidator);
      return ;
    }

    FirebaseFirestore.instance.collection('users').where('email', isEqualTo: emailCont.text)
        .where('password', isEqualTo: passCont.text)
        .snapshots().listen(
            (data) {

              isLoading=false;
              if(data.docs!=null){
                if(data.docs.isNotEmpty){
                  if(data.docs[0]['isValidate']==true){
                    UserAccount userAccount = new UserAccount(
                        id: data.docs[0].id,
                        phoneNumber: data.docs[0]['phoneNumber'],
                        isValidate: data.docs[0]['isValidate'],
                        email: data.docs[0]['email'],
                        password: data.docs[0]['password'],
                        frontName: data.docs[0]['frontName'],
                        backName: data.docs[0]['backName'],
                        address: data.docs[0]['address']
                    );
                    UserProfile.save(userAccount).then((value) {
                      TabHome().launch(context);

                    });
                    // TabHome().launch(context);
                  }else{
                    Utils.showToast(context, 'Account is not validate');
                    UserAccount userAccount = new UserAccount(
                      id: data.docs[0].id,
                      phoneNumber: data.docs[0]['phoneNumber'],
                      isValidate: data.docs[0]['isValidate'],
                        email: data.docs[0]['email'],
                        password: data.docs[0]['password'],
                        frontName: data.docs[0]['frontName'],
                        backName: data.docs[0]['backName'],
                        address: data.docs[0]['address']
                    );

                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => OtpVerificationScreen(userAccount: userAccount,)));
                  }
                }else{
                  Utils.showToast(context, 'user not found');
                }

                // print('email ${data.docs[0]['email']}');
              }else{
                Utils.showToast(context, 'user not found');
              }
            }
    );


  }

  
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailFocusNode.dispose();
    passFocusNode.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new SafeArea(
        child: new Scaffold(
          key: _scaffoldKey,
          backgroundColor: COLOR_PRIMARY,
          body: Stack(
            children: [
              Container(
                  margin: EdgeInsets.only(top: padding_24),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset("assets/icon_splash.png", height: 200, width: 200),
                  ),
              ),
              Container(
                margin: EdgeInsets.only(top: 200),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                  color: COLOR_WHITE,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: emailCont,
                        focusNode: emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(passFocusNode);
                        },
                        style: TextStyle(color: COLOR_BLACK),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: COLOR_DIVIDER)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: COLOR_YELLOW)),
                          labelText: "Email",
                          labelStyle: TextStyle(color: COLOR_GREY, fontSize: 14),
                        ),
                      ),
                      TextFormField(
                        controller: passCont,
                        focusNode: passFocusNode,
                        obscureText: !isShowPass,
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: COLOR_BLACK),
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(color: COLOR_GREY, fontSize: 14),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isShowPass = !isShowPass;
                              });
                            },
                            child: Icon(isShowPass ? Icons.visibility : Icons.visibility_off, color: COLOR_YELLOW, size: 20),
                          ),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: COLOR_DIVIDER)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: COLOR_YELLOW)),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: GestureDetector(
                      //     onTap: () {
                      //     },
                      //     child: Text(str_forget_pwd, style: TextStyle(color: COLOR_TEXTCOLORPRIMARY, fontSize: 14)),
                      //   ),
                      // ),
                      // 16.height,
                      new SizedBox(height: 16.0,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          padding: EdgeInsets.all(12),
                          onPressed: () {
                            // finish(context);
                            // TabHome().launch(context);
                            setState(() {
                              //isLoading = true;
                            });
                            onLogin();
                          },
                          color: COLOR_YELLOW,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          child: Text("Sign In", style: TextStyle(color: COLOR_WHITE, fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      // 16.height,
                      new SizedBox(height: 16.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: Container(height: 1, color: COLOR_DIVIDER, margin: EdgeInsets.only(right: 10))),
                          Text("Login", style: TextStyle(color: COLOR_GREY)),
                          Expanded(child: Container(height: 1, color: COLOR_DIVIDER, margin: EdgeInsets.only(left: 10))),
                        ],
                      ),
                      // 16.height,
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     SvgPicture.asset("assets/ic_twitter.svg", height: 40, width: 40),
                      //     SvgPicture.asset("assets/ic_facebook.svg", height: 40, width: 40),
                      //     SvgPicture.asset("assets/ic_youtube.svg", height: 40, width: 40),
                      //   ],
                      // ),
                      // 24.height,
                      new SizedBox(height: 24.0,),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            RegisterScreen().launch(context);
                          },
                          child: Text.rich(
                            TextSpan(
                              text: "you don't have account? ",
                              style: TextStyle(color: COLOR_TEXTCOLORPRIMARY),
                              children: <TextSpan>[
                                TextSpan(text: "Sign Up", style: TextStyle(color: COLOR_YELLOW)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ),
            ],
          ),
        )
    );
  }
  
}