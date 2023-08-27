import 'dart:io';
import 'package:crm_application/FCM/local_notification_service.dart';
import 'package:crm_application/Provider/ColdCallProvider.dart';
import 'package:crm_application/Provider/DumpLeadsProvider.dart';
import 'package:crm_application/Provider/LeavesProvider.dart';
import 'package:crm_application/Screens/DashBoard/dashboard.dart';
import 'package:crm_application/Utils/Constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Provider/AuthProvider.dart';
import 'Provider/DialProvider.dart';
import 'Provider/InteractionProvider.dart';
import 'Provider/LeadsProvider.dart';
import 'Provider/Reports/userActivityProvider.dart';
import 'Provider/SSSProvider.dart';
import 'Provider/UserProvider.dart';
import 'Provider/closedLeadsProvider.dart';
import 'Screens/Auth/ForgetPass.dart';
import 'Screens/Auth/LoginScreen.dart';
import 'Screens/Cold Calls/MyLeads/LeadFilter/Filter/FilterProvider.dart';
import 'Screens/Cold Calls/MyLeads/MyLeadScreen.dart';
import 'Screens/DashBoard/NavigationMain.dart';
import 'Screens/SplashScreen/SplashScreen.dart';

// PURE IOS APK

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp();
  LocalNotificationService.initialize();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      runApp(const CRMApp());
    },
  );
}
final navigatorKey = GlobalKey<NavigatorState>();

class CRMApp extends StatefulWidget {
  const CRMApp({Key? key}) : super(key: key);

  @override
  State<CRMApp> createState() => _CRMAppState();
}

  final mycontext = navigatorKey.currentContext!;
class _CRMAppState extends State<CRMApp> {
  // This widget is the root of your application.

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late String _deviceToken;
  late SharedPreferences prefs;



  @override
  void initState() {
    super.initState();

    _saveDeviceToken();

    // workaround for onLaunch: When the app is completely closed (not in the background) and opened directly from the push notification
    _firebaseMessaging.getInitialMessage().then(
      (RemoteMessage? message) {
        debugPrint('getInitialMessage data: ${message?.data}');
         if (message == null) return;

    if (message.data['redirect_screen'] == 'my_lead') {
      Navigator.push(
        mycontext,
        MaterialPageRoute(
          // builder: (context) => ContactTabsScreen(pageIndex: 'leads'),
          builder: (context) => MyLeadScreen(),
        ),
      );
    }
      },
      
    );

    // onMessage: When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        debugPrint("onMessage data: ${message.data}");
        LocalNotificationService.createanddisplaynotification(message);
          if (message == null) return;

    if (message.data['redirect_screen'] == 'my_lead') {
      Navigator.push(
        mycontext,
        MaterialPageRoute(
          // builder: (context) => ContactTabsScreen(pageIndex: 'leads'),
          builder: (context) => MyLeadScreen(),
        ),
      );
    }
      },
    );

    // replacement for onResume: When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        debugPrint('onMessageOpenedApp data: ${message.data}');
  if (message == null) return;

    if (message.data['redirect_screen'] == 'my_lead') {
      Navigator.push(
        mycontext,
        MaterialPageRoute(
          // builder: (context) => ContactTabsScreen(pageIndex: 'leads'),
          builder: (context) => MyLeadScreen(),
        ),
      );
    }
      },
    );
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
    return Builder(builder: (context) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => UserProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => AuthProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => LeadsProvider(),
          ),
           ChangeNotifierProvider(
            create: (ctx) => DumpLeadsProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => ClosedLeadsProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => SSSProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => InteractionProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => ColdCallProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => FilterProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => LeavesProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => UserActivityProvider(),
          ),
           ChangeNotifierProvider(
            create: (ctx) => DialProvider(),
          ),
        ],
        child: Consumer<AuthProvider>(
          builder: (ctx, auth, _) {
            return ScreenUtilInit(
              designSize: const Size(375, 770),
              //minTextAdapt: true,
              splitScreenMode: true,
              builder: () => GetMaterialApp(
                navigatorKey: navigatorKey,
                title: 'CRM Application',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  textTheme: GoogleFonts.workSansTextTheme(),
                ),
                home: SplashScreen(
                    // deviceToken: _deviceToken,
                    ),
                routes: {
                  '/home': (ctx) => const DashBoard(),
                  LoginScreen.routeName: (ctx) => const LoginScreen(),
                  ForgetPassScreen.routeName: (ctx) => const ForgetPassScreen(),
                },
              ),
            );
          },
        ),
      );
    });
  }
}
