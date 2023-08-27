import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:crm_application/Provider/UserProvider.dart';
import 'package:crm_application/Screens/Profile/UserProfile.dart';
import 'package:crm_application/Utils/Colors.dart';
import 'package:crm_application/Utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../Screens/DashBoard/NavigationMain.dart';
import '../Screens/DashBoard/dashboard.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);
  static const String route = '/welcomePage';

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Get.offAll(const DashBoard());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (true) SizedBox(height: Get.height * 0.2),
            Container(
              height: Get.height * 0.2,
              width: Get.width * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: themeColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Htext('Welcome'),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Ttext('Loading'),
                      AnimatedTextKit(
                        totalRepeatCount: 1000,
                        animatedTexts: [
                          TyperAnimatedText('...',
                              speed: const Duration(milliseconds: 400),
                              textStyle: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (true)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: Get.width * 0.1),
                            child:     ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeColor,
                                disabledBackgroundColor:  const Color(0xABA4A3A3),

                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),),

                              onPressed: () {
                                Provider.of<UserProvider>(context,listen: false).role='agent';
                                Get.offAll(const DashBoard());
                              },

                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Htext('Get Started'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
