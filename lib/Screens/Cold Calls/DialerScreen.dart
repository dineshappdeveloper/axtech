import 'package:crm_application/Provider/UserProvider.dart';
import 'package:crm_application/Screens/Cold%20Calls/ColdCallScreen.dart';
import 'package:crm_application/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialpad/flutter_dialpad.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Models/DialModel.dart';
import '../../Models/LeadInfoModel.dart';
import '../../Provider/DialProvider.dart';
import '../../Utils/database_helper.dart';

class DialerScreen extends StatefulWidget {
  const DialerScreen({Key? key}) : super(key: key);

  @override
  State<DialerScreen> createState() => _DialerScreenState();
}

class _DialerScreenState extends State<DialerScreen> {
  @override
  void initState() {
    super.initState();
    var dp = Provider.of<DialProvider>(context, listen: false);
    if (dp.timer != null) {
      dp.timer!.cancel();
    }
    dp.fetchDialedCalls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        backgroundColor: themeColor.withOpacity(0.1),
        title: const Text('Dialer'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 15.0, bottom: 20),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ColdCallScreen(),
              ),
            );
          },
          child: Image.asset(
            'assets/images/call_icon.png',
            height: 45.h,
            width: 35.w,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      backgroundColor: themeColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: DialPad(
                  buttonColor: Colors.white,
                  enableDtmf: true,
                  outputMask: "0000000000",
                  dialButtonColor: themeColor,
                  backspaceButtonIconColor: Colors.red,
                  dialButtonIcon: Icons.call_sharp,
                  buttonTextColor: Colors.black,
                  dialOutputTextColor: Colors.black,
                  keyPressed: (value) {
                    print('$value was pressed');
                  },
                  makeCall: (number) async {
                    if (number.isNotEmpty) {
                      try {
                        Get.back();
                        await Provider.of<DialProvider>(context, listen: false)
                            .makeDialCall(number, 'Custom');
                      } catch (e) {
                        print('dial screen error $e');
                      }
                    } else {
                      Fluttertoast.showToast(msg: 'Phone number is blank');
                    }
                    print(number.runtimeType);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DialledCallSubmitDialog extends StatefulWidget {
  const DialledCallSubmitDialog({
    Key? key,
    required this.dial, this.leadNumber,
  }) : super(key: key);
  final DialModel dial;
  final String? leadNumber;

  @override
  State<DialledCallSubmitDialog> createState() =>
      _DialledCallSubmitDialogState();
}

enum DialType { lead, customer }

class _DialledCallSubmitDialogState extends State<DialledCallSubmitDialog> {
  late DialModel dial;
  String?leadNumber;
  bool connected = false;
  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    dial = widget.dial;
    // dial.type = 'Lead';
    connected = dial.connected == 1;
    if (widget.dial.type == "Lead") {
      nameController.text = dial.name??'';
    }  if (widget.leadNumber!=null) {
      leadNumber=widget.leadNumber;
    }
    Provider.of<DialProvider>(context, listen: false).dialogOpen = true;
    print(dial.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        height: 400,
        width: Get.width * 0.8,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            opacity: dial.type == "Lead" ? 0.05 : 0.03,
            scale: 0.5,
            image: AssetImage(
              dial.type == "Lead"
                  ? 'assets/images/Leads.png'
                  : 'assets/images/keypad.png',
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Hello ${Provider.of<UserProvider>(context, listen: false).user.data!.firstName}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: RichText(
                  text: TextSpan(
                      text: 'You recently call to ',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                      children: [
                    TextSpan(
                      text:
                          dial.callId.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ])),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Please save it.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     children: [
            //       Expanded(
            //           child: TextFormField(
            //         readOnly: true,
            //         initialValue: dial.callId.toString(),
            //         decoration: InputDecoration(
            //             labelText:
            //                 dial.type == 'Lead' ? 'Lead Id' : "Phone Number"),
            //       )),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      // initialValue: dial.callId.toString(),
                      controller: nameController,
                      readOnly: dial.type == 'Lead' ? true : false,
                      decoration: InputDecoration(
                          labelText:
                              dial.type == 'Lead' ? 'Lead Name' : "Name"),
                    )),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Call connected',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Checkbox(
                    value: connected,
                    onChanged: (val) {
                      setState(() {
                        connected = val!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      dial.endTime = DateTime.now().toString();
                      dial.connected = connected ? 1 : 0;
                      dial.status = 1;


                      await Provider.of<DialProvider>(context, listen: false)
                          .makeCallAndSave(
                        dial: dial,
                        customerName: nameController.text,
                      );

                      print(dial.toJson());

                      setState(() {});
                      Get.back();
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: themeColor,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          )),
                      child: const Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> callANumber(String number) async {
  try {
  return await launch('tel:$number');

  } catch (e) {
    Fluttertoast.showToast(msg: 'Call failed $e');
    return false;
  }
}
