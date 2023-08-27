import 'package:crm_application/Provider/InteractionProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Utils/Colors.dart';
import 'InteractionsTile.dart';

class overallInteraction extends StatefulWidget {
  const overallInteraction({Key? key}) : super(key: key);

  @override
  State<overallInteraction> createState() => _overallInteractionState();
}

class _overallInteractionState extends State<overallInteraction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<InteractionProvider>(
        builder: (context, ip, child) => ip.OverAllData.isNotEmpty
            ? Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      controller: ip.controller,
                      itemCount: ip.OverAllData.length,
                      itemBuilder: (context, index) {
                        var date = DateFormat.yMMMEd().format(DateTime.parse(
                            ip.OverAllData[index].scheduleDate.toString()));
                        var time =
                            ip.OverAllData[index].scheduleTime.toString();
                        Color color = Colors.white;
                        if (ip.InteractionData.any(
                            (ele) => ele.id == ip.OverAllData[index].id)) {
                          color = Colors.red;
                        }
                        if (ip.TodayInter.any(
                            (ele) => ele.id == ip.OverAllData[index].id)) {
                          color = Colors.green;
                        }
                        if (ip.UpcomingInter.any(
                            (ele) => ele.id == ip.OverAllData[index].id)) {
                          color = Colors.amber;
                        }


                        return InteractionsTile(
                            name:
                                ip.OverAllData[index].leads[0].name.toString(),
                            leadId: ip.OverAllData[index].leadId.toString(),
                            date: date,
                            time: time,
                            color: color,
                            followupStatus:
                                ip.OverAllData[index].followupStatus!,
                            phone:
                                ip.OverAllData[index].leads[0].phone.toString(),
                            planToDo: ip.OverAllData[index].planToDo ?? '',
                            context: context,
                            statusUpdateMethod: (data) async {
                              await ip
                                  .updateInteractionStatus(
                                      newStatus: data,
                                      id: ip.OverAllData[index].id.toString())
                                  .then(
                                      (value) => print('Status Changed ---> '));
                            });
                      },
                    ),
                  ),
                  if (ip.isLoadMoreRunning == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 25),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: themeColor,
                        ),
                      ),
                    ),
                ],
              )
            : Container(
                height: 100,
              ),
      ),
    );
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
        throw 'Could not launch $uri';
      }
    }
  }
}
