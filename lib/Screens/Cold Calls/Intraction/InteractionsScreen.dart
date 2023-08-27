import 'dart:convert';

import 'package:crm_application/Provider/InteractionProvider.dart';
import 'package:crm_application/Screens/Cold%20Calls/Intraction/MissedInteraction.dart';
import 'package:crm_application/Screens/Cold%20Calls/Intraction/TodayInteraction.dart';
import 'package:crm_application/Screens/Cold%20Calls/Intraction/UpcomingInteraction.dart';
import 'package:crm_application/Screens/Cold%20Calls/Intraction/overallInteraction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Provider/UserProvider.dart';
import '../../../Utils/Colors.dart';
import '../MyLeads/LeadFilter/Filter/FilterUI.dart';
import '../MyLeads/LeadFilter/Models/agentsModel.dart';

class InteractionsScreen extends StatefulWidget {
  const InteractionsScreen({Key? key}) : super(key: key);
  @override
  State<InteractionsScreen> createState() => _InteractionsScreenState();
}

class _InteractionsScreenState extends State<InteractionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late SharedPreferences pref;
  var authToken;
  void getPrefs() async {
    var pref = await SharedPreferences.getInstance();
    authToken = pref.getString('token');
    try {
      Provider.of<InteractionProvider>(context, listen: false).token =
          authToken;
      Provider.of<InteractionProvider>(context, listen: false).role =
          jsonDecode(pref.getString('user')!)['role'];

      await Provider.of<InteractionProvider>(context, listen: false)
          .getInteraction(authToken);
      await Provider.of<InteractionProvider>(context, listen: false)
          .initFilterMethods();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
    getPrefs();
    Provider.of<InteractionProvider>(context, listen: false)
        .controller = ScrollController()
      ..addListener(
          Provider.of<InteractionProvider>(context, listen: false).loadMore);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
    Provider.of<InteractionProvider>(context, listen: false)
        .controller = ScrollController()
      ..removeListener(
          Provider.of<InteractionProvider>(context, listen: false).loadMore);
  }

  Future<bool> onWillPop(BuildContext context) async {
    var ip = Provider.of<InteractionProvider>(context, listen: false);

    return await ip.isFilterApplied(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var willBack = await onWillPop(context);

        return willBack;
      },
      child: Consumer<InteractionProvider>(builder: (context, ip, _) {
        return Scaffold(
          appBar: filterModeAppBar(ip),
          body: DefaultTabController(
              length: 4, // length of tabs
              initialIndex: 0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    TabBar(
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: 'Missed'),
                        Tab(text: 'Upcoming'),
                        Tab(text: 'Today'),
                        Tab(text: 'Overall'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(children: <Widget>[
                        MissedInteraction(),
                        UpcomingInteraction(),
                        TodayInteraction(),
                        overallInteraction()
                      ]),
                    )
                  ])),
        );
      }),
    );
  }

  AppBar filterModeAppBar(InteractionProvider ip) {
    return AppBar(
      title: Row(
        children: [
          const Expanded(child: Text('Interactions')),
          Text('( ${ip.total} )'),
        ],
      ),
      backgroundColor: themeColor,
      actions: [
        Stack(
          children: [
            IconButton(
                onPressed: () {
                  Get.to(InteractionProviderFilter(token: authToken));
                },
                icon: const Icon(Icons.filter_list_outlined)),
            if (ip.isFlrApplied)
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
      bottom: ip.isFlrApplied
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
                    if (ip.selectedAgent != null)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(InteractionProviderFilter(
                                  token: ip.token, selectedIndex: 0));
                            },
                            child: Chip(
                              deleteIcon: const Icon(Icons.clear),
                              label: ip.role != UserType.admin.name
                                  ? Text(ip.agentsByTeamList
                                      .firstWhere((element) => element.agents!
                                          .any((ele) =>
                                              ele.id == ip.selectedAgent))
                                      .name!)
                                  : Text(ip.agentsByIdList
                                      .firstWhere((element) =>
                                          element.id == ip.selectedAgent)
                                      .name!),
                              onDeleted: () async {
                                setState(() {
                                  ip.selectedAgent = null;
                                });
                                await ip.applyFilter(ip);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    if (ip.fromDate != null || ip.toDate != null)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(InteractionProviderFilter(
                                  token: ip.token, selectedIndex: 1));
                            },
                            child: Chip(
                              deleteIcon: const Icon(Icons.clear),
                              // deleteIconColor: Colors.red,
                              label: Text(
                                  ip.fromDate != null && ip.toDate != null
                                      ? DateFormat('yyyy-MM-dd')
                                              .format(ip.fromDate!) +
                                          '  To  ' +
                                          DateFormat('yyyy-MM-dd')
                                              .format(ip.toDate!)
                                      : ip.fromDate != null
                                          ? DateFormat('yyyy-MM-dd')
                                              .format(ip.fromDate!)
                                          : ip.toDate != null
                                              ? '  To  ' +
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(ip.toDate!)
                                              : ''),
                              onDeleted: () async {
                                setState(() {
                                  ip.fromDate = null;
                                  ip.toDate = null;
                                });
                                await ip.applyFilter(ip);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    if (ip.selectedType != null)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(InteractionProviderFilter(
                                  token: ip.token, selectedIndex: 2));
                            },
                            child: Chip(
                              deleteIcon: const Icon(Icons.clear),
                              label: Text(ip.selectedType!),
                              onDeleted: () async {
                                setState(() {
                                  ip.selectedType = null;
                                });
                                await ip.applyFilter(ip);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    if (ip.selectedStatus != null)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(InteractionProviderFilter(
                                  token: ip.token, selectedIndex: 0));
                            },
                            child: Chip(
                              deleteIcon: const Icon(Icons.clear),
                              label: Text(ip.selectedStatus!),
                              onDeleted: () async {
                                setState(() {
                                  ip.selectedStatus = null;
                                });
                                await ip.applyFilter(ip);
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

class InteractionProviderFilter extends StatefulWidget {
  const InteractionProviderFilter({
    Key? key,
    required this.token,
    this.selectedIndex,
  }) : super(key: key);
  final String token;
  final int? selectedIndex;

  @override
  State<InteractionProviderFilter> createState() =>
      _InteractionProviderFilterState();
}

class _InteractionProviderFilterState extends State<InteractionProviderFilter> {
  int selectedIndex = 0;

  List<AgentsByTeam> agentsByTeamList = [];
  List<AgentById> agentsByIdList = [];

  void init() {
    var ip = Provider.of<InteractionProvider>(context, listen: false);
    agentsByTeamList = ip.agentsByTeamList;
    agentsByIdList = ip.agentsByIdList;
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
    return Consumer<InteractionProvider>(builder: (context, ip, _) {
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
            Expanded(flex: 2, child: filterLeftSection(ip)),
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
                                  controller: ip.queryAgents,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  onChanged: (val) async {
                                    if (val.isNotEmpty) {
                                      var list = filterSearchResult(
                                          ip.agentsByIdList
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
                                        agentsByIdList = ip.agentsByIdList;
                                        ip.queryAgents.text = '';
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
                                        borderRadius: BorderRadius.circular(5)),
                                    tileColor: themeColor.withOpacity(0.1),
                                    onTap: () {
                                      setState(() {
                                        ip.selectedAgent = null;
                                        ip.queryAgents.text = 'All';
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
                                if (ip.role != UserType.admin.name)
                                  ...ip.agentsByTeamList.map(
                                    (e) => Container(
                                      color: Colors.white,
                                      child: ExpansionTile(
                                        collapsedBackgroundColor: Colors.white,
                                        title: Text(e.name!),
                                        children: [
                                          ...e.agents!.map(
                                            (agent) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: themeColor
                                                      .withOpacity(0.1),
                                                ),
                                                child: RadioListTile<String>(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  tileColor: themeColor
                                                      .withOpacity(0.1),
                                                  value: agent.id!,
                                                  groupValue: ip.selectedAgent,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      ip.selectedAgent = val!;
                                                      ip.queryAgents.text =
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
                                if (ip.role == UserType.admin.name)
                                  ...agentsByIdList.map(
                                    (e) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: RadioListTile<String>(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        tileColor: themeColor.withOpacity(0.1),
                                        value: e.id!,
                                        groupValue: ip.selectedAgent,
                                        onChanged: (val) {
                                          setState(() {
                                            ip.selectedAgent = val!;
                                            ip.queryAgents.text = e.name!;
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
                    : selectedIndex == 1
                        ? Column(
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
                                    hintText: ip.fromDate != null
                                        ? DateFormat('yyyy-MM-dd')
                                            .format(ip.fromDate!)
                                        : 'From',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                onTap: () async {
                                  var date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 365)),
                                      initialDate:
                                          ip.fromDate ?? DateTime.now());
                                  if (date != null) {
                                    setState(() {
                                      ip.fromDate = date;
                                      // ip.toDate = dateRange.end;
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
                                    hintText: ip.toDate != null
                                        ? DateFormat('yyyy-MM-dd')
                                            .format(ip.toDate!)
                                        : "To",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                onTap: () async {
                                  var date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 365)),
                                      initialDate: ip.toDate ?? DateTime.now());
                                  if (date != null) {
                                    setState(() {
                                      ip.toDate = date;
                                      // ip.toDate = dateRange.end;
                                    });
                                  }
                                },
                              ),
                            ],
                          )
                        : selectedIndex == 2
                            ? Column(
                                children: [
                                  const SizedBox(height: 10),
                                  const SizedBox(height: 10),
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
                                      onTap: () {
                                        setState(() {
                                          ip.selectedType = null;
                                        });
                                      },
                                      leading: const Text(''),
                                      title: const Text('All'),
                                    ),
                                  ),
                                  const Divider(),
                                  RadioListTile<String>(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    tileColor: themeColor.withOpacity(0.1),
                                    value: 'Call Back',
                                    title: const Text('Call Back'),
                                    groupValue: ip.selectedType,
                                    onChanged: (val) {
                                      setState(() {
                                        ip.selectedType = val;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  RadioListTile<String>(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    tileColor: themeColor.withOpacity(0.1),
                                    value: 'Meeting',
                                    title: const Text('Meeting'),
                                    groupValue: ip.selectedType,
                                    onChanged: (val) {
                                      setState(() {
                                        ip.selectedType = val;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 10),
                                ],
                              )
                            : Column(
                                children: [
                                  SizedBox(height: 10),
                                  SizedBox(height: 10),
                                  SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: themeColor.withOpacity(0.1),
                                    ),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      onTap: () {
                                        setState(() {
                                          ip.selectedStatus = null;
                                        });
                                      },
                                      leading: const Text(''),
                                      title: const Text('All'),
                                    ),
                                  ),
                                  const Divider(),
                                  RadioListTile<String>(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    tileColor: themeColor.withOpacity(0.1),
                                    value: 'Done',
                                    title: const Text('Done'),
                                    groupValue: ip.selectedStatus,
                                    onChanged: (val) {
                                      setState(() {
                                        ip.selectedStatus = val;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  RadioListTile<String>(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    tileColor: themeColor.withOpacity(0.1),
                                    value: 'Not Done',
                                    title: const Text('Not Done'),
                                    groupValue: ip.selectedStatus,
                                    onChanged: (val) {
                                      setState(() {
                                        ip.selectedStatus = val;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  RadioListTile<String>(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    tileColor: themeColor.withOpacity(0.1),
                                    value: 'Cancelled',
                                    title: const Text('Cancelled'),
                                    groupValue: ip.selectedStatus,
                                    onChanged: (val) {
                                      setState(() {
                                        ip.selectedStatus = val;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
              ),
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
                        ip.isFilterApplied(false);
                        Get.back();
                        await ip.applyFilter(ip);
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),),

                      onPressed: () async {
                        Get.back();
                        await ip.applyFilter(ip);
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

  ListView filterLeftSection(InteractionProvider ip) {
    return ListView(
      children: [
        ...ip.categoriesList.map(
          (e) => Column(
            children: [
              Stack(
                children: [
                  ListTile(
                    tileColor: selectedIndex == ip.categoriesList.indexOf(e)
                        ? themeColor.withOpacity(0.1)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedIndex = ip.categoriesList.indexOf(e);
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
                                        ip.categoriesList.indexOf(e)
                                    ? Get.theme.primaryColor
                                    : null),
                          ),
                        ],
                      ),
                    ),
                    trailing: Text(
                      e == ip.categoriesList[0] && ip.selectedAgent != null
                          ? 1.toString()
                          : e == ip.categoriesList[1] &&
                                  (ip.fromDate != null || ip.toDate != null)
                              ? '🔘'
                              : e == ip.categoriesList[2] &&
                                      (ip.selectedType != null)
                                  ? '1'
                                  : e == ip.categoriesList[3] &&
                                          (ip.selectedStatus != null)
                                      ? '1'
                                      : '',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        color: selectedIndex == ip.categoriesList.indexOf(e)
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
