import 'dart:core';

import 'package:crm_application/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Provider/ColdCallProvider.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key, required this.authToken}) : super(key: key);
  final String authToken;
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<bool> expansionList = [];
  List<int> listToDelete = [];
  bool doubleTapOn = false;

  void getNotifications() async {
    await Provider.of<ColdCallProvider>(context, listen: false)
        .getDeviceNotifications(widget.authToken, context);
    expansionList = List.generate(
        Provider.of<ColdCallProvider>(context, listen: false)
            .notifications
            .length,
        (index) => false);
  }

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ColdCallProvider>(
      builder: (key, provider, child) {
        // print(provider.notifications.length);

        return Scaffold(
          backgroundColor: const Color(0xFFE6E8E8),
          appBar: AppBar(
            backgroundColor: themeColor,
            title: const Text('Notifications'),
            actions: [
              doubleTapOn
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: InkWell(
                        onTap: () async {
                          // print('started');
                          int length = listToDelete.length;
                          await provider
                              .deleteDeviceNotifications(
                                  widget.authToken, listToDelete, context)
                              .then((value) async =>
                                  await provider.getDeviceNotifications(
                                      widget.authToken, context));
                          listToDelete.toList().forEach((element) {
                            debugPrint(element.toString());
                            setState(() {
                              // list.removeAt(element);
                              debugPrint(
                                  'Notification deleted at index $element');
                            });
                          });
                          setState(() {
                            doubleTapOn = false;
                          });
                          listToDelete.clear();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  '$length Notifications deleted successfully! 😍😍😍')));
                        },
                        child:
                            Image.asset('assets/images/delete.png', width: 25),
                      ),
                    )
                  : Container(),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications_active,
                        )),
                  ),
                  Positioned(
                      top: 0,
                      right: 10,
                      child: Container(
                        constraints:
                            const BoxConstraints(minHeight: 22, minWidth: 22),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.red),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Center(
                              child: Text(provider.notifications.length < 10
                                  ? provider.notifications.length.toString()
                                  : '${provider.notifications.length}+')),
                        ),
                      )),
                ],
              )
            ],
          ),
          body: ListView.builder(
            itemCount: provider.notifications.length,
            itemBuilder: (context, index) {
              // bool expanded = false;
              // print(expansionList[index]);
              // print(provider.notifications[index].message!.length);
              // var message =
              //     'provider.notifications[index].message! provider.notifications[index].m essage!prov ider. notificatio ns[index].mes sage!';
              // print(message.length);
              return Padding(
                padding: listToDelete.contains(provider.notifications[index].id)
                    ? const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8)
                    : const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onLongPress: () {
                    if (!doubleTapOn) {
                      setState(() {
                        doubleTapOn = true;
                        if (!listToDelete
                            .contains(provider.notifications[index].id)) {
                          listToDelete.add(provider.notifications[index].id!);
                        }
                      });
                    }
                  },
                  onTap: () {
                    if (doubleTapOn) {
                      setState(() {
                        // doubleTapOn = true;
                        if (listToDelete
                            .contains(provider.notifications[index].id)) {
                          listToDelete.remove(provider.notifications[index].id);
                          if (listToDelete.isEmpty) {
                            setState(() {
                              doubleTapOn = false;
                            });
                          }
                        } else {
                          listToDelete.add(provider.notifications[index].id!);
                          // if (listToDelete.length == 15) {
                          //   setState(() {
                          //     doubleTapOn = false;
                          //   });
                          // }
                        }
                      });
                      debugPrint(listToDelete.length.toString());
                    } else {
                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      //     content:
                      //         Text('Please press and hold for start selection.')));

                      if (provider.notifications[index].message!.length > 80) {
                        setState(() {
                          expansionList[index] = !expansionList[index];
                          // expanded = !expanded;
                        });
                      }
                      // print(expansionList[index]);
                    }
                  },
                  child: Container(
                    // height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: listToDelete
                              .contains(provider.notifications[index].id)
                          ? const Color(0xE2C3E4FF)
                          : Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // index.isOdd
                          //     ? Padding(
                          //         padding:
                          //             const EdgeInsets.symmetric(horizontal: 8.0),
                          //         child: Image.asset(
                          //           'assets/images/call_icon.png',
                          //           color: Colors.green,
                          //           width: 40,
                          //         ),
                          //       )
                          //     :
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: expansionList[index] ? 15.h : 32.h,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Container(
                                  child: Icon(
                                    Icons.notifications_none_rounded,
                                    color: themeColor,
                                    // Image.asset(
                                    //   'assets/images/notification.png',
                                    //   color: Colors.blueGrey,
                                    //   width: 35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // const Icon(
                                    //   Icons.access_time,
                                    //   size: 11,
                                    // ),
                                    // const SizedBox(width: 3),
                                    Row(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat('dd-MM-yyyy').format(
                                              provider.notifications[index]
                                                  .createdAt),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          DateFormat.jm().format(provider
                                              .notifications[index].createdAt),
                                          // ${list[index].isEven}
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0.0, top: 5),
                                  child: Text(
                                    provider.notifications[index].title!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0.0, top: 5),
                                  child: RichText(
                                    // '${provider.notifications[index].message!.split('').getRange(0, 20).join('')} '
                                    text: TextSpan(
                                      text:
                                          // message,
                                          // '${message.length}'
                                          '${provider.notifications[index].message!.split('').length > 100 && !expansionList[index] ? provider.notifications[index].message!.split('').getRange(0, 80).join('') : provider.notifications[index].message!}',
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black54),
                                      children: [
                                        TextSpan(
                                          text: provider.notifications[index]
                                                          .message!.length >
                                                      110 &&
                                                  !expansionList[index]
                                              ? '...'
                                              : '',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            // color: Colors.blue[300],
                                          ),
                                        ),
                                      ],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: expansionList[index] ? 20 : 2,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      provider.notifications[index].message!
                                                      .length >
                                                  110 &&
                                              !expansionList[index]
                                          ? ' Read More...'
                                          : '',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.blue[300]),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      expansionList[index]
                                          ? '⬆ Show Less...   '
                                          : '',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red[300],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
