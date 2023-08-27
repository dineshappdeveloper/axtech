import 'dart:convert';
import 'dart:io';

import 'package:crm_application/Screens/DashBoard/dashboard.dart';
import 'package:crm_application/UserInitialization/WelcomScreen.dart';
import 'package:crm_application/Utils/Colors.dart';
import 'package:crm_application/Utils/ImageConst.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/NewModels/UsrModel.dart';
import '../../Provider/AuthProvider.dart';
import '../../Provider/UserProvider.dart';
import '../../Utils/Constant.dart';
import '../Auth/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
    // required this.deviceToken,
  }) : super(key: key);
// final String deviceToken;
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String TAG = 'SplashScreen';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late String _deviceToken;
  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin(context);
  }

  Future<String> _saveDeviceToken() async {
    prefs = await SharedPreferences.getInstance();
    if (Platform.isAndroid) {
      var token = await FirebaseMessaging.instance.getToken();
      setState(() {
        _deviceToken = token!;
      });
    } else if (Platform.isIOS) {
      var token;
      try {
        token = await FirebaseMessaging.instance.getToken();
        setState(() {
          _deviceToken = token!;
          print('Ios token :--- $token');
        });
      } catch (e) {
        print(e);
      }
      print('Ios token :--- $token');
      setState(() {
        _deviceToken = token!;
      });
    }
    debugPrint('--------Device Token---------- $_deviceToken');
    await prefs.setString(Const.FCM_TOKEN, _deviceToken);
    return _deviceToken;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: themeColor,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: size.height / 4,
              ),
              Center(
                child: SizedBox(
                  width: 300,
                  height: 250,
                  child: Image.asset(ImageConst.AppLogo),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        color: themeColor,
        child: Center(
          child: CircularProgressIndicator.adaptive(
            strokeWidth: Platform.isAndroid ? 3 : 20,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }

  void checkLogin(BuildContext context) async {
    try {
      await _saveDeviceToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');
      debugPrint("$TAG UserId : $userId");
      debugPrint("$TAG  : $_deviceToken");
      Future.delayed(
        const Duration(seconds: 3),
        () async {
          if (userId == null) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginScreen(
                      deviceToken: _deviceToken,
                    )));
          } else {
            // Navigator.of(context).pushReplacementNamed('/home');
            prefs = await SharedPreferences.getInstance();
            await Provider.of<AuthProvider>(context, listen: false).login(
                prefs.getString('email')!,
                prefs.getString('password')!,
                prefs.getString(Const.FCM_TOKEN)!,
                context);

            Provider.of<UserProvider>(context, listen: false).user =
                UserModel.fromJson(jsonDecode(prefs.getString('user')!));
            print('User role in splash screen update ${Provider.of<UserProvider>(context, listen: false).user.role}');
            print('User role in splash screen update ${Provider.of<UserProvider>(context, listen: false).role}');
            Get.offAll(const DashBoard());
          }
        },
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: 'Slow internet connection.');
    }
  }
}
