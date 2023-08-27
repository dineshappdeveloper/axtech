import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:crm_application/Provider/ColdCallProvider.dart';
import 'package:crm_application/Provider/DialProvider.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/LeadFilter/Models/statusModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../ApiManager/Apis.dart';
import '../../Models/StatusListModel.dart';
import '../../Provider/UserProvider.dart';
import '../../Utils/Colors.dart';
import '../../Utils/ImageConst.dart';
import 'MyLeads/LeadFilter/Filter/FilterUI.dart';
import 'MyLeads/LeadFilter/Models/agentsModel.dart';
import 'MyLeads/LeadFilter/Models/developerModel.dart';
import 'MyLeads/LeadFilter/Models/propertyModel.dart';
import 'MyLeads/LeadFilter/Models/stausmodel.dart';
import 'MyLeads/MyLeadScreen.dart';

class ColdCallScreen extends StatefulWidget {
  const ColdCallScreen({Key? key}) : super(key: key);

  @override
  State<ColdCallScreen> createState() => _ColdCallScreenState();
}

class _ColdCallScreenState extends State<ColdCallScreen> {
  late SharedPreferences pref;
  var authToken;
  bool isVisible = false;

  bool _isLoading = false;

  var sourceName = '';
  var statusName = '';
  var length = 0;
  int? sourceId, statusId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs();
    Provider.of<ColdCallProvider>(context, listen: false).controller =
        ScrollController()
          ..addListener(
              Provider.of<ColdCallProvider>(context, listen: false).loadMore);
  }

  @override
  void dispose() {
    Provider.of<ColdCallProvider>(context, listen: false)
        .controller
        .removeListener(
            Provider.of<ColdCallProvider>(context, listen: false).loadMore);
    super.dispose();
  }

  Future<void> getPrefs() async {
    pref = await SharedPreferences.getInstance();
    authToken = pref.getString('token');
    debugPrint('AuthToken : $authToken');
    Provider.of<ColdCallProvider>(context, listen: false).role =
        jsonDecode(pref.getString('user')!)['role'];

    await Provider.of<ColdCallProvider>(context, listen: false)
        .getColdCalls(authToken);
    await Provider.of<ColdCallProvider>(context, listen: false)
        .getStatusList(authToken);
    await Provider.of<ColdCallProvider>(context, listen: false)
        .initFilterMethods();

    //debugPrint('newDate : $date');
  }

  Future<bool> onWillPop(BuildContext context) async {
    var ccp = Provider.of<ColdCallProvider>(context, listen: false);
    print(
        'On will Pop Scope selection mode-- > ' + ccp.selectionMode.toString());
    if (ccp.selectionMode) {
      ccp.selectionMode = false;
      ccp.selectedColdCalls.clear();

      setState(() {});
      return false;
    } else {
      ccp.coldCallsData.clear();
      ccp.total = 0;
      ccp.coldCallsByDate.clear();
      return await ccp.isFilterApplied(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var willBack = await onWillPop(context);

        return willBack;
      },
      child: Consumer<ColdCallProvider>(builder: (context, ccp, _) {
        return Scaffold(
            appBar: !ccp.selectionMode
                ? filterModeAppBar(
                    Provider.of<ColdCallProvider>(context, listen: false))
                : AppBar(
                    backgroundColor: themeColor,
                    leading: IconButton(
                      onPressed: () {
                        ccp.selectionMode = false;
                        ccp.selectedColdCalls.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    // title: CheckboxListTile(
                    //   checkColor: themeColor,
                    //   activeColor: Colors.white,
                    //   side: const BorderSide(color: Colors.white),
                    //   value: ccp.selectedColdCalls.length == ccp.leadsData.length,
                    //   onChanged: (v) {
                    //     setState(() {
                    //       !v!
                    //           ? ccp.selectedColdCalls.clear()
                    //           : ccp.selectedColdCalls.addAll(ccp.leadsData);
                    //     });
                    //     // print(ccp.selectedColdCalls.length);
                    //   },
                    title: Text(
                      '${ccp.selectedColdCalls.length} Selected',
                      style: const TextStyle(color: Colors.white),
                    ),
                    // ),
                    bottom: PreferredSize(
                      preferredSize: Size(Get.width, 55),
                      child: SizedBox(
                          // color: Colors.grey,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    // const SizedBox(width: 20),
                                    // RaisedButton(
                                    //   color: const Color(0xF2C08004),
                                    //   disabledColor: const Color(0xABA4A3A3),
                                    //   shape: RoundedRectangleBorder(
                                    //       borderRadius:
                                    //       BorderRadius.circular(50)),
                                    //   onPressed: ccp.selectedColdCalls.isNotEmpty
                                    //       ? () async {
                                    //     await showDialog(
                                    //         context: context,
                                    //         barrierDismissible: false,
                                    //         builder: (context) {
                                    //           return Dialog(
                                    //             shape:
                                    //             RoundedRectangleBorder(
                                    //                 borderRadius:
                                    //                 BorderRadius
                                    //                     .circular(
                                    //                     15)),
                                    //             child:
                                    //             LeadAssignmentToLeaderDialog(
                                    //                 lp: lp),
                                    //           );
                                    //         });
                                    //   }
                                    //       : null,
                                    //   child: const Text(
                                    //     'Assign To Team Leader',
                                    //     style: TextStyle(color: Colors.white),
                                    //   ),
                                    // ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xF2318005),
                                        disabledBackgroundColor:
                                            const Color(0xABA4A3A3),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                      ),
                                      onPressed:
                                          ccp.selectedColdCalls.isNotEmpty
                                              ? () async {
                                                  await showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (context) {
                                                        return Dialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15)),
                                                          child:
                                                              LeadAssignmentToAgentDialog(
                                                                  ccp: ccp),
                                                        );
                                                      });
                                                }
                                              : null,
                                      child: const Text(
                                        'Assign To Agent',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xF2E52121),
                                        disabledBackgroundColor:
                                            const Color(0xABA4A3A3),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                      ),
                                      onPressed: ccp
                                              .selectedColdCalls.isNotEmpty
                                          ? () {
                                              AwesomeDialog(
                                                dismissOnBackKeyPress: false,
                                                dismissOnTouchOutside: false,
                                                context: context,
                                                dialogType: DialogType.warning,
                                                animType: AnimType.rightSlide,
                                                title:
                                                    'Are you sure to delete this leads?',
                                                desc:
                                                    'After delete permanently,\nit will not be retrieve.',
                                                btnCancelOnPress: () {},
                                                btnOkOnPress: () async {
                                                  await ccp.bulkDelete();
                                                },
                                              ).show();
                                            }
                                          : null,
                                      child: const Text(
                                        'Bulk Delete',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                          height: 45),
                    ),
                  ),
            body: !ccp.IsLoading
                ?
                // print(ccp.responseList.length);
                /*
              if (ccp.date.isNotEmpty) {
                dates = ccp.date;
              } else {
                dates = '';
              }
              if (ccp.responseList.isNotEmpty) {
                history = ccp.responseList[0].history;
                isVisible = true;
              } else {
                history = [];
                isVisible = false;
              }

               */
                // return Container();
                // print(authToken);
                Column(
                    children: [
                      Expanded(
                          child: ccp.coldCallsData.isNotEmpty
                              ? ListView.builder(
                                  controller: ccp.controller,
                                  itemCount: ccp.coldCallsByDate.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Visibility(
                                          visible: true,
                                          child: Container(
                                            width: double.infinity,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: themeColor
                                                    .withOpacity(0.5)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    ccp.coldCallsByDate[index]
                                                        .date
                                                        .toString(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    '${ccp.coldCallsData.length} cold calls',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        ...ccp.coldCallsData.map((e) {
                                          var isSelected = ccp.selectedColdCalls
                                              .any((element) =>
                                                  element.id == e.id);
                                          var reason = e.coldcallsStatus != null
                                              ? e.coldcallsStatus!.name
                                              : null;
                                          return Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ListTile(
                                                  // onLongPress: () {
                                                  //   if (ccp.role ==
                                                  //       UserType.admin.name) {
                                                  //     if (!ccp.selectionMode) {
                                                  //       setState(() {
                                                  //         ccp.setSelectionMode(
                                                  //             true);
                                                  //         print(
                                                  //             'setSelectionMode is ${ccp.selectionMode}');
                                                  //       });
                                                  //     }
                                                  //   } else {
                                                  //     print(
                                                  //         'Your role is ${ccp.role}');
                                                  //   }
                                                  // },
                                                  onTap: () {
                                                    if (!ccp.selectionMode) {
                                                    } else {
                                                      ccp.setSelectedColdCalls(
                                                          e);
                                                      if (ccp.selectedColdCalls
                                                          .isEmpty) {
                                                        ccp.selectionMode =
                                                            false;
                                                        setState(() {});
                                                      }
                                                    }
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  tileColor: isSelected
                                                      ? themeColor
                                                          .withOpacity(0.8)
                                                      : Colors.white24,
                                                  title: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              e.name!,
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                color: isSelected
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 100,
                                                            // color: Colors.red,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    // launch(
                                                                    //     'tel:${e.phone}');
                                                                    try {
                                                                      await Provider.of<DialProvider>(context, listen: false).makeDialCall(
                                                                          e.phone
                                                                              .toString(),
                                                                          'Lead',
                                                                          name:
                                                                              e.name);
                                                                    } catch (e) {
                                                                      print(
                                                                          'Lead screen error $e');
                                                                    }
                                                                  },
                                                                  child: Image
                                                                      .asset(
                                                                    ImageConst
                                                                        .call_icon,
                                                                    height: 25,
                                                                    //width: 30,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                ),
                                                                const Spacer(),
                                                                InkWell(
                                                                  onTap: () {
                                                                    // Share.share(
                                                                    //   'check out this Lead\nName: ${ccp.responseList[0].history[index].name}\nCall id : ${ccp.responseList[0].history[index].id} \nPhone : ${ccp.responseList[0].history[index].phone}',
                                                                    // );
                                                                    // print(history[index]);
                                                                    _modalBottomSheetMenu1(
                                                                        context,
                                                                        e.id!
                                                                            .toInt(),
                                                                        // 3,
                                                                        ccp.reasonStatusList);
                                                                  },
                                                                  child: Image
                                                                      .asset(
                                                                    ImageConst
                                                                        .convert_to_lead,
                                                                    height: 25,
                                                                    color: isSelected
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                    //width: 30,
                                                                  ),
                                                                ),
                                                                const Spacer(),
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    AwesomeDialog(
                                                                      showCloseIcon:
                                                                          true,
                                                                      dismissOnBackKeyPress:
                                                                          true,
                                                                      dismissOnTouchOutside:
                                                                          false,
                                                                      context: Get
                                                                          .context!,
                                                                      dialogType:
                                                                          DialogType
                                                                              .question,
                                                                      animType:
                                                                          AnimType
                                                                              .rightSlide,
                                                                      title:
                                                                          '\n\nAre you sure to convert as lead?\n',
                                                                      btnCancel: FloatingActionButton.extended(
                                                                          onPressed: () {
                                                                            Get.back();
                                                                            // SuccessDialog(
                                                                            //     title:
                                                                            //         'Leave Rejected.');
                                                                          },
                                                                          label: const Text('No'),
                                                                          icon: const FaIcon(FontAwesomeIcons.cancel),
                                                                          backgroundColor: Colors.red),
                                                                      btnOk: FloatingActionButton.extended(
                                                                          onPressed: () async {
                                                                            await ccp.convertToLead(e.id!, context).then((value) =>
                                                                                Navigator.pop(context));
                                                                            Navigator.pop(context);
                                                                            await Provider.of<ColdCallProvider>(context, listen: false).getColdCalls(authToken);

                                                                          
                                                                          },
                                                                          label: const Text('Yes'),
                                                                          icon: const Icon(Icons.thumb_up),
                                                                          backgroundColor: Colors.green),
                                                                    ).show();
                                                                    // await showDialog(
                                                                    //     context:
                                                                    //     context,
                                                                    //     barrierDismissible:
                                                                    //     false,
                                                                    //     builder:
                                                                    //         (context) =>
                                                                    //         AlertDialog(
                                                                    //           shape:
                                                                    //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                    //           title:
                                                                    //           const Text('Are you sure to convert as lead?'),
                                                                    //           actions: [
                                                                    //             TextButton(
                                                                    //                 onPressed: () {
                                                                    //                   Navigator.pop(context);
                                                                    //                 },
                                                                    //                 child: const Text(
                                                                    //                   'No',
                                                                    //                   style: TextStyle(color: Colors.red, fontSize: 20),
                                                                    //                 )),
                                                                    //             TextButton(
                                                                    //                 onPressed: () async {
                                                                    //                   await ccp.convertToLead(e.id!, context).then((value) => Navigator.pop(context));
                                                                    //                 },
                                                                    //                 child: const Text(
                                                                    //                   'Yes',
                                                                    //                   style: TextStyle(color: Colors.green, fontSize: 20),
                                                                    //                 ))
                                                                    //           ],
                                                                    //         ));

                                                                    // _modalBottomSheetMenu1(context);
                                                                  },
                                                                  child: FaIcon(
                                                                    FontAwesomeIcons
                                                                        .shareFromSquare,
                                                                    size: 25,
                                                                    //width: 30,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .backgroundColor
                                                                        .withOpacity(
                                                                            1),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          // Container(
                                                          //   decoration: BoxDecoration(
                                                          //     color: Colors.grey,
                                                          //     borderRadius: BorderRadius.circular(3),
                                                          //   ),
                                                          //   child: Padding(
                                                          //     padding: const EdgeInsets.all(3.0),
                                                          //     child: Text(
                                                          //       ccp.coldCallsByDate[index].coldCalls![index].remindMeSent.toString(),
                                                          //       style: const TextStyle(fontSize: 10),
                                                          //     ),
                                                          //   ),
                                                          // ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5),
                                                      SizedBox(
                                                        // width: 180,
                                                        child: Row(
                                                          children: [
                                                            FaIcon(
                                                              FontAwesomeIcons
                                                                  .userShield,
                                                              size: 13,
                                                              color: Colors.red
                                                                  .withOpacity(
                                                                      isSelected
                                                                          ? 1
                                                                          : 0.6),
                                                            ),
                                                            const SizedBox(
                                                                width: 10),
                                                            Expanded(
                                                              child: Text(
                                                                e.agent != null
                                                                    ? e.agent!
                                                                        .fullName
                                                                    : "N/A",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .fade,
                                                                  color: isSelected
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      SizedBox(
                                                        // width: 180,
                                                        child: Row(
                                                          children: [
                                                            FaIcon(
                                                              FontAwesomeIcons
                                                                  .globe,
                                                              size: 13,
                                                              color: Colors
                                                                  .green
                                                                  .withOpacity(
                                                                      isSelected
                                                                          ? 1
                                                                          : 0.6),
                                                            ),
                                                            const SizedBox(
                                                                width: 10),
                                                            Expanded(
                                                              child: Text(
                                                                e.source != null
                                                                    ? e.source!
                                                                        .name!
                                                                    : "N/A",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .fade,
                                                                  color: isSelected
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              // mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                FaIcon(
                                                                    FontAwesomeIcons
                                                                        .arrowsUpDown,
                                                                    color: isSelected
                                                                        ? Colors
                                                                            .yellow
                                                                            .withOpacity(1)
                                                                        : themeColor,
                                                                    size: 15),
                                                                const SizedBox(
                                                                    width: 10),
                                                                Text(
                                                                  e.coldCallPreority ??
                                                                      'N/A',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .fade,
                                                                    color: isSelected
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Expanded(
                                                              child: Divider(
                                                            color: Colors.grey,
                                                          )),
                                                          const SizedBox(
                                                              width: 10),
                                                          Row(
                                                            children: [
                                                              FaIcon(
                                                                  FontAwesomeIcons
                                                                      .batteryHalf,
                                                                  color: Colors
                                                                      .purple
                                                                      .withOpacity(
                                                                          isSelected
                                                                              ? 1
                                                                              : 0.6),
                                                                  size: 15),
                                                              const SizedBox(
                                                                  width: 10),
                                                              Text(
                                                                reason ?? 'N/A',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .fade,
                                                                  color: isSelected
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5),

                                                      // Text(
                                                      //   'Status: ${reason != null ? reason.name : 'N/A'}',
                                                      //   style: const TextStyle(
                                                      //     color: Colors.black,
                                                      //     fontSize: 14,
                                                      //   ),
                                                      // ),
                                                      // const SizedBox(
                                                      //   height: 5,
                                                      // ),
                                                      // Text(
                                                      //   'Priority: ${e.coldCallPreority ?? 'N/A'}',
                                                      //   style: const TextStyle(
                                                      //     color: Colors.black,
                                                      //     fontSize: 14,
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                  // trailing: SizedBox(
                                                  //   width: 0,
                                                  //   // child: Row(
                                                  //   //   mainAxisAlignment:
                                                  //   //       MainAxisAlignment
                                                  //   //           .spaceBetween,
                                                  //   //   children: [
                                                  //   //     InkWell(
                                                  //   //       onTap: () {
                                                  //   //         launch(
                                                  //   //             'tel:${e.phone}');
                                                  //   //       },
                                                  //   //       child: Image.asset(
                                                  //   //         ImageConst
                                                  //   //             .call_icon,
                                                  //   //         height: 25,
                                                  //   //         //width: 30,
                                                  //   //         color: Colors.green,
                                                  //   //       ),
                                                  //   //     ),
                                                  //   //
                                                  //   //     const Spacer(),
                                                  //   //     InkWell(
                                                  //   //       onTap: () {
                                                  //   //         // Share.share(
                                                  //   //         //   'check out this Lead\nName: ${ccp.responseList[0].history[index].name}\nCall id : ${ccp.responseList[0].history[index].id} \nPhone : ${ccp.responseList[0].history[index].phone}',
                                                  //   //         // );
                                                  //   //         // print(history[index]);
                                                  //   //         _modalBottomSheetMenu1(
                                                  //   //             context,
                                                  //   //             e.id!.toInt(),
                                                  //   //             // 3,
                                                  //   //             ccp.reasonStatusList);
                                                  //   //       },
                                                  //   //       child: Image.asset(
                                                  //   //         ImageConst
                                                  //   //             .convert_to_lead,
                                                  //   //         height: 25,
                                                  //   //         color: isSelected
                                                  //   //             ? Colors.white
                                                  //   //             : Colors.black,
                                                  //   //         //width: 30,
                                                  //   //       ),
                                                  //   //     ),
                                                  //   //     const Spacer(),
                                                  //   //     InkWell(
                                                  //   //       onTap: () async {
                                                  //   //         await showDialog(
                                                  //   //             context:
                                                  //   //             context,
                                                  //   //             barrierDismissible:
                                                  //   //             false,
                                                  //   //             builder:
                                                  //   //                 (context) =>
                                                  //   //                 AlertDialog(
                                                  //   //                   shape:
                                                  //   //                   RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                  //   //                   title:
                                                  //   //                   const Text('Are you sure to convert as lead?'),
                                                  //   //                   actions: [
                                                  //   //                     TextButton(
                                                  //   //                         onPressed: () {
                                                  //   //                           Navigator.pop(context);
                                                  //   //                         },
                                                  //   //                         child: const Text(
                                                  //   //                           'No',
                                                  //   //                           style: TextStyle(color: Colors.red, fontSize: 20),
                                                  //   //                         )),
                                                  //   //                     TextButton(
                                                  //   //                         onPressed: () async {
                                                  //   //                           await ccp.convertToLead(e.id!, context).then((value) => Navigator.pop(context));
                                                  //   //                         },
                                                  //   //                         child: const Text(
                                                  //   //                           'Yes',
                                                  //   //                           style: TextStyle(color: Colors.green, fontSize: 20),
                                                  //   //                         ))
                                                  //   //                   ],
                                                  //   //                 ));
                                                  //   //
                                                  //   //         // _modalBottomSheetMenu1(context);
                                                  //   //       },
                                                  //   //       child: FaIcon(
                                                  //   //         FontAwesomeIcons
                                                  //   //             .shareFromSquare,
                                                  //   //         // height: 25,
                                                  //   //         //width: 30,
                                                  //   //         color: Theme.of(
                                                  //   //             context)
                                                  //   //             .backgroundColor
                                                  //   //             .withOpacity(1),
                                                  //   //       ),
                                                  //   //     ),
                                                  //   //   ],
                                                  //   // ),
                                                  // ),
                                                ),
                                              ),
                                              // const Divider(height: 1),
                                            ],
                                          );
                                        }),
                                      ],
                                    );
                                  })
                              : const Center(
                                  child: Text('No Cold Calls are  Available.'),
                                )),
                      if (ccp.isLoadMoreRunning == true)
                        Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.only(top: 25, bottom: 25),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ));
      }),
    );
  }

  AppBar filterModeAppBar(ColdCallProvider ccp) {
    return AppBar(
      title: Row(
        children: [
          const Expanded(child: Text('Cold Calls')),
          Text('( ${ccp.total} )'),
        ],
      ),
      backgroundColor: themeColor,
      actions: [
        Stack(
          children: [
            IconButton(
                onPressed: () {
                  Get.to(ColdCallFilter(
                    token: ccp.token,
                  ));
                  // Get.to(FilterFormWidget(
                  //   stringFormData: const {'Keyword': ''},
                  //   singleSelectionListData: {
                  //     'Developer': [
                  //       MapEntry(1, 'Ram'),
                  //       MapEntry(2, 'Rama'),
                  //     ],
                  //     'Developer2': [
                  //       MapEntry(1, 'Rame'),
                  //       MapEntry(2, 'Ramay'),
                  //     ],
                  //     'Developer3': [
                  //       MapEntry(1, 'Ramu'),
                  //       MapEntry(2, 'Ramas'),
                  //     ],
                  //   },
                  //   multiSelectionListData: {
                  //     'Status': [
                  //       MapEntry(3, 'value 3'),
                  //       MapEntry(4, 'value 4'),
                  //       MapEntry(5, 'value 5'),
                  //     ]
                  //   },
                  //   singleHiraricyListData: {
                  //     'Hirerchy Agents': [
                  //       MapEntry("Ricky Verghese", [
                  //         MapEntry("1941", "Ahmed Abdelghfar Mohamed"),
                  //         MapEntry("15596", "Syeda Bushra Fatima"),
                  //         MapEntry("2476", "Shubhangi Singh"),
                  //         MapEntry("2580", "Afraa Mahboob"),
                  //         MapEntry("284", "Sarah Nafeh"),
                  //         MapEntry("3347", "Suhail Ahmed Sheikh"),
                  //         MapEntry("3338", "Naveed Andrabi")
                  //       ]),
                  //       MapEntry("Vicky Verghese", [
                  //         MapEntry("1y91", "Ahmed Abdelghfar Mohamed"),
                  //         MapEntry("1e96", "Syeda Bushra Fatima"),
                  //         MapEntry("2y76", "Shubhangi Singh"),
                  //         MapEntry("2e80", "Afraa Mahboob"),
                  //         MapEntry("2e84", "Sarah Nafeh"),
                  //         MapEntry("33e7", "Suhail Ahmed Sheikh"),
                  //         MapEntry("3e38", "Naveed Andrabi")
                  //       ]),
                  //       MapEntry("Shyam Verghese", [
                  //         MapEntry("19rw1", "Ahmed Abdelghfar Mohamed"),
                  //         MapEntry("1er96", "Syeda Bushra Fatima"),
                  //         MapEntry("2e76", "Shubhangi Singh"),
                  //         MapEntry("2r80", "Afraa Mahboob"),
                  //         MapEntry("2wr4", "Sarah Nafeh"),
                  //         MapEntry("33e7", "Suhail Ahmed Sheikh"),
                  //         MapEntry("33r8", "Naveed Andrabi")
                  //       ]),
                  //     ]
                  //   },
                  //   onFilterClear: () async {},
                  //   applyFilter: (Map<String, dynamic> data) {
                  //     if (kDebugMode) {
                  //       print("final data for apply on $data");
                  //     }
                  //   },
                  // ));
                },
                icon: const Icon(Icons.filter_list_outlined)),
            if (ccp.isFlrApplied)
              const Positioned(
                child: Icon(
                  Icons.circle,
                  color: Colors.red,
                  size: 8,
                ),
                top: 12,
                right: 12,
              ),
          ],
        ),
        const SizedBox(width: 10),
      ],
      bottom: ccp.isFlrApplied
          ? PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Container(
                height: 60,
                width: Get.width,
                padding: const EdgeInsets.only(left: 10),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    if (ccp.selectedAgent != null)
                      Row(
                        children: [
                          Chip(
                            deleteIcon: const Icon(Icons.clear),
                            label: ccp.role != UserType.admin.name
                                ? Text(ccp.agentsByTeamList
                                    .firstWhere((element) => element.agents!
                                        .any((ele) =>
                                            ele.id == ccp.selectedAgent))
                                    .agents!
                                    .firstWhere((element) =>
                                        element.id == ccp.selectedAgent)
                                    .name!)
                                : Text(ccp.agentsByIdList
                                    .firstWhere((element) =>
                                        element.id == ccp.selectedAgent)
                                    .name!),
                            onDeleted: () async {
                              setState(() {
                                ccp.selectedAgent = null;
                              });
                              await ccp.applyFilter(ccp);
                            },
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    if (ccp.fromDate != null || ccp.toDate != null)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(ColdCallFilter(
                                  token: ccp.token, selectedIndex: 1));
                            },
                            child: Chip(
                              deleteIcon: const Icon(Icons.clear),
                              // deleteIconColor: Colors.red,
                              label: Text(
                                  ccp.fromDate != null && ccp.toDate != null
                                      ? DateFormat('yyyy-MM-dd')
                                              .format(ccp.fromDate!) +
                                          '  To  ' +
                                          DateFormat('yyyy-MM-dd')
                                              .format(ccp.toDate!)
                                      : ccp.fromDate != null
                                          ? DateFormat('yyyy-MM-dd')
                                              .format(ccp.fromDate!)
                                          : ccp.toDate != null
                                              ? '  To  ' +
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(ccp.toDate!)
                                              : ''),
                              onDeleted: () async {
                                setState(() {
                                  ccp.fromDate = null;
                                  ccp.toDate = null;
                                });
                                await ccp.applyFilter(ccp);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    if (ccp.selectedDeveloper != null)
                      Row(
                        children: [
                          Chip(
                            deleteIcon: const Icon(Icons.clear),
                            label: Text(ccp.developersList
                                .firstWhere((element) =>
                                    element.id == ccp.selectedDeveloper)
                                .name!),
                            onDeleted: () async {
                              setState(() {
                                ccp.selectedDeveloper = null;
                              });
                              await ccp.applyFilter(ccp);
                            },
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    if (ccp.selectedProperty != null)
                      Row(
                        children: [
                          Chip(
                            deleteIcon: const Icon(Icons.clear),
                            label: Text(ccp.propertyList
                                .firstWhere((element) =>
                                    element.id == ccp.selectedProperty)
                                .name!),
                            onDeleted: () async {
                              setState(() {
                                ccp.selectedProperty = null;
                              });
                              await ccp.applyFilter(ccp);
                            },
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    if (ccp.multiSelectedStatus.isNotEmpty)
                      Row(
                        children: [
                          PopupMenuButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            itemBuilder: (context) {
                              return [
                                ...ccp.multiSelectedStatus.map(
                                  (e) => PopupMenuItem(
                                      child: Chip(
                                    deleteIcon: const Icon(Icons.clear),
                                    label: Text(e.name!),
                                    onDeleted: () async {
                                      setState(() {
                                        ccp.multiSelectedStatus.remove(e);
                                      });
                                      Get.back();
                                      await ccp.applyFilter(ccp);
                                    },
                                  )),
                                ),
                              ];
                            },
                            child: Chip(
                              deleteIcon: const Icon(Icons.arrow_drop_down),
                              label: Row(
                                children: [
                                  Text(
                                      '${ccp.multiSelectedStatus.length} Status'),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    if (ccp.multiSelectedSources.isNotEmpty)
                      Row(
                        children: [
                          PopupMenuButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            itemBuilder: (context) {
                              return [
                                ...ccp.multiSelectedSources.map(
                                  (e) => PopupMenuItem(
                                      child: Chip(
                                    deleteIcon: const Icon(Icons.clear),
                                    label: Text(e.name!),
                                    onDeleted: () async {
                                      setState(() {
                                        ccp.multiSelectedSources.remove(e);
                                      });
                                      Get.back();
                                      await ccp.applyFilter(ccp);
                                    },
                                  )),
                                ),
                              ];
                            },
                            child: Chip(
                              deleteIcon: const Icon(Icons.arrow_drop_down),
                              label: Row(
                                children: [
                                  Text(
                                      '${ccp.multiSelectedSources.length} Sources'),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    if (ccp.selectedPriority != null)
                      Row(
                        children: [
                          Chip(
                            deleteIcon: const Icon(Icons.clear),
                            label: Text(ccp.selectedPriority!),
                            onDeleted: () async {
                              setState(() {
                                ccp.selectedPriority = null;
                              });
                              await ccp.applyFilter(ccp);
                            },
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    if (ccp.query.text.isNotEmpty)
                      Row(
                        children: [
                          Chip(
                            deleteIcon: const Icon(Icons.clear),
                            label: Text(ccp.query.text),
                            onDeleted: () async {
                              setState(() {
                                ccp.query.clear();
                              });
                              await ccp.applyFilter(ccp);
                            },
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Future<void> updateColdCallReason(
      int status, var coldCallId, BuildContext context) async {
    var url =
        ApiManager.BASE_URL + ApiManager.changeColdCallStatus + '/$coldCallId';
    debugPrint("All Cold Calls UpdateInfoUrl : $url");
    _isLoading = true;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $authToken',
      // 'Accept': 'application/json',
    };
    Map<String, dynamic> body = {
      "status": status.toString(),
    };
    try {
      final response =
          await http.post(Uri.parse(url), body: body, headers: headers);
      var responseData = json.decode(response.body);
      debugPrint("All Cold Calls UpdateLeadParameters : $body");
      log('All Cold Calls UpdateLeadResponse : $responseData');
      log('All Cold Calls UpdateLeadResponse : ${response.statusCode} ${responseData['success']} ');
      if (response.statusCode == 200) {
        var message = responseData['message'];
        if (responseData['success'] == true) {
          _isLoading = false;
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(message),
          //   ),
          // );
          Fluttertoast.showToast(msg: message);
          await Provider.of<ColdCallProvider>(context, listen: false)
              .getColdCalls(authToken);

          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => CompleteLeadProfile(
          //       leadId: leadId,
          //       leadName: leadName,
          //     ),
          //   ),
          // );
          // notifyListeners();
        }
        //notifyListeners();
      } else {
        _isLoading = false;
        // notifyListeners();
        throw const HttpException('All Cold Calls Update Failed');
      }
    } catch (error) {
      _isLoading = false;
      print('updateColdCallReason $error');
      rethrow;
    }
  }

  void _modalBottomSheetMenu1(BuildContext context, int coldCallId,
      List<ColdCallStatus> statusList) async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          'Choose Status',
        ),
        actions: <Widget>[createListView1(context, statusList, coldCallId)],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget createListView1(
      BuildContext context, List<ColdCallStatus> values, int coldCallId) {
    return SizedBox(
      height: 235.h,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: false,
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              CupertinoActionSheetAction(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    values[index].name.toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                onPressed: () async {
                  setState(
                    () {
                      statusName = values[index].name.toString();
                      statusId = values[index].id;
                    },
                  );
                  // print(statusName);
                  // print(statusId);
                  // print(statusId.runtimeType);
                  await updateColdCallReason(statusId!, coldCallId, context)
                      .then((value) => Get.back());
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class ColdCallFilter extends StatefulWidget {
  const ColdCallFilter({
    Key? key,
    required this.token,
    this.selectedIndex,
  }) : super(key: key);
  final String token;
  final int? selectedIndex;

  @override
  State<ColdCallFilter> createState() => _ColdCallFilterState();
}

class _ColdCallFilterState extends State<ColdCallFilter> {
  int selectedIndex = 0;
  List<AgentById> agentsByIdList = [];
  List<DeveloperModel> developersList = [];
  List<PropertyModel> propertyList = [];
  List<StatusModel> statusList = [];
  List<SourceModel> sourcesList = [];
  List<String> priorityList = [];

  void init() {
    var ccp = Provider.of<ColdCallProvider>(context, listen: false);
    agentsByIdList = ccp.agentsByIdList;
    developersList = ccp.developersList;
    propertyList = ccp.propertyList;
    statusList = ccp.statusList;
    sourcesList = ccp.sourcesList;
    priorityList = ccp.priorityList;
  }

  @override
  void initState() {
    super.initState();
    if (widget.selectedIndex != null) {
      selectedIndex = widget.selectedIndex!;
    }
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ColdCallProvider>(builder: (context, ccp, _) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Text('Filters', style: Get.theme.textTheme.headline6),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Row(
          children: [
            Expanded(
              flex: 2,
              child: filterLeftSection(ccp),
            ),
            VerticalDivider(
              width: 1,
              color: themeColor,
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: selectedIndex == 0
                    ? Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                if (ccp.role == UserType.admin.name)
                                  TextFormField(
                                    controller: ccp.queryAgents,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    onChanged: (val) async {
                                      if (val.isNotEmpty) {
                                        // List<MapEntry<int, String>> ls = [];
                                        // // print(lp.role == UserType.admin.name);
                                        // if (lp.role != UserType.admin.name) {
                                        //   for (var e inccp.agentsByTeamList) {
                                        //     // print('user role ${lp.role}');
                                        //
                                        //     // print(e);
                                        //     for (var element in e.agents!) {
                                        //       ls.add(MapEntry(
                                        //           int.parse(element.id!),
                                        //           element.name!));
                                        //     }
                                        //   }
                                        //   print('ls length' +
                                        //       ls.length.toString());
                                        // }
                                        // // ls.map((e) => print(e));
                                        var list = filterSearchResult(
                                            //ccp.role != UserType.admin.name
                                            //     ? ls
                                            ccp.agentsByIdList
                                                .map((e) => MapEntry(
                                                    int.parse(e.id!), e.name!))
                                                .toList(),
                                            val);
                                        setState(() {
                                          // agentsByTeamList = list
                                          //     .map((e) => AgentsByTeam(name:ccp.agentsByTeamList.firstWhere((element) => element.agents!.any((element) => element.id==e.key.toString())).name,agents: list.where((element) =>ccp.agentsByTeamList.firstWhere((element) => element.agents!.any((element) => element.id==e.key.toString())).agents.map((e) => AgentById(
                                          //   id: e.key.toString(),
                                          //   name: e.value,
                                          // )).toList()))))
                                          //     .toList();
                                          agentsByIdList = list
                                              .map((e) => AgentById(
                                                    id: e.key.toString(),
                                                    name: e.value,
                                                  ))
                                              .toList();
                                        });
                                      } else {
                                        setState(() {
                                          agentsByIdList = ccp.agentsByIdList;
                                          ccp.queryAgents.text = '';
                                        });
                                      }
                                    },
                                  ),
                                const SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: themeColor.withOpacity(0.1),
                                  ),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    tileColor: themeColor.withOpacity(0.1),
                                    onTap: () {
                                      setState(() {
                                        ccp.selectedAgent = null;
                                        ccp.queryAgents.text = 'All';
                                      });
                                    },
                                    leading: const Text(''),
                                    title: const Text('All'),
                                  ),
                                ),
                                const Divider(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              children: [
                                if (ccp.role != UserType.admin.name)
                                  ...ccp.agentsByTeamList.map(
                                    (e) => Container(
                                      color: Colors.white,
                                      child: ExpansionTile(
                                        collapsedBackgroundColor: Colors.white,
                                        title: Text(e.name!),
                                        children: [
                                          ...e.agents!.map(
                                            (agent) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: themeColor
                                                      .withOpacity(0.1),
                                                ),
                                                child: RadioListTile<String>(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  tileColor: themeColor
                                                      .withOpacity(0.1),
                                                  value: agent.id!,
                                                  groupValue: ccp.selectedAgent,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      ccp.selectedAgent = val!;
                                                      ccp.queryAgents.text =
                                                          agent.name!;
                                                    });
                                                  },
                                                  title: Text(agent.name!),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                        // child: Text(e.name!),
                                      ),
                                    ),
                                  ),
                                if (ccp.role == UserType.admin.name)
                                  ...agentsByIdList.map(
                                    (e) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: RadioListTile<String>(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        tileColor: themeColor.withOpacity(0.1),
                                        value: e.id!,
                                        groupValue: ccp.selectedAgent,
                                        onChanged: (val) {
                                          setState(() {
                                            ccp.selectedAgent = val!;
                                            ccp.queryAgents.text = e.name!;
                                          });
                                        },
                                        title: Text(e.name!),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : selectedIndex == 1
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'From Date',
                                style: Get.theme.textTheme.headline6,
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                readOnly: true,
                                controller: TextEditingController(),
                                decoration: InputDecoration(
                                    hintText: ccp.fromDate != null
                                        ? DateFormat('yyyy-MM-dd')
                                            .format(ccp.fromDate!)
                                        : 'From',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                onTap: () async {
                                  var date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 365)),
                                      initialDate:
                                          ccp.fromDate ?? DateTime.now());
                                  if (date != null) {
                                    setState(() {
                                      ccp.fromDate = date;
                                      // ccp.toDate = dateRange.end;
                                    });
                                  }
                                },
                              ),
                              const Divider(),
                              Text(
                                'To Date',
                                style: Get.theme.textTheme.headline6,
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                readOnly: true,
                                controller: TextEditingController(),
                                decoration: InputDecoration(
                                    hintText: ccp.toDate != null
                                        ? DateFormat('yyyy-MM-dd')
                                            .format(ccp.toDate!)
                                        : "To",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                onTap: () async {
                                  var date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 365)),
                                      initialDate:
                                          ccp.toDate ?? DateTime.now());
                                  if (date != null) {
                                    setState(() {
                                      ccp.toDate = date;
                                    });
                                  }
                                },
                              ),
                            ],
                          )
                        : selectedIndex == 2
                            ? Column(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: ccp.queryStatus,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5))),
                                          onChanged: (val) {
                                            if (val.isNotEmpty) {
                                              var list = filterSearchResult(
                                                  ccp.statusList
                                                      .map((e) => MapEntry(
                                                          e.id!, e.name!))
                                                      .toList(),
                                                  val);
                                              setState(() {
                                                statusList = list
                                                    .map((e) => StatusModel(
                                                          id: e.key,
                                                          name: e.value,
                                                        ))
                                                    .toList();
                                              });
                                            } else {
                                              setState(() {
                                                statusList = ccp.statusList;
                                                ccp.queryStatus.text = '';
                                              });
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: themeColor.withOpacity(0.1),
                                          ),
                                          child: CheckboxListTile(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            tileColor:
                                                themeColor.withOpacity(0.1),
                                            value: ccp.multiSelectedStatus
                                                        .length ==
                                                    ccp.statusList.length ||
                                                ccp.multiSelectedStatus.isEmpty,
                                            onChanged: (bool? val) {
                                              setState(() {
                                                if (val!) {
                                                  ccp.multiSelectedStatus
                                                      .clear();
                                                  ccp.multiSelectedStatus
                                                      .addAll(ccp.statusList);
                                                } else {
                                                  ccp.multiSelectedStatus = [];
                                                }
                                                if (ccp.multiSelectedStatus
                                                            .length ==
                                                        ccp.statusList.length ||
                                                    ccp.multiSelectedStatus
                                                        .isEmpty) {
                                                  ccp.queryStatus.text = 'All';
                                                } else {
                                                  ccp.queryStatus.text = '';
                                                }
                                              });
                                            },
                                            title: const Text('All'),
                                          ),
                                        ),
                                        const Divider(),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView(
                                      children: [
                                        ...statusList.map(
                                          (e) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: CheckboxListTile(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              tileColor:
                                                  themeColor.withOpacity(0.1),
                                              value: ccp.multiSelectedStatus
                                                  .contains(e),
                                              onChanged: (val) {
                                                setState(() {
                                                  if (val!) {
                                                    ccp.multiSelectedStatus
                                                        .add(e);
                                                  } else {
                                                    ccp.multiSelectedStatus
                                                        .remove(e);
                                                  }
                                                  if (ccp.multiSelectedStatus
                                                              .length ==
                                                          ccp.statusList
                                                              .length ||
                                                      ccp.multiSelectedStatus
                                                          .isEmpty) {
                                                    ccp.queryStatus.text =
                                                        'All';
                                                  } else {
                                                    ccp.queryStatus.text = '';
                                                  }
                                                });
                                              },
                                              title: Text(e.name!),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : selectedIndex == 3
                                ? Column(
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              controller: ccp.querySources,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5))),
                                              onChanged: (val) {
                                                if (val.isNotEmpty) {
                                                  var list = filterSearchResult(
                                                      ccp.sourcesList
                                                          .map((e) => MapEntry(
                                                              e.id!, e.name!))
                                                          .toList(),
                                                      val);
                                                  setState(() {
                                                    sourcesList = list
                                                        .map((e) => SourceModel(
                                                              id: e.key,
                                                              name: e.value,
                                                            ))
                                                        .toList();
                                                  });
                                                } else {
                                                  setState(() {
                                                    sourcesList =
                                                        ccp.sourcesList;
                                                    ccp.querySources.text = '';
                                                  });
                                                }
                                              },
                                            ),
                                            const SizedBox(height: 10),
                                            CheckboxListTile(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              tileColor:
                                                  themeColor.withOpacity(0.1),
                                              value: ccp.multiSelectedSources
                                                          .length ==
                                                      ccp.sourcesList.length ||
                                                  ccp.multiSelectedSources
                                                      .isEmpty,
                                              onChanged: (bool? val) {
                                                setState(() {
                                                  if (val!) {
                                                    ccp.multiSelectedSources
                                                        .clear();
                                                    ccp.multiSelectedSources
                                                        .addAll(
                                                            ccp.sourcesList);
                                                  } else {
                                                    ccp.multiSelectedSources =
                                                        [];
                                                  }
                                                  if (ccp.multiSelectedSources
                                                              .length ==
                                                          ccp.sourcesList
                                                              .length ||
                                                      ccp.multiSelectedSources
                                                          .isEmpty) {
                                                    ccp.querySources.text =
                                                        'All';
                                                  } else {
                                                    ccp.querySources.text = '';
                                                  }
                                                });
                                              },
                                              title: const Text('All'),
                                            ),
                                            const Divider(),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView(
                                          children: [
                                            ...sourcesList.map(
                                              (e) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: CheckboxListTile(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  tileColor: themeColor
                                                      .withOpacity(0.1),
                                                  value: ccp
                                                      .multiSelectedSources
                                                      .contains(e),
                                                  // groupValue: true,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      if (val!) {
                                                        ccp.multiSelectedSources
                                                            .add(e);
                                                      } else {
                                                        ccp.multiSelectedSources
                                                            .remove(e);
                                                      }
                                                      if (ccp.multiSelectedSources
                                                                  .length ==
                                                              ccp.sourcesList
                                                                  .length ||
                                                          ccp.multiSelectedSources
                                                              .isEmpty) {
                                                        ccp.querySources.text =
                                                            'All';
                                                      } else {
                                                        ccp.querySources.text =
                                                            '';
                                                      }
                                                    });
                                                  },
                                                  title: Text(e.name!),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : selectedIndex == 4
                                    ? Column(
                                        children: [
                                          TextFormField(
                                            controller: ccp.queryPriority,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5))),
                                            onChanged: (val) {
                                              if (val.isNotEmpty) {
                                                var list = filterSearchResult(
                                                    ccp.priorityList
                                                        .map((e) => MapEntry(
                                                            ccp.priorityList
                                                                .indexOf(e),
                                                            e))
                                                        .toList(),
                                                    val);
                                                setState(() {
                                                  priorityList = list
                                                      .map((e) => e.value)
                                                      .toList();
                                                });
                                              } else {
                                                setState(() {
                                                  priorityList =
                                                      ccp.priorityList;
                                                  ccp.querySources.text = '';
                                                });
                                              }
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          const Divider(),
                                          ...priorityList.map(
                                            (e) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: RadioListTile<String>(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                tileColor:
                                                    themeColor.withOpacity(0.1),
                                                value: e,
                                                groupValue:
                                                    ccp.selectedPriority,
                                                onChanged: (val) {
                                                  setState(() {
                                                    ccp.selectedPriority = val!;
                                                    ccp.queryPriority.text = e;
                                                  });
                                                },
                                                title: Text(e),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          TextFormField(
                                            controller: ccp.query,
                                            decoration: InputDecoration(
                                                hintText: 'Search By Words',
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5))),
                                            onChanged: (val) {
                                              setState(() {
                                                // ccp.query.text=val;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          height: 70,
          child: Column(
            children: [
              const Divider(height: 1, thickness: 1),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () async {
                        ccp.isFilterApplied(false);
                        Get.back();
                        await ccp.applyFilter(ccp);
                        Future.delayed(const Duration(seconds: 1), () {});
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.clear,
                            size: 13,
                          ),
                          Text(' Clear Filters'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        disabledBackgroundColor: const Color(0xABA4A3A3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      onPressed: () async {
                        Get.back();
                        await ccp.applyFilter(ccp);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28.0),
                        child: Text(
                          'Apply',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  ListView filterLeftSection(ColdCallProvider ccp) {
    return ListView(
      children: [
        ...ccp.categoriesList.map(
          (e) => Column(
            children: [
              Stack(
                children: [
                  ListTile(
                    tileColor: selectedIndex == ccp.categoriesList.indexOf(e)
                        ? themeColor.withOpacity(0.1)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedIndex = ccp.categoriesList.indexOf(e);
                      });
                    },
                    title: SizedBox(
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e,
                            style: TextStyle(
                                color: selectedIndex ==
                                        ccp.categoriesList.indexOf(e)
                                    ? Get.theme.primaryColor
                                    : null),
                          ),
                        ],
                      ),
                    ),
                    trailing: Text(
                      e == ccp.categoriesList[0] && ccp.selectedAgent != null
                          ? 1.toString()
                          : e == ccp.categoriesList[1] &&
                                  (ccp.fromDate != null || ccp.toDate != null)
                              ? '🔘'
                              : e == ccp.categoriesList[2] &&
                                      ccp.multiSelectedStatus.isNotEmpty
                                  ? ccp.multiSelectedStatus.length.toString()
                                  : e == ccp.categoriesList[3] &&
                                          ccp.multiSelectedSources.isNotEmpty
                                      ? ccp.multiSelectedSources.length
                                          .toString()
                                      : e == ccp.categoriesList[4] &&
                                              ccp.selectedPriority != null
                                          ? 1.toString()
                                          : e == ccp.categoriesList[5] &&
                                                  ccp.query.text.isNotEmpty
                                              ? '💤'
                                              : '',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        color: selectedIndex == ccp.categoriesList.indexOf(e)
                            ? themeColor.withOpacity(1)
                            : null,
                        width: 7,
                        height: 58,
                      ),
                    ],
                  ),
                ],
              ),
              Divider(thickness: 0.1, color: themeColor, height: 1),
            ],
          ),
        ),
      ],
    );
  }
}

class LeadAssignmentToAgentDialog extends StatefulWidget {
  const LeadAssignmentToAgentDialog({
    Key? key,
    required this.ccp,
  }) : super(key: key);
  final ColdCallProvider ccp;

  @override
  State<LeadAssignmentToAgentDialog> createState() =>
      _LeadAssignmentToAgentDialogState();
}

class _LeadAssignmentToAgentDialogState
    extends State<LeadAssignmentToAgentDialog> {
  var agentId;
  var sourceId;
  var statusId;
  final GlobalKey<FormState> _agentKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _sourceKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _statusKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _dateKey = GlobalKey<FormState>();

  DateTime? date;
  TextEditingController agentsController = TextEditingController();
  TextEditingController dtController = TextEditingController();
  List<AgentById> agents = [];
  AgentById? selectedAgent;
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  SimpleAutoCompleteTextField? textField;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Container(
        height: Get.height * 0.6,
        width: Get.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Lead Assign To Agents",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Agents',
                        style: Get.theme.textTheme.bodyText1!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Form(
                    key: _agentKey,
                    child: TextFormField(
                      readOnly: true,
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: SizedBox(
                                  width: Get.width * 0.6,
                                  height: Get.height * 0.4,
                                  child: Column(children: <Widget>[
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                          color: Colors.white,
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                hintText: 'Search here'),
                                          ),
                                        ))
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: AgentsList(
                                          selectedAgent: selectedAgent,
                                          onTap: (agent) {
                                            setState(() {
                                              selectedAgent = agent;
                                              agentsController.text =
                                                  agent.name!;
                                              Get.back();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              );
                            });
                      },
                      controller: agentsController,
                      decoration: InputDecoration(
                          hintText: 'Select',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                selectedAgent = null;
                                agentsController.text = '';
                              });
                            },
                            icon: const Icon(Icons.clear),
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required field";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  TestPage(
                    formKey: _sourceKey,
                    title: 'Sources',
                    list: widget.ccp.sourcesList,
                    onTap: (id) {
                      setState(() {
                        sourceId = id;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TestPage(
                    formKey: _statusKey,
                    title: 'Status',
                    list: widget.ccp.statusList,
                    onTap: (id) {
                      setState(() {
                        statusId = id;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Date',
                        style: Get.theme.textTheme.bodyText1!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Form(
                    key: _dateKey,
                    child: TextFormField(
                      readOnly: true,
                      onTap: () async {
                        var dt = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)));
                        if (dt != null) {
                          date = dt;
                          dtController.text =
                              DateFormat('yyyy-MM-dd').format(dt);
                          setState(() {});
                        }
                      },
                      controller: dtController,
                      decoration: InputDecoration(
                          hintText: 'Select Date',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                date = null;
                                dtController.text = '';
                              });
                            },
                            icon: const Icon(Icons.clear),
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required field";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Close'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_agentKey.currentState!.validate() &&
                        _sourceKey.currentState!.validate() &&
                        _statusKey.currentState!.validate() &&
                        _dateKey.currentState!.validate()) {
                      await widget.ccp.assignToAgent();
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
          ],
        ),
      );
    });
  }
}
