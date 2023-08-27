// import 'dart:convert';
// import 'dart:io';
// import 'package:crm_application/Provider/AuthProvider.dart';
// import 'package:crm_application/Utils/Colors.dart';
// import 'package:crm_application/Utils/ImageConst.dart';
// import 'package:crm_application/Widgets/DrawerWidget.dart';
// import 'package:crm_application/Widgets/IconsWidget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import '../../Models/DashBoardModel.dart';
// import '../../Utils/Constant.dart';
//
// class NavigationMain extends StatefulWidget {
//   const NavigationMain({Key? key}) : super(key: key);
//
//   @override
//   _NavigationMainState createState() => _NavigationMainState();
// }
//
// class _NavigationMainState extends State<NavigationMain> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   int? userId;
//   var authToken, fName = '', lName = '';
//   late SharedPreferences prefs;
//   bool _isLoading = true;
//   var tot_cold_call, tot_leads, tot_properties, featured_properties;
//   List<FeaturedProperty> propertiesList = [];
//   String? userProfile, availability;
//
//   void refreshUser()async{
//     prefs = await SharedPreferences.getInstance();
//     CheckState();
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     refreshUser();
//   }
//
//   void CheckState() async {
//
//     userId = prefs.getInt('userId')!;
//     fName = prefs.getString('fname')!;
//     lName = prefs.getString('lname')!;
//     userProfile = prefs.getString('image');
//     availability = prefs.getString('availability');
//     authToken = prefs.getString('token');
//     debugPrint('CheckUserId : $userId');
//     debugPrint('CheckUserName : $fName');
//     debugPrint('CheckUserLName : $lName');
//     getDashBoardDetails();
//   }
//
//   void getDashBoardDetails() async {
//     var url = 'http://axtech.range.ae/api/v1/dashboard';
//     final headers = {
//       'Authorization-token': '3MPHJP0BC63435345341',
//       'Authorization': 'Bearer $authToken',
//     };
//     try {
//       final response = await http.get(Uri.parse(url), headers: headers);
//       var responseData = json.decode(response.body);
//      print('DashboardResponse : ${responseData.toString()}');
//       if (response.statusCode == 200) {
//         var success = responseData['success'];
//         tot_cold_call = responseData['tot_cold_call'];
//         tot_leads = responseData['tot_leads'];
//         tot_properties = responseData['tot_properties'];
//         featured_properties = responseData['featured_properties'];
//         if (success == 200) {
//           setState(
//             () {
//               _isLoading = false;
//             },
//           );
//           featured_properties.forEach((v) {
//             propertiesList.add(FeaturedProperty.fromJson(v));
//           });
//         }
//       } else {
//         setState(
//           () {
//             _isLoading = false;
//           },
//         );
//         throw const HttpException('Failed To get Leads');
//       }
//     } catch (error) {
//       rethrow;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size _screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         backgroundColor: themeColor,
//         elevation: 1,
//         title: const Text('DashBoard'),
//       ),
//       endDrawer: CustomDrawer(
//         userID: userId,
//         fname: fName,
//         lname: lName,
//         profile_url: userProfile,
//         authToken: authToken,
//         availability: availability,
//       ),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 children: [
//                   Center(
//                     child: SizedBox(
//                       height: 200.h,
//                       width: 200.h,
//                       child: Image.asset(ImageConst.logo, fit: BoxFit.cover),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15.h,
//                   ),
//                   /* Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 12.0),
//                   child: Text(
//                     'Focus Projects',
//                     style: TextStyle(
//                       fontSize: 25,
//                       color: themeColor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 12.0),
//                   child: TextButton(
//                     onPressed: () {},
//                     child: const Text(
//                       'View All',
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),*/
//                   /* SizedBox(
//               height: 20.h,
//             ),
//             SizedBox(
//               height: _screenSize.height * .25,
//               child: ListView.builder(
//                 itemCount: 10,
//                 physics: const BouncingScrollPhysics(),
//                 scrollDirection: Axis.horizontal,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.only(
//                       right: 10.0,
//                       left: 10,
//                       bottom: 10,
//                     ),
//                     child: Container(
//                       width: _screenSize.height * .45, //325
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         image: const DecorationImage(
//                           image: AssetImage(ImageConst.imagenotfound),
//                           fit: BoxFit.cover,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             offset: const Offset(0, 10),
//                             blurRadius: 10,
//                             color: themeColor.withOpacity(0.23),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           const Align(
//                             alignment: Alignment.bottomLeft,
//                             child: Padding(
//                               padding: EdgeInsets.only(left: 15.0),
//                               child: Text(
//                                 'Text Data',
//                                 style: TextStyle(fontSize: 18),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10.h,
//                           ),
//                           const Align(
//                             alignment: Alignment.bottomLeft,
//                             child: Padding(
//                               padding: EdgeInsets.only(left: 15.0),
//                               child: Text(
//                                 'Delhi',
//                                 style: TextStyle(fontSize: 18),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 25.h,
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(
//               height: 30,
//             ),*/
//                   Container(
//                     height: _screenSize.height * .2, //150
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: themeColor,
//                     ),
//                     child: Center(
//                       child: Column(
//                         children: [
//                           const SizedBox(
//                             height: 35,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                   left: 13.0,
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Text(
//                                       'MY LEADS',
//                                       style: TextStyle(
//                                         color: Colors.grey,
//                                         fontSize: 17,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 20,
//                                     ),
//                                     Text(
//                                       tot_leads.toString(),
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 22,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                   left: 10.0,
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Text(
//                                       'COLD CALLS',
//                                       style: TextStyle(
//                                         color: Colors.grey,
//                                         fontSize: 17,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 20,
//                                     ),
//                                     Text(
//                                       tot_cold_call.toString(),
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 22,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                   left: 10.0,
//                                   right: 20,
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Text(
//                                       'PROPERTIES',
//                                       style: TextStyle(
//                                         color: Colors.grey,
//                                         fontSize: 17,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 20,
//                                     ),
//                                     Text(
//                                       tot_properties.toString(),
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 22,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15.h,
//                   ),
//                   SizedBox(
//                     height: _screenSize.height * .5, //
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: GridView.count(
//                         physics: const NeverScrollableScrollPhysics(),
//                         crossAxisCount: 3,
//                         childAspectRatio: 0.8,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: LeadWidget("MY LEADS", context),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: InteractionWidget("INTERACTIONS", context),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: LeavesWidget("LEAVES",context),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: ReportWidget("REPORTS"),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: CallsWidget("COLD CALLS", context),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: DialerWidget("DIALER", context),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   /*Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20.0, right: 20),
//                   child: SizedBox(
//                     child: Row(
//                       //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Image.asset(
//                           ImageConst.report_icon,
//                           height: 30.h,
//                           width: 30.h,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             'Total Payable incentives',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 18.sp,
//                             ),
//                           ),
//                         ),
//                         const Spacer(),
//                         Text(
//                           'AED 0',
//                           style: TextStyle(
//                             color: Colors.blue,
//                             fontSize: 18.sp,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.only(left: 20.0, right: 20, top: 10),
//                   child: Divider(
//                     color: Colors.black,
//                     height: 2,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 25.h,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20.0, right: 20),
//                   child: SizedBox(
//                     child: Row(
//                       //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Image.asset(ImageConst.report_icon,
//                             height: 30.h, width: 30.h),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             'Paid incentives',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 18.sp,
//                             ),
//                           ),
//                         ),
//                         const Spacer(),
//                         Text(
//                           'AED 0',
//                           style: TextStyle(
//                             color: Colors.blue,
//                             fontSize: 18.sp,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.only(left: 20.0, right: 20, top: 10),
//                   child: Divider(
//                     color: Colors.black,
//                     height: 2,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 25.h,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20.0, right: 20),
//                   child: SizedBox(
//                     child: Row(
//                       //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Image.asset(ImageConst.report_icon,
//                             height: 30.h, width: 30.h),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             'Balance Due',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 18.sp,
//                             ),
//                           ),
//                         ),
//                         const Spacer(),
//                         Text(
//                           'AED 0',
//                           style: TextStyle(
//                             color: Colors.blue,
//                             fontSize: 18.sp,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),*/
//                   SizedBox(
//                     height: 30.h,
//                   ),
//                   Center(
//                     child: Text(
//                       'Recent Projects',
//                       style: TextStyle(
//                         fontSize: 22.sp,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 30.h,
//                   ),
//                   SizedBox(
//                     height: 65.h,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 15.0, right: 10),
//                       child: ListView.builder(
//                         itemCount: propertiesList.length,
//                         scrollDirection: Axis.horizontal,
//                         itemBuilder: (context, index) => Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.blue,
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(10.0),
//                               child: Center(
//                                 child: Text(
//                                   propertiesList[index].name.toString(),
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 18.sp,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 60,
//                   ),
//                   const Text(
//                     'Brought to you by Xperties',
//                     style: TextStyle(
//                       fontSize: 18,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
