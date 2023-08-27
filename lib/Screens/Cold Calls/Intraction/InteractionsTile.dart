import 'package:crm_application/Provider/DialProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class InteractionsTile extends StatelessWidget {
  const InteractionsTile(
      {Key? key,
      required this.name,
      required this.leadId,
      required this.date,
      required this.time,
      required this.followupStatus,
      required this.phone,
      required this.planToDo,
      required this.context,
      this.color,
      required this.statusUpdateMethod})
      : super(key: key);
  final String name;
  final String leadId;
  final String date;
  final String time;
  final String followupStatus;
  final String phone;
  final String planToDo;
  final BuildContext context;
  final Color? color;
  final Future<void> Function(String data) statusUpdateMethod;


  void callNumber(String number, {String? name}) async {
    try {
      await Provider.of<DialProvider>(context, listen: false)
          .makeDialCall(number, 'Lead', name: name);
    } catch (e) {
      print('Lead screen error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        shadowColor: Colors.black,
        elevation: 3,
        // color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name : ' + name,
                    style: TextStyle(
                        color: color ?? Colors.black,
                        fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text("Lead ID : "),
                      Text(
                        leadId,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Schedule : ' + date + ' ' + time,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text("Status : "),
                      Text(
                        followupStatus,
                        style: TextStyle(
                            color: followupStatus == 'Done'
                                ? Colors.green
                                : followupStatus == 'Not Done'
                                    ? Colors.amber
                                    : Colors.red),
                      ),
                    ],
                  )
                ],
              ),
              const Spacer(),
              Expanded(
                  child: InkWell(
                onTap: () async {
                  planToDo == 'Call Back' ? callNumber(phone,name: name) : _textMe(phone);
                  // Share.share(
                  //   'check out this Lead Name ${intProvider.InteractionData[index].leads[0].name.toString()}\nLead id : ${intProvider.InteractionData[index].leadId.toString()} Date : ${intProvider.InteractionData[index].createdAt.toString()}',
                  // );
                },
                child: planToDo == 'Call Back'
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.call,
                          color: Colors.green,
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.message_outlined,
                          color: Colors.black,
                        ),
                      ),
              )),
              SizedBox(
                width: 20.w,
              ),
              InkWell(
                onTap: () {
                  // Share.share(
                  //   'check out this Lead Name ${intProvider.InteractionData[index].leads[0].name.toString()}\nLead id : ${intProvider.InteractionData[index].leadId.toString()} Date : ${intProvider.InteractionData[index].createdAt.toString()}',
                  // );
                  showCupertinoModalPopup(
                      context: context,
                      builder: (context) {
                        return CupertinoActionSheet(
                          title: const Text(
                            'Update Status',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                await statusUpdateMethod('Done')
                                    .then((value) =>
                                        print('Status Changed ---> '))
                                    .then(
                                        (value) => Navigator.of(context).pop());
                              },
                              child: const Text(
                                'Done',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await statusUpdateMethod('Not Done')
                                    .then((value) =>
                                        print('Status Changed ---> '))
                                    .then(
                                        (value) => Navigator.of(context).pop());
                              },
                              child: const Text(
                                'Not Done',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await statusUpdateMethod('Cancelled')
                                    .then((value) =>
                                        print('Status Changed ---> '))
                                    .then(
                                        (value) => Navigator.of(context).pop());
                              },
                              child: const Text(
                                'Cancelled',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ),
                          ],
                          cancelButton: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Go Back'),
                          ),
                        );
                      });
                },
                child: const Icon(Icons.more_vert),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print(e);
    }
  }

  _textMe(var number) async {
    print(number);
    // Android
    var uri = "sms:+$number?body=hello%20there";
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      var uri = 'sms:+$number?body=hello%20there';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }
}
