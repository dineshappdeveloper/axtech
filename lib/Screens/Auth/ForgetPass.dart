import 'dart:io';

import 'package:crm_application/Screens/Auth/UpdatePassScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Provider/AuthProvider.dart';
import '../../Utils/Colors.dart';
import '../../Utils/CustomDialogs.dart';
import '../../Utils/ImageConst.dart';

class ForgetPassScreen extends StatefulWidget {
  static const routeName = '/forgetpass';

  const ForgetPassScreen({Key? key}) : super(key: key);

  @override
  _ForgetPassScreenState createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  FocusNode emailFocusNode = FocusNode();
  FocusNode otpFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool isOTPVisible = false;
  bool isEmailVisible = true;
  var userId, otp;
  late Map<String, dynamic> response;

  Future<void> ForgetPass() async {
    try {
      // Log user in
      response =
          await Provider.of<AuthProvider>(context, listen: false).ForgetPass(
        emailController.text,
      );
      userId = response['userId'];
      otp = response['otp'];
      debugPrint('UserId : $userId \nOTP : $otp');
      CustomDialogs.showSuccessToast('email sent Successful');
      setState(
        () {
          ShowDialogOtp();
          isOTPVisible = true;
          isEmailVisible = false;
        },
      );
      setState(
        () {
          _isLoading = false;
        },
      );
    } on HttpException {
      var errorMsg =
          "This account seems doesn't exists, please check and try again.";
      CustomDialogs.showErrorDialog(errorMsg, context);
    } catch (error) {
      debugPrint('Error Email sending : ${error.toString()}');
      const errorMsg = 'Could not send email!';
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
    return Scaffold(
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
                  SizedBox(height: _screenSize.height / 8),
                  Center(
                    child: SizedBox(
                      height: 200.h,
                      width: 250.w,
                      child: Image.asset(ImageConst.AppLogo),
                    ),
                  ),
                  Visibility(
                    visible: isEmailVisible,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        Text(
                          "Enter Your Email",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
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
                              return "Please enter a valid email address";
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
                            //FocusScope.of(context).requestFocus(passFocusNode);
                          },
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            hintText: 'Username/email',
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.grey),
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
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          ForgetPass();
                                        },
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Please correct the errors in the form",
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.email,
                                      color: Colors.black),
                                  label: const Text(
                                    "Send",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isOTPVisible,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        Text(
                          "Enter the OTP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          controller: otpController,
                          textCapitalization: TextCapitalization.none,
                          focusNode: otpFocusNode,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter a otp";
                            } else if (value.length < 6) {
                              return "Please enter valid otp";
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                          autocorrect: false,
                          onEditingComplete: () {
                            otpFocusNode.unfocus();
                            //FocusScope.of(context).requestFocus(passFocusNode);
                          },
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            hintText: '6 Digit OTP',
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.grey),
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
                                          // _isLoading = true;
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          if (otpController.text.toString() !=
                                              otp.toString()) {
                                            setState(
                                              () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title:
                                                        const Text('Error occurred'),
                                                    content: const Text(
                                                        "Entered OTP doesn't match"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          setState(
                                                            () {
                                                              Navigator.pop(
                                                                  context);
                                                              otpController
                                                                  .clear();
                                                            },
                                                          );
                                                        },
                                                        child:
                                                            const Text('Okay'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          } else {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdatePassScreen(
                                                  userId: userId,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Please correct the errors in the form",
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.email,
                                      color: Colors.black),
                                  label: const Text(
                                    "Update",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void ShowDialogOtp() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Verify OTP'),
          content: const Text(
              'OTP has been send on your mail, please check and confirm!'),
          actions: [
            TextButton(
              onPressed: () {
                setState(
                  () {
                    Navigator.pop(context);
                    isOTPVisible = true;
                    isEmailVisible = false;
                  },
                );
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      ),
    );
  }
}
