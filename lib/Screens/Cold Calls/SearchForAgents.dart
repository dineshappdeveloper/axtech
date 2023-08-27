
import 'package:crm_application/Utils/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Provider/LeadsProvider.dart';

class SearchForAgents extends StatefulWidget {
  var leadId;
   SearchForAgents({Key? key,@required this.leadId}) : super(key: key);

  @override
  State<SearchForAgents> createState() => _SearchForAgentsState();
}

class _SearchForAgentsState extends State<SearchForAgents> {
  late SharedPreferences pref;
  var authToken, responseData, leadData, whatsapp;
  TextEditingController agentController = TextEditingController();

  void getPrefs() async {
    pref = await SharedPreferences.getInstance();
    authToken = pref.getString('token');
    debugPrint("authToken: " + authToken);
    Provider.of<LeadsProvider>(context, listen: false).AgentsList.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: themeColor,
        title: const Text("Search For Agent"),
      ),
      body: Consumer<LeadsProvider>(
        builder: (context, leadsProvider, child) => Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: agentController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search_rounded),
                  hintText: 'Search Your Agent',
                ),
                onChanged: (val) => setState(
                  () {
                    leadsProvider.getAgentList(authToken, val);
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            /* leadsProvider.IsLoading == true
                ?
                : const Center(
                    child: CircularProgressIndicator(),
                  ),*/
            Expanded(
              child: ListView.builder(
                itemCount: leadsProvider.AgentsList.length,
                itemBuilder: (context, index) => Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: InkWell(
                      onTap: () {
                        showAlertDialog(context,leadsProvider.AgentsList[index].firstName
                            .toString(),leadsProvider,authToken,widget.leadId.toString(),leadsProvider.AgentsList[index].id.toString());
                      },
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: themeColor),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                leadsProvider.AgentsList[index].firstName
                                    .toString(),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text(
                                    'Phone : ${leadsProvider.AgentsList[index].phone.toString()}'
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text('ID : ${leadsProvider.AgentsList[index].id.toString()}'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  showAlertDialog(BuildContext context,var name, LeadsProvider leadsProvider,var token,var leadId,var agentId) {

    // set up the button
    Widget okButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        Navigator.pop(context);
        leadsProvider.shareToAgent(token, leadId, agentId, context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Message"),
      content: Text("Do you want to Share Lead with $name"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
