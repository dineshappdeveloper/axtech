import 'package:crm_application/Utils/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../Models/LeadInfoModel.dart';

class LeadNotesScreen extends StatefulWidget {
  List<NewComment> notes;
  Widget addCommentWidget;
  final String leadType;
  LeadNotesScreen(
      {Key? key,
      required this.notes,
      required this.addCommentWidget,
      required this.leadType})
      : super(key: key);

  @override
  State<LeadNotesScreen> createState() => _LeadNotesScreenState();
}

class _LeadNotesScreenState extends State<LeadNotesScreen> {
  DateFormat dateFormat = DateFormat("dd-MM-yyyy");

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
            itemCount: widget.notes.length,
            reverse: true,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 15,
                    bottom: index == 0 ? 50 : 0),
                child: Container(
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // border: Border.all(color: themeColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              dateFormat.format(
                                widget.notes[index].date,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              widget.notes[index].time.toString(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          widget.notes[index].newComments ?? '',
                          style: GoogleFonts.workSans(fontSize: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
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
                            child: widget.addCommentWidget,
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
                  width: 160,
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
                          'Add Notes',
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
                              child: widget.addCommentWidget,
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
                    width: 160,
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
                            'Add Notes',
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
