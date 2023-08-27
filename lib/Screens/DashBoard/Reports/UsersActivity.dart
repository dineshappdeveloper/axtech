import 'dart:async';
import 'dart:convert';

import 'package:crm_application/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Provider/Reports/userActivityProvider.dart';
import '../../../Provider/UserProvider.dart';
import '../../Cold Calls/MyLeads/LeadFilter/Filter/FilterUI.dart';
import '../../Cold Calls/MyLeads/LeadFilter/Models/agentsModel.dart';

class UsersActivity extends StatefulWidget {
  const UsersActivity({Key? key}) : super(key: key);

  @override
  State<UsersActivity> createState() => _UsersActivityState();
}

class _UsersActivityState extends State<UsersActivity> {
  var pref;
  var authToken;
  TimelineEventDisplay plainEventDisplay() {
    return TimelineEventDisplay(
      child: TimelineEventCard(
        title: const Text("just now",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          "someone commented on your timeline ${DateTime.now()}",
          style: TextStyle(fontSize: 13),
        ),
      ),
      // indicator: TimelineDots.of(context).icon,
      indicator: const Padding(
        padding: EdgeInsets.all(2.0),
        child: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FaIcon(
              FontAwesomeIcons.droplet,
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }

  List<TimelineEventDisplay> events = [];

  Widget _buildTimeline() {
    return TimelineTheme(
        data: TimelineThemeData(lineColor: themeColor, itemGap: 15),
        child: Timeline(
          reverse: true,
          indicatorSize: 56,
          events: events,
        ));
  }

  void _addEvent() {
    if (this.mounted) {
      setState(() {
        events.add(plainEventDisplay());
      });
    }
  }

  void getPrefs() async {
    var pref = await SharedPreferences.getInstance();
    authToken = pref.getString('token');
    try {
      Provider.of<UserActivityProvider>(context, listen: false).token =
          authToken;
      Provider.of<UserActivityProvider>(context, listen: false).role =
          jsonDecode(pref.getString('user')!)['role'];
      // await Provider.of<UserActivityProvider>(context, listen: false)
      //     .getClosedLeads();
      await Provider.of<UserActivityProvider>(context, listen: false)
          .initFilterMethods();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getPrefs();
    Timer.periodic(const Duration(seconds: 2), (timer) {
      _addEvent();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> onWillPop(BuildContext context) async {
    var clp = Provider.of<UserActivityProvider>(context, listen: false);

    return await clp.isFilterApplied(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var willBack = await onWillPop(context);

        return willBack;
      },
      child: Consumer<UserActivityProvider>(builder: (context, uap, _) {
        return Scaffold(
          appBar: filterModeAppBar(uap),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildTimeline(),
              ],
            ),
          ),
        );
      }),
    );
  }

  AppBar filterModeAppBar(UserActivityProvider uap) {
    return AppBar(
      title: const Text('Users Activity'),
      backgroundColor: themeColor,
      actions: [
        Stack(
          children: [
            IconButton(
                onPressed: () {
                  Get.to(UserActivityFilter(token: authToken));
                },
                icon: const Icon(Icons.filter_list_outlined)),
            if (uap.isFlrApplied)
              const Positioned(
                child: Icon(
                  Icons.circle,
                  color: Colors.red,
                  size: 8,
                ),
                top: 12,
                right: 12,
              ),
          ],
        ),
        const SizedBox(width: 10),
      ],
      bottom: uap.isFlrApplied
          ? PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Container(
                height: 60,
                width: Get.width,
                // color: Colors.grey,
                padding: const EdgeInsets.only(left: 10),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    if (uap.selectedAgent != null)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(UserActivityFilter(
                                  token: uap.token, selectedIndex: 0));
                            },
                            child: Chip(
                              deleteIcon: const Icon(Icons.clear),
                              label: uap.role != UserType.admin.name
                                  ? Text(uap.agentsByTeamList
                                      .firstWhere((element) => element.agents!
                                          .any((ele) =>
                                              ele.id == uap.selectedAgent))
                                      .name!)
                                  : Text(uap.agentsByIdList
                                      .firstWhere((element) =>
                                          element.id == uap.selectedAgent)
                                      .name!),
                              onDeleted: () async {
                                setState(() {
                                  uap.selectedAgent = null;
                                });
                                await uap.applyFilter(uap);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    if (uap.fromDate != null && uap.toDate != null)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(UserActivityFilter(
                                  token: uap.token, selectedIndex: 1));
                            },
                            child: Chip(
                              deleteIcon: const Icon(Icons.clear),
                              // deleteIconColor: Colors.red,
                              label: Text(DateFormat('yyyy-MM-dd')
                                      .format(uap.fromDate!) +
                                  '  TO  ' +
                                  DateFormat('yyyy-MM-dd').format(uap.toDate!)),
                              onDeleted: () async {
                                setState(() {
                                  uap.fromDate = null;
                                  uap.toDate = null;
                                });
                                await uap.applyFilter(uap);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

class UserActivityFilter extends StatefulWidget {
  const UserActivityFilter({
    Key? key,
    required this.token,
    this.selectedIndex,
  }) : super(key: key);
  final String token;
  final int? selectedIndex;

  @override
  State<UserActivityFilter> createState() => _UserActivityFilterState();
}

class _UserActivityFilterState extends State<UserActivityFilter> {
  int selectedIndex = 0;

  List<AgentsByTeam> agentsByTeamList = [];
  List<AgentById> agentsByIdList = [];

  void init() {
    var uap = Provider.of<UserActivityProvider>(context, listen: false);
    agentsByTeamList = uap.agentsByTeamList;
    agentsByIdList = uap.agentsByIdList;
  }

  @override
  void initState() {
    super.initState();
    if (widget.selectedIndex != null) {
      selectedIndex = widget.selectedIndex!;
    }
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserActivityProvider>(builder: (context, uap, _) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Text('Filters', style: Get.theme.textTheme.headline6),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Row(
          children: [
            Expanded(flex: 2, child: filterLeftSection(uap)),
            VerticalDivider(width: 1, color: themeColor),
            Expanded(
              flex: 3,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: selectedIndex == 0
                      ? Column(
                          children: [
                            Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: uap.queryAgents,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    onChanged: (val) async {
                                      if (val.isNotEmpty) {
                                        var list = filterSearchResult(
                                            uap.agentsByIdList
                                                .map((e) => MapEntry(
                                                    int.parse(e.id!),
                                                    e.name! + e.id.toString()))
                                                .toList(),
                                            val);
                                        setState(() {
                                          agentsByIdList = list
                                              .map((e) => AgentById(
                                                  id: e.key.toString(),
                                                  name: e.value))
                                              .toList();
                                        });
                                      } else {
                                        setState(() {
                                          agentsByIdList = uap.agentsByIdList;
                                          uap.queryAgents.text = '';
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: themeColor.withOpacity(0.1),
                                    ),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      tileColor: themeColor.withOpacity(0.1),
                                      onTap: () {
                                        setState(() {
                                          uap.selectedAgent = null;
                                          uap.queryAgents.text = 'All';
                                        });
                                      },
                                      leading: const Text(''),
                                      title: const Text('All'),
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView(
                                children: [
                                  if (uap.role != UserType.admin.name)
                                    ...uap.agentsByTeamList.map(
                                      (e) => Container(
                                        color: Colors.white,
                                        child: ExpansionTile(
                                          collapsedBackgroundColor:
                                              Colors.white,
                                          title: Text(e.name!),
                                          children: [
                                            ...e.agents!.map(
                                              (agent) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: themeColor
                                                        .withOpacity(0.1),
                                                  ),
                                                  child: RadioListTile<String>(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                    tileColor: themeColor
                                                        .withOpacity(0.1),
                                                    value: agent.id!,
                                                    groupValue:
                                                        uap.selectedAgent,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        uap.selectedAgent =
                                                            val!;
                                                        uap.queryAgents.text =
                                                            agent.name!;
                                                      });
                                                    },
                                                    title: Text(agent.name!),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                          // child: Text(e.name!),
                                        ),
                                      ),
                                    ),
                                  if (uap.role == UserType.admin.name)
                                    ...agentsByIdList.map(
                                      (e) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: RadioListTile<String>(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          tileColor:
                                              themeColor.withOpacity(0.1),
                                          value: e.id!,
                                          groupValue: uap.selectedAgent,
                                          onChanged: (val) {
                                            setState(() {
                                              uap.selectedAgent = val!;
                                              uap.queryAgents.text = e.name!;
                                            });
                                          },
                                          title: Text(e.name!),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'From Date',
                              style: Get.theme.textTheme.headline6,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              readOnly: true,
                              controller: TextEditingController(),
                              decoration: InputDecoration(
                                  hintText: uap.fromDate != null
                                      ? DateFormat('yyyy-MM-dd')
                                          .format(uap.fromDate!)
                                      : 'From',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              onTap: () async {
                                var dateRange = await showDateRangePicker(
                                    context: context,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 365)));
                                if (dateRange != null) {
                                  setState(() {
                                    uap.fromDate = dateRange.start;
                                    uap.toDate = dateRange.end;
                                  });
                                }
                              },
                            ),
                            const Divider(),
                            Text(
                              'To Date',
                              style: Get.theme.textTheme.headline6,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              readOnly: true,
                              controller: TextEditingController(),
                              decoration: InputDecoration(
                                  hintText: uap.fromDate != null
                                      ? DateFormat('yyyy-MM-dd')
                                          .format(uap.toDate!)
                                      : "To",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              onTap: () async {
                                var dateRange = await showDateRangePicker(
                                    context: context,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 365)));
                                if (dateRange != null) {
                                  setState(() {
                                    uap.fromDate = dateRange.start;
                                    uap.toDate = dateRange.end;
                                  });
                                }
                              },
                            ),
                          ],
                        )),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          height: 70,
          child: Column(
            children: [
              const Divider(height: 1, thickness: 1),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                   TextButton(
                      onPressed: () async {
                        uap.isFilterApplied(false);
                        Get.back();
                        await uap.applyFilter(uap);
                        Future.delayed(const Duration(seconds: 1), () {});
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.clear,
                            size: 13,
                          ),
                          Text(' Clear Filters'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        disabledBackgroundColor: const Color(0xABA4A3A3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      onPressed: () async {
                        Get.back();
                        await uap.applyFilter(uap);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28.0),
                        child: Text(
                          'Apply',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  ListView filterLeftSection(UserActivityProvider uap) {
    return ListView(
      children: [
        ...uap.categoriesList.map(
          (e) => Column(
            children: [
              Stack(
                children: [
                  ListTile(
                    tileColor: selectedIndex == uap.categoriesList.indexOf(e)
                        ? themeColor.withOpacity(0.1)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedIndex = uap.categoriesList.indexOf(e);
                      });
                    },
                    title: SizedBox(
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e,
                            style: TextStyle(
                                color: selectedIndex ==
                                        uap.categoriesList.indexOf(e)
                                    ? Get.theme.primaryColor
                                    : null),
                          ),
                        ],
                      ),
                    ),
                    trailing: Text(
                      e == uap.categoriesList[0] && uap.selectedAgent != null
                          ? 1.toString()
                          : e == uap.categoriesList[1] &&
                                  (uap.fromDate != null || uap.toDate != null)
                              ? '🔘'
                              : '',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        color: selectedIndex == uap.categoriesList.indexOf(e)
                            ? themeColor.withOpacity(1)
                            : null,
                        width: 7,
                        height: 58,
                      ),
                    ],
                  ),
                ],
              ),
              Divider(thickness: 0.1, color: themeColor, height: 1),
            ],
          ),
        ),
      ],
    );
  }
}
