import 'package:crm_application/Provider/InteractionProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Utils/Colors.dart';
import 'InteractionsTile.dart';

class TodayInteraction extends StatefulWidget {
  const TodayInteraction({Key? key}) : super(key: key);

  @override
  State<TodayInteraction> createState() => _TodayInteractionState();
}

class _TodayInteractionState extends State<TodayInteraction> {
  //late TabController _tabController;
  late SharedPreferences pref;
  var authToken;

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
  // void getPrefs() async {
  //   pref = await SharedPreferences.getInstance();
  //   authToken = pref.getString('token');
  //   debugPrint('AuthToken : $authToken');
  //   // Provider.of<InteractionProvider>(context, listen: false)
  //   //     .getInteraction(authToken);
  //   //await Provider.of<LeadsProvider>(context, listen: false).getLeads(authToken);
  // }


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
                      itemCount: ip.TodayInter.length,
                      itemBuilder: (context, index) {
                        var date = DateFormat.yMMMEd().format(DateTime.parse(
                            ip.TodayInter[index].scheduleDate.toString()));
                        var time =
                            ip.TodayInter[index].scheduleTime.toString();
                        var name = ip.TodayInter[index].leads[0].name
                            .toString();
                        var id = ip.TodayInter[index].id.toString();
                        var leadId =
                        ip.TodayInter[index].leadId.toString();
                        var followupStatus =
                        ip.TodayInter[index].followupStatus!;
                        var callMethod = ip
                            .TodayInter[index].scheduleTime
                            .toString();
                        statusUpdateMethod(final String data) =>
                            ip.updateInteractionStatus(
                                newStatus: data,
                                id: ip.TodayInter[index].id.toString());
                        var phone = ip.TodayInter[index].leads[0].phone
                            .toString();
                        var planToDo = ip.TodayInter[index].planToDo;
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
