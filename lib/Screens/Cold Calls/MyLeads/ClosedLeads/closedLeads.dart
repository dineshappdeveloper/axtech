import 'package:crm_application/Provider/closedLeadsProvider.dart';

import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:crm_application/Provider/UserProvider.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/LeadFilter/Models/agentsModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../Utils/Colors.dart';
import '../LeadFilter/Filter/FilterUI.dart';
import 'ViewClosedLeads.dart';
import 'editClosedLeads.dart';

class ClosedLeadsScreen extends StatefulWidget {
  const ClosedLeadsScreen({Key? key}) : super(key: key);

  @override
  State<ClosedLeadsScreen> createState() => _ClosedLeadsScreenState();
}

class _ClosedLeadsScreenState extends State<ClosedLeadsScreen> {
  late SharedPreferences pref;
  var authToken, responseData, url;
  String TAG = 'MyLeadScreen';

  bool isAddingContact = false;

  void getPrefs() async {
    pref = await SharedPreferences.getInstance();
    authToken = pref.getString('token');
    try {
      Provider.of<ClosedLeadsProvider>(context, listen: false).token =
          authToken;
      Provider.of<ClosedLeadsProvider>(context, listen: false).role =
          jsonDecode(pref.getString('user')!)['role'];
      await Provider.of<ClosedLeadsProvider>(context, listen: false)
          .getClosedLeads();
      await Provider.of<ClosedLeadsProvider>(context, listen: false)
          .initFilterMethods();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs();
    Provider.of<ClosedLeadsProvider>(context, listen: false)
        .controller = ScrollController()
      ..addListener(
          Provider.of<ClosedLeadsProvider>(context, listen: false).loadMore);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    Provider.of<ClosedLeadsProvider>(context, listen: false)
        .controller
        .removeListener(
            Provider.of<ClosedLeadsProvider>(context, listen: false).loadMore);
    super.dispose();
  }

  Future<bool> onWillPop(BuildContext context) async {
    var clp = Provider.of<ClosedLeadsProvider>(context, listen: false);
    print(
        'On will Pop Scope selection mode-- > ' + clp.selectionMode.toString());
    if (clp.selectionMode) {
      clp.selectionMode = false;
      clp.selectedLeads.clear();
      setState(() {});
      return false;
    } else {
      return await clp.isFilterApplied(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var willBack = await onWillPop(context);

        return willBack;
      },
      child: Consumer<ClosedLeadsProvider>(builder: (context, clp, _) {
        // print('On loading more mode-- > ' + lp.selectedLeads.length.toString());
        // lp.selectedLeads.forEach((element) {print(element.leadId);});

        return Scaffold(
          appBar: filterModeAppBar(clp),
          body: !clp.IsLoading
              // ?  MyHomePage(lp: lp,)
              ? Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: ClosedLeadsCard(
                            clp: clp,
                          ),
                        ),
                        // when the _loadMore function is running
                        if (clp.isLoadMoreRunning == true)
                          const Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 25),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
                    isAddingContact
                        ? Container(
                            color: const Color(0x30595B59),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Container(),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      }),
    );
  }

  AppBar filterModeAppBar(ClosedLeadsProvider clp) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Closed Leads'),
          Text('( ${clp.total} )'),
        ],
      ),
      backgroundColor: themeColor,
      actions: [
        Stack(
          children: [
            IconButton(
                onPressed: () {
                  Get.to(ClosedLeadsFilter(token: authToken));
                },
                icon: const Icon(Icons.filter_list_outlined)),
            if (clp.isFlrApplied)
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
      bottom: clp.isFlrApplied
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
                    if (clp.selectedAgent != null)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(ClosedLeadsFilter(
                                  token: clp.token, selectedIndex: 0));
                            },
                            child: Chip(
                              deleteIcon: const Icon(Icons.clear),
                              label: clp.role != UserType.admin.name
                                  ? Text(clp.agentsByTeamList
                                      .firstWhere((element) => element.agents!
                                          .any((ele) =>
                                              ele.id == clp.selectedAgent))
                                      .agents!
                                      .firstWhere((element) =>
                                          element.id == clp.selectedAgent)
                                      .name!)
                                  : Text(clp.agentsByIdList
                                      .firstWhere((element) =>
                                          element.id == clp.selectedAgent)
                                      .name!),
                              onDeleted: () async {
                                setState(() {
                                  clp.selectedAgent = null;
                                });
                                await clp.applyFilter(clp);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    if (clp.fromDate != null || clp.toDate != null)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(ClosedLeadsFilter(
                                  token: clp.token, selectedIndex : 1));
                            },
                            child: Chip(
                              deleteIcon: const Icon(Icons.clear),
                              // deleteIconColor: Colors.red,
                              label: Text(
                                  clp.fromDate != null && clp.toDate != null
                                      ? DateFormat('yyyy-MM-dd')
                                      .format(clp.fromDate!) +
                                      '  To  ' +
                                      DateFormat('yyyy-MM-dd')
                                          .format(clp.toDate!)
                                      : clp.fromDate != null
                                      ? DateFormat('yyyy-MM-dd')
                                      .format(clp.fromDate!)
                                      : clp.toDate != null
                                      ? '  To  ' +
                                      DateFormat('yyyy-MM-dd')
                                          .format(clp.toDate!)
                                      : ''),
                              onDeleted: () async {
                                setState(() {
                                  clp.fromDate = null;
                                  clp.toDate = null;
                                });
                                await clp.applyFilter(clp);
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

class ClosedLeadsCard extends StatefulWidget {
  const ClosedLeadsCard({Key? key, required this.clp}) : super(key: key);
  final ClosedLeadsProvider clp;

  @override
  State<ClosedLeadsCard> createState() => _ClosedLeadsCardState();
}

class _ClosedLeadsCardState extends State<ClosedLeadsCard> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    if (widget.clp.closedLeadsByDate.isNotEmpty) {
      return ListView(
        controller: widget.clp.controller,
        physics: const BouncingScrollPhysics(),
        children: [
          ...widget.clp.closedLeadsByDate.map((e) {
            return Column(
              children: [
                // const SizedBox(height: 10),
                // Row(
                //   children: [
                //     Container(
                //       color: Color(0xAE111F44),
                //       width: Get.width,
                //       child: Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Text(
                //           DateFormat(
                //             'yyyy-MM-dd',
                //           ).format(DateTime.parse(e.date!)),
                //           style: Get.theme.textTheme.headline6!.copyWith(
                //               fontWeight: FontWeight.bold, color: Colors.white),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                Column(
                  children: [
                    ...e.sss!.map((sss) {
                      var isSelected = widget.clp.selectedLeads
                          .any((element) => element.leadId == sss.leadId);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 3),
                        child: GestureDetector(
                          onTap: () {
                            // Get.to(EditClosedLeads());
                            Get.to(ViewClosedLeads(sss: sss));
                          },
                          child: Card(
                            elevation: 5,
                            shadowColor: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: isSelected
                                ? const Color(0xC3B7DBF5)
                                : Colors.white,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, top: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text('Lead ID : ',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                  Expanded(
                                                    child: Text(
                                                      sss.leadId.toString(),
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  // PopupMenuButton<int>(
                                                  //   shape:
                                                  //       RoundedRectangleBorder(
                                                  //     borderRadius:
                                                  //         BorderRadius.circular(
                                                  //             15),
                                                  //   ),
                                                  //   onSelected: (val) {
                                                  //     print(val);
                                                  //     if (val == 2) {
                                                  //       Get.to(
                                                  //           const EditClosedLeads());
                                                  //     }
                                                  //   },
                                                  //   itemBuilder: (context) {
                                                  //     return [
                                                  //       PopupMenuItem(
                                                  //           value: 1,
                                                  //           child: Padding(
                                                  //             padding:
                                                  //                 const EdgeInsets
                                                  //                     .all(8.0),
                                                  //             child: Row(
                                                  //               children: const [
                                                  //                 FaIcon(
                                                  //                   FontAwesomeIcons
                                                  //                       .solidEye,
                                                  //                   color: Colors
                                                  //                       .blue,
                                                  //                 ),
                                                  //                 SizedBox(
                                                  //                     width:
                                                  //                         10),
                                                  //                 Text('View')
                                                  //               ],
                                                  //             ),
                                                  //           )),
                                                  //       PopupMenuItem(
                                                  //           value: 2,
                                                  //           child: Padding(
                                                  //             padding:
                                                  //                 const EdgeInsets
                                                  //                     .all(8.0),
                                                  //             child: Row(
                                                  //               children: [
                                                  //                 FaIcon(
                                                  //                   FontAwesomeIcons
                                                  //                       .penToSquare,
                                                  //                   color:
                                                  //                       themeColor,
                                                  //                 ),
                                                  //                 const SizedBox(
                                                  //                     width:
                                                  //                         10),
                                                  //                 const Text(
                                                  //                     'Edit')
                                                  //               ],
                                                  //             ),
                                                  //           )),
                                                  //     ];
                                                  //   },
                                                  //   child: const Padding(
                                                  //     padding:
                                                  //         EdgeInsets.symmetric(
                                                  //             horizontal: 18.0,
                                                  //             vertical: 3),
                                                  //     child: Icon(
                                                  //       Icons.more_vert,
                                                  //       size: 25,
                                                  //       // color: cardTextColor,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                              Text(sss.fname.toString(),
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Get.theme.textTheme
                                                          .caption!.color,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              const SizedBox(height: 7),
                                              SizedBox(
                                                // width: 180,
                                                child: Row(
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons.users,
                                                      size: 13,
                                                      color: Colors.red
                                                          .withOpacity(0.5),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        sss.agentName ?? 'N/A',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          overflow:
                                                              TextOverflow.fade,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              SizedBox(
                                                // width: 180,
                                                child: Row(
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons.mailBulk,
                                                      color: Colors.green
                                                          .withOpacity(0.5),
                                                      size: 15,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        sss.email ?? 'N/A',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          overflow:
                                                              TextOverflow.fade,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              SizedBox(
                                                // width: 180,
                                                child: Row(
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons.phone,
                                                      color: Colors.pink
                                                          .withOpacity(0.5),
                                                      size: 15,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        sss.phone ?? 'N/A',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          overflow:
                                                              TextOverflow.fade,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              SizedBox(
                                                width: 180,
                                                child: Row(
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons
                                                          .calendarCheck,
                                                      color: Colors.pink
                                                          .withOpacity(0.5),
                                                      size: 15,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        sss.onboardingDate ??
                                                            'N/A',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          overflow:
                                                              TextOverflow.fade,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            );
          }),
        ],
      );
    } else {
      return const Center(
        child: Text('Closed Leads not available.'),
      );
    }
  }
}

class ClosedLeadsFilter extends StatefulWidget {
  const ClosedLeadsFilter({
    Key? key,
    required this.token,
    this.selectedIndex,
  }) : super(key: key);
  final String token;
  final int? selectedIndex;

  @override
  State<ClosedLeadsFilter> createState() => _ClosedLeadsFilterState();
}

class _ClosedLeadsFilterState extends State<ClosedLeadsFilter> {
  int selectedIndex = 0;

  List<AgentsByTeam> agentsByTeamList = [];
  List<AgentById> agentsByIdList = [];

  void init() {
    var lp = Provider.of<ClosedLeadsProvider>(context, listen: false);
    agentsByTeamList = lp.agentsByTeamList;
    agentsByIdList = lp.agentsByIdList;
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
    return Consumer<ClosedLeadsProvider>(builder: (context, lp, _) {
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
            Expanded(flex: 2, child: filterLeftSection(lp)),
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
                                  if (lp.role == UserType.admin.name)
                                    TextFormField(
                                      controller: lp.queryAgents,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5))),
                                      onChanged: (val) async {
                                        if (val.isNotEmpty) {
                                          var list = filterSearchResult(
                                              lp.agentsByIdList
                                                  .map((e) => MapEntry(
                                                      int.parse(e.id!),
                                                      e.name!))
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
                                            agentsByIdList = lp.agentsByIdList;
                                            lp.queryAgents.text = '';
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
                                          lp.selectedAgent = null;
                                          lp.queryAgents.text = 'All';
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
                                  if (lp.role != UserType.admin.name)
                                    ...lp.agentsByTeamList.map(
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
                                                        lp.selectedAgent,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        lp.selectedAgent = val!;
                                                        lp.queryAgents.text =
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
                                  if (lp.role == UserType.admin.name)
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
                                          groupValue: lp.selectedAgent,
                                          onChanged: (val) {
                                            setState(() {
                                              lp.selectedAgent = val!;
                                              lp.queryAgents.text = e.name!;
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
                                  hintText: lp.fromDate != null
                                      ? DateFormat('yyyy-MM-dd')
                                          .format(lp.fromDate!)
                                      : 'From',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              onTap: () async {
                                var date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 365)),
                                    initialDate:
                                    lp.fromDate ?? DateTime.now());
                                if (date != null) {
                                  setState(() {
                                    lp.fromDate = date;
                                    // lp.toDate = dateRange.end;
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
                                  hintText: lp.toDate != null
                                      ? DateFormat('yyyy-MM-dd')
                                          .format(lp.toDate!)
                                      : "To",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              onTap: () async {
                                var date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 365)),
                                    initialDate:
                                    lp.toDate ?? DateTime.now());
                                if (date != null) {
                                  setState(() {
                                    lp.toDate = date;
                                    // lp.toDate = dateRange.end;
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
                        lp.isFilterApplied(false);
                        Get.back();
                        await lp.applyFilter(lp);
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
                        await lp.applyFilter(lp);
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

  ListView filterLeftSection(ClosedLeadsProvider clp) {
    return ListView(
      children: [
        ...clp.categoriesList.map(
          (e) => Column(
            children: [
              Stack(
                children: [
                  ListTile(
                    tileColor: selectedIndex == clp.categoriesList.indexOf(e)
                        ? themeColor.withOpacity(0.1)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedIndex = clp.categoriesList.indexOf(e);
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
                                        clp.categoriesList.indexOf(e)
                                    ? Get.theme.primaryColor
                                    : null),
                          ),
                        ],
                      ),
                    ),
                    trailing: Text(
                      e == clp.categoriesList[0] && clp.selectedAgent != null
                          ? 1.toString()
                          : e == clp.categoriesList[1] &&
                                  (clp.fromDate != null || clp.toDate != null)
                              ? '🔘'
                              : '',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        color: selectedIndex == clp.categoriesList.indexOf(e)
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

// class ClosedLeadsScreen extends StatefulWidget {
//   const ClosedLeadsScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ClosedLeadsScreen> createState() => _ClosedLeadsScreenState();
// }
//
// class _ClosedLeadsScreenState extends State<ClosedLeadsScreen> {
//   late SharedPreferences pref;
//   var authToken, responseData, url;
//   String TAG = 'MyLeadScreen';
//
//   bool isAddingContact = false;
//
//   void getPrefs() async {
//     pref = await SharedPreferences.getInstance();
//     authToken = pref.getString('token');
//     try {
//       Provider.of<ClosedLeadsProvider>(context, listen: false).token =
//           authToken;
//       Provider.of<ClosedLeadsProvider>(context, listen: false).role =
//           jsonDecode(pref.getString('user')!)['role'];
//       await Provider.of<ClosedLeadsProvider>(context, listen: false).getLeads();
//       await Provider.of<ClosedLeadsProvider>(context, listen: false)
//           .initFilterMethods();
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getPrefs();
//     Provider.of<ClosedLeadsProvider>(context, listen: false)
//         .controller = ScrollController()
//       ..addListener(
//           Provider.of<ClosedLeadsProvider>(context, listen: false).loadMore);
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//   }
//
//   @override
//   void dispose() {
//     Provider.of<ClosedLeadsProvider>(context, listen: false)
//         .controller
//         .removeListener(
//             Provider.of<ClosedLeadsProvider>(context, listen: false).loadMore);
//     super.dispose();
//   }
//
//   Future<bool> onWillPop(BuildContext context) async {
//     var lp = Provider.of<ClosedLeadsProvider>(context, listen: false);
//     print(
//         'On will Pop Scope selection mode-- > ' + lp.selectionMode.toString());
//     if (lp.selectionMode) {
//       lp.selectionMode = false;
//       lp.selectedLeads.clear();
//       setState(() {});
//       return false;
//     } else {
//       return await lp.isFilterApplied(false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         var willBack = await onWillPop(context);
//
//         return willBack;
//       },
//       child: Consumer<ClosedLeadsProvider>(builder: (context, lp, _) {
//         print('On selection mode-- > ' + lp.selectedLeads.length.toString());
//         // lp.selectedLeads.forEach((element) {print(element.leadId);});
//
//         return Scaffold(
//           appBar: !lp.selectionMode
//               ? filterModeAppBar(lp)
//               : AppBar(
//                   backgroundColor: themeColor,
//                   leading: IconButton(
//                     onPressed: () {
//                       lp.selectionMode = false;
//                       lp.selectedLeads.clear();
//                       setState(() {});
//                     },
//                     icon: const Icon(Icons.clear),
//                   ),
//                   // title: CheckboxListTile(
//                   //   checkColor: themeColor,
//                   //   activeColor: Colors.white,
//                   //   side: const BorderSide(color: Colors.white),
//                   //   value: lp.selectedLeads.length == lp.leadsData.length,
//                   //   onChanged: (v) {
//                   //     setState(() {
//                   //       !v!
//                   //           ? lp.selectedLeads.clear()
//                   //           : lp.selectedLeads.addAll(lp.leadsData);
//                   //     });
//                   //     // print(lp.selectedLeads.length);
//                   //   },
//                   title: Text(
//                     '${lp.selectedLeads.length} Selected',
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                   // ),
//                   bottom: PreferredSize(
//                     preferredSize: Size(Get.width, 55),
//                     child: SizedBox(
//                         // color: Colors.grey,
//                         child: Column(
//                           children: [
//                             Expanded(
//                               child: ListView(
//                                 scrollDirection: Axis.horizontal,
//                                 children: [
//                                   const SizedBox(width: 20),
//                                   RaisedButton(
//                                     color: const Color(0xF2C08004),
//                                     disabledColor: const Color(0xABA4A3A3),
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(50)),
//                                     onPressed: lp.selectedLeads.isNotEmpty
//                                         ? () async {
//                                             await showDialog(
//                                                 context: context,
//                                                 barrierDismissible: false,
//                                                 builder: (context) {
//                                                   return Dialog(
//                                                     shape:
//                                                         RoundedRectangleBorder(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         15)),
//                                                     child:
//                                                         LeadAssignmentToLeaderDialog(
//                                                             lp: lp),
//                                                   );
//                                                 });
//                                           }
//                                         : null,
//                                     child: const Text(
//                                       'Assign To Team Leader',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 10),
//                                   RaisedButton(
//                                     color: const Color(0xF2318005),
//                                     disabledColor: const Color(0xABA4A3A3),
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(50)),
//                                     onPressed: lp.selectedLeads.isNotEmpty
//                                         ? () async {
//                                             await showDialog(
//                                                 context: context,
//                                                 barrierDismissible: false,
//                                                 builder: (context) {
//                                                   return Dialog(
//                                                     shape:
//                                                         RoundedRectangleBorder(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         15)),
//                                                     child:
//                                                         LeadAssignmentToAgentDialog(
//                                                             lp: lp),
//                                                   );
//                                                 });
//                                           }
//                                         : null,
//                                     child: const Text(
//                                       'Assign To Agent',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 10),
//                                   RaisedButton(
//                                     color: const Color(0xF2E52121),
//                                     disabledColor: const Color(0xABA4A3A3),
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(50)),
//                                     onPressed: lp.selectedLeads.isNotEmpty
//                                         ? () {
//                                             AwesomeDialog(
//                                               dismissOnBackKeyPress: false,
//                                               dismissOnTouchOutside: false,
//                                               context: context,
//                                               dialogType: DialogType.warning,
//                                               animType: AnimType.rightSlide,
//                                               title:
//                                                   'Are you sure to delete this leads?',
//                                               desc:
//                                                   'After delete permanently,\nit will not be retrieve.',
//                                               btnCancelOnPress: () {},
//                                               btnOkOnPress: () async {
//                                                 await lp.bulkDelete();
//                                               },
//                                             ).show();
//                                           }
//                                         : null,
//                                     child: const Text(
//                                       'Bulk Delete',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                           ],
//                         ),
//                         height: 45),
//                   ),
//                 ),
//           body: !lp.IsLoading
//               // ?  MyHomePage(lp: lp,)
//               ? Stack(
//                   children: [
//                     Column(
//                       children: [
//                         Expanded(
//                           child: ClosedLeadsCard(
//                             lp: lp,
//                           ),
//                         ),
//                         // when the _loadMore function is running
//                         if (lp.isLoadMoreRunning == true)
//                           const Padding(
//                             padding: EdgeInsets.only(top: 10, bottom: 25),
//                             child: Center(
//                               child: CircularProgressIndicator(),
//                             ),
//                           ),
//                       ],
//                     ),
//                     isAddingContact
//                         ? Container(
//                             color: const Color(0x30595B59),
//                             child: const Center(
//                               child: CircularProgressIndicator(),
//                             ),
//                           )
//                         : Container(),
//                   ],
//                 )
//               : const Center(
//                   child: CircularProgressIndicator(),
//                 ),
//         );
//       }),
//     );
//   }
//
//   AppBar filterModeAppBar(ClosedLeadsProvider lp) {
//     return AppBar(
//       title: Text('${lp.total} Closed Leads'),
//       backgroundColor: themeColor,
//       actions: [
//         Stack(
//           children: [
//             IconButton(
//                 onPressed: () {
//                   Get.to(LeadsFilters(token: authToken));
//                 },
//                 icon: const Icon(Icons.filter_list_outlined)),
//             if (lp.isFlrApplied)
//               const Positioned(
//                 child: Icon(
//                   Icons.circle,
//                   color: Colors.red,
//                   size: 8,
//                 ),
//                 top: 12,
//                 right: 12,
//               ),
//           ],
//         ),
//         const SizedBox(width: 10),
//       ],
//       bottom: lp.isFlrApplied
//           ? PreferredSize(
//               preferredSize: const Size.fromHeight(70),
//               child: Container(
//                 height: 60,
//                 width: Get.width,
//                 // color: Colors.grey,
//                 padding: const EdgeInsets.only(left: 10),
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   children: [
//                     if (lp.selectedAgent != null)
//                       Row(
//                         children: [
//                           Chip(
//                             deleteIcon: const Icon(Icons.clear),
//                             label: lp.role != UserType.admin.name
//                                 ? Text(lp.agentsByTeamList
//                                     .firstWhere((element) => element.agents!
//                                         .any((ele) =>
//                                             ele.id == lp.selectedAgent))
//                                     .name!)
//                                 : Text(lp.agentsByIdList
//                                     .firstWhere((element) =>
//                                         element.id == lp.selectedAgent)
//                                     .name!),
//                             onDeleted: () async {
//                               setState(() {
//                                 lp.selectedAgent = null;
//                               });
//                               await lp.applyFilter(lp);
//                             },
//                           ),
//                           const SizedBox(width: 10),
//                         ],
//                       ),
//                     if (lp.fromDate != null && lp.toDate != null)
//                       Row(
//                         children: [
//                           Chip(
//                             deleteIcon: const Icon(Icons.clear),
//                             // deleteIconColor: Colors.red,
//                             label: Text(DateFormat('yyyy-MM-dd')
//                                     .format(lp.fromDate!) +
//                                 '  TO  ' +
//                                 DateFormat('yyyy-MM-dd').format(lp.toDate!)),
//                             onDeleted: () async {
//                               setState(() {
//                                 lp.fromDate = null;
//                                 lp.toDate = null;
//                               });
//                               await lp.applyFilter(lp);
//                             },
//                           ),
//                           const SizedBox(width: 10),
//                         ],
//                       ),
//                     if (lp.selectedDeveloper != null)
//                       Row(
//                         children: [
//                           Chip(
//                             deleteIcon: const Icon(Icons.clear),
//                             label: Text(lp.developersList
//                                 .firstWhere((element) =>
//                                     element.id == lp.selectedDeveloper)
//                                 .name!),
//                             onDeleted: () async {
//                               setState(() {
//                                 lp.selectedDeveloper = null;
//                               });
//                               await lp.applyFilter(lp);
//                             },
//                           ),
//                           const SizedBox(width: 10),
//                         ],
//                       ),
//                     if (lp.selectedProperty != null)
//                       Row(
//                         children: [
//                           Chip(
//                             deleteIcon: const Icon(Icons.clear),
//                             label: Text(lp.propertyList
//                                 .firstWhere((element) =>
//                                     element.id == lp.selectedProperty)
//                                 .name!),
//                             onDeleted: () async {
//                               setState(() {
//                                 lp.selectedProperty = null;
//                               });
//                               await lp.applyFilter(lp);
//                             },
//                           ),
//                           const SizedBox(width: 10),
//                         ],
//                       ),
//                     if (lp.multiSelectedStatus.isNotEmpty)
//                       Row(
//                         children: [
//                           PopupMenuButton(
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             itemBuilder: (context) {
//                               return [
//                                 ...lp.multiSelectedStatus.map(
//                                   (e) => PopupMenuItem(
//                                       child: Chip(
//                                     deleteIcon: const Icon(Icons.clear),
//                                     label: Text(e.name!),
//                                     onDeleted: () async {
//                                       setState(() {
//                                         lp.multiSelectedStatus.remove(e);
//                                       });
//                                       Get.back();
//                                       await lp.applyFilter(lp);
//                                     },
//                                   )),
//                                 ),
//                               ];
//                             },
//                             child: Chip(
//                               deleteIcon: const Icon(Icons.arrow_drop_down),
//                               label: Row(
//                                 children: [
//                                   Text(
//                                       '${lp.multiSelectedStatus.length} Status'),
//                                   const Icon(Icons.arrow_drop_down),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                         ],
//                       ),
//                     if (lp.multiSelectedSources.isNotEmpty)
//                       Row(
//                         children: [
//                           PopupMenuButton(
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             itemBuilder: (context) {
//                               return [
//                                 ...lp.multiSelectedSources.map(
//                                   (e) => PopupMenuItem(
//                                       child: Chip(
//                                     deleteIcon: const Icon(Icons.clear),
//                                     label: Text(e.name!),
//                                     onDeleted: () async {
//                                       setState(() {
//                                         lp.multiSelectedSources.remove(e);
//                                       });
//                                       Get.back();
//                                       await lp.applyFilter(lp);
//                                     },
//                                   )),
//                                 ),
//                               ];
//                             },
//                             child: Chip(
//                               deleteIcon: const Icon(Icons.arrow_drop_down),
//                               label: Row(
//                                 children: [
//                                   Text(
//                                       '${lp.multiSelectedSources.length} Status'),
//                                   const Icon(Icons.arrow_drop_down),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                         ],
//                       ),
//                     if (lp.selectedPriority != null)
//                       Row(
//                         children: [
//                           Chip(
//                             deleteIcon: const Icon(Icons.clear),
//                             label: Text(lp.selectedPriority!),
//                             onDeleted: () async {
//                               setState(() {
//                                 lp.selectedPriority = null;
//                               });
//                               await lp.applyFilter(lp);
//                             },
//                           ),
//                           const SizedBox(width: 10),
//                         ],
//                       ),
//                     if (lp.query.text.isNotEmpty)
//                       Row(
//                         children: [
//                           Chip(
//                             deleteIcon: const Icon(Icons.clear),
//                             label: Text(lp.query.text),
//                             onDeleted: () async {
//                               setState(() {
//                                 lp.query.clear();
//                               });
//                               await lp.applyFilter(lp);
//                             },
//                           ),
//                           const SizedBox(width: 10),
//                         ],
//                       ),
//                   ],
//                 ),
//               ),
//             )
//           : null,
//     );
//   }
// }
//
// class ClosedLeadsCard extends StatefulWidget {
//   const ClosedLeadsCard({Key? key, required this.lp}) : super(key: key);
//   final ClosedLeadsProvider lp;
//
//   @override
//   State<ClosedLeadsCard> createState() => _ClosedLeadsCardState();
// }
//
// class _ClosedLeadsCardState extends State<ClosedLeadsCard> {
//   bool isVisible = false;
//   var whatsapp;
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       controller: widget.lp.controller,
//       physics: const BouncingScrollPhysics(),
//       children: [
//         ...widget.lp.leadsByDate.map((e) {
//           return Column(
//             children: [
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   Container(
//                     color: const Color(0xAE111F44),
//                     width: Get.width,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         DateFormat(
//                           'yyyy-MM-dd',
//                         ).format(DateTime.parse(e.date!)),
//                         style: Get.theme.textTheme.headline6!.copyWith(
//                             fontWeight: FontWeight.bold, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Column(
//                 children: [
//                   ...e.leads!.map((lead) {
//                     String agentsName = '';
//                     if (lead.agents != null || lead.agents!.isNotEmpty) {
//                       lead.agents!.length > 1
//                           ? isVisible = true
//                           : isVisible = false;
//                       for (var element in lead.agents!) {
//                         agentsName +=
//                             "${element.firstName} ${element.lastName},";
//                       }
//                       agentsName =
//                           agentsName.substring(0, agentsName.length - 1);
//                     }
//
//                     var colorCode;
//                     var color = const Color(0xFF000000);
//                     if (lead.statuses != null) {
//                       colorCode = lead.statuses!.color
//                           .substring(1, lead.statuses!.color.length - 1);
//                       colorCode = '0xFF' + colorCode;
//                       var intCode = int.parse(colorCode);
//                       color = Color(intCode);
//                     }
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: GestureDetector(
//                         onTap: () {},
//                         child: Card(
//                           elevation: 3,
//                           shadowColor: Colors.blueGrey,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           color: Colors.white,
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10)),
//                             foregroundDecoration: lead.priority != null
//                                 ? RotatedCornerDecoration(
//                                     color: themeColor,
//                                     geometry: BadgeGeometry(
//                                         width:
//                                             lead.priority!.split(' ').length > 1
//                                                 ? 100
//                                                 : 60,
//                                         cornerRadius: 10,
//                                         height: 60),
//                                     textSpan: TextSpan(
//                                       children: [
//                                         TextSpan(
//                                           text:
//                                               lead.priority!.split(' ').first +
//                                                   "\n",
//                                           style: const TextStyle(
//                                               fontSize: 10,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white),
//                                         ),
//                                         if (lead.priority!.split(' ').length >
//                                             1)
//                                           TextSpan(
//                                             text: lead.priority!.split(' ')[1],
//                                             style: const TextStyle(
//                                                 fontSize: 10,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.white),
//                                           ),
//                                       ],
//                                     ),
//                                     labelInsets:
//                                         const LabelInsets(baselineShift: 1),
//                                   )
//                                 : null,
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(
//                                             left: 20.0, top: 15),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 const Text('Lead ID : ',
//                                                     style: TextStyle(
//                                                         fontSize: 16,
//                                                         overflow: TextOverflow
//                                                             .ellipsis),
//                                                     overflow:
//                                                         TextOverflow.ellipsis),
//                                                 Expanded(
//                                                   child: Text(
//                                                     '232331',
//                                                     style: const TextStyle(
//                                                         fontSize: 20,
//                                                         overflow: TextOverflow
//                                                             .ellipsis),
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                   ),
//                                                 ),
//                                                 PopupMenuButton<int>(
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             15),
//                                                   ),
//                                                   onSelected: (val) {},
//                                                   itemBuilder: (context) {
//                                                     return [
//                                                       PopupMenuItem(
//                                                           value: 1,
//                                                           child: Row(
//                                                             children: const [
//                                                               FaIcon(
//                                                                 FontAwesomeIcons
//                                                                     .solidEye,
//                                                                 color:
//                                                                     Colors.blue,
//                                                               ),
//                                                               SizedBox(
//                                                                   width: 10),
//                                                               Text('View')
//                                                             ],
//                                                           )),
//                                                       PopupMenuItem(
//                                                           value: 2,
//                                                           child: Row(
//                                                             children: [
//                                                               FaIcon(
//                                                                 FontAwesomeIcons
//                                                                     .penToSquare,
//                                                                 color:
//                                                                     themeColor,
//                                                               ),
//                                                               const SizedBox(
//                                                                   width: 10),
//                                                               const Text('Edit')
//                                                             ],
//                                                           )),
//                                                     ];
//                                                   },
//                                                   child: const Icon(
//                                                     Icons.more_vert,
//                                                     // color: cardTextColor,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Text('lead.name.toString()',
//                                                 style: TextStyle(
//                                                     fontSize: 18,
//                                                     color: Get.theme.textTheme
//                                                         .caption!.color,
//                                                     fontWeight: FontWeight.bold,
//                                                     overflow:
//                                                         TextOverflow.ellipsis),
//                                                 overflow:
//                                                     TextOverflow.ellipsis),
//                                             const SizedBox(height: 7),
//                                             SizedBox(
//                                               width: 180,
//                                               child: Row(
//                                                 children: [
//                                                   FaIcon(
//                                                     FontAwesomeIcons.users,
//                                                     size: 13,
//                                                     color: Colors.red
//                                                         .withOpacity(0.5),
//                                                   ),
//                                                   const SizedBox(width: 10),
//                                                   Expanded(
//                                                     child: Text(
//                                                       'Ankit Kumar Jha',
//                                                       style: const TextStyle(
//                                                         fontSize: 14,
//                                                         overflow:
//                                                             TextOverflow.fade,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             const SizedBox(height: 5),
//                                             SizedBox(
//                                               width: 180,
//                                               child: Row(
//                                                 children: [
//                                                   FaIcon(
//                                                     FontAwesomeIcons.mailBulk,
//                                                     color: Colors.green
//                                                         .withOpacity(0.5),
//                                                     size: 15,
//                                                   ),
//                                                   const SizedBox(width: 10),
//                                                   Expanded(
//                                                     child: Text(
//                                                       'Ke@triviumconcepts.co',
//                                                       style: const TextStyle(
//                                                         fontSize: 14,
//                                                         overflow:
//                                                             TextOverflow.fade,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             const SizedBox(height: 5),
//                                             SizedBox(
//                                               width: 180,
//                                               child: Row(
//                                                 children: [
//                                                   FaIcon(
//                                                     FontAwesomeIcons.phone,
//                                                     color: Colors.pink
//                                                         .withOpacity(0.5),
//                                                     size: 15,
//                                                   ),
//                                                   const SizedBox(width: 10),
//                                                   Expanded(
//                                                     child: Text(
//                                                       '+971505281914',
//                                                       style: const TextStyle(
//                                                         fontSize: 14,
//                                                         overflow:
//                                                             TextOverflow.fade,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             const SizedBox(height: 5),
//                                             SizedBox(
//                                               width: 180,
//                                               child: Row(
//                                                 children: [
//                                                   FaIcon(
//                                                     FontAwesomeIcons
//                                                         .calendarCheck,
//                                                     color: Colors.pink
//                                                         .withOpacity(0.5),
//                                                     size: 15,
//                                                   ),
//                                                   const SizedBox(width: 10),
//                                                   Expanded(
//                                                     child: Text(
//                                                       '2022-10-11',
//                                                       style: const TextStyle(
//                                                         fontSize: 14,
//                                                         overflow:
//                                                             TextOverflow.fade,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//
//                                     // const Spacer(),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 15),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//                 ],
//               ),
//             ],
//           );
//         })
//       ],
//     );
//   }
// }
