import 'package:crm_application/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Provider/LeadsProvider.dart';

class LeadHistoryScreen extends StatefulWidget {
  String leadId;

  LeadHistoryScreen({Key? key, required this.leadId}) : super(key: key);

  @override
  State<LeadHistoryScreen> createState() => _LeadHistoryScreenState();
}

class _LeadHistoryScreenState extends State<LeadHistoryScreen> {
  late SharedPreferences pref;
  var authToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs();
  }

  void getPrefs() async {
    pref = await SharedPreferences.getInstance();
    authToken = pref.getString('token');
    debugPrint("authToken: " + authToken);
    Provider.of<LeadsProvider>(context, listen: false)
        .getLeadsHistory(authToken, widget.leadId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LeadsProvider>(
        builder: (context, leadsProvider, child) => ListView.builder(
          itemCount: leadsProvider.LeadsUserHistory.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: themeColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Plan to Do : ${leadsProvider.LeadsUserHistory[index].planToDo}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        'I Have Done : ${leadsProvider.LeadsUserHistory[index].iHaveDone}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        'Comments : ${leadsProvider.LeadsUserHistory[index].comment}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        'Interested Projects : ${leadsProvider.LeadsUserHistory[index].interestedProjects}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        'Date & Time : ${leadsProvider.LeadsUserHistory[index].scheduleDate} ${leadsProvider.LeadsUserHistory[index].scheduleTime}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        'schedule Date : ${leadsProvider.LeadsUserHistory[index].scheduleDate}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
