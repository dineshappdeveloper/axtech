import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Provider/LeadsProvider.dart';
import '../../../../Utils/Colors.dart';

class AddLeadNoteScreen extends StatefulWidget {
  String leadId, leadName;

  AddLeadNoteScreen({Key? key, required this.leadId, required this.leadName})
      : super(key: key);

  @override
  State<AddLeadNoteScreen> createState() => _AddLeadNoteScreenState();
}

class _AddLeadNoteScreenState extends State<AddLeadNoteScreen> {
  var formatter, formattedDate, currentTime;
  final _formKey = GlobalKey<FormState>();
  TextEditingController noteController = TextEditingController();
  late SharedPreferences pref;
  var authToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var now = DateTime.now();
    formatter = DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
    currentTime = DateFormat('hh:mm:ss').format(DateTime.now());
    getPrefs();
  }

  void getPrefs() async {
    pref = await SharedPreferences.getInstance();
    authToken = pref.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<LeadsProvider>(
          builder: (context, leadsProvider, child) {
            debugPrint(leadsProvider.IsLoading.toString());
            leadsProvider.setIsLoading = false;
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lead ID : ${widget.leadId}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Lead Name : ${widget.leadName}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Date : $formattedDate',
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Time : $currentTime',
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            controller: noteController,
                            textCapitalization: TextCapitalization.none,
                            //focusNode: emailFocusNode,
                            validator: (Value) {
                              if (Value!.isEmpty) {
                                return 'Please enter note';
                              }
                              return null;
                            },
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: themeColor,
                            ),
                            maxLines: 3,
                            autocorrect: false,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: themeColor),
                              ),
                              disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: themeColor, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: themeColor, width: 2),
                              ),
                              hintText: 'Add Note',
                              hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        !leadsProvider.IsLoading
                            ? Center(
                                child: TextButton.icon(
                                  style: TextButton.styleFrom(
                                    backgroundColor: themeColor,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25,
                                      vertical: 9,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      setState(
                                        () {
                                          leadsProvider.addComment(
                                              authToken,
                                              widget.leadId,
                                              formattedDate,
                                              currentTime,
                                              noteController.text,
                                              context);
                                        },
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Please correct the errors in the form",
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.edit_sharp,
                                      color: Colors.white),
                                  label: const Text(
                                    "Create Note",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
