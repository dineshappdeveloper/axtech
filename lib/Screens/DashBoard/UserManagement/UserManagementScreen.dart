import 'package:crm_application/Screens/DashBoard/UserManagement/AddUser.dart';
import 'package:crm_application/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'EditUser.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        backgroundColor: themeColor,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(AddUser());
              },
              icon: const Icon(Icons.person_add_alt_1_rounded)),
          Stack(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const FaIcon(FontAwesomeIcons.filter)),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  height: 5,
                  width: 5,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.red),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: ListView(
        children: [
          ...[1, 2, 3, 4, 5, 6, 7, 8, 9].map((e) {
            var cardTextColor = Colors.black;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Row(
                    children: [
                      SizedBox(width: Get.width / 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.to(const EditUser());
                          },
                          child: Card(
                            elevation: 10,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xF5FCFDFF),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 28.0,
                                  top: 8,
                                  right: 8,
                                  bottom: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        // SizedBox(width: Get.width / 17),
                                        Expanded(
                                          child: Text(
                                            'Chandan Kumar Singh Chandan Kumar Singh Chandan Kumar Singh ',
                                            // textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: Get.textTheme.bodyText1!
                                                .copyWith(
                                              color: cardTextColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        PopupMenuButton<int>(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          onSelected: (val) {
                                            if (val == 1) {
                                              setState(() {
                                                isActive = !isActive;
                                              });
                                            }
                                          },
                                          itemBuilder: (context) {
                                            return [
                                              PopupMenuItem(
                                                  value: 1,
                                                  child: Row(
                                                    children: const [
                                                      Icon(
                                                        Icons
                                                            .thumb_up_off_alt_rounded,
                                                        color: Colors.blue,
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text('Convert To Active')
                                                    ],
                                                  )),
                                              PopupMenuItem(
                                                  value: 2,
                                                  child: Row(
                                                    children: const [
                                                      Icon(
                                                        Icons
                                                            .volunteer_activism_sharp,
                                                        color: Colors.red,
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text('Activity')
                                                    ],
                                                  )),
                                              PopupMenuItem(
                                                  value: 3,
                                                  child: Row(
                                                    children: const [
                                                      Icon(
                                                        Icons.send,
                                                        color: Colors.green,
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text('Resend Password')
                                                    ],
                                                  )),
                                              PopupMenuItem(
                                                  value: 4,
                                                  child: Row(
                                                    children: [
                                                      FaIcon(
                                                        FontAwesomeIcons.edit,
                                                        color: cardTextColor,
                                                      ),
                                                      const SizedBox(width: 10),
                                                      const Text('Edit')
                                                    ],
                                                  )),
                                              PopupMenuItem(
                                                  value: 5,
                                                  child: Row(
                                                    children: const [
                                                      Icon(
                                                        Icons.delete_outlined,
                                                        color: Colors.red,
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text('Delete')
                                                    ],
                                                  )),
                                            ];
                                          },
                                          child: Icon(
                                            Icons.more_vert,
                                            color: cardTextColor,
                                          ),
                                        ),
                                      ],
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        SizedBox(width: Get.width / 13),
                                        Text(
                                          'DESIGNATION :'.capitalize!,
                                          style:
                                              Get.textTheme.bodyText1!.copyWith(
                                            color: cardTextColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            'Chandan Kumar Singh',
                                            style: Get.textTheme.bodyText1!
                                                .copyWith(
                                              color: cardTextColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 7),
                                    Row(
                                      children: [
                                        SizedBox(width: Get.width / 10),
                                        Text(
                                          'EMAIL :'.capitalize!,
                                          style:
                                              Get.textTheme.bodyText1!.copyWith(
                                            color: cardTextColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            'rishmal@range.ae',
                                            style: Get.textTheme.bodyText1!
                                                .copyWith(
                                              color: cardTextColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 7),
                                    Row(
                                      children: [
                                        SizedBox(width: Get.width / 10),
                                        Text(
                                          'MOBILE NO. :'.capitalize!,
                                          style:
                                              Get.textTheme.bodyText1!.copyWith(
                                            color: cardTextColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            '971524402816',
                                            style: Get.textTheme.bodyText1!
                                                .copyWith(
                                              color: cardTextColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 7),
                                    Row(
                                      children: [
                                        SizedBox(width: Get.width / 13),
                                        Text(
                                          'ROLE :'.capitalize!,
                                          style:
                                              Get.textTheme.bodyText1!.copyWith(
                                            color: cardTextColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            'Agent',
                                            style: Get.textTheme.bodyText1!
                                                .copyWith(
                                              color: cardTextColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 7),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // SizedBox(width: Get.width / 17),
                                        Text(
                                          'Cold Calls : ${8}'.capitalize!,
                                          style:
                                              Get.textTheme.bodyText1!.copyWith(
                                            color: cardTextColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Leads : ${100}',
                                          style:
                                              Get.textTheme.bodyText1!.copyWith(
                                            color: cardTextColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          isActive
                                              ? '( Active )'
                                              : '( InActive )',
                                          style:
                                              Get.textTheme.bodyText1!.copyWith(
                                            color: isActive
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 7),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Positioned(
                      top: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        radius: Get.width / 9 + 5,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: Get.width / 9,
                          backgroundColor: Colors.blueAccent,
                          backgroundImage: const AssetImage(
                            'assets/user.png',
                          ),
                        ),
                      ))
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}
