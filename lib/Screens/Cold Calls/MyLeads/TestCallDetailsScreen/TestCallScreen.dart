import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crm_application/Screens/Cold%20Calls/MyLeads/TestCallDetailsScreen/AddLeadActivityScreen.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/TestCallDetailsScreen/AddLeadNoteScreen.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/TestCallDetailsScreen/CompleteleadProfile.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/TestCallDetailsScreen/LeadDetailsScreen.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/TestCallDetailsScreen/LeadNotesScreen.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/TestCallDetailsScreen/ScheduleACallBack.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/TestCallDetailsScreen/ScheduledCall.dart';
import 'package:crm_application/Utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../../../ApiManager/Apis.dart';
import '../../../../Models/LeadInfoModel.dart';
import '../../../../Utils/Colors.dart';

class TestCallScreen extends StatefulWidget {
  /* String leadId,
      leadName,
      Name,
      leadDate,
      leadContact,
      leadAltContact,
      leadEmail,
      avg_amount,
      authToken;
  List<NewComment> notes;*/
  String leadId;
  String leadType;

  TestCallScreen({
    Key? key,
    required this.leadId,
    required this.leadType,
    /*required this.leadId,
    required this.leadName,
    required this.Name,
    required this.leadDate,
    required this.leadContact,
    required this.leadAltContact,
    required this.leadEmail,
    required this.notes,
    required this.avg_amount,
    required this.authToken,*/
  }) : super(key: key);

  @override
  State<TestCallScreen> createState() => _TestCallScreenState();
}

class _TestCallScreenState extends State<TestCallScreen> {
  var whatsapp, message;
  String TAG = 'TestCallScreen';
  List<LeadInfo> _leadInfoList = [];
  late SharedPreferences pref;
  bool _isLoading = true;
  var authToken,
      leadId = '',
      agentId = 0,
      leadName = '',
      Name = '',
      leadDate = '',
      leadContact = '',
      leadAltContact = '',
      leadEmail = '',
      leadComment = '',
      leadPropertyPreference = '',
      avg_amount = '',
      leadSource = '',
      sourceName = '',
      statusName = '',
      sourceId = '',
      statusId = '',
      additionalPhone = '',
      assigndUser1 = '',
      assigndUser = '';
  List<NewComment> notes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //leadAltContact = widget.leadAltContact;
    debugPrint('$TAG LeadID: ${widget.leadId}');
    getPrefs();
  }

  void getPrefs() async {
    pref = await SharedPreferences.getInstance();
    authToken = pref.getString('token');
    debugPrint("authToken: " + authToken);
    debugPrint("LeadId: " + widget.leadId);
    debugPrint("myId: " + myId.toString());
    getLeadInfo();
  }

  void getLeadInfo() async {
    _leadInfoList.clear();
    var url = '${ApiManager.BASE_URL}${ApiManager.getLead}/${widget.leadId}';
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $authToken',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      var responseData = json.decode(response.body);
      log('LeadInfo : ${responseData.toString()}');
      if (response.statusCode == 200) {
        var success = responseData['success'];
        var leadInfoList = responseData['data'];
        if (success == 200) {
          _isLoading = false;
          leadInfoList.forEach((v) {
            _leadInfoList.add(LeadInfo.fromJson(v));
          });
          setState(() {
            leadId = _leadInfoList[0].lead!.id.toString();
            agentId = _leadInfoList[0].userId;
            leadName = _leadInfoList[0].lead!.name.toString();
            leadEmail = _leadInfoList[0].lead!.email.toString();
            leadComment = _leadInfoList[0].lead!.comment ?? '';
            leadContact = _leadInfoList[0].lead!.phone.toString();
            leadAltContact = _leadInfoList[0].lead!.altPhone.toString();
            leadDate = _leadInfoList[0].lead!.date.toString();
            avg_amount = _leadInfoList[0].lead!.avgIncome.toString();
            // print('propertyPreference         ---------> ${_leadInfoList[0].lead!.propertyPreference}');
            leadPropertyPreference =
                _leadInfoList[0].lead!.propertyPreference ?? '';
            notes = _leadInfoList[0].lead!.newComments;
            leadSource = _leadInfoList[0].lead!.sources!.name.toString();
            sourceName = _leadInfoList[0].lead!.sources!.name.toString();
            statusName = _leadInfoList[0].lead!.statuses != null
                ? _leadInfoList[0].lead!.statuses!.name!
                : '';
            sourceId = _leadInfoList[0].lead!.sources!.id.toString();
            statusId = _leadInfoList[0].lead!.statuses != null
                ? _leadInfoList[0].lead!.statuses!.id.toString()
                : '';
                 additionalPhone = _leadInfoList[0].lead!.additionalPhone.toString();

            /* if(_leadInfoList[0].lead!.agents.length>1){
              setState(() {
                assigndUser1 =
                '${_leadInfoList[0].lead!.agents[1].firstName.toString()} ${_leadInfoList[0].lead!.agents[1].lastName.toString()}';
              },);

            }else{
              assigndUser =
              '${_leadInfoList[0].lead!.agents[0].firstName.toString()} ${_leadInfoList[0].lead!.agents[0].lastName.toString()}';
            }*/
            if (_leadInfoList[0].lead!.agents != null &&
                _leadInfoList[0].lead!.agents!.isNotEmpty) {
              assigndUser =
                  '${_leadInfoList[0].lead!.agents![0].firstName.toString()} ${_leadInfoList[0].lead!.agents![0].lastName.toString()}';
            }
          });
        }
      } else {
        _isLoading = false;
        throw const HttpException('Failed To get Leads');
      }
    } catch (error) {
      rethrow;
    }
  }

  void SendTestimonialMail() async {
    var url = 'http://axtech.range.ae/api/v1/askTestimonial/${widget.leadId}';
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $authToken',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      var responseData = json.decode(response.body);
      debugPrint("Response :${responseData.toString()}");
      if (response.statusCode == 200) {
        var success = responseData['success'];
        /* if (success == true) {
          Navigator.pop(context);
          debugPrint("$TAG Success : ${response.body}");
        }*/
        Navigator.pop(context);
        debugPrint("$TAG Success : ${response.body}");
      } else {
        Navigator.pop(context);
        throw const HttpException('Failed To Add note');
      }
    } catch (error) {
      rethrow;
    }
  }

  void SendReferalMail() async {
    var url = 'http://axtech.range.ae/api/v1/askReferal/${widget.leadId}';
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $authToken',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      var responseData = json.decode(response.body);
      debugPrint(responseData.toString());
      if (response.statusCode == 200) {
        var success = responseData['success'];
        message = responseData['message'];
        if (success == 200) {
          Navigator.pop(context);
          debugPrint("$TAG Success : ${response.body}");
        } else if (success == 401) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        }
        Navigator.pop(context);
        debugPrint("$TAG Success : ${response.body}");
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        throw const HttpException('Failed To Add note');
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 1,
        titleSpacing: 0,
        title: Text(leadName),
        actions: [],
      ),
      body: !_isLoading
          ? SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lead ID : $leadId',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    leadName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Source : $sourceName',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Lead Date : " +
                                  DateFormat('yyyy-MM-dd').format(
                                      DateTime.parse(
                                          leadDate)), //'2022-04-20 16:20:32',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Divider(
                    color: themeColor,
                    thickness: 1,
                  ),
                  // if(widget.leadType=='lead')
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                // openWhatsapp('971581546367');
                                // openWhatsapp('971927632972');
                                if (agentId == myId) {
                                  openWhatsapp(leadContact);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'You don\'t have permission. ');
                                }
                              },
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.whatsapp_outlined,
                                    size: 40,
                                    color: Colors.greenAccent,
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  const Text('Whatsapp'),
                                ],
                              ),
                            ),
                            Container(
                              height: 65.h,
                              width: 1,
                              color: Colors.black,
                            ),
                            InkWell(
                              onTap: () {
                                /*Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddLeadNoteScreen(
                                      leadId: widget.leadId,
                                      leadName: widget.leadName,
                                    ),
                                  ),
                                );*/
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CompleteLeadProfile(
                                        leadId: widget.leadId,
                                        leadName: leadName,
                                        agentId: agentId,
                                      ),
                                    ));
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/addNote.png',
                                    height: 40,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  const Text('Change Status'),
                                ],
                              ),
                            ),
                            Container(
                              height: 65.h,
                              width: 1,
                              color: Colors.black,
                            ),
                            InkWell(
                              onTap: () {
                                if (agentId == myId) {
                                  // _textMe();
                                  mailMe(leadEmail);

                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'You don\'t have permission. ');
                                }
                              },
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.email_outlined,
                                    size: 40,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  const Text('Messages'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: themeColor,
                        thickness: 1,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  /* Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddLeadNoteScreen(
                            leadId: widget.leadId,
                            leadName: widget.leadName,
                          ),
                        ),
                      );
                      //showTestimonyDialog();
                    },
                    child: Container(
                      height: 100,
                      width: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.green,
                      ),
                      child: Column(
                        children: const [
                          SizedBox(
                            height: 15,
                          ),
                          Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            'Add Comments',//"Ask Testimonial",
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CompleteleadProfile(leadId: widget.leadId,leadName: widget.leadName),));
                    },
                    child: Container(
                      height: 100,
                      width: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: themeColor,
                      ),
                      child: Column(
                        children: const [
                          SizedBox(
                            height: 15,
                          ),
                          Icon(
                            Icons.note_add,
                            size: 40,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            "Complete Profile",
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showReferalDialog();
                    },
                    child: Container(
                      height: 100,
                      width: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.blue,
                      ),
                      child: Column(
                        children: const [
                          SizedBox(
                            height: 15,
                          ),
                          Icon(
                            Icons.star,
                            size: 40,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            'Change Status',//"Ask Referal",
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),*/
                  const SizedBox(
                    height: 10,
                  ),
                  DefaultTabController(
                    length: 3, // length of tabs
                    initialIndex: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TabBar(
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                5.0,
                              ),
                              color: themeColor,
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: themeColor,
                            tabs: const [
                              Tab(text: 'Details'),
                              Tab(text: 'Notes'),
                              Tab(text: 'Schedules'),

                              //Tab(text: 'History'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          child: Container(
                            height: 400.h, //height of TabBarView
                            decoration: const BoxDecoration(),
                            child: TabBarView(
                              children: <Widget>[
                                LeadDetailsScreen(
                                  leadName: leadName,
                                  leadId: widget.leadId,
                                  agentId: agentId,
                                  leadAltContact: leadAltContact == ''
                                      ? 'No Alternate Number'
                                      : leadAltContact,
                                  leadContact: leadContact,
                                  leadDate: leadDate,
                                  name: sourceName,
                                  leadEmail: leadEmail,
                                  leadComment: leadComment,
                                  leadPropertyPreference:
                                      leadPropertyPreference,
                                  avgAmount: avg_amount,
                                  assignUser: assigndUser,
                                  assignedUsers: assigndUser1,
                                  agents: _leadInfoList[0].lead!.agents!,
                                  additionalPhone: additionalPhone,
                                ),
                                LeadNotesScreen(
                                  notes: notes, leadType: widget.leadType,
                                  addCommentWidget: AddLeadNoteScreen(
                                      leadId: leadId, leadName: leadName),
                                ),
                                ScheduledCall(
                                    authToken: authToken, leadId: leadId, leadType: widget.leadType),

                                // const AddLeadActivityScreen(),
                                //LeadHistoryScreen(leadId: widget.leadId),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void showTestimonyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ask Testimonials'),
        content: const Text('Do you want to Email the Lead for Testimonials'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                SendTestimonialMail();
              },
              child: const Text('Send Email')),
        ],
      ),
    );
  }

  void showReferalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ask Testimonials'),
        content: const Text('Do you want to Ask for Referal'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                SendReferalMail();
              },
              child: const Text('Send Email')),
        ],
      ),
    );
  }

  void openWhatsapp(String number) async {
    whatsapp = '+$number';
    print(whatsapp);

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
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("whatsapp no installed")));
      }
    }
  }

  _textMe() async {
    // Android
    var uri = "sms:$leadContact?body=hello%20there";
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      var uri = 'sms:$leadContact?body=hello%20there';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }
  mailMe(var email) async {
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

}
