import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:crm_application/Provider/UserProvider.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/LeadFilter/Models/agentsModel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Provider/SSSProvider.dart';
import '../../../../Utils/Colors.dart';
import '../LeadFilter/Filter/FilterUI.dart';
import 'SurveyReviewPage.dart';

class SSSScreen extends StatefulWidget {
  const SSSScreen({Key? key}) : super(key: key);

  @override
  State<SSSScreen> createState() => _SSSScreenState();
}

class _SSSScreenState extends State<SSSScreen> {
  late SharedPreferences pref;
  var authToken, responseData, url;
  String TAG = 'MyLeadScreen';

  bool isAddingContact = false;

  void getPrefs() async {
    pref = await SharedPreferences.getInstance();
    authToken = pref.getString('token');
    try {
      Provider.of<SSSProvider>(context, listen: false).token = authToken;
      Provider.of<SSSProvider>(context, listen: false).role =
          jsonDecode(pref.getString('user')!)['role'];
      await Provider.of<SSSProvider>(context, listen: false).getSSS();
      await Provider.of<SSSProvider>(context, listen: false)
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
    Provider.of<SSSProvider>(context, listen: false)
        .controller = ScrollController()
      ..addListener(Provider.of<SSSProvider>(context, listen: false).loadMore);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    Provider.of<SSSProvider>(context, listen: false).controller.removeListener(
        Provider.of<SSSProvider>(context, listen: false).loadMore);
    super.dispose();
  }

  Future<bool> onWillPop(BuildContext context) async {
    var lp = Provider.of<SSSProvider>(context, listen: false);
    print(
        'On will Pop Scope selection mode-- > ' + lp.selectionMode.toString());
    if (lp.selectionMode) {
      lp.selectionMode = false;
      lp.selectedLeads.clear();
      setState(() {});
      return false;
    } else {
      return await lp.isFilterApplied(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var willBack = await onWillPop(context);

        return willBack;
      },
      child: Consumer<SSSProvider>(builder: (context, lp, _) {
        // print('On loading more mode-- > ' + lp.selectedLeads.length.toString());
        // lp.selectedLeads.forEach((element) {print(element.leadId);});

        return Scaffold(
          appBar: filterModeAppBar(lp),
          body: !lp.IsLoading
              // ?  MyHomePage(lp: lp,)
              ? Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: SSSCard(
                            lp: lp,
                          ),
                        ),
                        // when the _loadMore function is running
                        if (lp.isLoadMoreRunning == true)
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

  AppBar filterModeAppBar(SSSProvider sssp) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Surveys'),
          Text('( ${sssp.total} )'),
        ],
      ),
      backgroundColor: themeColor,
      actions: [
        Stack(
          children: [
            IconButton(
                onPressed: () {
                  Get.to(SSSFilter(token: authToken));
                },
                icon: const Icon(Icons.filter_list_outlined)),
            if (sssp.isFlrApplied)
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
      bottom: sssp.isFlrApplied
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
                    if (sssp.selectedAgent != null)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(SSSFilter(
                                  token: sssp.token, selectedIndex: 0));
                            },
                            child: Chip(
                              deleteIcon: const Icon(Icons.clear),
                              label: sssp.role != UserType.admin.name
                                  ? Text(sssp.agentsByTeamList
                                      .firstWhere((element) => element.agents!
                                          .any((ele) =>
                                              ele.id == sssp.selectedAgent))
                                      .name!)
                                  : Text(sssp.agentsByIdList
                                      .firstWhere((element) =>
                                          element.id == sssp.selectedAgent)
                                      .name!),
                              onDeleted: () async {
                                setState(() {
                                  sssp.selectedAgent = null;
                                });
                                await sssp.applyFilter(sssp);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    if (sssp.fromDate != null || sssp.toDate != null)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(SSSFilter(
                                  token: sssp.token, selectedIndex : 1));
                            },
                            child: Chip(
                              deleteIcon: const Icon(Icons.clear),
                              // deleteIconColor: Colors.red,
                              label: Text(
                                  sssp.fromDate != null && sssp.toDate != null
                                      ? DateFormat('yyyy-MM-dd')
                                      .format(sssp.fromDate!) +
                                      '  To  ' +
                                      DateFormat('yyyy-MM-dd')
                                          .format(sssp.toDate!)
                                      : sssp.fromDate != null
                                      ? DateFormat('yyyy-MM-dd')
                                      .format(sssp.fromDate!)
                                      : sssp.toDate != null
                                      ? '  To  ' +
                                      DateFormat('yyyy-MM-dd')
                                          .format(sssp.toDate!)
                                      : ''),
                              onDeleted: () async {
                                setState(() {
                                  sssp.fromDate = null;
                                  sssp.toDate = null;
                                });
                                await sssp.applyFilter(sssp);
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

class SSSCard extends StatefulWidget {
  const SSSCard({Key? key, required this.lp}) : super(key: key);
  final SSSProvider lp;

  @override
  State<SSSCard> createState() => _SSSCardState();
}

class _SSSCardState extends State<SSSCard> {
  bool isVisible = false;
  var whatsapp;

  @override
  Widget build(BuildContext context) {
    if (widget.lp.sssByDate.isNotEmpty) {
      return ListView(
        controller: widget.lp.controller,
        physics: const BouncingScrollPhysics(),
        children: [
          ...widget.lp.sssByDate.map((e) {
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
                      var isSelected = widget.lp.selectedLeads
                          .any((element) => element.leadId == sss.leadId);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 3),
                        child: GestureDetector(
                          onLongPress: () {
                            if (widget.lp.role == UserType.admin.name) {
                              if (!widget.lp.selectionMode) {
                                setState(() {
                                  // widget.lp.setSelectionMode(true);
                                  // widget.lp.setSelectedLeads(lead);
                                });
                              }
                            } else {
                              print('Your role is ${widget.lp.role}');
                            }
                          },
                          onTap: () {
                            if (!widget.lp.selectionMode) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SurveyReviewPage(
                                    sss: sss,
                                    // leadId: lead.leadId.toString(),
                                  ),
                                ),
                              );
                            } else {
                              // widget.lp.setSelectedLeads(sss);
                              if (widget.lp.selectedLeads.isEmpty) {
                                widget.lp.selectionMode = false;
                                setState(() {});
                              }
                            }
                          },
                          child: Card(
                            elevation: 3,
                            shadowColor: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: isSelected
                                ? const Color(0xC3B7DBF5)
                                : Colors.white,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                // border: Border.all(color: Colors.grey),
                              ),
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
                                              // Row(
                                              //   children: [
                                              //     const Text('Lead ID : ',
                                              //         style: TextStyle(
                                              //             fontSize: 16,
                                              //             overflow: TextOverflow
                                              //                 .ellipsis),
                                              //         overflow:
                                              //         TextOverflow.ellipsis),
                                              //     Expanded(
                                              //       child: Text(
                                              //         lead.leadId.toString(),
                                              //         style: const TextStyle(
                                              //             fontSize: 20,
                                              //             overflow: TextOverflow
                                              //                 .ellipsis),
                                              //         overflow:
                                              //         TextOverflow.ellipsis,
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                              Text(sss.fname!,
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
                                                    Text(
                                                      'Sold By :'.capitalize!,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        sss.agentName ?? '',
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 7),
                                              SizedBox(
                                                // width: 180,
                                                child: Row(
                                                  children: [
                                                    const Text(
                                                      'Purchased On :',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        sss.onboardingDate!,
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
                                              const SizedBox(height: 7),
                                              SizedBox(
                                                // width: 180,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'DATE OF SALE :'
                                                          .capitalize!,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        sss.createdAt!
                                                            .split('T')
                                                            .first,
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
                                              const SizedBox(height: 7),
                                              SizedBox(
                                                // width: 180,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Delivered On :'
                                                          .capitalize!,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        sss.createdAt!
                                                            .split('T')
                                                            .first,
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
                                  const SizedBox(
                                    height: 10,
                                  ),
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
        child: Text('Surveys not available.'),
      );
    }
  }
}

class SSSFilter extends StatefulWidget {
  const SSSFilter({
    Key? key,
    required this.token,
    this.selectedIndex,
  }) : super(key: key);
  final String token;
  final int? selectedIndex;

  @override
  State<SSSFilter> createState() => _SSSFilterState();
}

class _SSSFilterState extends State<SSSFilter> {
  int selectedIndex = 0;

  List<AgentsByTeam> agentsByTeamList = [];
  List<AgentById> agentsByIdList = [];

  void init() {
    var lp = Provider.of<SSSProvider>(context, listen: false);
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
    return Consumer<SSSProvider>(builder: (context, lp, _) {
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
                                  if(lp.role==UserType.admin.name)
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
                                                    int.parse(e.id!), e.name!))
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
                        disabledBackgroundColor:  const Color(0xABA4A3A3),
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

  ListView filterLeftSection(SSSProvider lp) {
    return ListView(
      children: [
        ...lp.categoriesList.map(
          (e) => Column(
            children: [
              Stack(
                children: [
                  ListTile(
                    tileColor: selectedIndex == lp.categoriesList.indexOf(e)
                        ? themeColor.withOpacity(0.1)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedIndex = lp.categoriesList.indexOf(e);
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
                                        lp.categoriesList.indexOf(e)
                                    ? Get.theme.primaryColor
                                    : null),
                          ),
                        ],
                      ),
                    ),
                    trailing: Text(
                      e == lp.categoriesList[0] && lp.selectedAgent != null
                          ? 1.toString()
                          : e == lp.categoriesList[1] &&
                                  (lp.fromDate != null || lp.toDate != null)
                              ? '🔘'
                              : '',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        color: selectedIndex == lp.categoriesList.indexOf(e)
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
