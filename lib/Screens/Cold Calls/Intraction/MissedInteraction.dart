import 'package:crm_application/Provider/InteractionProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Utils/Colors.dart';
import 'InteractionsTile.dart';

class MissedInteraction extends StatefulWidget {
  const MissedInteraction({Key? key}) : super(key: key);

  @override
  State<MissedInteraction> createState() => _MissedInteractionState();
}

class _MissedInteractionState extends State<MissedInteraction> {
  @override
  void initState() {
    super.initState();
    // getPrefs();
    Provider.of<InteractionProvider>(context, listen: false).controller =
    ScrollController()
      ..addListener(
          Provider.of<InteractionProvider>(context, listen: false).loadMore);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Provider.of<InteractionProvider>(context, listen: false).controller =
    ScrollController()
      ..removeListener(
          Provider.of<InteractionProvider>(context, listen: false).loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<InteractionProvider>(
        builder: (context, ip, child) => ip.IsLoading == false
            ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
          controller: ip.controller,
                      itemCount: ip.InteractionData.length,
                      itemBuilder: (context, index) {
                        var date = DateFormat.yMMMEd().format(DateTime.parse(
                            ip.InteractionData[index].scheduleDate
                                .toString()));
                        var time = ip.InteractionData[index].scheduleTime
                            .toString();
                        var name = ip.InteractionData[index].leads[0].name
                            .toString();
                        var id = ip.InteractionData[index].id.toString();
                        var leadId =
                            ip.InteractionData[index].leadId.toString();
                        var followupStatus =
                            ip.InteractionData[index].followupStatus!;
                        var callMethod = ip
                            .InteractionData[index].scheduleTime
                            .toString();
                        statusUpdateMethod(final String data) =>
                            ip.updateInteractionStatus(
                                newStatus: data,
                                id: ip.InteractionData[index].id.toString());
                        var phone = ip.InteractionData[index].leads[0].phone
                            .toString();
                        var planToDo = ip.InteractionData[index].planToDo;
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
                            planToDo: planToDo??'',
                            context: context,
                            statusUpdateMethod: statusUpdateMethod);
                      },
                    ),
                ),
                if (ip.isLoadMoreRunning == true)
                   Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 25),
                    child: Center(
                      child: CircularProgressIndicator( color: themeColor,),
                    ),
                  ),
              ],
            )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
