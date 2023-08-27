import 'package:crm_application/Provider/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Utils/Colors.dart';
import '../../Utils/ImageConst.dart';

class UpdatePassScreen extends StatefulWidget {
  int userId;

  UpdatePassScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<UpdatePassScreen> createState() => _UpdatePassScreenState();
}

class _UpdatePassScreenState extends State<UpdatePassScreen> {
  FocusNode emailFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  bool _isLoading = false;
  bool _isPassword = true;
  bool _iscPassword = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: themeColor,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => SingleChildScrollView(
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
                    const Center(
                      child: Text(
                        "Create a new Password",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 50.h),
                    Text(
                      "New Password",
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
                      obscureText: _isPassword,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      controller: passwordController,
                      textCapitalization: TextCapitalization.none,
                      focusNode: emailFocusNode,
                      validator: (passValue) {
                        if (passValue!.isEmpty) {
                          return 'Please Enter a new password';
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
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(
                              () {
                                _isPassword = !_isPassword;
                              },
                            );
                          },
                          icon: _isPassword
                              ? const Icon(Icons.visibility_off,
                                  color: Colors.white)
                              : const Icon(Icons.visibility,
                                  color: Colors.white),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        disabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        hintText: '******',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 25.h),
                    const Text(
                      "Confirm Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextFormField(
                      obscureText: _iscPassword,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      controller: confirmPassController,
                      textCapitalization: TextCapitalization.none,
                      focusNode: passFocusNode,
                      validator: (cPassValue) {
                        if (cPassValue == null) {
                          return 'Please enter password';
                        } else if (passwordController.text != cPassValue) {
                          return "Confirm password doesNot match";
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
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(
                              () {
                                _iscPassword = !_iscPassword;
                              },
                            );
                          },
                          icon: _iscPassword
                              ? const Icon(Icons.visibility_off,
                                  color: Colors.white)
                              : const Icon(Icons.visibility,
                                  color: Colors.white),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        disabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        hintText: '******',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 28.h,
                    ),
                    SizedBox(height: _screenSize.height / 14),
                    authProvider.isLoading
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
                                      //_isLoading = true;
                                      //LoginUser();
                                      authProvider.updatePass(
                                        widget.userId.toString(),
                                        passwordController.text,
                                        confirmPassController.text,
                                        context,
                                      );
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
                              icon:
                                  const Icon(Icons.email, color: Colors.black),
                              label: const Text(
                                "Login",
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
            ),
          ),
        ),
      ),
    );
  }
}
