import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:crm_application/Models/SSSModel.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/LeadFilter/Models/agentsModel.dart';
import 'package:crm_application/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rating/rating.dart';

import '../MyLeadScreen.dart';

class SurveyReviewPage extends StatefulWidget {
  const SurveyReviewPage({Key? key, required this.sss}) : super(key: key);
  final SSSModel sss;

  @override
  State<SurveyReviewPage> createState() => _SurveyReviewPageState();
}

class _SurveyReviewPageState extends State<SurveyReviewPage> {
  PageController controller = PageController();
  double topBoxRate = 0.0;
  // double netPromoterRate = 0.0;
  double currentPageValue = 0.0;
  int netPromoterRate = 0;
  TextEditingController address = TextEditingController();
  String? propertyUsedBy;
  final TextEditingController _name1 = TextEditingController();
  final TextEditingController _email1 = TextEditingController();
  final TextEditingController _contact1 = TextEditingController();
  final TextEditingController _name2 = TextEditingController();
  final TextEditingController _email2 = TextEditingController();
  final TextEditingController _contact2 = TextEditingController();
  final TextEditingController _comments = TextEditingController();
  bool wantUseRPMS = false;
  Map<String, dynamic> data = {};
  late SSSModel sss;
  @override
  void initState() {
    super.initState();
    sss = widget.sss;
    initForm();
    controller.addListener(() {
      setState(() {
        currentPageValue = controller.page!;
      });
    });
  }

  void initForm() {
    if (sss.surveyData != null) {
      if (sss.surveyData!.topBoxRate != null) {
        topBoxRate = double.parse(sss.surveyData!.topBoxRate!);
      }
      if (sss.surveyData!.netPromoterRate != null) {
        netPromoterRate = int.parse(sss.surveyData!.netPromoterRate!);
      }
      if (sss.surveyData!.currentAddress != null) {
        address.text = sss.surveyData!.currentAddress!;
      }
      if (sss.surveyData!.propertyBeingUsed != null) {
        propertyUsedBy = sss.surveyData!.propertyBeingUsed!;
      }

      if (sss.surveyData!.rangeProperty != null) {
        wantUseRPMS = sss.surveyData!.rangeProperty == 'Yes' ? true : false;
      }
      if (sss.surveyData!.nameOne != null) {
        _name1.text = sss.surveyData!.nameOne!;
      }
      if (sss.surveyData!.emailOne != null) {
        _email1.text = sss.surveyData!.emailOne!;
      }
      if (sss.surveyData!.contactOne != null) {
        _contact1.text = sss.surveyData!.contactOne!;
      }
      if (sss.surveyData!.nameTwo != null) {
        _name2.text = sss.surveyData!.nameTwo!;
      }
      if (sss.surveyData!.emailTwo != null) {
        _email2.text = sss.surveyData!.emailTwo!;
      }
      if (sss.surveyData!.contactTwo != null) {
        _contact2.text = sss.surveyData!.contactTwo!;
      }
      if (sss.surveyData!.comments != null) {
        _comments.text = sss.surveyData!.comments!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(sss.address);
    return Scaffold(
      appBar: AppBar(
          title: const Text('Service Satisfaction Survey'),
          backgroundColor: themeColor),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Details :',
                  style: Get.theme.textTheme.headline5!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Customer Name',
                      style: Get.theme.textTheme.bodyText1!
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Text(
                      sss.fname ?? '',
                      style: Get.theme.textTheme.bodyText1!
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Property Purchase Date:',
                      style: Get.theme.textTheme.bodyText1!
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Text(
                      sss.onboardingDate ?? '',
                      style: Get.theme.textTheme.bodyText1!
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Salesperson Name',
                      style: Get.theme.textTheme.bodyText1!
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Text(
                      sss.agentName ?? '',
                      style: Get.theme.textTheme.bodyText1!
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date of Sale',
                      style: Get.theme.textTheme.bodyText1!
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Text(
                      sss.createdAt!.split('T').first,
                      style: Get.theme.textTheme.bodyText1!
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date of Salesperson Contact',
                      style: Get.theme.textTheme.bodyText1!
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Text(
                      sss.dateOfClientMeeting!.split('T').first,
                      style: Get.theme.textTheme.bodyText1!
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Project Delivered',
                      style: Get.theme.textTheme.bodyText1!
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Text(
                      sss.createdAt!.split('T').first,
                      style: Get.theme.textTheme.bodyText1!
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Data Collected :',
                  style: Get.theme.textTheme.headline5!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
              child: PageView.builder(
            pageSnapping: true,
            controller: controller,
            itemBuilder: (context, position) {
              if (position == currentPageValue.floor()) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX(currentPageValue - position)
                    ..rotateY(currentPageValue - position)
                    ..rotateZ(currentPageValue - position),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        // color: themeColor,
                        color: position == 0
                            ? const Color(0xF20B3793)
                            : position == 1
                                // ? const Color(0xFF04910B)
                                ? const Color(0xFF011B54)
                                : position == 2
                                    // ? const Color(0xFFA29B04)
                                    ? const Color(0xD0010F3A)
                                    : position == 3
                                        // ? const Color(0xFF500665)
                                        ? const Color(0xFF300665)
                                        : position == 4
                                            // ? const Color(0xFF069DA2)
                                            ? const Color(0xFF050142)
                                            // : const Color(0xDFFA1010),
                                            : const Color(0xDF010823),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: position == 0
                              ? form1()
                              : position == 1
                                  ? form2()
                                  : position == 2
                                      ? form3()
                                      : position == 3
                                          ? form4()
                                          : position == 4
                                              ? form5()
                                              : position == 5
                                                  ? form6()
                                                  : form7(),
                        ),
                      ),
                    ),
                  ),
                );
              } else if (position == currentPageValue.floor() + 1) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX(currentPageValue - position)
                    ..rotateY(currentPageValue - position)
                    ..rotateZ(currentPageValue - position),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        color: position == 0
                            ? const Color(0xFF5019F5)
                            : position == 1
                                ? const Color(0xFF04910B)
                                : position == 2
                                    ? const Color(0xFFA29B04)
                                    : position == 3
                                        ? const Color(0xFF500665)
                                        : position == 4
                                            ? const Color(0xFF069DA2)
                                            : const Color(0xFFC00404),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: position == 0
                              ? form1()
                              : position == 1
                                  ? form2()
                                  : position == 2
                                      ? form3()
                                      : position == 3
                                          ? form4()
                                          : position == 4
                                              ? form5()
                                              : position == 5
                                                  ? form6()
                                                  : form7(),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      color: position == 0
                          ? const Color(0xFF5019F5)
                          : position == 1
                              ? const Color(0xFF04910B)
                              : position == 2
                                  ? const Color(0xFFA29B04)
                                  : position == 3
                                      ? const Color(0xFF500665)
                                      : position == 4
                                          ? const Color(0xFF069DA2)
                                          : const Color(0xFFC00404),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: position == 0
                            ? form1()
                            : position == 1
                                ? form2()
                                : position == 2
                                    ? form3()
                                    : position == 3
                                        ? form4()
                                        : position == 4
                                            ? form5()
                                            : position == 5
                                                ? form6()
                                                : form7(),
                      ),
                    ),
                  ),
                );
              }
            },
            itemCount: 7,
            padEnds: false,
          )),
          SizedBox(height: 30),
        ],
      ),
      // bottomNavigationBar: Container(
      //   color: Colors.transparent,
      //   height: 80,
      //   child: Column(
      //     children: [
      //       const SizedBox(height: 20),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: [
      //           FloatingActionButton.extended(
      //               onPressed: () {
      //                 Future.delayed(const Duration(seconds: 1), () {
      //                   AwesomeDialog(
      //                     dismissOnBackKeyPress: true,
      //                     dismissOnTouchOutside: false,
      //                     context: Get.context!,
      //                     dialogType: DialogType.success,
      //                     animType: AnimType.rightSlide,
      //                     title: '\n\n Updated Successfully\n',
      //                     // body: Image.asset('assets/images/delete.png'),
      //                     autoHide: const Duration(seconds: 2),
      //                   ).show();
      //                 })
      //                     .then((value) => null)
      //                     .then((value) => Timer(Duration(seconds: 1), () {
      //                           Get.back();
      //                         }));
      //               },
      //               label: const Text('Update'),
      //               icon: const Icon(Icons.thumb_up),
      //               backgroundColor: Colors.green),
      //           FloatingActionButton.extended(
      //               onPressed: () {},
      //               label: const Text('Go Back'),
      //               icon: const FaIcon(FontAwesomeIcons.cancel),
      //               backgroundColor: Colors.red),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Widget form1() {
    print(sss.surveyData);
    // final ratingModel = RatingModel(
    //   id: 1,
    //   title: '(1) How happy were you with the service provided by Sakshi Kumar',
    //   subtitle: null,
    //   ratingConfig: RatingConfigModel(
    //     id: 1,
    //     ratingSurvey1: 'Bad',
    //     ratingSurvey2: 'Not Good',
    //     ratingSurvey3: 'Good',
    //     ratingSurvey4: 'Very Good',
    //     ratingSurvey5: 'Superb',
    //     items: [],
    //   ),
    // );
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Expanded(
                child: Text(
                    '1) How happy were you with the service provided by Sakshi Kumar?',
                    style: Get.textTheme.headline5!
                        .copyWith(color: Colors.white))),
          ],
        ),

        // RatingWidget(controller: PrintRatingController(ratingModel)),
        RatingBar.builder(
          initialRating: topBoxRate,
          itemCount: 5,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return const Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                );
              case 1:
                return const Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.redAccent,
                );
              case 2:
                return const Icon(
                  Icons.sentiment_neutral,
                  color: Colors.amber,
                );
              case 3:
                return const Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.lightGreen,
                );
              default:
                return const Icon(
                  Icons.sentiment_very_satisfied,
                  color: Colors.green,
                );
            }
          },
          onRatingUpdate: (rating) {
            print(rating);
            setState(() {
              topBoxRate = rating;
            });
            data.addAll({'rating': rating});
            print(data);
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget form2() {
    int count = 10;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Expanded(
                child: Text(
                    '2) How likely are you to recommend Range to you friends and family ?',
                    style: Get.textTheme.headline5!
                        .copyWith(color: Colors.white))),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: count,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      netPromoterRate = index + 1;
                      data.addAll({'recommendationValue': netPromoterRate});
                      print(data);
                    });
                    // print('Will Recommend to ${index + 1}');
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: netPromoterRate == index + 1
                            ? Colors.white.withOpacity(0.8)
                            : Colors.pink.withOpacity(0.1 * index + 0.1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text('${index + 1}',
                            style: Get.textTheme.headline5!.copyWith(
                                color: netPromoterRate == index + 1
                                    ? Colors.black
                                    : Colors.white))),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget form3() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                      '3) Collect current address to send the gift to (Personalized Diary)',
                      style: Get.textTheme.headline5!
                          .copyWith(color: Colors.white))),
            ],
          ),
          const SizedBox(height: 30),
          TextFormField(
            controller: address,
            style: const TextStyle(color: Colors.white, fontSize: 22),
            maxLines: 10,
            decoration: const InputDecoration(
              hintText: 'Address',
              hintStyle: TextStyle(color: Colors.white38),
              border: OutlineInputBorder(
                // borderSide: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                // borderSide: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                // borderSide: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
            ),
            onChanged: (val) {
              data.addAll({'address': address.text});
              print(data);
            },
          ),
        ],
      ),
    );
  }

  Widget form4() {
    final GlobalKey<FormState> _key = GlobalKey<FormState>();
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text('4) Confirm if the property is being used by',
                      style: Get.textTheme.headline5!
                          .copyWith(color: Colors.white))),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    propertyUsedBy != null
                        ? propertyUsedBy!.capitalize!
                        : 'Select',
                    style:
                        Get.textTheme.headline5!.copyWith(color: Colors.white)),
                PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Text('Owner'),
                        value: 'owner',
                      ),
                      PopupMenuItem(
                        child: Text('Vacant'),
                        value: 'vacant',
                      ),
                      PopupMenuItem(
                        child: Text('Rented'),
                        value: 'rented',
                      ),
                    ];
                  },
                  onSelected: (val) {
                    setState(() {
                      propertyUsedBy = val;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // TestPage(
          //   list: [
          //     ...[
          //       {1: 'Owner'},
          //       {2: 'Vacant'},
          //       {3: 'Rented'}
          //     ]
          //         .map((e) => AgentById(
          //             id: e.entries.first.key.toString(),
          //             name: e.entries.first.value))
          //         .toList()
          //   ],
          //   textColor: Colors.white,
          //   formKey: _key,
          //   onTap: (id) {
          //     // setState(() {
          //
          //     print('property is being used by $id');
          //     data.addAll({'used_by': id});
          //     print(data);
          //     // });
          //   },
          //   title: '',
          // ),
        ],
      ),
    );
  }

  Widget form5() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                      '5) Would you like to use Range property management service?',
                      style: Get.textTheme.headline5!
                          .copyWith(color: Colors.white))),
            ],
          ),
          const SizedBox(height: 30),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  RadioListTile<bool>(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      tileColor: Colors.green,
                      activeColor: Colors.white,
                      title: const Text('Yes'),
                      value: true,
                      groupValue: wantUseRPMS,
                      onChanged: (val) {
                        setState(() {
                          wantUseRPMS = val!;
                        });
                        data.addAll({'wantToUse': wantUseRPMS});
                        print(data);
                      }),
                  const SizedBox(height: 20),
                  RadioListTile<bool>(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      tileColor: Colors.red,
                      activeColor: Colors.white,
                      // selected: wantUseRPMS,
                      title: const Text(
                        'No',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: false,
                      groupValue: wantUseRPMS,
                      onChanged: (val) {
                        setState(() {
                          wantUseRPMS = val!;
                        });
                        data.addAll({'wantToUse': wantUseRPMS});
                        print(data);
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget form6() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                      '6) Request 2 referrals, provide them details of Referral program',
                      style: Get.textTheme.headline5!
                          .copyWith(color: Colors.white))),
            ],
          ),
          const SizedBox(height: 30),
          Text('Referral 1',
              style: Get.textTheme.headline5!.copyWith(color: Colors.white)),
          const SizedBox(height: 10),
          SurvayAddReferal(
            name: _name1,
            email: _email1,
            contact: _contact1,
            onChange: (name, email, contact) {
              data.addAll({
                'referral_1': {'name': name, 'email': email, 'contact': contact}
              });
              print(data);
            },
          ),
          const SizedBox(height: 30),
          Text('Referral 2',
              style: Get.textTheme.headline5!.copyWith(color: Colors.white)),
          const SizedBox(height: 10),
          SurvayAddReferal(
            name: _name2,
            email: _email2,
            contact: _contact2,
            onChange: (name, email, contact) {
              data.addAll({
                'referral_2': {'name': name, 'email': email, 'contact': contact}
              });
              print(data);
            },
          ),
        ],
      ),
    );
  }

  Widget form7() {
    final TextEditingController _name = TextEditingController();
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text('Extra Comment',
                      style: Get.textTheme.headline5!
                          .copyWith(color: Colors.white))),
            ],
          ),
          const SizedBox(height: 30),
          CustomTextFieldSurveyPage(
            maxLines: 10,
            hint: 'Referrals will be provided to Shakshi Kumar',
            controller: _comments,
            onChange: (String? val) {
              data.addAll({'extra_comment': val});
              print(data);
            },
          ),
        ],
      ),
    );
  }
}

class SurvayAddReferal extends StatelessWidget {
  SurvayAddReferal({
    Key? key,
    required this.onChange,
    required this.name,
    required this.email,
    required this.contact,
  }) : super(key: key);

  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController contact;
  final void Function(String name, String email, String contact) onChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFieldSurveyPage(
          hint: 'Name',
          controller: name,
          onChange: (String? val) {
            onChange(name.text, email.text, contact.text);
          },
        ),
        const SizedBox(height: 15),
        CustomTextFieldSurveyPage(
          hint: 'Email',
          controller: email,
          onChange: (String? val) {
            onChange(name.text, email.text, contact.text);
          },
        ),
        const SizedBox(height: 15),
        CustomTextFieldSurveyPage(
          hint: 'Contact',
          controller: contact,
          onChange: (String? val) {
            onChange(name.text, email.text, contact.text);
          },
        ),
      ],
    );
  }
}

class PrintRatingController extends RatingController {
  PrintRatingController(RatingModel ratingModel) : super(ratingModel);

  @override
  Future<void> ignoreForEverCallback() async {
    print('Rating ignored forever!');
    await Future.delayed(const Duration(seconds: 3));
  }

  @override
  Future<void> saveRatingCallback(
      int rate, List<RatingCriterionModel> selectedCriterions) async {
    print('Rating saved!\nRate: $rate\nsSelectedItems: $selectedCriterions');
    await Future.delayed(const Duration(seconds: 3));
  }
}

class CustomTextFieldSurveyPage extends StatelessWidget {
  const CustomTextFieldSurveyPage(
      {Key? key,
      required this.controller,
      required this.hint,
      required this.onChange,
      this.maxLines})
      : super(key: key);
  final TextEditingController controller;
  final String hint;
  final int? maxLines;
  final void Function(String? val) onChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 22),
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        hintText: hint,
        labelText: hint,
        hintStyle: const TextStyle(color: Colors.white10),
        labelStyle: const TextStyle(color: Colors.white54),
        border: const OutlineInputBorder(
          // borderSide: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          // borderSide: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          // borderSide: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      onChanged: (val) {
        onChange(val);
      },
    );
  }
}
