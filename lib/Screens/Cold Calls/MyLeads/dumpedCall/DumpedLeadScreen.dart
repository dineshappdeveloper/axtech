import 'dart:convert';
import 'dart:io';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:crm_application/ApiManager/Apis.dart';
import 'package:crm_application/Models/LeadsModel.dart';
import 'package:crm_application/Provider/DialProvider.dart';
import 'package:crm_application/Provider/DumpLeadsProvider.dart';
import 'package:crm_application/Provider/UserProvider.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/LeadFilter/Filter/FilterUI.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/LeadFilter/Models/agentsModel.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/ClosedLeads/closedLeads.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/LeadFilter/Models/developerModel.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/LeadFilter/Models/propertyModel.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/LeadFilter/Models/statusModel.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/LeadFilter/Models/stausmodel.dart';
import 'package:crm_application/Utils/Colors.dart';
import 'package:crm_application/Utils/Constant.dart';
import 'package:crm_application/Utils/ImageConst.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/TestCallDetailsScreen/TestCallScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class DumpedLeadScreen extends StatefulWidget {
  const DumpedLeadScreen({Key? key}) : super(key: key);

  @override
  State<DumpedLeadScreen> createState() => _MyLeadScreenState();
}

class _MyLeadScreenState extends State<DumpedLeadScreen> {
  late SharedPreferences pref;
  var authToken, responseData, url;
  int? sssPermission;
  int? clPermission;
  String TAG = 'DumpedCallScreen';

  bool isAddingContact = false;

  void getPrefs() async {
    pref = await SharedPreferences.getInstance();
    authToken = pref.getString('token');
    sssPermission = pref.getInt('sssPermission');
    clPermission = pref.getInt('clPermission');
    try {
      Provider.of<DumpLeadsProvider>(context, listen: false).token = authToken;
      Provider.of<DumpLeadsProvider>(context, listen: false).role =
          jsonDecode(pref.getString('user')!)['role'];
      await Provider.of<DumpLeadsProvider>(context, listen: false)
          .getDumpedLeads();
      await Provider.of<DumpLeadsProvider>(context, listen: false)
          .initFilterMethods();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs();
    Provider.of<DumpLeadsProvider>(context, listen: false).controller =
        ScrollController()
          ..addListener(
              Provider.of<DumpLeadsProvider>(context, listen: false).loadMore);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    Provider.of<DumpLeadsProvider>(context, listen: false)
        .controller
        .removeListener(
            Provider.of<DumpLeadsProvider>(context, listen: false).loadMore);
    super.dispose();
  }

  Future<bool> onWillPop(BuildContext context) async {
    var dp = Provider.of<DumpLeadsProvider>(context, listen: false);
    print(
        'On will Pop Scope selection mode-- > ' + dp.selectionMode.toString());
    if (dp.selectionMode) {
      dp.selectionMode = false;
      dp.selectedLeads.clear();
      setState(() {});
      return false;
    } else {
      return await dp.isFilterApplied(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var willBack = await onWillPop(context);

        return willBack;
      },
      child: Consumer<DumpLeadsProvider>(builder: (context, dp, _) {
        print('On selection mode-- > ' + dp.leadsData.length.toString());
        print('On selection mode-- > ' + dp.IsLoading.toString());
        print('On sss permission -- > ' + sssPermission.toString());
        print('On cl permission -- > ' + clPermission.toString());
        //  dp.selectedLeads.forEach((element) {print(element.leadId);});

        return Scaffold(
          appBar: !dp.selectionMode
              ? filterModeAppBar(dp)
              : AppBar(
                  backgroundColor: themeColor,
                  leading: IconButton(
                    onPressed: () {
                      dp.selectionMode = false;
                      dp.selectedLeads.clear();
                      setState(() {});
                    },
                    icon: const Icon(Icons.clear),
                  ),
                  // title: CheckboxListTile(
                  //   checkColor: themeColor,
                  //   activeColor: Colors.white,
                  //   side: const BorderSide(color: Colors.white),
                  //   value:  dp.selectedLeads.length ==  dp.leadsData.length,
                  //   onChanged: (v) {
                  //     setState(() {
                  //       !v!
                  //           ?  dp.selectedLeads.clear()
                  //           :  dp.selectedLeads.addAll(dp.leadsData);
                  //     });
                  //     // print(dp.selectedLeads.length);
                  //   },
                  title: Text(
                    '${dp.selectedLeads.length} Selected',
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
                                  const SizedBox(width: 20),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xF2C08004),
                                      disabledBackgroundColor:
                                          const Color(0xABA4A3A3),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    onPressed: dp.selectedLeads.isNotEmpty
                                        ? () async {
                                            await showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                    child:
                                                        DumpLeadAssignmentToLeaderDialog(
                                                            dp: dp),
                                                  );
                                                });
                                          }
                                        : null,
                                    child: const Text(
                                      'Assign To Team Leader',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xF2318005),
                                      disabledBackgroundColor:
                                          const Color(0xABA4A3A3),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    onPressed: dp.selectedLeads.isNotEmpty
                                        ? () async {
                                            await showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                    child:
                                                        DumpLeadAssignmentToAgentDialog(
                                                            dp: dp),
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
                                      backgroundColor: const Color(0xF2E52121),
                                      disabledBackgroundColor:
                                          const Color(0xABA4A3A3),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    onPressed: dp.selectedLeads.isNotEmpty
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
                                                await dp.bulkDelete();
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
          body: !dp.IsLoading
              // ?  MyHomePage(dp:  dp,)
              ? Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: DumpLeadsCard(
                            dp: dp,
                          ),
                        ),
                        // when the _loadMore function is running
                        if (dp.isLoadMoreRunning == true)
                          const Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 25),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
                    isAddingContact
                        ? Container(
                            color: const Color(0x30595B59),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Container(),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      }),
    );
  }

  AppBar filterModeAppBar(DumpLeadsProvider dp) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios)),
          const Expanded(
              child: Text(
            ' Dumped Leads',
            textAlign: TextAlign.start,
            maxLines: 2,
          )),
          Text('( ${dp.total} )')
        ],
      ),
      backgroundColor: themeColor,
      actions: [
        Stack(
          children: [
            IconButton(
                onPressed: () {
                  Get.to(DumpLeadsFilters(token: authToken));
                },
                icon: const Icon(Icons.filter_list_outlined)),
            if (dp.isFlrApplied)
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

        ///TODO:
        ///Closed leads popup menu
        /*
        const SizedBox(width: 10),
        PopupMenuButton<int>(
          onSelected: (val) {
            if (val == 0) {
              Get.to(const ClosedLeadsScreen());
            }
            if (val == 1) {
              // Get.to(const SSSScreen());
            }
          },
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                  value: 0,
                  child: Row(
                    children: const [
                      FaIcon(
                        FontAwesomeIcons.solidFolderClosed,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Text('CLosed Leads')
                    ],
                  )),
              if (dp.role == UserType.admin.name || sssPermission == 1)
                PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.reviews_rounded,
                          color: Colors.black,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                            child: Text('Service Satisfactory Survey (SSS)'))
                      ],
                    )),
            ];
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.all(10),
        ),
        */
      ],
      bottom: dp.isFlrApplied
          ? PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Container(
                height: 60,
                width: Get.width,
                // color: Colors.grey,
                padding: const EdgeInsets.only(left: 10),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    if (dp.selectedAgent != null)
                      GestureDetector(
                        onTap: () {
                          Get.to(DumpLeadsFilters(
                              token: dp.token, selectedIndex: 0));
                        },
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(DumpLeadsFilters(
                                    token: dp.token, selectedIndex: 0));
                              },
                              child: Chip(
                                deleteIcon: const Icon(Icons.clear),
                                label: dp.role != UserType.admin.name
                                    ? Text(dp.agentsByTeamList
                                        .firstWhere((element) => element.agents!
                                            .any((ele) =>
                                                ele.id == dp.selectedAgent))
                                        .agents!
                                        .firstWhere((element) =>
                                            element.id == dp.selectedAgent)
                                        .name!)
                                    : Text(dp.agentsByIdList
                                        .firstWhere((element) =>
                                            element.id == dp.selectedAgent)
                                        .name!),
                                onDeleted: () async {
                                  setState(() {
                                    dp.selectedAgent = null;
                                  });
                                  await dp.applyFilter(dp);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    if (dp.fromDate != null || dp.toDate != null)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(DumpLeadsFilters(
                                  token: dp.token, selectedIndex: 1));
                            },
                            child: Chip(
                              deleteIcon: const Icon(Icons.clear),
                              // deleteIconColor: Colors.red,
                              label: Text(
                                  dp.fromDate != null && dp.toDate != null
                                      ? DateFormat('yyyy-MM-dd')
                                              .format(dp.fromDate!) +
                                          '  To  ' +
                                          DateFormat('yyyy-MM-dd')
                                              .format(dp.toDate!)
                                      : dp.fromDate != null
                                          ? DateFormat('yyyy-MM-dd')
                                              .format(dp.fromDate!)
                                          : dp.toDate != null
                                              ? '  To  ' +
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(dp.toDate!)
                                              : ''),
                              onDeleted: () async {
                                setState(() {
                                  dp.fromDate = null;
                                  dp.toDate = null;
                                });
                                await dp.applyFilter(dp);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    if (dp.selectedDeveloper != null)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(DumpLeadsFilters(
                                  token: dp.token, selectedIndex: 2));
                            },
                            child: Chip(
                              deleteIcon: const Icon(Icons.clear),
                              label: Text(dp.developersList
                                  .firstWhere((element) =>
                                      element.id == dp.selectedDeveloper)
                                  .name!),
                              onDeleted: () async {
                                setState(() {
                                  dp.selectedDeveloper = null;
                                });
                                await dp.applyFilter(dp);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    if (dp.selectedProperty != null)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(DumpLeadsFilters(
                                  token: dp.token, selectedIndex: 3));
                            },
                            child: Chip(
                              deleteIcon: const Icon(Icons.clear),
                              label: Text(dp.propertyList
                                  .firstWhere((element) =>
                                      element.id == dp.selectedProperty)
                                  .name!),
                              onDeleted: () async {
                                setState(() {
                                  dp.selectedProperty = null;
                                });
                                await dp.applyFilter(dp);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    if (dp.multiSelectedStatus.isNotEmpty)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(DumpLeadsFilters(
                                  token: dp.token, selectedIndex: 4));
                            },
                            child: PopupMenuButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              itemBuilder: (context) {
                                return [
                                  ...dp.multiSelectedStatus.map(
                                    (e) => PopupMenuItem(
                                        child: Chip(
                                      deleteIcon: const Icon(Icons.clear),
                                      label: Text(e.name!),
                                      onDeleted: () async {
                                        setState(() {
                                          dp.multiSelectedStatus.remove(e);
                                        });
                                        Get.back();
                                        await dp.applyFilter(dp);
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
                                        '${dp.multiSelectedStatus.length} Status'),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    if (dp.multiSelectedSources.isNotEmpty)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(DumpLeadsFilters(
                                  token: dp.token, selectedIndex: 5));
                            },
                            child: PopupMenuButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              itemBuilder: (context) {
                                return [
                                  ...dp.multiSelectedSources.map(
                                    (e) => PopupMenuItem(
                                        child: Chip(
                                      deleteIcon: const Icon(Icons.clear),
                                      label: Text(e.name!),
                                      onDeleted: () async {
                                        setState(() {
                                          dp.multiSelectedSources.remove(e);
                                        });
                                        Get.back();
                                        await dp.applyFilter(dp);
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
                                        '${dp.multiSelectedSources.length} Sources'),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    if (dp.selectedPriority != null)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(DumpLeadsFilters(
                                  token: dp.token, selectedIndex: 6));
                            },
                            child: Chip(
                              deleteIcon: const Icon(Icons.clear),
                              label: Text(dp.selectedPriority!),
                              onDeleted: () async {
                                setState(() {
                                  dp.selectedPriority = null;
                                });
                                await dp.applyFilter(dp);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    if (dp.query.text.isNotEmpty)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(DumpLeadsFilters(
                                  token: dp.token, selectedIndex: 7));
                            },
                            child: Chip(
                              deleteIcon: const Icon(Icons.clear),
                              label: Text(dp.query.text),
                              onDeleted: () async {
                                setState(() {
                                  dp.query.clear();
                                });
                                await dp.applyFilter(dp);
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
}

class DumpLeadsCard extends StatefulWidget {
  const DumpLeadsCard({Key? key, required this.dp}) : super(key: key);
  final DumpLeadsProvider dp;

  @override
  State<DumpLeadsCard> createState() => _DumpLeadsCardState();
}

class _DumpLeadsCardState extends State<DumpLeadsCard> {
  bool isVisible = false;
  var whatsapp;
  _callNumber(String number) async {
    const numbrr = '08592119XXXX'; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  openWhatsapp(String number) async {
    whatsapp = '+$number';
    debugPrint(number);
    debugPrint(whatsapp);
    var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp";
    var whatappURLIos = "https://wa.me/$whatsapp";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURLIos)) {
        await launch(whatappURLIos, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURlAndroid)) {
        await launch(whatsappURlAndroid);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("whatsapp no installed"),
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }

  _textMe(var number) async {
    // Android
    var uri = "sms:$number?body=hello%20there";
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      var uri = 'sms:$number?body=hello%20there';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Could not open message app"),
          behavior: SnackBarBehavior.floating,
        ));
        throw 'Could not launch $uri';
      }
    }
  }

  _MailMe(var email) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: '$email',
      // query: 'subject=App Feedback&body=App Version 3.23', //add subject and body here
    );

    var url = params.toString();
    if (await canLaunch(url)) {
      print('can launch.');
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Could not email app"),
        behavior: SnackBarBehavior.floating,
      ));
      throw 'Could not launch $url';
    }
    // // Android
    // var uri = "mailto:${email ?? ''}?subject=News&body=New%20plugin";
    // if (await canLaunch(uri)) {
    //   await launch(uri);
    // } else {
    //   // iOS
    //   // var uri = 'sms:$number?body=hello%20there';
    //   if (await canLaunch(uri)) {
    //     await launch(uri);
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       content: Text("Could not email app"),
    //       behavior: SnackBarBehavior.floating,
    //     ));
    //     throw 'Could not launch $uri';
    //   }
    // }
  }

  Future<void> convertToLead(
      int id, BuildContext context, DumpLeadsProvider dp) async {
    //_isLoading = true;
    late SharedPreferences pref;
    var authToken;
    pref = await SharedPreferences.getInstance();
    authToken = pref.getString('token');
    var url =
        ApiManager.BASE_URL + ApiManager.dumpedLeadMovedToActiveLead + '/$id';
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $authToken',
      //'Accept': 'application/json',
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
      );
      // print(response.statusCode);
      // print(response.body);
      // print('started2');
      var responseData = json.decode(response.body);
      debugPrint(responseData.toString());
      if (response.statusCode == 200) {
        // print('started3');
        // _isLoading = false;
        var success = responseData['success'];
        var message = responseData['message'];

        if (success == true) {
          Get.back();
          await dp.getDumpedLeads();
          // _isLoading = false;
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(message),
          //   ),
          // );

          AwesomeDialog(
            dismissOnBackKeyPress: true,
            dismissOnTouchOutside: false,
            context: Get.context!,
            dialogType: DialogType.success,
            animType: AnimType.scale,
            title: '\n$message\n',
            // body: Image.asset('assets/images/delete.png'),
            autoHide: const Duration(seconds: 2),
          ).show();
        }
        // notifyListeners();
      } else {
        // _isLoading = false;
        throw const HttpException('Failed To Conversion');
      }
      // notifyListeners();
    } catch (error) {
      debugPrint(error.toString());
      // _isLoading = false;
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.dp.controller,
      physics: const BouncingScrollPhysics(),
      children: [
        ...widget.dp.leadsByDate.map((e) {
          return Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    color: const Color(0xAE111F44),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        DateFormat(
                          'yyyy-MM-dd',
                        ).format(DateTime.parse(e.date!)),
                        style: Get.theme.textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  ...e.leads!.map((lead) {
                    String agentsName = '';
                    int agentId = 0;
                    if (lead.agents != null || lead.agents!.isNotEmpty) {
                      agentId = lead.agents!.first.id;
                      lead.agents!.length > 1
                          ? isVisible = true
                          : isVisible = false;
                      for (var element in lead.agents!) {
                        agentsName += "${element.fullName},";
                      }
                      // print('eeeeeeeeeeeeeeeeeeeeeeee $agentsName');
                      // print('eeeeeeeeeeeeeeeeeeeeeeee ${agentsName.length}');
                      if (agentsName.length > 1) {
                        agentsName =
                            agentsName.substring(0, agentsName.length - 1);
                      }
                    }
                    var isSelected = widget.dp.selectedLeads
                        .any((element) => element.leadId == lead.leadId);

                    var priorityImage = "assets/images/profile.png";
                    if (lead.priority != null) {
                      lead.priority!.toLowerCase() == 'cold'
                          ? priorityImage = 'assets/icons/Cold.png'
                          : lead.priority!.toLowerCase() == 'warm'
                              ? priorityImage = 'assets/icons/Warm.png'
                              : lead.priority!.toLowerCase() == 'hot'
                                  ? priorityImage = 'assets/icons/Hot.png'
                                  : lead.priority!.toLowerCase() ==
                                          'not interested'
                                      ? priorityImage =
                                          'assets/icons/Not Interested.png'
                                      : "assets/images/profile.png";
                    }
                    var colorCode;
                    var color = const Color(0xFF000000);
                    if (lead.statuses != null) {
                      colorCode = lead.statuses!.color
                          .substring(1, lead.statuses!.color.length - 1);
                      colorCode = '0xFF' + colorCode;
                      var intCode = int.parse(colorCode);
                      color = Color(intCode);
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        // onLongPress: () {
                        //   if (widget.dp.role == UserType.admin.name) {
                        //     if (!widget.dp.selectionMode) {
                        //       setState(() {
                        //         widget.dp.setSelectionMode(true);
                        //         // widget.dp.setSelectedLeads(lead);
                        //       });
                        //     }
                        //   } else {
                        //     print('Your role is ${widget.dp.role}');
                        //   }
                        // },
                        onTap: () {
                          if (!widget.dp.selectionMode) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TestCallScreen(
                                  leadId: lead.leadId.toString(),
                                  leadType: 'dumped',
                                ),
                              ),
                            );
                          } else {
                            widget.dp.setSelectedLeads(lead);
                            if (widget.dp.selectedLeads.isEmpty) {
                              widget.dp.selectionMode = false;
                              setState(() {});
                            }
                          }
                        },
                        child: Card(
                          elevation: 3,
                          shadowColor: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: isSelected
                              ? const Color(0xC3B7DBF5)
                              : Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            foregroundDecoration: lead.priority != null
                                ? RotatedCornerDecoration(
                                    color: themeColor,
                                    geometry: BadgeGeometry(
                                        width:
                                            lead.priority!.split(' ').length > 1
                                                ? 100
                                                : 60,
                                        cornerRadius: 10,
                                        height: 60),
                                    textSpan: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              lead.priority!.split(' ').first +
                                                  "\n",
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        if (lead.priority!.split(' ').length >
                                            1)
                                          TextSpan(
                                            text: lead.priority!.split(' ')[1],
                                            style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                      ],
                                    ),
                                    labelInsets:
                                        const LabelInsets(baselineShift: 1),
                                  )
                                : null,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, top: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Text('Lead ID : ',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                Expanded(
                                                  child: Text(
                                                    lead.leadId.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(lead.name.toString(),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Get.theme.textTheme
                                                        .caption!.color,
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            const SizedBox(height: 7),
                                            SizedBox(
                                              width: 180,
                                              child: Row(
                                                children: [
                                                  FaIcon(
                                                    FontAwesomeIcons.users,
                                                    size: 13,
                                                    color: Colors.red
                                                        .withOpacity(0.5),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      agentsName,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            SizedBox(
                                              width: 180,
                                              child: Row(
                                                children: [
                                                  FaIcon(
                                                    FontAwesomeIcons.globe,
                                                    color: Colors.green
                                                        .withOpacity(0.5),
                                                    size: 15,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      lead.sources!.name
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        overflow:
                                                            TextOverflow.fade,
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
                                    if (agentId == myId)
                                      InkWell(
                                        onTap: () async {
                                          print('call');
                                          try {
                                            // _callNumber(
                                            //     'tel:${lead.phone.toString()}');
                                            try {
                                              await Provider.of<DialProvider>(
                                                      context,
                                                      listen: false)
                                                  .makeDialCall(
                                                      lead.phone.toString(),
                                                      'Lead',
                                                      name: lead.name);
                                            } catch (e) {
                                              print('Lead screen error $e');
                                            }
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 18.0,
                                          ),
                                          child: Image.asset(
                                            ImageConst.call_icon,
                                            height: 25,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(width: 30),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        child: Divider(
                                          thickness: 1,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Row(
                                        children: [
                                          FaIcon(FontAwesomeIcons.batteryHalf,
                                              color: color.withOpacity(1),
                                              size: 15),
                                          const SizedBox(width: 5),
                                          Text(
                                            lead.statuses != null
                                                ? lead.statuses!.name.toString()
                                                : "N/A",
                                            style: TextStyle(
                                                fontSize: 14,
                                                overflow: TextOverflow.fade,
                                                color: color.withOpacity(1)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30.0, right: 30.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (agentId == myId) {
                                            openWhatsapp(
                                              lead.phone.toString(),
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'You don\'t have permission. ');
                                          }
                                        },
                                        child: Image.asset(
                                          'assets/images/whatsapp.png',
                                          height: 25,
                                          width: 25,
                                        ),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            if (agentId == myId) {
                                              _MailMe(
                                                lead.email,
                                              );
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'You don\'t have permission. ');
                                            }
                                          },
                                          child: const Icon(
                                              Icons.email_outlined,
                                              color: Colors.green)),
                                      GestureDetector(
                                        onTap: () async {
                                          if (agentId == myId) {
                                            await Clipboard.setData(
                                                ClipboardData(
                                                    text: lead.phone));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    duration:
                                                        Duration(seconds: 1),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    content: Text(
                                                        'Phone number copied successfully!')));
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'You don\'t have permission. ');
                                          }
                                        },
                                        child: const Icon(
                                          Icons.copy,
                                          size: 25,
                                          color: Colors.green,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          AwesomeDialog(
                                            showCloseIcon: true,
                                            dismissOnBackKeyPress: true,
                                            dismissOnTouchOutside: false,
                                            context: Get.context!,
                                            dialogType: DialogType.question,
                                            animType: AnimType.rightSlide,
                                            title:
                                                '\n\nAre you sure to convert as lead?\n',
                                            btnCancel:
                                                FloatingActionButton.extended(
                                                    onPressed: () {
                                                      Get.back();
                                                      // SuccessDialog(
                                                      //     title:
                                                      //         'Leave Rejected.');
                                                    },
                                                    label: const Text('No'),
                                                    icon: const FaIcon(
                                                        FontAwesomeIcons
                                                            .cancel),
                                                    backgroundColor:
                                                        Colors.red),
                                            btnOk:
                                                FloatingActionButton.extended(
                                                    onPressed: () async {
                                                      // Get.back();
                                                      await convertToLead(
                                                          lead.id,
                                                          context,
                                                          widget.dp);
                                                    },
                                                    label: const Text('Yes'),
                                                    icon: const Icon(
                                                        Icons.thumb_up),
                                                    backgroundColor:
                                                        Colors.green),
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
                                        child: const FaIcon(
                                          FontAwesomeIcons.shareFromSquare,
                                          size: 25,
                                          //width: 30,
                                          color: Colors.green,
                                        ),
                                      ),

                                      ///TODO: remove button on card
                                      /*
                                      GestureDetector(

                                        onTap: () async {
                                          AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.question,
                                              title:
                                                  'Are you sure to remove from list?',
                                              dismissOnBackKeyPress: true,
                                              dismissOnTouchOutside: false,
                                              btnOkText: 'Yes sure!',
                                              btnCancelText: 'No',
                                              btnCancelOnPress: () {},
                                              btnOkOnPress: () async {
                                                await widget.lp
                                                    .removeLeadFromList(lead
                                                        .leadId!
                                                        .toString());
                                              }).show();
                                          // if (agentId == myId) {
                                          //   await Clipboard.setData(
                                          //       ClipboardData(
                                          //           text: lead.phone));
                                          //   ScaffoldMessenger.of(context)
                                          //       .showSnackBar(const SnackBar(
                                          //           duration:
                                          //               Duration(seconds: 1),
                                          //           behavior: SnackBarBehavior
                                          //               .floating,
                                          //           content: Text(
                                          //               'Phone number copied successfully!')));
                                          // } else {
                                          //   Fluttertoast.showToast(
                                          //       msg:
                                          //           'You don\'t have permission. ');
                                          // }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              // shape: BoxShape.circle,
                                              // border: Border.all(color: Colors.red,width: 2,),

                                              ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: const Icon(
                                              Icons.remove_circle_rounded,
                                              size: 25,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                      */
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          );
        })
      ],
    );
  }
}

class DumpLeadAssignmentToLeaderDialog extends StatefulWidget {
  const DumpLeadAssignmentToLeaderDialog({
    Key? key,
    required this.dp,
  }) : super(key: key);
  final DumpLeadsProvider dp;

  @override
  State<DumpLeadAssignmentToLeaderDialog> createState() =>
      _DumpLeadAssignmentToLeaderDialogState();
}

class _DumpLeadAssignmentToLeaderDialogState
    extends State<DumpLeadAssignmentToLeaderDialog> {
  var leaderId;
  var sourceId;
  var statusId;
  final GlobalKey<FormState> _leaderKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _sourceKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _statusKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _dateKey = GlobalKey<FormState>();

  DateTime? date;
  TextEditingController dtController = TextEditingController();
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
                        "Lead Assign To Team Leader",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  DumpTestPage(
                    title: 'Team Leader',
                    list: widget.dp.teamLeadersList,
                    formKey: _leaderKey,
                    onTap: (id) {
                      setState(() {
                        leaderId = id;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  DumpTestPage(
                    formKey: _sourceKey,
                    title: 'Source',
                    list: widget.dp.sourcesList,
                    onTap: (id) {
                      setState(() {
                        sourceId = id;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  DumpTestPage(
                    formKey: _statusKey,
                    title: 'Status',
                    list: widget.dp.statusList,
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

                          print(date);
                          setState(() {});
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required field";
                        } else {
                          return null;
                        }
                      },
                      controller: dtController,
                      decoration: InputDecoration(
                          hintText: 'Select Date',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                  ),
                  onPressed: () async {
                    //  dp.dispose();
                    if (_leaderKey.currentState!.validate() &&
                        _sourceKey.currentState!.validate() &&
                        _statusKey.currentState!.validate() &&
                        _dateKey.currentState!.validate()) {
                      await widget.dp.assignToTeamLeader();
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
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

class DumpLeadAssignmentToAgentDialog extends StatefulWidget {
  const DumpLeadAssignmentToAgentDialog({
    Key? key,
    required this.dp,
  }) : super(key: key);
  final DumpLeadsProvider dp;

  @override
  State<DumpLeadAssignmentToAgentDialog> createState() =>
      _DumpLeadAssignmentToAgentDialogState();
}

class _DumpLeadAssignmentToAgentDialogState
    extends State<DumpLeadAssignmentToAgentDialog> {
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
                                        child: DumpAgentsList(
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
                  DumpTestPage(
                    formKey: _sourceKey,
                    title: 'Sources',
                    list: widget.dp.sourcesList,
                    onTap: (id) {
                      setState(() {
                        sourceId = id;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  DumpTestPage(
                    formKey: _statusKey,
                    title: 'Status',
                    list: widget.dp.statusList,
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                  ),
                  onPressed: () async {
                    if (_agentKey.currentState!.validate() &&
                        _sourceKey.currentState!.validate() &&
                        _statusKey.currentState!.validate() &&
                        _dateKey.currentState!.validate()) {
                      await widget.dp.assignToAgent();
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
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

class DumpAgentsList extends StatefulWidget {
  const DumpAgentsList({Key? key, required this.onTap, this.selectedAgent})
      : super(key: key);
  final void Function(AgentById agent) onTap;
  final AgentById? selectedAgent;

  @override
  State<DumpAgentsList> createState() => _DumpAgentsListState();
}

class _DumpAgentsListState extends State<DumpAgentsList> {
  AgentById? selectedAgent;
  @override
  void initState() {
    super.initState();
    if (widget.selectedAgent != null) {
      selectedAgent = widget.selectedAgent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DumpLeadsProvider>(builder: (context, dp, _) {
      return ListView(
        children: [
          if (dp.role != UserType.admin.name)
            ...dp.agentsByTeamList.map(
              (e) {
                return Container(
                  color: Colors.white,
                  child: ExpansionTile(
                    collapsedBackgroundColor: Colors.white,
                    title: Text(e.name!),
                    children: [
                      ...e.agents!.map(
                        (agent) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, left: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: selectedAgent == agent
                                  ? themeColor.withOpacity(0.1)
                                  : Colors.white,
                            ),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              tileColor: selectedAgent == agent
                                  ? themeColor.withOpacity(0.1)
                                  : Colors.white,
                              onTap: () {
                                setState(() {
                                  selectedAgent = agent;
                                  widget.onTap(selectedAgent!);
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
                );
              },
            ),
          if (dp.role == UserType.admin.name)
            ...dp.agentsByIdList.map(
              (e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    tileColor: themeColor.withOpacity(0.1),
                    onTap: () {
                      setState(() {
                        selectedAgent = e;
                        widget.onTap(selectedAgent!);
                      });
                    },
                    title: Text(e.name!),
                  ),
                );
              },
            ),
        ],
      );
    });
  }
}

class DumpTestPage extends StatefulWidget {
  const DumpTestPage({
    Key? key,
    required this.title,
    required this.list,
    required this.onTap,
    required this.formKey,
    this.textColor,
    this.textStyle,
    this.fieldRadius,
  }) : super(key: key);
  final String? title;
  final List list;
  final Color? textColor;
  final TextStyle? textStyle;
  final double? fieldRadius;
  final GlobalKey<FormState> formKey;
  final void Function(int id) onTap;

  @override
  State<DumpTestPage> createState() => _DumpTestPageState();
}

class _DumpTestPageState extends State<DumpTestPage> {
  late SingleValueDropDownController _cnt;

  @override
  void initState() {
    _cnt = SingleValueDropDownController();
    super.initState();
  }

  @override
  void dispose() {
    _cnt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.title ?? '',
                style: widget.textStyle ??
                    Get.theme.textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold, color: widget.textColor),
              ),
            ],
          ),
          const SizedBox(height: 5),
          DropDownTextField(
            controller: _cnt,
            clearOption: true,
            enableSearch: true,
            textStyle: TextStyle(color: widget.textColor),
            textFieldDecoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: widget.textColor ?? Colors.black),
                  borderRadius: BorderRadius.all(
                      Radius.circular(widget.fieldRadius ?? 4.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: widget.textColor ?? Colors.black),
                  borderRadius: BorderRadius.all(
                      Radius.circular(widget.fieldRadius ?? 4.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: widget.textColor ?? Colors.black),
                  borderRadius: BorderRadius.all(
                      Radius.circular(widget.fieldRadius ?? 4.0)),
                ),
                hintText: 'Select',
                hintStyle: TextStyle(color: widget.textColor)),
            searchDecoration: const InputDecoration(hintText: "Search here"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Required field";
              } else {
                return null;
              }
            },
            dropDownIconProperty:
                IconProperty(color: widget.textColor ?? Colors.black),
            dropDownItemCount: 5,
            dropDownList: [
              ...widget.list.map((e) {
                return DropDownValueModel(
                    name: e.name, value: e.id, toolTipMsg: e.name);
              }),
            ],
            onChanged: (val) {
              widget.onTap(val.value.runtimeType == 1.runtimeType
                  ? val.value
                  : int.parse(val.value));
            },
          ),
        ],
      ),
    );
  }
}

class DumpLeadsFilters extends StatefulWidget {
  const DumpLeadsFilters({
    Key? key,
    required this.token,
    this.selectedIndex,
  }) : super(key: key);
  final String token;
  final int? selectedIndex;

  @override
  State<DumpLeadsFilters> createState() => _DumpLeadsFiltersState();
}

class _DumpLeadsFiltersState extends State<DumpLeadsFilters> {
  int selectedIndex = 0;
  List<AgentById> agentsByIdList = [];
  List<DeveloperModel> developersList = [];
  List<PropertyModel> propertyList = [];
  List<StatusModel> statusList = [];
  List<SourceModel> sourcesList = [];
  List<String> priorityList = [];

  void init() {
    var dp = Provider.of<DumpLeadsProvider>(context, listen: false);
    agentsByIdList = dp.agentsByIdList;
    developersList = dp.developersList;
    propertyList = dp.propertyList;
    statusList = dp.statusList;
    sourcesList = dp.sourcesList;
    priorityList = dp.priorityList;
    if (widget.selectedIndex != null) {
      selectedIndex = widget.selectedIndex!;
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DumpLeadsProvider>(builder: (context, dp, _) {
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
            Expanded(flex: 2, child: filterLeftSection(dp)),
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
                                if (dp.role == UserType.admin.name)
                                  TextFormField(
                                    controller: dp.queryAgents,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    onChanged: (val) async {
                                      if (val.isNotEmpty) {
                                        // List<MapEntry<int, String>> ls = [];
                                        // // print(dp.role == UserType.admin.name);
                                        // if (dp.role != UserType.admin.name) {
                                        //   for (var e in  dp.agentsByTeamList) {
                                        //     // print('user role ${dp.role}');
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
                                            //  dp.role != UserType.admin.name
                                            //     ? ls
                                            dp.agentsByIdList
                                                .map((e) => MapEntry(
                                                    int.parse(e.id!), e.name!))
                                                .toList(),
                                            val);
                                        setState(() {
                                          // agentsByTeamList = list
                                          //     .map((e) => AgentsByTeam(name:  dp.agentsByTeamList.firstWhere((element) => element.agents!.any((element) => element.id==e.key.toString())).name,agents: list.where((element) =>  dp.agentsByTeamList.firstWhere((element) => element.agents!.any((element) => element.id==e.key.toString())).agents.map((e) => AgentById(
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
                                          agentsByIdList = dp.agentsByIdList;
                                          dp.queryAgents.text = '';
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
                                        dp.selectedAgent = null;
                                        dp.queryAgents.text = 'All';
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
                                if (dp.role != UserType.admin.name)
                                  ...dp.agentsByTeamList.map(
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
                                                  groupValue: dp.selectedAgent,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      dp.selectedAgent = val!;
                                                      dp.queryAgents.text =
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
                                if (dp.role == UserType.admin.name)
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
                                        groupValue: dp.selectedAgent,
                                        onChanged: (val) {
                                          setState(() {
                                            dp.selectedAgent = val!;
                                            dp.queryAgents.text = e.name!;
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
                                // controller: TextEditingController(),
                                decoration: InputDecoration(
                                    hintText: dp.fromDate != null
                                        ? DateFormat('yyyy-MM-dd')
                                            .format(dp.fromDate!)
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
                                          dp.fromDate ?? DateTime.now());
                                  if (date != null) {
                                    setState(() {
                                      dp.fromDate = date;
                                      //  dp.toDate = dateRange.end;
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
                                    hintText: dp.toDate != null
                                        ? DateFormat('yyyy-MM-dd')
                                            .format(dp.toDate!)
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
                                      initialDate: dp.toDate ?? DateTime.now());
                                  if (date != null) {
                                    setState(() {
                                      dp.toDate = date;
                                      //  dp.toDate = dateRange.end;
                                    });
                                  }
                                },
                              ),
                            ],
                          )
                        : selectedIndex == 2
                            ? Column(
                                children: [
                                  TextFormField(
                                    controller: dp.queryDevelopers,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    onChanged: (val) {
                                      if (val.isNotEmpty) {
                                        var list = filterSearchResult(
                                            dp.developersList
                                                .map((e) =>
                                                    MapEntry(e.id!, e.name!))
                                                .toList(),
                                            val);
                                        setState(() {
                                          developersList = list
                                              .map((e) => DeveloperModel(
                                                    id: e.key,
                                                    name: e.value,
                                                  ))
                                              .toList();
                                        });
                                      } else {
                                        setState(() {
                                          developersList = dp.developersList;
                                          dp.queryDevelopers.text = '';
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    tileColor: themeColor.withOpacity(0.1),
                                    onTap: () {
                                      setState(() {
                                        dp.selectedDeveloper = null;
                                        dp.queryDevelopers.text = 'All';
                                      });
                                    },
                                    leading: const Text(''),
                                    title: const Text('All'),
                                  ),
                                  const Divider(),
                                  Expanded(
                                    child: ListView(
                                      children: [
                                        ...developersList.map(
                                          (e) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: RadioListTile<int>(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              tileColor:
                                                  themeColor.withOpacity(0.1),
                                              value: e.id!,
                                              groupValue: dp.selectedDeveloper,
                                              onChanged: (val) {
                                                setState(() {
                                                  dp.selectedDeveloper = val;
                                                  dp.queryDevelopers.text =
                                                      e.name!;
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
                                              controller: dp.queryProperty,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5))),
                                              onChanged: (val) {
                                                if (val.isNotEmpty) {
                                                  var list = filterSearchResult(
                                                      dp.propertyList
                                                          .map((e) => MapEntry(
                                                              e.id!, e.name!))
                                                          .toList(),
                                                      val);
                                                  setState(() {
                                                    propertyList = list
                                                        .map((e) =>
                                                            PropertyModel(
                                                              id: e.key,
                                                              name: e.value,
                                                            ))
                                                        .toList();
                                                  });
                                                } else {
                                                  setState(() {
                                                    propertyList =
                                                        dp.propertyList;
                                                    dp.queryProperty.text = '';
                                                  });
                                                }
                                              },
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: themeColor
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: ListTile(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                tileColor:
                                                    themeColor.withOpacity(0.1),
                                                onTap: () {
                                                  setState(() {
                                                    dp.selectedProperty = null;
                                                    dp.queryProperty.text =
                                                        'All';
                                                  });
                                                },
                                                leading: const Text(''),
                                                title: const Text('All'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          // color: Colors.white,
                                          child: ListView(
                                            children: [
                                              const Divider(),
                                              ...propertyList.map(
                                                (e) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: RadioListTile<int>(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                    tileColor: themeColor
                                                        .withOpacity(0.1),
                                                    value: e.id!,
                                                    groupValue:
                                                        dp.selectedProperty,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        // if (dp.selectedAgent==e) {
                                                        dp.selectedProperty =
                                                            val!;
                                                        dp.queryProperty.text =
                                                            e.name!;
                                                      });
                                                    },
                                                    title: Text(e.name!),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : selectedIndex == 4
                                    ? Column(
                                        children: [
                                          Container(
                                            color: Colors.white,
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  controller: dp.queryStatus,
                                                  decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5))),
                                                  onChanged: (val) {
                                                    if (val.isNotEmpty) {
                                                      var list =
                                                          filterSearchResult(
                                                              dp
                                                                  .statusList
                                                                  .map((e) =>
                                                                      MapEntry(
                                                                          e.id!,
                                                                          e.name!))
                                                                  .toList(),
                                                              val);
                                                      setState(() {
                                                        statusList = list
                                                            .map((e) =>
                                                                StatusModel(
                                                                  id: e.key,
                                                                  name: e.value,
                                                                ))
                                                            .toList();
                                                      });
                                                    } else {
                                                      setState(() {
                                                        statusList =
                                                            dp.statusList;
                                                        dp.queryStatus.text =
                                                            '';
                                                      });
                                                    }
                                                  },
                                                ),
                                                const SizedBox(height: 10),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: themeColor
                                                        .withOpacity(0.1),
                                                  ),
                                                  child: CheckboxListTile(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                    tileColor: themeColor
                                                        .withOpacity(0.1),
                                                    value: dp.multiSelectedStatus
                                                                .length ==
                                                            dp.statusList
                                                                .length ||
                                                        dp.multiSelectedStatus
                                                            .isEmpty,
                                                    onChanged: (bool? val) {
                                                      setState(() {
                                                        if (val!) {
                                                          dp.multiSelectedStatus
                                                              .clear();
                                                          dp.multiSelectedStatus
                                                              .addAll(dp
                                                                  .statusList);
                                                        } else {
                                                          dp.multiSelectedStatus =
                                                              [];
                                                        }
                                                        if (dp.multiSelectedStatus
                                                                    .length ==
                                                                dp.statusList
                                                                    .length ||
                                                            dp.multiSelectedStatus
                                                                .isEmpty) {
                                                          dp.queryStatus.text =
                                                              'All';
                                                        } else {
                                                          dp.queryStatus.text =
                                                              '';
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8.0),
                                                    child: CheckboxListTile(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                      tileColor: themeColor
                                                          .withOpacity(0.1),
                                                      value: dp
                                                          .multiSelectedStatus
                                                          .contains(e),
                                                      onChanged: (val) {
                                                        setState(() {
                                                          if (val!) {
                                                            dp.multiSelectedStatus
                                                                .add(e);
                                                          } else {
                                                            dp.multiSelectedStatus
                                                                .remove(e);
                                                          }
                                                          if (dp.multiSelectedStatus
                                                                      .length ==
                                                                  dp.statusList
                                                                      .length ||
                                                              dp.multiSelectedStatus
                                                                  .isEmpty) {
                                                            dp.queryStatus
                                                                .text = 'All';
                                                          } else {
                                                            dp.queryStatus
                                                                .text = '';
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
                                    : selectedIndex == 5
                                        ? Column(
                                            children: [
                                              Container(
                                                color: Colors.white,
                                                child: Column(
                                                  children: [
                                                    TextFormField(
                                                      controller:
                                                          dp.querySources,
                                                      decoration: InputDecoration(
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5))),
                                                      onChanged: (val) {
                                                        if (val.isNotEmpty) {
                                                          var list = filterSearchResult(
                                                              dp.sourcesList
                                                                  .map((e) =>
                                                                      MapEntry(
                                                                          e.id!,
                                                                          e.name!))
                                                                  .toList(),
                                                              val);
                                                          setState(() {
                                                            sourcesList = list
                                                                .map((e) =>
                                                                    SourceModel(
                                                                      id: e.key,
                                                                      name: e
                                                                          .value,
                                                                    ))
                                                                .toList();
                                                          });
                                                        } else {
                                                          setState(() {
                                                            sourcesList =
                                                                dp.sourcesList;
                                                            dp.querySources
                                                                .text = '';
                                                          });
                                                        }
                                                      },
                                                    ),
                                                    const SizedBox(height: 10),
                                                    CheckboxListTile(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                      tileColor: themeColor
                                                          .withOpacity(0.1),
                                                      value: dp.multiSelectedSources
                                                                  .length ==
                                                              dp.sourcesList
                                                                  .length ||
                                                          dp.multiSelectedSources
                                                              .isEmpty,
                                                      onChanged: (bool? val) {
                                                        setState(() {
                                                          if (val!) {
                                                            dp.multiSelectedSources
                                                                .clear();
                                                            dp.multiSelectedSources
                                                                .addAll(dp
                                                                    .sourcesList);
                                                          } else {
                                                            dp.multiSelectedSources =
                                                                [];
                                                          }
                                                          if (dp.multiSelectedSources
                                                                      .length ==
                                                                  dp.sourcesList
                                                                      .length ||
                                                              dp.multiSelectedSources
                                                                  .isEmpty) {
                                                            dp.querySources
                                                                .text = 'All';
                                                          } else {
                                                            dp.querySources
                                                                .text = '';
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
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 8.0),
                                                        child: CheckboxListTile(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          tileColor: themeColor
                                                              .withOpacity(0.1),
                                                          value: dp
                                                              .multiSelectedSources
                                                              .contains(e),
                                                          // groupValue: true,
                                                          onChanged: (val) {
                                                            setState(() {
                                                              if (val!) {
                                                                dp.multiSelectedSources
                                                                    .add(e);
                                                              } else {
                                                                dp.multiSelectedSources
                                                                    .remove(e);
                                                              }
                                                              if (dp.multiSelectedSources
                                                                          .length ==
                                                                      dp.sourcesList
                                                                          .length ||
                                                                  dp.multiSelectedSources
                                                                      .isEmpty) {
                                                                dp.querySources
                                                                        .text =
                                                                    'All';
                                                              } else {
                                                                dp.querySources
                                                                    .text = '';
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
                                        : selectedIndex == 6
                                            ? Column(
                                                children: [
                                                  TextFormField(
                                                    controller:
                                                        dp.queryPriority,
                                                    decoration: InputDecoration(
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5))),
                                                    onChanged: (val) {
                                                      if (val.isNotEmpty) {
                                                        var list = filterSearchResult(
                                                            dp.priorityList
                                                                .map((e) => MapEntry(
                                                                    dp.priorityList
                                                                        .indexOf(
                                                                            e),
                                                                    e))
                                                                .toList(),
                                                            val);
                                                        setState(() {
                                                          priorityList = list
                                                              .map((e) =>
                                                                  e.value)
                                                              .toList();
                                                        });
                                                      } else {
                                                        setState(() {
                                                          priorityList =
                                                              dp.priorityList;
                                                          dp.querySources.text =
                                                              '';
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  const SizedBox(height: 10),
                                                  const Divider(),
                                                  ...priorityList.map(
                                                    (e) => Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8.0),
                                                      child:
                                                          RadioListTile<String>(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                        tileColor: themeColor
                                                            .withOpacity(0.1),
                                                        value: e,
                                                        groupValue:
                                                            dp.selectedPriority,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            dp.selectedPriority =
                                                                val!;
                                                            dp.queryPriority
                                                                .text = e;
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
                                                    controller: dp.query,
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            'Search By Words',
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5))),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        //  dp.query.text=val;
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
                        dp.isFilterApplied(false);
                        Get.back();
                        await dp.applyFilter(dp);
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
                        await dp.applyFilter(dp);
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

  ListView filterLeftSection(DumpLeadsProvider dp) {
    return ListView(
      children: [
        ...dp.categoriesList.map(
          (e) => Column(
            children: [
              Stack(
                children: [
                  ListTile(
                    tileColor: selectedIndex == dp.categoriesList.indexOf(e)
                        ? themeColor.withOpacity(0.1)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedIndex = dp.categoriesList.indexOf(e);
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
                                        dp.categoriesList.indexOf(e)
                                    ? Get.theme.primaryColor
                                    : null),
                          ),
                        ],
                      ),
                    ),
                    trailing: Text(
                      e == dp.categoriesList[0] && dp.selectedAgent != null
                          ? 1.toString()
                          : e == dp.categoriesList[1] &&
                                  (dp.fromDate != null || dp.toDate != null)
                              ? '🔘'
                              : e == dp.categoriesList[2] &&
                                      dp.selectedDeveloper != null
                                  ? 1.toString()
                                  : e == dp.categoriesList[3] &&
                                          dp.selectedProperty != null
                                      ? 1.toString()
                                      : e == dp.categoriesList[4] &&
                                              dp.multiSelectedStatus.isNotEmpty
                                          ? dp.multiSelectedStatus.length
                                              .toString()
                                          : e == dp.categoriesList[5] &&
                                                  dp.multiSelectedSources
                                                      .isNotEmpty
                                              ? dp.multiSelectedSources.length
                                                  .toString()
                                              : e == dp.categoriesList[6] &&
                                                      dp.selectedPriority !=
                                                          null
                                                  ? 1.toString()
                                                  : e == dp.categoriesList[7] &&
                                                          dp.query.text
                                                              .isNotEmpty
                                                      ? '💤'
                                                      : '',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        color: selectedIndex == dp.categoriesList.indexOf(e)
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
