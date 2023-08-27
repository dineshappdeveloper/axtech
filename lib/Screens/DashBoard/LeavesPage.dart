import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:crm_application/Models/LeavesModel.dart';
import 'package:crm_application/Provider/LeavesProvider.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/MyLeadScreen.dart';
import 'package:crm_application/Utils/Colors.dart';
import 'package:crm_application/Widgets/successfullDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ApiManager/Apis.dart';
import '../../Provider/UserProvider.dart';
import '../Cold Calls/MyLeads/LeadFilter/Filter/FilterUI.dart';
import '../Cold Calls/MyLeads/LeadFilter/Models/agentsModel.dart';

class LeavesPage extends StatefulWidget {
  const LeavesPage({Key? key}) : super(key: key);

  @override
  State<LeavesPage> createState() => _LeavesPageState();
}

class _LeavesPageState extends State<LeavesPage> {
  late SharedPreferences pref;
  var authToken;
  @override
  void initState() {
    super.initState();

    init();
    Provider.of<LeavesProvider>(context, listen: false).controller =
        ScrollController()
          ..addListener(
              Provider.of<LeavesProvider>(context, listen: false).loadMore);
  }

  @override
  void dispose() {
    Provider.of<LeavesProvider>(context, listen: false)
        .controller
        .removeListener(
            Provider.of<LeavesProvider>(context, listen: false).loadMore);
    super.dispose();
  }

  void init() async {
    pref = await SharedPreferences.getInstance();
    authToken = pref.getString('token');
    Provider.of<LeavesProvider>(context, listen: false).role =
        jsonDecode(pref.getString('user')!)['role'];
    var lp = Provider.of<LeavesProvider>(context, listen: false);
    lp.setIsLoading(true);
    await lp.getLeavesTypeList();
    await lp.getAllLeaves();
    await lp.initFilterMethods();
  }

  Future<bool> onWillPop(BuildContext context) async {
    var lp = Provider.of<LeavesProvider>(context, listen: false);
    print(
        'On will Pop Scope selection mode-- > ' + lp.selectionMode.toString());
    if (lp.selectionMode) {
      lp.selectionMode = false;
      lp.selectedLeads.clear();
      setState(() {});
      return false;
    } else {
      lp.allLeaves.clear();
      lp.total = 0;
      lp.approved = 0;
      lp.waiting = 0;
      lp.notApproved = 0;

      return await lp.isFilterApplied(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var willBack = await onWillPop(context);

        return willBack;
      },
      child: Consumer<LeavesProvider>(builder: (context, lp, _) {
        return Scaffold(
          appBar: filterModeAppBar(lp),
          body: SafeArea(
            child: !lp.IsLoading
                ? Column(
                    children: [
                      lp.allLeaves.isNotEmpty
                          ? Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Container(
                                            height: 50,
                                            width: Get.width * 0.25,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFF11c9ef),
                                                    Color(0xFF1276ef)
                                                  ]),
                                            ),
                                            child: Row(
                                              children: [
                                                const Spacer(),
                                                Container(
                                                  height: 40,
                                                  constraints:
                                                      const BoxConstraints(
                                                          minWidth: 40),
                                                  // width: Get.width * 0.1,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      border: Border.all(
                                                          color: Colors.white)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                        child: Text(
                                                      lp.waiting.toString(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Container(
                                            height: 50,
                                            width: Get.width * 0.25,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFF2dce8b),
                                                    Color(0xFF2eccca)
                                                  ]),
                                            ),
                                            child: Row(
                                              children: [
                                                const Spacer(),
                                                Container(
                                                  height: 40,
                                                  constraints:
                                                      const BoxConstraints(
                                                          minWidth: 40),
                                                  // // width: Get.width * 0.1,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      border: Border.all(
                                                          color: Colors.white)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                        child: Text(
                                                      lp.approved.toString(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Container(
                                            height: 50,
                                            width: Get.width * 0.25,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFFf5375b),
                                                    Color(0xFFf35f38)
                                                  ]),
                                            ),
                                            child: Row(
                                              children: [
                                                const Spacer(),
                                                Container(
                                                  height: 40,
                                                  constraints:
                                                      const BoxConstraints(
                                                          minWidth: 40),
                                                  // width: Get.width * 0.1,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      border: Border.all(
                                                          color: Colors.white)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                        child: Text(
                                                      lp.notApproved.toString(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView(
                                      controller: lp.controller,
                                      children: [
                                        ...lp.allLeaves.map((e) {
                                          var leave = e;

                                          var fdate =
                                              dateFormatting(leave.fromDate!);
                                          var tdate =
                                              dateFormatting(leave.toDate!);
                                          leave.fromDate = fdate;
                                          leave.toDate = tdate;
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    // AwesomeDialog(
                                                    //   showCloseIcon: true,
                                                    //   dismissOnBackKeyPress:
                                                    //       true,
                                                    //   dismissOnTouchOutside:
                                                    //       false,
                                                    //   context: Get.context!,
                                                    //   dialogType:
                                                    //       DialogType.question,
                                                    //   animType:
                                                    //       AnimType.rightSlide,
                                                    //   title:
                                                    //       '\n\nDo you want to approve\nthe leave?\n',
                                                    //   btnCancel: FloatingActionButton
                                                    //       .extended(
                                                    //           onPressed: () {
                                                    //             Get.back();
                                                    //             SuccessDialog(
                                                    //                 title:
                                                    //                     'Leave Rejected.');
                                                    //           },
                                                    //           label: const Text(
                                                    //               'Reject'),
                                                    //           icon: const FaIcon(
                                                    //               FontAwesomeIcons
                                                    //                   .cancel),
                                                    //           backgroundColor:
                                                    //               Colors.red),
                                                    //   btnOk: FloatingActionButton
                                                    //       .extended(
                                                    //           onPressed: () {
                                                    //             Get.back();
                                                    //             SuccessDialog(
                                                    //                 title:
                                                    //                     'Leave Approval Completed.');
                                                    //           },
                                                    //           label: const Text(
                                                    //               'Approve'),
                                                    //           icon: const Icon(
                                                    //               Icons
                                                    //                   .thumb_up),
                                                    //           backgroundColor:
                                                    //               Colors.green),
                                                    // ).show();
                                                  },
                                                  child: Column(
                                                    children: [
                                                      const SizedBox(
                                                          height: 10),
                                                      Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 5),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            // color: Colors.teal.withOpacity(0.2),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      leave
                                                                          .agent!
                                                                          .fullName,
                                                                      maxLines:
                                                                          2,
                                                                      style: Get
                                                                          .textTheme
                                                                          .headline6,
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          IconButton(
                                                                              onPressed: () {
                                                                                buildApplyLeaveShowDialog(lp, context, 'Update', Get.width, Get.height, data: [
                                                                                  leave.id!,
                                                                                  leave.fromDate!,
                                                                                  leave.toDate!,
                                                                                  leave.leaveTypeId!,
                                                                                  leave.description!
                                                                                ]);
                                                                              },
                                                                              icon: FaIcon(
                                                                                FontAwesomeIcons.penToSquare,
                                                                                size: 20,
                                                                                color: themeColor,
                                                                              )),
                                                                          // if (lp.role ==
                                                                          //     UserType.admin.name)
                                                                          // IconButton(
                                                                          //     onPressed: () {
                                                                          //       ConFirmDialog(
                                                                          //           title: 'Do you want to delete?',
                                                                          //           onConfirm: () {
                                                                          //             // Get.back();
                                                                          //             SuccessDialog(title: 'Leave deleted');
                                                                          //           });
                                                                          //     },
                                                                          //     icon: const Icon(
                                                                          //       Icons.delete_outlined,
                                                                          //       color: Colors.red,
                                                                          //       size: 25,
                                                                          //     )
                                                                          //     ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  const Icon(
                                                                    Icons.alarm,
                                                                    size: 15,
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          10),
                                                                  Expanded(
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                            '$fdate To $tdate'),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    '(${DateTime.parse(leave.toDate!).toUtc().difference(DateTime.parse(leave.fromDate!)).inDays + 1} days)',
                                                                    style: Get
                                                                        .theme
                                                                        .textTheme
                                                                        .bodyText1,
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 5),
                                                              Row(
                                                                children: [
                                                                  const Icon(
                                                                    Icons
                                                                        .calendar_month,
                                                                    size: 15,
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          10),
                                                                  Expanded(
                                                                    child: Row(
                                                                      children: [
                                                                        Text(leave
                                                                            .postingDate!),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 5),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Row(
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .done_all_rounded,
                                                                          color:
                                                                              Colors.green,
                                                                          size:
                                                                              16,
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                10),
                                                                        Row(
                                                                          children: [
                                                                            Text(whoApproved(
                                                                                MA: leave.status ?? 0,
                                                                                HR: leave.isHrApprovel ?? 0,
                                                                                RP: leave.isReportingPersonApprovel ?? 0)),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .watch_later_outlined,
                                                                          color:
                                                                              Colors.blue,
                                                                          size:
                                                                              16,
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                10),
                                                                        Row(
                                                                          children: [
                                                                            Text(whoWaiting(
                                                                                MA: leave.status ?? 0,
                                                                                HR: leave.isHrApprovel ?? 0,
                                                                                RP: leave.isReportingPersonApprovel ?? 0)),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .cancel,
                                                                          color:
                                                                              Colors.red,
                                                                          size:
                                                                              16,
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                10),
                                                                        Row(
                                                                          children: [
                                                                            Text(whoNotApproved(
                                                                                MA: leave.status ?? 0,
                                                                                HR: leave.isHrApprovel ?? 0,
                                                                                RP: leave.isReportingPersonApprovel ?? 0)),
                                                                          ],
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
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(width: 20),
                                                    Container(
                                                      width: Get.width * 0.5,
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20,
                                                          vertical: 5),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        30),
                                                                topRight: Radius
                                                                    .circular(
                                                                        30)),
                                                        color: themeColor
                                                            .withOpacity(0.7),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          lp.leavesTypeList
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .id ==
                                                                      leave
                                                                          .leaveTypeId)
                                                              .leavetype,
                                                          // leave.leaveTypeId
                                                          //     .toString(),
                                                          style: Get.textTheme
                                                              .bodyText1!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                        })
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Center(
                              child: Column(
                                children: const [
                                  SizedBox(height: 300),
                                  Text('No Leaves are Available.'),
                                ],
                              ),
                            ),
                      if (lp.isLoadMoreRunning == true)
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
                  ),
          ),
        );
      }),
    );
  }

  AppBar filterModeAppBar(LeavesProvider lp) {
    return AppBar(
      title: Row(
        children: [
          const Expanded(child: Text('Leaves')),
          Text('( ${lp.total} )'),
        ],
      ),
      backgroundColor: themeColor,
      actions: [
        buildRApplyForLeaveButton(lp, context, Get.width, Get.height),
        const SizedBox(width: 10),
        Stack(
          children: [
            IconButton(
                onPressed: () {
                  Get.to(LeavesFilter(
                    token: lp.token,
                  ));
                },
                icon: const Icon(Icons.filter_list_outlined)),
            if (lp.isFlrApplied)
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
      bottom: lp.isFlrApplied
          ? PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Container(
                height: 60,
                width: Get.width,
                padding: const EdgeInsets.only(left: 10),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    if (lp.selectedAgent != null)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(LeavesFilter(
                                  token: lp.token, selectedIndex: 0));
                            },
                            child: Chip(
                              deleteIcon: const Icon(Icons.clear),
                              label: lp.role != UserType.admin.name
                                  ? Text(lp.agentsByTeamList
                                      .firstWhere((element) => element.agents!
                                          .any((ele) =>
                                              ele.id == lp.selectedAgent))
                                      .agents!
                                      .firstWhere((element) =>
                                          element.id == lp.selectedAgent)
                                      .name!)
                                  : Text(lp.agentsByIdList
                                      .firstWhere((element) =>
                                          element.id == lp.selectedAgent)
                                      .name!),
                              onDeleted: () async {
                                setState(() {
                                  lp.selectedAgent = null;
                                });
                                await lp.applyFilter(lp);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    if (lp.fromDate != null || lp.toDate != null)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(LeavesFilter(
                                  token: lp.token, selectedIndex: 1));
                            },
                            child: Chip(
                              deleteIcon: const Icon(Icons.clear),
                              // deleteIconColor: Colors.red,
                              label: Text(
                                  lp.fromDate != null && lp.toDate != null
                                      ? DateFormat('yyyy-MM-dd')
                                              .format(lp.fromDate!) +
                                          '  To  ' +
                                          DateFormat('yyyy-MM-dd')
                                              .format(lp.toDate!)
                                      : lp.fromDate != null
                                          ? DateFormat('yyyy-MM-dd')
                                              .format(lp.fromDate!)
                                          : lp.toDate != null
                                              ? '  To  ' +
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(lp.toDate!)
                                              : ''),
                              onDeleted: () async {
                                setState(() {
                                  lp.fromDate = null;
                                  lp.toDate = null;
                                });
                                await lp.applyFilter(lp);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    if (lp.dropdownValue != null)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(LeavesFilter(
                                  token: lp.token, selectedIndex: 2));
                            },
                            child: Chip(
                              deleteIcon: const Icon(Icons.clear),
                              label: Text(
                                  '${showStatusTypeOnFilter(lp)} - ${lp.dropdownValue!.toLowerCase().contains('0') ? 'Waiting for Approval' : lp.dropdownValue!.toLowerCase().contains('1') ? 'Approval' : 'Not Approved'}'),
                              onDeleted: () async {
                                setState(() {
                                  lp.dropdownValue = null;
                                });
                                await lp.applyFilter(lp);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    if (lp.leaveTypeId != null)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(LeavesFilter(
                                  token: lp.token, selectedIndex: 3));
                            },
                            child: Chip(
                              deleteIcon: const Icon(Icons.clear),
                              label: Text(lp.leavesTypeList
                                  .firstWhere(
                                      (element) => element.id == lp.leaveTypeId)
                                  .leavetype),
                              onDeleted: () async {
                                setState(() {
                                  lp.leaveTypeId = null;
                                });
                                await lp.applyFilter(lp);
                              },
                            ),
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

  String whoNotApproved({required int MA, required int HR, required int RP}) {
    String data = '';
    if (MA == 2) {
      data += 'MA,';
    }
    if (HR == 2) {
      data += 'HR,';
    }
    if (RP == 2) {
      data += 'RP';
    }
    if (!data.lastIndexOf(',').isNegative &&
        data.lastIndexOf(',') == data.length - 1) {
      data = data.substring(0, data.length - 1);
    }
    return data;
  }

  String whoWaiting({required int MA, required int HR, required int RP}) {
    String data = '';
    if (MA == 0) {
      data += 'MA,';
    }
    if (HR == 0) {
      data += 'HR,';
    }
    if (RP == 0) {
      data += 'RP';
    }

    if (!data.lastIndexOf(',').isNegative &&
        data.lastIndexOf(',') == data.length - 1) {
      data = data.substring(0, data.length - 1);
    }
    return data;
  }

  String whoApproved({required int MA, required int HR, required int RP}) {
    String data = '';
    if (MA == 1) {
      data += 'MA,';
    }
    if (HR == 1) {
      data += 'HR,';
    }
    if (RP == 1) {
      data += 'RP';
    }

    if (!data.lastIndexOf(',').isNegative &&
        data.lastIndexOf(',') == data.length - 1) {
      data = data.substring(0, data.length - 1);
    }
    return data;
  }

  buildApplyLeaveShowDialog(LeavesProvider lp, BuildContext context,
      String actionTitle, double w, double h,
      {List? data}) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return ApplyLeaveShowDialog(
            actionTitle: actionTitle,
            w: w,
            h: h,
            getAllLeaves: lp.getAllLeaves,
            leavesTypeList: lp.leavesTypeList,
            data: data,
          );
        });
  }

  Widget buildRApplyForLeaveButton(
    LeavesProvider lp,
    BuildContext context,
    double w,
    double h,
  ) {
    return Row(
      children: [
        InkWell(
          onTap: () async {
            buildApplyLeaveShowDialog(lp, context, 'Apply', w, h);
          },
          child: Container(
            height: 30,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
              image: const DecorationImage(
                image: AssetImage('assets/apply_leave.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container buildLeavesCountContainer(double h, double w,
      {required List<Color> colors,
      required String title,
      required int count}) {
    return Container(
      height: h * 0.07,
      width: w * 0.3,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: h * 0.013),
                ),
                Text(
                  count.toString(),
                  style: TextStyle(color: Colors.white, fontSize: h * 0.013),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors),
              shape: BoxShape.circle,
            ),
            child: const Padding(
              padding: EdgeInsets.all(2.0),
              child: Icon(
                Icons.bar_chart,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  String dateFormatting(String date) {
    var dateTime;
    try {
      dateTime =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(date)).toString();
      return dateTime;
    } on FormatException catch (e) {
      var splited = date.split('/');
      var joined = '${splited[2]}-${splited[0]}-${splited[1]}';

      dateTime = DateFormat('yyyy-MM-dd').format(DateTime.parse(joined));
      print(e);
      return dateTime;
    }
  }
}

class ApplyLeaveShowDialog extends StatefulWidget {
  const ApplyLeaveShowDialog({
    Key? key,
    required this.actionTitle,
    required this.w,
    required this.h,
    required this.getAllLeaves,
    required this.leavesTypeList,
    this.data,
  }) : super(key: key);
  final String actionTitle;
  final double w, h;
  final VoidCallback getAllLeaves;

  final List<LeavesTypeModel> leavesTypeList;
  final List? data;

  @override
  State<ApplyLeaveShowDialog> createState() => _ApplyLeaveShowDialogState();
}

class _ApplyLeaveShowDialogState extends State<ApplyLeaveShowDialog> {
  String? id;
  TextEditingController descriptionController = TextEditingController();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now().add(const Duration(days: 1));
  String leavesType = "Select";
  int? leaveTypeId;
  int? selectedAgent;

  final GlobalKey<FormState> _agentFormKey = GlobalKey();

  

  Future<void> applyLeave() async {
    var pref = await SharedPreferences.getInstance();
    var authToken = pref.getString('token');
      var userId = pref.getInt('userId');
    var url = ApiManager.BASE_URL + ApiManager.addLeaveAgent;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $authToken',
      'Accept': 'application/json',
    };
    final body = {
      "agent_id": userId.toString(),
      "from_date": DateFormat('yyyy-MM-dd').format(fromDate),
      "to_date": DateFormat('yyyy-MM-dd').format(toDate),
      "leave_type_id": leaveTypeId.toString(),
      "description": descriptionController.text
    };
    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      var responseData = json.decode(response.body);
      debugPrint('Leaves Total : ---' + responseData.toString());
      if (response.statusCode == 200) {
        Get.back();
        Timer(const Duration(seconds: 0), () {
          AwesomeDialog(
            dismissOnBackKeyPress: true,
            dismissOnTouchOutside: false,
            context: Get.context!,
            dialogType: DialogType.success,
            animType: AnimType.rightSlide,
            title: '\n\nLeave Applied Successfully\n',
            // body: Image.asset('assets/images/delete.png'),
            autoHide: const Duration(seconds: 2),
          ).show();
        });
      } else {
        throw const HttpException('Failed To apply leave');
      }
      // print('----------------------------');
    } catch (error) {
      rethrow;
    }
    widget.getAllLeaves();
  }

  Future<void> updateLeave({required String id}) async {
    var pref = await SharedPreferences.getInstance();
    var authToken = pref.getString('token');
    var url = ApiManager.BASE_URL + ApiManager.updateLeaveAgent + '/$id';
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $authToken',
      'Accept': 'application/json',
    };
    final body = {
      // "agent_id": selectedAgent,
      "agent_id": id,
      "from_date": DateFormat('yyyy-MM-dd').format(fromDate),
      "to_date": DateFormat('yyyy-MM-dd').format(toDate),
      "leave_type_id": leaveTypeId.toString(),
      "description": descriptionController.text
    };
    print('this is body for update keave $body');
    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      var responseData = json.decode(response.body);
      debugPrint('Updated Leaves : ---' + responseData.toString());
      if (response.statusCode == 200) {
        Get.back();
        Timer(const Duration(seconds: 0), () {
          AwesomeDialog(
            dismissOnBackKeyPress: true,
            dismissOnTouchOutside: false,
            context: Get.context!,
            dialogType: DialogType.success,
            animType: AnimType.rightSlide,
            title: '\n\nUpdated Successfully\n',
            autoHide: const Duration(seconds: 2),
          ).show();
        });
      } else {
        throw const HttpException('Failed To Update leave');
      }
    } catch (error) {
      rethrow;
    }
    widget.getAllLeaves();
  }

  @override
  void initState() {
    super.initState();
    print('this is widget.data ${widget.data}');
    if (widget.data != null) {
      id = widget.data![0].toString();
      fromDate = DateTime.parse(widget.data![1]);
      toDate = DateTime.parse(widget.data![2]);
      leavesType = widget.leavesTypeList
          .firstWhere((element) => element.id == widget.data![3])
          .leavetype;
      leaveTypeId = widget.data![3];
      descriptionController.text = widget.data![4];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        // insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        // alignment: Alignment.bottomCenter,
        onClosing: () {},
        enableDrag: false,
        builder: (context) {
          return SizedBox(
            height: 410,
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: widget.h * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              // width: widget.w,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color: themeColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  widget.actionTitle == "Apply"
                                      ? 'Apply a new leave'
                                      : 'Update your leave',
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: widget.h * 0.01),

                      // const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: widget.w * 0.4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('From Date'),
                                const SizedBox(height: 3),
                                InkWell(
                                  onTap: () async {
                                    var newDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1990),
                                        lastDate:
                                            DateTime(DateTime.now().year + 3));
                                    setState(() {
                                      fromDate = newDate!;
                                    });
                                    // setState((){});
                                    print(fromDate);
                                    print(newDate);
                                  },
                                  child: Container(
                                    height: widget.h * 0.063,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: themeColor),
                                      // color: themeColor,
                                    ),
                                    child: Center(
                                        child: Text(DateFormat('dd-MM-yyyy')
                                            .format(fromDate))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: widget.w * 0.4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('To Date'),
                                const SizedBox(
                                  height: 3,
                                ),
                                InkWell(
                                  onTap: () async {
                                    var newDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1990),
                                        lastDate:
                                            DateTime(DateTime.now().year + 3));
                                    setState(() {
                                      toDate = newDate!;
                                    });
                                  },
                                  child: Container(
                                    height: widget.h * 0.063,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: themeColor),
                                      // color: themeColor,
                                    ),
                                    child: Center(
                                        child: Text(DateFormat('dd-MM-yyyy')
                                            .format(toDate))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: widget.h * 0.01),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Spacer(),
                          SizedBox(
                            width: widget.w * 0.4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Leaves Type'),
                                const SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  height: widget.h * 0.063,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: themeColor),
                                    // color: themeColor,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text(leavesType)),
                                      PopupMenuButton<String>(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        itemBuilder: (context) {
                                          return widget.leavesTypeList
                                              .map((e) => PopupMenuItem<String>(
                                                    child: Text(e.leavetype),
                                                    value: e.leavetype,
                                                  ))
                                              .toList();
                                        },
                                        onSelected: (val) {
                                          setState(() {
                                            leavesType = val;
                                            leaveTypeId = widget.leavesTypeList
                                                .firstWhere((element) =>
                                                    element.leavetype == val)
                                                .id;
                                          });
                                        },
                                        icon: const Icon(
                                            Icons.arrow_drop_down_rounded),
                                      ),
                                      // IconButton(onPressed: (){}, icon: Icon(Icons.arrow_drop_down_rounded),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (Provider.of<LeavesProvider>(context,
                                          listen: false)
                                      .role ==
                                  UserType.admin.name ||
                              Provider.of<LeavesProvider>(context,
                                          listen: false)
                                      .role ==
                                  UserType.hr.name)
                            SizedBox(
                                width: widget.w * 0.4,
                                child: TestPage(
                                    textStyle: const TextStyle(),
                                    fieldRadius: 10,
                                    title: 'Agent',
                                    list: Provider.of<LeavesProvider>(context,
                                            listen: false)
                                        .agentsByIdList,
                                    onTap: (id) {
                                      selectedAgent = id;
                                      print(
                                          'selected agent id--- $selectedAgent');
                                    },
                                    formKey: _agentFormKey)),
                        ],
                      ),
                      SizedBox(height: widget.h * 0.01),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Description'),
                          const SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: descriptionController,
                                  decoration: InputDecoration(
                                    hintText: 'Add Description',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: themeColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  maxLength: 45,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeColor,
                              disabledBackgroundColor: const Color(0xABA4A3A3),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () async {
                              if (toDate.difference(fromDate) <
                                      const Duration(hours: 11) ||
                                  fromDate.isAfter(toDate)) {
                                Fluttertoast.showToast(
                                    msg: 'Please select valid dates.');
                              } else if (leaveTypeId == null) {
                                Fluttertoast.showToast(
                                    msg: 'Please select valid leave type.');
                              } else if (descriptionController.text == '') {
                                Fluttertoast.showToast(
                                    msg: 'Please describe reason of leave.');
                              } else {
                                widget.actionTitle == 'Apply'
                                    ? await applyLeave()
                                        .then((value) => print('Applied'))
                                    : await updateLeave(id: id!)
                                        .then((value) => print('Updated'));
                              }
                            },
                            child: Text(
                              widget.actionTitle == 'Apply'
                                  ? 'Apply'
                                  : 'Update',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeColor,
                              disabledBackgroundColor: const Color(0xABA4A3A3),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class LeaveDetails extends StatefulWidget {
  const LeaveDetails({Key? key, required this.leave}) : super(key: key);
  final Leaves leave;

  @override
  State<LeaveDetails> createState() => _LeaveDetailsState();
}

class _LeaveDetailsState extends State<LeaveDetails> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: CircleAvatar(),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 250,
              child: Stack(
                children: [
                  Container(
                    height: 200,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: kToolbarHeight),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 20),
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                                        color: themeColor),
                                    onPressed: () {
                                      Get.back();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                            widget.leave.agent != null &&
                                    widget.leave.agent!.userProfile != null
                                ? widget.leave.agent!.userProfile!
                                : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpWvXdcjNuTkrkDCYKZRtWwZ-emiiDJdP6sUb7VRshRA&s',
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.leave.agent!.fullName,
                        style: Get.theme.textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.bold, letterSpacing: 5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.extended(
                    onPressed: () {},
                    label: const Text('Reject'),
                    icon: const FaIcon(FontAwesomeIcons.cancel),
                    backgroundColor: Colors.red),
                FloatingActionButton.extended(
                    onPressed: () {},
                    label: const Text('Approve'),
                    icon: const Icon(Icons.thumb_up),
                    backgroundColor: Colors.green),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class LeavesFilter extends StatefulWidget {
  const LeavesFilter({
    Key? key,
    required this.token,
    this.selectedIndex,
  }) : super(key: key);
  final String token;
  final int? selectedIndex;

  @override
  State<LeavesFilter> createState() => _LeavesFilterState();
}

class _LeavesFilterState extends State<LeavesFilter> {
  int selectedIndex = 0;

  InkWell buildOptionInkWell(BuildContext context,
      {required String value,
      required String name,
      required LeavesProvider lp}) {
    return InkWell(
      onTap: () {
        setState(() {
          lp.dropdownValue = value;
          lp.statusText = name;
        });
        // Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: lp.dropdownValue == value ? themeColor.withOpacity(0.1) : null,
        ),
        child: Row(
          children: [
            Text(
              name,
              style: TextStyle(
                  color: name == 'Waiting for Approval'
                      ? Colors.blue
                      : name == 'Approved'
                          ? Colors.green
                          : Colors.red,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  ListTile buildHeaderListTile(String header) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      tileColor: themeColor,
      leading: Text(
        header,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  List<AgentsByTeam> agentsByTeamList = [];
  List<AgentById> agentsByIdList = [];
  List<LeavesTypeModel> leavesTypeList = [];

  void init() {
    var lp = Provider.of<LeavesProvider>(context, listen: false);
    agentsByTeamList = lp.agentsByTeamList;
    agentsByIdList = lp.agentsByIdList;
    leavesTypeList = lp.leavesTypeList;
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
    return Consumer<LeavesProvider>(builder: (context, lp, _) {
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
            Expanded(flex: 2, child: filterLeftSection(lp)),
            VerticalDivider(width: 1, color: themeColor),
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
                                TextFormField(
                                  controller: lp.queryAgents,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  onChanged: (val) {
                                    if (val.isNotEmpty) {
                                      var list = filterSearchResult(
                                          lp.agentsByIdList
                                              .map((e) => MapEntry(
                                                  int.parse(e.id!),
                                                  e.name! + e.id.toString()))
                                              .toList(),
                                          val);
                                      setState(() {
                                        agentsByIdList = list
                                            .map((e) => AgentById(
                                                id: e.key.toString(),
                                                name: e.value))
                                            .toList();
                                      });
                                    } else {
                                      setState(() {
                                        agentsByIdList = lp.agentsByIdList;
                                        lp.queryAgents.text = '';
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
                                        lp.selectedAgent = null;
                                        lp.queryAgents.text = 'All';
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
                                if (lp.role != UserType.admin.name)
                                  ...lp.agentsByTeamList.map(
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
                                                  groupValue: lp.selectedAgent,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      lp.selectedAgent = val!;
                                                      lp.queryAgents.text =
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
                                if (lp.role == UserType.admin.name)
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
                                        groupValue: lp.selectedAgent,
                                        onChanged: (val) {
                                          setState(() {
                                            lp.selectedAgent = val!;
                                            lp.queryAgents.text = e.name!;
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
                                    hintText: lp.fromDate != null
                                        ? DateFormat('yyyy-MM-dd')
                                            .format(lp.fromDate!)
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
                                          lp.fromDate ?? DateTime.now());
                                  if (date != null) {
                                    setState(() {
                                      lp.fromDate = date;
                                      // lp.toDate = dateRange.end;
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
                                    hintText: lp.toDate != null
                                        ? DateFormat('yyyy-MM-dd')
                                            .format(lp.toDate!)
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
                                      initialDate: lp.toDate ?? DateTime.now());
                                  if (date != null) {
                                    setState(() {
                                      lp.toDate = date;
                                      // lp.toDate = dateRange.end;
                                    });
                                  }
                                },
                              ),
                            ],
                          )
                        : selectedIndex == 2
                            ? SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildHeaderListTile('Management'),
                                    buildOptionInkWell(context,
                                        value: 'ad_0',
                                        name: 'Waiting for Approval',
                                        lp: lp),
                                    buildOptionInkWell(context,
                                        value: 'ad_1',
                                        name: 'Approved',
                                        lp: lp),
                                    buildOptionInkWell(context,
                                        value: 'ad_2',
                                        name: 'Not Approved',
                                        lp: lp),
                                    const SizedBox(height: 20),
                                    buildHeaderListTile('HR'),
                                    buildOptionInkWell(context,
                                        value: 'hr_0',
                                        name: 'Waiting for Approval',
                                        lp: lp),
                                    buildOptionInkWell(context,
                                        value: 'hr_1',
                                        name: 'Approved',
                                        lp: lp),
                                    buildOptionInkWell(context,
                                        value: 'hr_2',
                                        name: 'Not Approved',
                                        lp: lp),
                                    const SizedBox(height: 20),
                                    buildHeaderListTile('Reporting Person'),
                                    buildOptionInkWell(context,
                                        value: 'rp_0',
                                        name: 'Waiting for Approval',
                                        lp: lp),
                                    buildOptionInkWell(context,
                                        value: 'rp_1',
                                        name: 'Approved',
                                        lp: lp),
                                    buildOptionInkWell(context,
                                        value: 'rp_2',
                                        name: 'Not Approved',
                                        lp: lp),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.transparent,
                                            shadowColor: themeColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () {
                                            lp.dropdownValue = null;
                                            setState(() {});
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 18.0),
                                            child: Text('Reset'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: lp.queryLeave,
                                    decoration: InputDecoration(
                                        hintText: 'Search By Words',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    onChanged: (val) {
                                      if (val.isNotEmpty) {
                                        var list = filterSearchResult(
                                            lp.leavesTypeList
                                                .map((e) =>
                                                    MapEntry(e.id, e.leavetype))
                                                .toList(),
                                            val);
                                        setState(() {
                                          leavesTypeList = list
                                              .map((e) => LeavesTypeModel(
                                                  id: e.key,
                                                  leavetype: e.value,
                                                  updated_at: '',
                                                  created_at: '',
                                                  description: ''))
                                              .toList();
                                        });
                                      } else {
                                        setState(() {
                                          leavesTypeList = lp.leavesTypeList;
                                          lp.queryLeave.text = '';
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: themeColor.withOpacity(0.1),
                                      ),
                                      child: ListTile(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        // tileColor: themeColor.withOpacity(0.1),
                                        onTap: () {
                                          setState(() {
                                            lp.leaveTypeId = null;
                                            lp.queryLeave.text = 'All';
                                          });
                                        },
                                        leading: const Text(''),
                                        title: const Text('All'),
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          ...leavesTypeList.map(
                                            (e) => Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: RadioListTile<int>(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                tileColor:
                                                    themeColor.withOpacity(0.1),
                                                value: e.id,
                                                groupValue: lp.leaveTypeId,
                                                onChanged: (val) {
                                                  setState(() {
                                                    lp.leaveTypeId = val!;
                                                    lp.queryLeave.text =
                                                        e.leavetype;
                                                  });
                                                },
                                                title: Text(e.leavetype),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
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
                        lp.isFilterApplied(false);
                        Get.back();
                        await lp.applyFilter(lp);
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
                        disabledBackgroundColor:  const Color(0xABA4A3A3),

                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),),

                      onPressed: () async {
                        Get.back();
                        await lp.applyFilter(lp);
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

  Color showTrailingColorOnFilter(LeavesProvider lp) {
    Color trailingColor = Colors.black;
    if (lp.dropdownValue != null) {
      if (lp.dropdownValue!.toLowerCase().contains('0')) {
        trailingColor = Colors.blue;
      }
      if (lp.dropdownValue!.toLowerCase().contains('1')) {
        trailingColor = Colors.green;
      }
      if (lp.dropdownValue!.toLowerCase().contains('2')) {
        trailingColor = Colors.red;
      }
    }
    return trailingColor;
  }

  ListView filterLeftSection(LeavesProvider lp) {
    return ListView(
      children: [
        ...lp.categoriesList.map(
          (e) => Column(
            children: [
              Stack(
                children: [
                  ListTile(
                    tileColor: selectedIndex == lp.categoriesList.indexOf(e)
                        ? themeColor.withOpacity(0.1)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedIndex = lp.categoriesList.indexOf(e);
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
                                        lp.categoriesList.indexOf(e)
                                    ? Get.theme.primaryColor
                                    : null),
                          ),
                        ],
                      ),
                    ),
                    trailing: Text(
                      e == lp.categoriesList[0] && lp.selectedAgent != null
                          ? 1.toString()
                          : e == lp.categoriesList[1] &&
                                  (lp.fromDate != null || lp.toDate != null)
                              ? '🔘'
                              : e == lp.categoriesList[2] &&
                                      lp.dropdownValue != null
                                  ? showStatusTypeOnFilter(lp)
                                  : e == lp.categoriesList[3] &&
                                          lp.leaveTypeId != null
                                      ? 1.toString()
                                      : '',
                      style: TextStyle(
                          color: e != lp.categoriesList[2]
                              ? Colors.pink
                              : showTrailingColorOnFilter(lp)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        color: selectedIndex == lp.categoriesList.indexOf(e)
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

String showStatusTypeOnFilter(LeavesProvider lp) {
  var text = '';
  var text2 = '';
  if (lp.dropdownValue!.toLowerCase().contains('ad')) {
    text2 = 'MA';
    switch (lp.dropdownValue) {
      case 'ad_0':
        {
          text = 'ad_0';
        }
        break;

      case 'ad_1':
        {
          text = 'ad_1';
        }
        break;

      default:
        {
          text = 'ad_2';
        }
        break;
    }
  } else if (lp.dropdownValue!.toLowerCase().contains('hr')) {
    text2 = 'HR';
    switch (lp.dropdownValue) {
      case 'hr_0':
        {
          text = 'hr_0';
        }
        break;

      case 'hr_1':
        {
          text = 'hr_1';
        }
        break;

      default:
        {
          text = 'hr_2';
        }
        break;
    }
  } else {
    text2 = 'RP';

    switch (lp.dropdownValue) {
      case 'rp_0':
        {
          text = 'rp_0';
        }
        break;

      case 'rp_1':
        {
          text = 'rp_1';
        }
        break;

      default:
        {
          text = 'rp_2';
        }
        break;
    }
  }
  return text2;
  return text;
}
