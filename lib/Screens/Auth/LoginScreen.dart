import 'dart:io';
import 'package:crm_application/Provider/AuthProvider.dart';
import 'package:crm_application/Screens/Auth/ForgetPass.dart';
import 'package:crm_application/Screens/DashBoard/dashboard.dart';
import 'package:crm_application/UserInitialization/WelcomScreen.dart';
import 'package:crm_application/Utils/Colors.dart';
import 'package:crm_application/Utils/CustomDialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/Constant.dart';
import '../../Utils/ImageConst.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  final String? deviceToken;
  const LoginScreen({Key? key, this.deviceToken}) : super(key: key);
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_LoginScreenState>()?.restartApp();
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode emailFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final String _message = '';

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String TAG = 'LoginScreen';
  var respons;
  String? _deviceToken = '';
  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFirebase();
  }

  initFirebase() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      _deviceToken = prefs.getString(Const.FCM_TOKEN);
    });
    // print('-----------------------'+Const.FCM_TOKEN.length.toString() );
    print('-----login page token------------------' + _deviceToken.toString());
    if (_deviceToken == null) {
      const errorMsg = 'Token not found Please restart the app!';
      if (!Platform.isIOS) {
        _showErrorDialog(errorMsg, context);
      }
    }
  }

  _showErrorDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message, style: const TextStyle(color: Colors.red)),
        actions: <Widget>[
          MaterialButton(
            child: const Text('Okay'),
            onPressed: () {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
                // LoginScreen.restartApp(context);
                print('restarting');
              } else if (Platform.isIOS) {
                exit(0);
              }
            },
          )
        ],
      ),
    );
  }

  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  Future<void> loginUser() async {
    debugPrint('Device TOKEN : $_deviceToken');
    prefs = await SharedPreferences.getInstance();

    _deviceToken = prefs.getString(Const.FCM_TOKEN);
    bool setted = await prefs.setString(Const.FCM_TOKEN, _deviceToken!);
    print(setted);
    try {
      // Log user in
      await Provider.of<AuthProvider>(context, listen: false).login(
        emailController.text,
        passwordController.text,
        _deviceToken!,
        context,
      );

      // Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
      Get.offAll(const WelcomePage());
      CustomDialogs.showSuccessToast('Login Successful');
    } on HttpException catch (e) {
      var errorMsg = 'You are not registered as Agent.';
      CustomDialogs.showErrorDialog(errorMsg, context);
    } catch (error) {
      debugPrint('Error Login : ${error.toString()}');
      const errorMsg = 'Invalid credentials, please try again';
      CustomDialogs.showErrorDialog(errorMsg, context);
    }
    setState(
      () {
        _isLoading = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return KeyedSubtree(
      key: key,
      child: Scaffold(
        backgroundColor: themeColor,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 54),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 200.h,
                        width: 250.w,
                        child: Image.asset(ImageConst.AppLogo),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Login in to Getting Started",
                        style: TextStyle(
                          fontSize: 20.w,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        // textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 50.h),
                    Text(
                      "Username/email",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.w,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      controller: emailController,
                      textCapitalization: TextCapitalization.none,
                      focusNode: emailFocusNode,
                      validator: (emailValue) {
                        //var pattern = "[a-zA-Z0-9]{2,}@[a-z]*[.][a-z]{2,}";
                        RegExp regExp = RegExp(
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                        if (!regExp.hasMatch(emailValue!)) {
                          return "Please enter a valid email addreess";
                        }
                        return null;
                      },
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                      autocorrect: false,
                      onEditingComplete: () {
                        emailFocusNode.unfocus();
                        FocusScope.of(context).requestFocus(passFocusNode);
                      },
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        hintText: 'Username',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w300, color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 25.h),
                    Text(
                      "Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.w,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextFormField(
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      controller: passwordController,
                      textCapitalization: TextCapitalization.none,
                      focusNode: passFocusNode,
                      validator: (nameValue) {
                        if (nameValue == null) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                      autocorrect: false,
                      onEditingComplete: () {
                        passFocusNode.unfocus();
                      },
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        hintText: '******',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    SizedBox(
                      width: _screenSize.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, ForgetPassScreen.routeName);
                            },
                            child: Text(
                              'Forgot your password?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.w,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: _screenSize.height / 14),
                    _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Center(
                            child: TextButton.icon(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 9,
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(
                                    () {
                                      _isLoading = true;
                                      loginUser();
                                      //_register();
                                    },
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please correct the errors in the form",
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: Icon(
                                Icons.email,
                                color: Colors.black,
                                size: 21.w,
                              ),
                              label: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.w),
                              ),
                            ),
                          ),
                    // TextButton.icon(
                    //   style: TextButton.styleFrom(
                    //     backgroundColor: Colors.white,
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 25,
                    //       vertical: 9,
                    //     ),
                    //   ),
                    //   label: Text('Restart App'),
                    //   icon: Icon(Icons.restart_alt),
                    //   onPressed: () {
                    //     LoginScreen.restartApp(context);
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
