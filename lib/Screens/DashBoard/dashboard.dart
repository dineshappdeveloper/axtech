import 'dart:convert';
import 'dart:io';
import 'package:crm_application/ApiManager/Apis.dart';
import 'package:crm_application/Models/NewModels/UsrModel.dart';
import 'package:crm_application/Provider/DialProvider.dart';
import 'package:crm_application/Provider/UserProvider.dart';
import 'package:crm_application/Utils/Colors.dart';
import 'package:crm_application/Utils/ImageConst.dart';
import 'package:crm_application/Widgets/DrawerWidget.dart';
import 'package:crm_application/Widgets/IconsWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Models/DashBoardModel.dart';
import '../../Utils/Constant.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? userId;
  var authToken, fName = '', lName = '';
  late SharedPreferences prefs;
  bool _isLoading = true;
  var tot_cold_call, tot_leads, tot_properties, featured_properties;
  List<FeaturedProperty> propertiesList = [];
  String? userProfile, availability;
  void init() async {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckState();

    var dp = Provider.of<DialProvider>(context, listen: false);
    if (dp.timer != null) {
      dp.timer!.cancel();
    }
    dp.fetchDialedCalls();
  }

  void CheckState() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId')!;
    fName = prefs.getString('fname')!;
    lName = prefs.getString('lname')!;
    userProfile = prefs.getString('image');
    availability = prefs.getString('availability');
    authToken = prefs.getString('token');
    debugPrint('CheckUserId : $userId');
    debugPrint('CheckUserName : $fName');
    debugPrint('CheckUserLName : $lName');
    getDashBoardDetails();
  }

  void getDashBoardDetails() async {
    var url = '${ApiManager.BASE_URL}dashboard';
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $authToken',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      var responseData = json.decode(response.body);
      print('DashboardResponse : ${responseData.toString()}');
      if (response.statusCode == 200) {
        var success = responseData['success'];
        tot_cold_call = responseData['tot_cold_call'];
        tot_leads = responseData['tot_leads'];
        tot_properties = responseData['tot_properties'];
        featured_properties = responseData['featured_properties'];
        if (success == 200) {
          setState(
            () {
              _isLoading = false;
            },
          );
          featured_properties.forEach((v) {
            propertiesList.add(FeaturedProperty.fromJson(v));
          });
        }
      } else {
        setState(
          () {
            _isLoading = false;
          },
        );
        throw const HttpException('Failed To get Leads');
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return Consumer<UserProvider>(builder: (context, up, _) {
      myId = up.user.data!.id!;
      var data = up.user.data!;

      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: themeColor,
          elevation: 1,
          // title: Text('DashBoard(${up.user.role})'),
          title: const Text('Dashboard'),
        ),
        endDrawer: CustomDrawer(
          userID: data.id,
          fname: data.firstName!,
          lname: data.lastName!,
          profile_url: data.userProfile,
          authToken: up.user.token,
          availability: data.availability,
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Center(
                      child: SizedBox(
                        height: 200.h,
                        width: 200.h,
                        child: Image.asset(ImageConst.logo, fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Container(
                      height: _screenSize.height * .2, //150
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: themeColor,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 35,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 13.0,
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'MY LEADS',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 17,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Text(
                                        '--',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10.0,
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'COLD CALLS',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 17,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Text(
                                        '--',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 20,
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'PROPERTIES',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 17,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Text(
                                        '--',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    SizedBox(
                      height: _screenSize.height * .5, //
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                        // childAspectRatio: 1,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: LeadWidget("MY LEADS", context),
                            ),
                             Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: DumpLeadWidget("DUMPED LEADS", context),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 8.0),
                            //   child: InteractionWidget("INTERACTIONS", context),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: LeavesWidget("LEAVES", context),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 8.0),
                            //   child: ReportWidget("REPORTS"),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: CallsWidget("COLD CALLS", context),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 8.0),
                            //   child: DialerWidget("DIALER", context),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    // Column(
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 20.0, right: 20),
                    //       child: SizedBox(
                    //         child: Row(
                    //           //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Image.asset(
                    //               ImageConst.report_icon,
                    //               height: 30.h,
                    //               width: 30.h,
                    //             ),
                    //             Padding(
                    //               padding: const EdgeInsets.all(8.0),
                    //               child: Text(
                    //                 'Total Payable incentives',
                    //                 style: TextStyle(
                    //                   color: Colors.black,
                    //                   fontSize: 18.sp,
                    //                 ),
                    //               ),
                    //             ),
                    //             const Spacer(),
                    //             Text(
                    //               'AED 0',
                    //               style: TextStyle(
                    //                 color: Colors.blue,
                    //                 fontSize: 18.sp,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //     const Padding(
                    //       padding:
                    //           EdgeInsets.only(left: 20.0, right: 20, top: 10),
                    //       child: Divider(
                    //         color: Colors.black,
                    //         height: 2,
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       height: 25.h,
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 20.0, right: 20),
                    //       child: SizedBox(
                    //         child: Row(
                    //           //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Image.asset(ImageConst.report_icon,
                    //                 height: 30.h, width: 30.h),
                    //             Padding(
                    //               padding: const EdgeInsets.all(8.0),
                    //               child: Text(
                    //                 'Paid incentives',
                    //                 style: TextStyle(
                    //                   color: Colors.black,
                    //                   fontSize: 18.sp,
                    //                 ),
                    //               ),
                    //             ),
                    //             const Spacer(),
                    //             Text(
                    //               'AED 0',
                    //               style: TextStyle(
                    //                 color: Colors.blue,
                    //                 fontSize: 18.sp,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //     const Padding(
                    //       padding:
                    //           EdgeInsets.only(left: 20.0, right: 20, top: 10),
                    //       child: Divider(
                    //         color: Colors.black,
                    //         height: 2,
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       height: 25.h,
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 20.0, right: 20),
                    //       child: SizedBox(
                    //         child: Row(
                    //           //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Image.asset(ImageConst.report_icon,
                    //                 height: 30.h, width: 30.h),
                    //             Padding(
                    //               padding: const EdgeInsets.all(8.0),
                    //               child: Text(
                    //                 'Balance Due',
                    //                 style: TextStyle(
                    //                   color: Colors.black,
                    //                   fontSize: 18.sp,
                    //                 ),
                    //               ),
                    //             ),
                    //             const Spacer(),
                    //             Text(
                    //               'AED 0',
                    //               style: TextStyle(
                    //                 color: Colors.blue,
                    //                 fontSize: 18.sp,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 30.h,
                    // ),
                    Center(
                      child: Text(
                        'Recent Projects',
                        style: TextStyle(
                          fontSize: 22.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    SizedBox(
                      height: 65.h,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 10),
                        child: ListView.builder(
                          itemCount: propertiesList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(
                                  child: Text(
                                    propertiesList[index].name.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    const Text(
                      'Brought to you by Xperties',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
      );
    });
  }
}
