import 'package:crm_application/Screens/Cold%20Calls/MyLeads/TestCallDetailsScreen/EditScheduledCall.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Provider/LeadsProvider.dart';
import 'ScheduleACallBack.dart';

class ScheduledCall extends StatefulWidget {
  const ScheduledCall(
      {Key? key,
      required this.authToken,
      required this.leadId,
      required this.leadType})
      : super(key: key);

  final String authToken;
  final String leadId;
  final String leadType;
  @override
  State<ScheduledCall> createState() => _ScheduledCallState();
}

class _ScheduledCallState extends State<ScheduledCall> {
  void getScheduledList() async {
    print('Scheduled call page');
    await Provider.of<LeadsProvider>(context, listen: false)
        .getLeadsHistory(widget.authToken, widget.leadId);
    print('Scheduled call page');

    print('leadid-->${widget.leadId}');
  }

  @override
  void initState() {
    super.initState();
    getScheduledList();
  }

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    return Scaffold(
      // backgroundColor: Colors.grey,
      body: Consumer<LeadsProvider>(
        builder: (context, leadsProvider, child) {
          debugPrint(leadsProvider.LeadsUserHistory.length.toString());
          debugPrint(
              'Scheduled call ---> ${leadsProvider.IsLoading.toString()}');
          return Stack(
            children: [
              ListView.builder(
                  itemCount: leadsProvider.LeadsUserHistory.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                          top: 15,
                          bottom:
                              index == leadsProvider.LeadsUserHistory.length - 1
                                  ? 50
                                  : 0),
                      child: Container(
                        // height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: const Color(0x34CFFAD6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                          text: 'Plan To Do : ',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black87),
                                          children: [
                                            TextSpan(
                                              text: leadsProvider
                                                  .LeadsUserHistory[index]
                                                  .planToDo!,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ]),
                                    ),
                                    // Text(
                                    //   'Plan To Do : ' +
                                    //       leadsProvider
                                    //           .LeadsUserHistory[index].planToDo!,
                                    //   style: const TextStyle(fontSize: 15),
                                    // ),
                                    Text(
                                      'Schedule-Date : ' +
                                          leadsProvider.LeadsUserHistory[index]
                                              .scheduleDate!,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      'Schedule-Time : ' +
                                          leadsProvider.LeadsUserHistory[index]
                                              .scheduleTime!,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    leadsProvider.LeadsUserHistory[index]
                                                .comment ==
                                            null
                                        ? const Text(
                                            'Comment :   ---',
                                            style: TextStyle(fontSize: 15),
                                          )
                                        : RichText(
                                            text: TextSpan(
                                                text: 'Comment : ',
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black54),
                                                children: [
                                                  TextSpan(
                                                    text: leadsProvider
                                                        .LeadsUserHistory[index]
                                                        .comment!,
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black54),
                                                  )
                                                ]),
                                          ),
                                  ],
                                ),
                              ),
                              // if(widget.leadType=='lead')
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      debugPrint(leadsProvider
                                          .LeadsUserHistory[index].id
                                          .toString());
                                      debugPrint(leadsProvider
                                          .LeadsUserHistory[index].leadId
                                          .toString());
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Are you sure to cancel the event?'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    child: const Text('No')),
                                                InkWell(
                                                    onTap: () async {
                                                      await Provider.of<
                                                                  LeadsProvider>(
                                                              context,
                                                              listen: false)
                                                          .deleteScheduledLeads(
                                                              widget.authToken,
                                                              leadsProvider
                                                                  .LeadsUserHistory[
                                                                      index]
                                                                  .id
                                                                  .toString(),
                                                              context)
                                                          .then((value) =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop())
                                                          .then((value) async {
                                                        await Provider.of<
                                                                    LeadsProvider>(
                                                                context,
                                                                listen: false)
                                                            .getLeadsHistory(
                                                                widget
                                                                    .authToken,
                                                                widget.leadId);
                                                        // Navigator.of(context).pop();
                                                      });
                                                    },
                                                    child: const Text(
                                                        'I\'m sure!')),
                                              ],
                                            );
                                          });

                                      // await Provider.of<LeadsProvider>(context,
                                      //         listen: false)
                                      //     .deleteScheduledLeads(
                                      //         widget.authToken,
                                      //         leadsProvider
                                      //             .LeadsUserHistory[index].id
                                      //             .toString(),
                                      //         context)
                                      //     .then((value) async {
                                      //   await Provider.of<LeadsProvider>(context,
                                      //           listen: false)
                                      //       .getLeadsHistory(
                                      //           widget.authToken, widget.leadId);
                                      // Navigator.of(context).pop();
                                      // });
                                      // print(widget.authToken);
                                    },
                                    child: Image.asset(
                                      'assets/images/delete.png',
                                      width: 30,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showCupertinoModalPopup(
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.7,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20),
                                                    bottomLeft:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20),
                                                  ),
                                                  color: Colors.white,
                                                ),
                                                child: EditScheduledCall(
                                                    leadHistory: leadsProvider
                                                            .LeadsUserHistory[
                                                        index],
                                                    authToken:
                                                        widget.authToken),
                                              ),
                                            );
                                          });
                                    },
                                    child: Image.asset(
                                      'assets/images/addNote.png',
                                      width: 27,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
              // if (widget.leadType=='lead'&&s.height < 700)
              if (s.height < 700)
                Positioned(
                  bottom: 110,
                  right: 10,
                  // alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                  color: Colors.white,
                                ),
                                child: ScheduleACallBack(
                                  leadId: widget.leadId,
                                  authToken: widget.authToken,
                                ),
                              ),
                            );
                          });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 9.0,
                          ),
                        ],
                      ),
                      height: 50,
                      width: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Schedule A Call',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
            ],
          );
        },
      ),
      floatingActionButton:
      // widget.leadType!='lead'?null:
      s.height > 700
          ? InkWell(
              onTap: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          child: ScheduleACallBack(
                            leadId: widget.leadId,
                            authToken: widget.authToken,
                          ),
                        ),
                      );
                    });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 9.0,
                    ),
                  ],
                ),
                height: 50,
                width: 200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Schedule A Call',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container(),
    );
  }
}
