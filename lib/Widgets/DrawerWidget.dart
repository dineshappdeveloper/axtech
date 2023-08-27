import 'package:crm_application/Screens/Auth/LoginScreen.dart';
import 'package:crm_application/Screens/DrawerPags/Notifications.dart';
import 'package:crm_application/Screens/DashBoard/dashboard.dart';
import 'package:crm_application/Screens/Profile/UserProfile.dart';
import 'package:crm_application/Utils/Colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Provider/AuthProvider.dart';
import '../Provider/ColdCallProvider.dart';
import '../Screens/Cold Calls/ColdCallScreen.dart';
import '../Screens/Cold Calls/ContactTabsScreen.dart';
import '../Screens/Cold Calls/Intraction/InteractionsScreen.dart';
import '../Screens/Cold Calls/MyLeads/MyLeadScreen.dart';
import '../Screens/Cold Calls/MyLeads/dumpedCall/DumpedLeadScreen.dart';
import '../Screens/DashBoard/UserManagement/UserManagementScreen.dart';
import '../Utils/ImageConst.dart';

class CustomDrawer extends StatefulWidget {
  String fname, lname;
  int? userID;
  String? profile_url, availability;
  var authToken;

  CustomDrawer({
    Key? key,
    required this.userID,
    required this.fname,
    required this.lname,
    required this.profile_url,
    required this.availability,
    required this.authToken,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late SharedPreferences pref;

  var _dropDownValue;
  late Icon icon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dropDownValue = widget.availability;
    switch (_dropDownValue) {
      case 'Available':
        icon = const Icon(
          Icons.circle,
          color: Colors.green,
          size: 10,
        );
        break;
      case 'In Meeting':
        icon = const Icon(
          MdiIcons.moonWaningCrescent,
          color: Colors.red,
          size: 13,
        );
        break;
      case 'Sick Leave':
        icon = const Icon(
          MdiIcons.circle,
          color: Colors.red,
          size: 10,
        );
        break;
      case 'Annual Leave':
        icon = const Icon(
          MdiIcons.circle,
          color: Colors.red,
          size: 10,
        );
        break;
    }
    Provider.of<ColdCallProvider>(context, listen: false)
        .getDeviceNotifications(widget.authToken, context);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(this.context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserProfile(),
                  ),
                );
              },
              child: Container(
                height: 200.h,
                decoration: BoxDecoration(
                  color: themeColor,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: widget.profile_url == null
                                ? SizedBox(
                                    width: 70.w,
                                    height: 70.h,
                                    child: Image.asset(ImageConst.userImage),
                                  )
                                : SizedBox(
                                    height: 80.h,
                                    width: 70.w,
                                    child: Image.network(
                                      widget.profile_url!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: 30.w,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello,',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.sp),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${widget.fname} ${widget.lname}',
                                        //'Testing',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.sp),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  'User ID : ${widget.userID}',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(this.context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const UserProfile(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 30.h,
                                width: 130.w,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text(
                                    'View Profile',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              height: 34.h,
                              width: 94.w,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: DropdownButton(
                                hint: _dropDownValue == null
                                    ? Center(
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 2,
                                              ),
                                              child: icon,
                                            ),
                                            const Text(
                                              'Available',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Center(
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 2,
                                              ),
                                              child: icon,
                                            ),
                                            Expanded(
                                              child: Text(
                                                _dropDownValue,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                isExpanded: true,
                                underline: Container(),
                                icon: Container(),
                                borderRadius: BorderRadius.circular(5),
                                dropdownColor: themeColor,
                                style: const TextStyle(color: Colors.white),
                                items: [
                                  'Available',
                                  'In Meeting',
                                  'Sick Leave',
                                  'Annual Leave'
                                ].map(
                                  (val) {
                                    return DropdownMenuItem<String>(
                                      value: val,
                                      child: Text(val),
                                    );
                                  },
                                ).toList(),
                                onChanged: (val) {
                                  setState(
                                    () {
                                      _dropDownValue = val;
                                      authProvider.changeAvailability(
                                        _dropDownValue,
                                        widget.authToken,
                                        context,
                                      );
                                    },
                                  );
                                },
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
            Expanded(
              child: ListView(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(this.context);
                      // Navigator.pushReplacementNamed(context, '/home');
                      Get.to(DashBoard());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: SizedBox(
                        height: 45.h,
                        child: Row(
                          children: [
                            Image.asset(
                              ImageConst.homeImage,
                              height: 35.h,
                              width: 35.h,
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            const Text(
                              'Dashboard',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Divider(
                    color: Colors.black,
                    height: 2.h,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(this.context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                           builder: (context) => MyLeadScreen(),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 45.h,
                        child: Row(
                          children: [
                            Image.asset(
                               ImageConst.leads_icon,
                              height: 35.h,
                              width: 35.h,
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            const Text(
                              'My Leads',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Divider(
                    color: Colors.black,
                    height: 2.h,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  InkWell(
                    onTap: (){
                        Navigator.pop(this.context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                           builder: (context) => DumpedLeadScreen(),
                          ),
                        );

                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: SizedBox(
                        height: 45.h,
                        child: Row(
                          children: [
                            Image.asset(
                             ImageConst.dump_leads_icon,
                              height: 35.h,
                              width: 35.h,
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            const Text(
                              'Dump Leads',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Divider(
                    color: Colors.black,
                    height: 2.h,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(this.context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ColdCallScreen(),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 45.h,
                        child: Row(
                          children: [
                            Image.asset(
                              ImageConst.callsImage,
                              height: 35.h,
                              width: 35.h,
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            const Text(
                              'Cold Calls',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Divider(
                    color: Colors.black,
                    height: 2.h,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Builder(builder: (context) {
                    if (kDebugMode) {
                      print(Provider.of<ColdCallProvider>(context)
                          .notifications
                          .length);
                    }
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                Notifications(authToken: widget.authToken)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: SizedBox(
                          height: 45.h,
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  Image.asset(
                                    ImageConst.notificationImage,
                                    height: 35.h,
                                    width: 35.h,
                                  ),
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        width: 13,
                                        height: 13,
                                        decoration: BoxDecoration(
                                            color:
                                                Provider.of<ColdCallProvider>(
                                                            context)
                                                        .notifications
                                                        .isNotEmpty
                                                    ? Colors.red
                                                    : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                      ))
                                ],
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                              const Text(
                                'Notifications',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  // SizedBox(
                  //   height: 15.h,
                  // ),
                  // Divider(
                  //   color: Colors.black,
                  //   height: 2.h,
                  // ),
                  // SizedBox(
                  //   height: 15.h,
                  // ),
                  
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 20.0),
                  //   child: SizedBox(
                  //     height: 45.h,
                  //     child: Row(
                  //       children: [
                  //         Image.asset(
                  //           ImageConst.reportsImage,
                  //           height: 35.h,
                  //           width: 35.h,
                  //         ),
                  //         SizedBox(
                  //           width: 15.w,
                  //         ),
                  //         const Text(
                  //           'Reports',
                  //           style: TextStyle(
                  //             color: Colors.black,
                  //             fontSize: 18,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 15.h,
                  // ),
                  // Divider(
                  //   color: Colors.black,
                  //   height: 2.h,
                  // ),
                  // SizedBox(
                  //   height: 15.h,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 20.0),
                  //   child: InkWell(
                  //     onTap: () {
                  //       // Get.to(UserManagementScreen());
                  //     },
                  //     child: SizedBox(
                  //       height: 45.h,
                  //       child: Row(
                  //         children: [
                  //           Image.asset(
                  //             ImageConst.reportsImage,
                  //             height: 35.h,
                  //             width: 35.h,
                  //           ),
                  //           SizedBox(
                  //             width: 15.w,
                  //           ),
                  //           const Text(
                  //             'Users Management',
                  //             style: TextStyle(
                  //               color: Colors.black,
                  //               fontSize: 18,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Divider(
                    color: Colors.black,
                    height: 2.h,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  InkWell(
                    onTap: () async {
                      await Provider.of<AuthProvider>(context, listen: false)
                          .Logout()
                          .then(
                              (value) => debugPrint('Logged Out Successfully'))
                          .then(
                            (_) => Navigator.pushNamedAndRemoveUntil(
                              context,
                              LoginScreen.routeName,
                              (route) => false,
                            ),
                          );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: SizedBox(
                        height: 45.h,
                        child: Row(
                          children: [
                            Image.asset(
                              ImageConst.logoutImage,
                              height: 35.h,
                              width: 35.h,
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            const Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
