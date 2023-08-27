import 'package:crm_application/Utils/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Provider/InteractionProvider.dart';
import 'InteractionsTile.dart';

class UpcomingInteraction extends StatefulWidget {
  const UpcomingInteraction({Key? key}) : super(key: key);

  @override
  State<UpcomingInteraction> createState() => _UpcomingInteractionState();
}

class _UpcomingInteractionState extends State<UpcomingInteraction> {
  late SharedPreferences pref;
  var authToken;

  @override
  void initState() {
    super.initState();
    // getPrefs();
    Provider.of<InteractionProvider>(context, listen: false)
        .controller = ScrollController()
      ..addListener(
          Provider.of<InteractionProvider>(context, listen: false).loadMore);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Provider.of<InteractionProvider>(context, listen: false)
        .controller = ScrollController()
      ..removeListener(
          Provider.of<InteractionProvider>(context, listen: false).loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<InteractionProvider>(
        builder: (context, ip, child) =>
            // intProvider.IsLoading ?
            ip.IsLoading == false
                ? Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: ip.controller,
                          itemCount: ip.UpcomingInter.length,
                          itemBuilder: (context, index) {
                            var date = DateFormat.yMMMEd().format(
                                DateTime.parse(ip
                                    .UpcomingInter[index].scheduleDate
                                    .toString()));
                            var time =
                                ip.UpcomingInter[index].scheduleTime.toString();
                            var name = ip.UpcomingInter[index].leads[0].name
                                .toString();
                            var id = ip.UpcomingInter[index].id.toString();
                            var leadId =
                                ip.UpcomingInter[index].leadId.toString();
                            var followupStatus =
                                ip.UpcomingInter[index].followupStatus!;
                            var callMethod =
                                ip.UpcomingInter[index].scheduleTime.toString();
                            statusUpdateMethod(final String data) =>
                                ip.updateInteractionStatus(
                                    newStatus: data,
                                    id: ip.UpcomingInter[index].id.toString());
                            var phone = ip.UpcomingInter[index].leads[0].phone
                                .toString();
                            var planToDo = ip.UpcomingInter[index].planToDo;
                            // print(date);
                            // print(time);
                            // print(planToDo);

                            return InteractionsTile(
                                name: name,
                                leadId: leadId,
                                date: date,
                                time: time,
                                followupStatus: followupStatus,
                                phone: phone,
                                planToDo: planToDo!,
                                context: context,
                                statusUpdateMethod: statusUpdateMethod);
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
                // ListView.builder(itemCount: intProvider.UpcomingInter.length,
                //   itemBuilder: (context, index)  {
                //     return  Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                //       child: Row(
                //         children: [
                //           Column(
                //             children: [
                //               CircleAvatar(
                //                 radius: 30,
                //                 child: Image.asset(
                //                   'assets/images/profile.png',
                //                   height: 25,
                //                   color: Colors.white,
                //                 ),
                //               ),
                //             ],
                //           ),
                //           SizedBox(
                //             width: 20,
                //           ),
                //           Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(intProvider.UpcomingInter[index].leads[0].name.toString(),style: TextStyle(
                //                   color: Colors.black
                //               ),),
                //               Row(
                //                 children: [
                //                   Text("Lead ID : "),
                //                   Text(intProvider.UpcomingInter[index].leadId.toString(),style: TextStyle(
                //                       color: Colors.black
                //                   ),),
                //                 ],
                //               ),
                //               Text(intProvider.UpcomingInter[index].createdAt.toString(),style: TextStyle(
                //                   color: Colors.black
                //               ),),
                //               Row(
                //                 children: [
                //                   Text("Status : "),
                //                   Text(intProvider.UpcomingInter[index].followupStatus.toString(),style: TextStyle(
                //                       color: Colors.black
                //                   ),),
                //                 ],
                //               )
                //             ],
                //           ),
                //           Spacer(),
                //           Column(
                //             children: [
                //               Icon(Icons.more_vert)
                //             ],
                //           ),
                //         ],
                //       ),
                //     );
                //   },)
                : const Center(
                    child: CircularProgressIndicator(),
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
