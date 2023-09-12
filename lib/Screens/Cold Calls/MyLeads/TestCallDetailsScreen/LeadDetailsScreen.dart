import 'package:crm_application/Utils/Constant.dart';
import 'package:crm_application/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Models/LeadInfoModel.dart';
import '../../../../Provider/LeadsProvider.dart';
import '../../../../Utils/Colors.dart';
import '../../../../Utils/ImageConst.dart';

class LeadDetailsScreen extends StatefulWidget {
  String leadId,
      leadName,
      name,
      leadDate,
      leadContact,
      leadAltContact,
      leadEmail,
      leadComment,
      leadPropertyPreference,
      avgAmount,
      assignUser,
      additionalPhone,
      assignedUsers;
    
  int agentId;
  List<Agent> agents;

  LeadDetailsScreen({
    Key? key,
    required this.leadId,
    required this.agentId,
    required this.leadName,
    required this.name,
    required this.leadDate,
    required this.leadContact,
    required this.leadAltContact,
    required this.leadEmail,
    required this.leadComment,
    required this.leadPropertyPreference,
    required this.avgAmount,
    required this.assignUser,
    required this.assignedUsers,
    required this.additionalPhone,
    required this.agents,
  }) : super(key: key);

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen>
    with SingleTickerProviderStateMixin {
  var altContact;
  late SharedPreferences pref;
  var authToken,
      leadId = '',
      agentId = 0,
      leadName = '',
      Name = '',
      leadDate = '',
      leadContact = '',
      leadAltContact = '',
      leadEmail = '',
      leadPropertyPreference = '',
      addPhone ='',
      avg_amount = '';
  bool tapDwonLeadContact = false;
  bool tapDwonAltContact = false;
  bool tapDwonLeadEmail = false;
  // late AnimationController copiAnimationController;
  // late Animation curveAnimation;

  TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    altContact = widget.leadAltContact;
    agentId = widget.agentId;
    getPrefs();
    addPhone = widget.additionalPhone;
    _phoneNumberController.text = addPhone;
    // print(widget.leadAltContact);
    // copiAnimationController =
    //     AnimationController(vsync: this, duration: const Duration(seconds: 1));
    // curveAnimation =
    //     CurvedAnimation(parent: copiAnimationController, curve: Curves.easeIn);
    // var tween = Tween(begin: 0, end: 1).animate(copiAnimationController);
    // copiAnimationController.addListener(() {});
  }

  void getPrefs() async {
    pref = await SharedPreferences.getInstance();
    authToken = pref.getString('token');
    debugPrint("authToken: " + authToken);
    debugPrint("LeadId: " + widget.leadId);
    //getLeadInfo();
  }

  /*void getLeadInfo() async {
    _leadInfoList.clear();
    //var url = ApiManager.BASE_URL + '${ApiManager.Leadinformation}+/${widget.leadId}';
    var url = 'https://axtech.range.ae/api/v1/getLead/${widget.leadId}';
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
          _isLoading = false;
          leadInfoList.forEach((v) {
            _leadInfoList.add(LeadInfo.fromJson(v));
          });
          setState(() {
            leadId = _leadInfoList[0].lead!.id.toString();
            leadName = _leadInfoList[0].lead!.name.toString();
            leadEmail = _leadInfoList[0].lead!.email.toString();
            leadContact = _leadInfoList[0].lead!.phone.toString();
            leadSource = _leadInfoList[0].lead!.sources!.name.toString();
            sourceName = _leadInfoList[0].lead!.sources!.name.toString();
            statusName = _leadInfoList[0].lead!.statuses.name.toString();
            sourceId = _leadInfoList[0].lead!.sources!.id.toString();
            statusId = _leadInfoList[0].lead!.statuses.id.toString();
            assigndUser =
                '${_leadInfoList[0].lead!.agents[0].firstName.toString()} ${_leadInfoList[0].lead!.agents[0].lastName.toString()}';
          });
        }
      } else {
        _isLoading = false;
        throw const HttpException('Failed To get Leads');
      }
    } catch (error) {
      rethrow;
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          /* ListTile(
            title: const Text(
              "Assign To",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            ),
            subtitle: Row(
              children: [
                Text(
                  widget.assignUser,
                ),
                Text(
                  widget.assigndUsers,
                ),
              ],
            ),
          ),*/
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 12.0),
                        child: Text(
                          "Assign To",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.agents.length,
                          itemBuilder: (context, index) {
                            var agent =
                                '${widget.agents[index].firstName} ${widget.agents[index].lastName},';
                            if (index == widget.agents.length - 1) {
                              agent = agent.substring(0, agent.length - 1);
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 3),
                              child: Text(agent),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () async {},
                  icon: const FaIcon(
                    FontAwesomeIcons.shareFromSquare,
                    size: 15,
                  )),
            ],
          ),
          const Divider(),
          ListTile(
            title: const Text(
              "Lead Contact",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            ),
            subtitle: Row(
              children: [
                if (myId != agentId)
                  Text(widget.leadContact != ''
                      ? maskString(widget.leadContact, false)
                      : 'N/A'),
                if (myId == agentId)
                  Text(widget.leadContact != '' ? widget.leadContact : 'N/A'),
                const SizedBox(
                  width: 20,
                ),
                if (myId == agentId)
                  AnimatedSize(
                    curve: Curves.ease,
                    duration: const Duration(milliseconds: 500),
                    vsync: this,
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          tapDwonLeadContact = true;
                        });
                        await Clipboard.setData(
                                ClipboardData(text: widget.leadContact))
                            .then((value) {
                          Future.delayed(const Duration(milliseconds: 500), () {
                            setState(() {
                              tapDwonLeadContact = false;
                            });
                          });
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                duration: Duration(milliseconds: 300),
                                // width: 300,
                                // behavior: SnackBarBehavior.fixed,
                                content:
                                    Text('Phone number copied successfully!'),
                                behavior: SnackBarBehavior.floating));
                      },
                      // onTapUp: (tapDetails) async {
                      //   // setState(() {
                      //   //   tapDwon = false;
                      //   // });
                      //   await Clipboard.setData(
                      //           ClipboardData(text: widget.leadContact))
                      //       .then((value) => ScaffoldMessenger.of(context)
                      //           .showSnackBar(const SnackBar(
                      //               content: Text(
                      //                   'Phone number copied successfully!'))));
                      // },
                      child: Icon(
                        Icons.copy,
                        size: tapDwonLeadContact ? 40 : 18,
                      ),
                      // tooltip: 'Copy Phone Number',
                    ),
                  )
              ],
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text(
              "Alternate Contact",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            ),
            subtitle: Row(
              children: [
                if (myId != agentId)
                  Text(widget.leadAltContact != 'No Alternate Number'
                      ? maskString(widget.leadAltContact, false)
                      : 'No Alternate Number'),
                if (myId == agentId)
                  Text(widget.leadAltContact != 'No Alternate Number'
                      ? widget.leadAltContact
                      : 'No Alternate Number'),
                const SizedBox(
                  width: 20,
                ),
                if (myId == agentId)
                  AnimatedSize(
                    curve: Curves.bounceInOut,
                    duration: const Duration(milliseconds: 500),
                    child: altContact != 'No Alternate Number'
                        ? GestureDetector(
                            onTap: () async {
                              print(altContact);
                              setState(() {
                                tapDwonAltContact = true;
                              });
                              await Clipboard.setData(
                                      ClipboardData(text: widget.leadContact))
                                  .then((value) {
                                Future.delayed(
                                    const Duration(milliseconds: 500), () {
                                  setState(() {
                                    tapDwonAltContact = false;
                                  });
                                });
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      duration: Duration(milliseconds: 300),
                                      width: 300,
                                      content: Text(
                                          'Alternate Phone number copied successfully!'),
                                      behavior: SnackBarBehavior.floating));
                            },
                            // onTapUp: (tapDetails) async {
                            //   // setState(() {
                            //   //   tapDwon = false;
                            //   // });
                            //   await Clipboard.setData(
                            //           ClipboardData(text: widget.leadContact))
                            //       .then((value) => ScaffoldMessenger.of(context)
                            //           .showSnackBar(const SnackBar(
                            //               content: Text(
                            //                   'Phone number copied successfully!'))));
                            // },
                            child: Icon(
                              Icons.copy,
                              size: tapDwonAltContact ? 40 : 18,
                            ),
                            // tooltip: 'Copy Phone Number',
                          )
                        : Container(),
                  )
              ],
            ),
          ),
       
                     const Divider(),
            ListTile(
              title: Row(
                children: [
                  const Text(
                    "Additional Number",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      _showUpdateDialog();
                    },
                    child: Icon(Icons.edit, size: 18, color: themeColor),
                  )
                  // addPhone != 'No Additional Phone Number'
                  //     ? InkWell(
                  //         onTap: () {
                  //           _showUpdateDialog();
                  //         },
                  //         child: Icon(Icons.edit, size: 18, color: themeColor),
                  //       )
                  //     : const SizedBox(),
                ],
              ),
              subtitle: Row(
                children: [
                  Text(addPhone),
                  const SizedBox(
                    width: 20,
                  ),
                  AnimatedSize(
                      curve: Curves.bounceInOut,
                      duration: const Duration(milliseconds: 500),
                      child: addPhone != "No Additional Phone Number"
                          ? GestureDetector(
                              onTap: () async {
                                print(addPhone);
                                setState(() {
                                  tapDwonAltContact = true;
                                });
                                await Clipboard.setData(ClipboardData(
                                        text: widget.additionalPhone))
                                    .then((value) {
                                  Future.delayed(
                                      const Duration(milliseconds: 500), () {
                                    setState(() {
                                      tapDwonAltContact = false;
                                    });
                                  });
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        duration: Duration(milliseconds: 300),
                                        width: 300,
                                        content: Text(
                                            'Alternate Phone number copied successfully!'),
                                        behavior: SnackBarBehavior.floating));
                              },
                              // onTapUp: (tapDetails) async {
                              //   // setState(() {
                              //   //   tapDwon = false;
                              //   // });
                              //   await Clipboard.setData(
                              //           ClipboardData(text: widget.leadContact))
                              //       .then((value) => ScaffoldMessenger.of(context)
                              //           .showSnackBar(const SnackBar(
                              //               content: Text(
                              //                   'Phone number copied successfully!'))));
                              // },
                              child: Icon(
                                Icons.copy,
                                size: tapDwonAltContact ? 40 : 18,
                              ),
                              // tooltip: 'Copy Phone Number',
                            )
                          : SizedBox()),
                  SizedBox(
                    width: 10,
                  ),
                  addPhone != 'No Additional Phone Number'
                      ? InkWell(
                          onTap: () {
                            openWhatsapp(addPhone, context);
                          },
                          child: Image.asset(
                            'assets/images/whatsapp.png',
                            height: 18,
                            width: 18,
                          ),
                        )
                      : const SizedBox(),
                  SizedBox(
                    width: 10,
                  ),
                  addPhone != 'No Additional Phone Number'
                      ? InkWell(
                          onTap: () {
                            FlutterPhoneDirectCaller.callNumber(addPhone);
                          },
                          child: Image.asset(
                            ImageConst.call_icon,
                            height: 18,
                            color: Colors.green,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
               const Divider(),
          ListTile(
            title: const Text(
              "Email Id",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Row(
              children: [
                myId != agentId
                    ? Text(widget.leadEmail != ''
                        ? maskString(widget.leadEmail, true)
                        : 'N/A')
                    : Text(widget.leadEmail != '' ? widget.leadEmail : 'N/A'),
                SizedBox(width: 20),
                if (myId == agentId)
                  AnimatedSize(
                    curve: Curves.bounceInOut,
                    duration: const Duration(milliseconds: 500),
                    child: widget.leadEmail != ''
                        ? GestureDetector(
                            onTap: () async {
                              setState(() {
                                tapDwonLeadEmail = true;
                              });
                              await Clipboard.setData(
                                      ClipboardData(text: widget.leadEmail))
                                  .then((value) {
                                Future.delayed(
                                    const Duration(milliseconds: 500), () {
                                  setState(() {
                                    tapDwonLeadEmail = false;
                                  });
                                });
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      duration: Duration(milliseconds: 300),
                                      width: 300,
                                      content:
                                          Text('Email copied successfully!'),
                                      behavior: SnackBarBehavior.floating));
                            },
                            child: Icon(
                              Icons.copy,
                              size: tapDwonLeadEmail ? 40 : 18,
                            ),
                            // tooltip: 'Copy Phone Number',
                          )
                        : Container(),
                  )
              ],
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text(
              "Property Preference",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(widget.leadPropertyPreference != ''
                ? widget.leadPropertyPreference
                : 'N/A'),
          ),
          const Divider(),
          ListTile(
            title: const Text(
              "Comment",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle:
                Text(widget.leadComment != '' ? widget.leadComment : 'N/A'),
          ),
        ],
      )),
    );
  }
  void _showUpdateDialog() {
    final leadProvider = Provider.of<LeadsProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Additional Phone Number'),
          content: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: themeColor, // Customize border color here
                width: 1.0, // Customize border width here
              ),
            ),
            child: TextField(
              controller: _phoneNumberController,
              inputFormatters: [LengthLimitingTextInputFormatter(10)],
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Additional Number',
                border: InputBorder.none, // Remove default border
                contentPadding: EdgeInsets.all(10.0), // Adjust padding
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: themeColor,
              ),
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: themeColor,
              ),
              child: Text('Submit'),
              onPressed: () async {
                String newPhoneNumber = _phoneNumberController.text;
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ));
                try {
                  await leadProvider
                      .updateAdditionalNumber(
                          authToken, widget.leadId, context, newPhoneNumber)
                      .then((value) {
                        _phoneNumberController.text = newPhoneNumber;
                        // _phoneNumberController.clear();
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text(
                    //         'Additional Phone number updated successfully'),
                    //   ),
                    // );
                    
                  });
                  setState(() {
                    addPhone = newPhoneNumber;
                  });
                } catch (e) {
                  print(e.toString());
                }
                navigatorKey.currentState!.pop(context);
                navigatorKey.currentState!.pop(context);
                // navigatorKey.currentState!.popUntil((route) => route.isFirst);

                // try {

                // }
                // oncatch (e) {
                //

                // }
              },
            ),
          ],
        );
      },
    );
  
}
}
