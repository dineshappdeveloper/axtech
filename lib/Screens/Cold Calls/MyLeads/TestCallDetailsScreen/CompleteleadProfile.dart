import 'dart:developer';
import 'dart:io';
import 'dart:convert';

import 'package:crm_application/ApiManager/Apis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Models/LeadInfoModel.dart';
import '../../../../Models/SourceListModel.dart';
import '../../../../Models/StatusListModel.dart';
import '../../../../Provider/LeadsProvider.dart';
import '../../../../Utils/Colors.dart';
import '../../../../Utils/Constant.dart';

class CompleteLeadProfile extends StatefulWidget {
  var leadId, agentId, leadName;

  CompleteLeadProfile(
      {Key? key,
      required this.leadId,
      required this.agentId,
      required this.leadName})
      : super(key: key);

  @override
  State<CompleteLeadProfile> createState() => _CompleteLeadProfileState();
}

class _CompleteLeadProfileState extends State<CompleteLeadProfile> {
  //var TAG ='CompleteleadProfile';
  late TextEditingController nameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController commentController = TextEditingController();
  late TextEditingController phoneController = TextEditingController();

  //var name,email,phone,source,status;
  var TAG = 'Completeleadprofile';
  late SharedPreferences pref;
  var authToken,
      leadId = '',
      agentId,
      leadName = '',
      leadSource = '',
      assigndUser = '',
      leadEmail = '',
      leadContact = '';
  var sourceId, statusId;
  bool _isLoading = false;
  List<LeadInfo> _leadInfoList = [];
  List<SourceList> _sourceList = [];
  List<ReasonStatus> _statusList = [];
  var sourceName = '';
  var statusName = '';
  var length = 0;
  bool updating = false;
  void getPrefs() async {
    pref = await SharedPreferences.getInstance();
    authToken = pref.getString('token');
    agentId = widget.agentId;
    debugPrint("authToken: " + authToken);
    debugPrint("LeadId: " + widget.leadId);
    getLeadInfo();
    getSourceList();
    getStatusList();
    //Provider.of<LeadsProvider>(context, listen: false).getLeadInfo(authToken);
  }

  void initState() {
    super.initState();
    getPrefs();
  }

  void getLeadInfo() async {
    _leadInfoList.clear();
    //var url = ApiManager.BASE_URL + '${ApiManager.Leadinformation}+/${widget.leadId}';
    var url = '${ApiManager.BASE_URL}getLead/${widget.leadId}';
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $authToken',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      var responseData = json.decode(response.body);
      debugPrint('LeadInfo : ${responseData.toString()}');
      if (response.statusCode == 200) {
        var success = responseData['success'];
        var leadInfoList = responseData['data'];
        if (success == 200) {
          leadInfoList.forEach((v) {
            _leadInfoList.add(LeadInfo.fromJson(v));
          });
          setState(() {
            _isLoading = true;
            leadId = _leadInfoList[0].lead!.id.toString();
            leadName = _leadInfoList[0].lead!.name.toString();
            leadEmail = _leadInfoList[0].lead!.email.toString();
            leadContact = _leadInfoList[0].lead!.phone.toString();
            leadSource = _leadInfoList[0].lead!.sources!.name.toString();
            sourceName = _leadInfoList[0].lead!.sources!.name.toString();
            statusName = _leadInfoList[0].lead!.statuses!.name.toString();
            sourceId = _leadInfoList[0].lead!.sources!.id.toString();
            statusId = _leadInfoList[0].lead!.statuses!.id.toString();
            assigndUser =
                '${_leadInfoList[0].lead!.agents![0].firstName.toString()} ${_leadInfoList[0].lead!.agents![0].lastName.toString()}';
            length = _leadInfoList[0].lead!.newComments.length;
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

  void getSourceList() async {
    _sourceList.clear();
    var url = ApiManager.BASE_URL + ApiManager.leadSource;
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
        var sourceList = responseData['data'];
        if (success == 200) {
          _isLoading = true;
          sourceList.forEach((v) {
            _sourceList.add(SourceList.fromJson(v));
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

  void getStatusList() async {
    _sourceList.clear();
    var url = ApiManager.BASE_URL + ApiManager.leadStatus;
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
        var statusList = responseData['data'];
        if (success == 200) {
          _isLoading = true;
          statusList.forEach((v) {
            _statusList.add(ReasonStatus.fromJson(v));
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

  void _modalBottomSheetMenu(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          'Choose Source',
        ),
        actions: <Widget>[createListView(context, _sourceList)],
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

  Widget createListView(BuildContext context, List<SourceList> values) {
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
                onPressed: () => {
                  setState(
                    () {
                      sourceName = values[index].name.toString();
                      sourceId = values[index].id;
                    },
                  ),
                  Navigator.pop(context)
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _modalBottomSheetMenu1(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          'Choose Status',
        ),
        actions: <Widget>[createListView1(context, _statusList)],
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

  Widget createListView1(BuildContext context, List<ReasonStatus> values) {
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
                onPressed: () => {
                  setState(
                    () {
                      statusName = values[index].name.toString();
                      statusId = values[index].id;
                    },
                  ),
                  Navigator.pop(context)
                },
              ),
            ],
          );
        },
      ),
    );
  }

  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  void UpdateLeadInfo(
      var name, var email, var contact, var source, var status) async {
    var url = ApiManager.BASE_URL + '${ApiManager.Leadupdate}/${widget.leadId}';
    debugPrint("$TAG UpdateInfoUrl : $url");
    _isLoading = true;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $authToken',
      // 'Accept': 'application/json',
    };
    Map<String, dynamic> body = {
      "name": name,
      "email": email,
      "phone": contact,
      "date": dateFormat.format(DateTime.now()), //"2020-10-12",
      "source": source,
      "status": status,
      "type": "Active",
    };
    try {
      final response =
          await http.post(Uri.parse(url), body: body, headers: headers);
      var responseData = json.decode(response.body);
      debugPrint("$TAG UpdateLeadParameters : $body");
      log('$TAG UpdateLeadResponse : $responseData');
      if (response.statusCode == 200) {
        var message = responseData['message'];
        if (responseData['success'] == true) {
          setState(
            () {
              _isLoading = false;
            },
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CompleteLeadProfile(
                leadId: widget.leadId,
                leadName: widget.leadName,
                agentId: widget.agentId,
              ),
            ),
          );
        }
      } else {
        setState(
          () {
            _isLoading = false;
          },
        );
        throw const HttpException('Auth Failed');
      }
    } catch (error) {
      setState(
        () {
          _isLoading = false;
        },
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: themeColor,
        title: const Text(
          "Complete lead Profile ",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer<LeadsProvider>(
        builder: (context, leadsProvider, child) => SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Lead ID : $leadId",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  leadName,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Source By : $leadSource",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: const [
                    Text(
                      "Assign To",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(assigndUser),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                thickness: 1,
                color: Colors.grey,
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Name',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: nameController,
                      readOnly: true,
                      decoration: InputDecoration(
                        fillColor: Colors.grey[150],
                        filled: true,
                        prefixIcon: const Icon(Icons.man_rounded),
                        hintText: leadName,
                        labelStyle: const TextStyle(fontSize: 20),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.grey,
                      //indent: 10,endIndent: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: const [
                        Text(
                          'Email Id',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blueGrey.withOpacity(0.07),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          const Icon(Icons.email_rounded, color: Colors.grey),
                          const SizedBox(width: 15),
                          if (myId != agentId)
                            Text(leadEmail != ''
                                ? maskString(leadEmail, true)
                                : 'N/A'),
                          if (myId == agentId)
                            Text(leadEmail != '' ? leadEmail : 'N/A'),
                        ],
                      ),
                    ),
                    // TextFormField(
                    //   controller: emailController,
                    //   readOnly: true,
                    //   decoration: InputDecoration(
                    //     fillColor: Colors.grey[150],
                    //     filled: true,
                    //     hintText: leadEmail,
                    //     prefixIcon: const Icon(Icons.email),
                    //     border: const OutlineInputBorder(),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.grey,
                      //indent: 10,endIndent: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: const [
                        Text(
                          'Phone',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blueGrey.withOpacity(0.07),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          const Icon(Icons.phone, color: Colors.grey),
                          const SizedBox(width: 15),
                          if (myId != agentId)
                            Text(leadContact != 'No Alternate Number'
                                ? maskString(leadContact, false)
                                : 'No Alternate Number'),
                          if (myId == agentId)
                            Text(leadContact != 'No Alternate Number'
                                ? leadContact
                                : 'No Alternate Number'),
                        ],
                      ),
                    ),
                    // TextFormField(
                    //   controller: phoneController,
                    //   readOnly: true,
                    //   keyboardType: TextInputType.phone,
                    //   decoration: InputDecoration(
                    //     fillColor: Colors.grey[150],
                    //     filled: true,
                    //     //labelText: leadContact,
                    //     hintText: leadContact,
                    //     prefixIcon: const Icon(Icons.phone),
                    //     border: const OutlineInputBorder(),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: const [
                        Text(
                          'Source',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      readOnly: true,
                      onTap: () {
                        //_modalBottomSheetMenu(context);
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.grey[150],
                        filled: true,
                        hintText: sourceName,
                        border: const OutlineInputBorder(),
                        // prefixIcon: Icon(Icons.edit),
                        // border: Outlined,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: const [
                        Text(
                          'Status',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      readOnly: true,
                      onTap: () {
                        _modalBottomSheetMenu1(context);
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.grey[150],
                        filled: true,
                        hintText: statusName,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: const [
                        Text(
                          'Comment',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: commentController,
                      readOnly: false,
                      maxLines: 3,
                      decoration: InputDecoration(
                        fillColor: Colors.grey[150],
                        filled: true,
                        hintText: 'Write some comment',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (commentController.text.isEmpty && updating)
                      Column(
                        children: [
                          Row(
                            children: const [
                              Text(
                                '*Comment field is required',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),


                    /* const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Notes',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: InkWell(
                            onTap: () {
                              //UpdateLeadInfo();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddLeadNoteScreen(
                                    leadId: widget.leadId,
                                    leadName: leadName,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "Add Note",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 100.h,
                      child: ListView.builder(
                        itemCount: length,
                        itemBuilder: (BuildContext context, int index) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            _leadInfoList[0]
                                .lead!
                                .newComments[index]
                                .newComments
                                .toString(),
                          ),
                        ),
                      ),
                    ),*/
                    SizedBox(
                      height: 20.h,
                    ),
                    !leadsProvider.IsLoading
                        ? InkWell(
                            onTap: () {
                              setState(
                                () {
                                  if (commentController.text.isEmpty) {
                                    setState(() {
                                      updating = true;
                                    });
                                    Fluttertoast.showToast(
                                        msg: 'Comment field is required.');
                                  } else {
                                    leadsProvider.updateLeadInfo(
                                      nameController.text.isEmpty
                                          ? leadName
                                          : nameController.text,
                                      emailController.text.isEmpty
                                          ? leadEmail
                                          : emailController.text,
                                      phoneController.text.isEmpty
                                          ? leadContact
                                          : phoneController.text,
                                      sourceId.toString(),
                                      statusId.toString(),
                                      authToken,
                                      leadId,
                                      leadName,
                                      commentController.text,
                                      dateFormat
                                          .format(_leadInfoList[0].lead!.date),
                                      agentId,
                                      context,
                                    );
                                    setState(() {
                                      updating = true;
                                    });
                                  }
                                },
                              );
                            },
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  "UPDATE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                    /*leadsProvider.IsLoading
                        ? InkWell(
                            onTap: () {
                              setState(
                                () {
                                  leadsProvider.UpdateLeadInfo(
                                    nameController.text.isEmpty
                                        ? leadName
                                        : nameController.text,
                                    emailController.text.isEmpty
                                        ? leadEmail
                                        : emailController.text,
                                    phoneController.text.isEmpty
                                        ? leadContact
                                        : phoneController.text,
                                    sourceId.toString(),
                                    statusId.toString(),
                                    authToken,
                                    leadId,
                                    leadName,
                                    dateFormat
                                        .format(_leadInfoList[0].lead!.date),
                                    context,
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: 50.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  "UPDATE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),*/
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
