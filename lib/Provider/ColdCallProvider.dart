import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:crm_application/Models/NotificationModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiManager/Apis.dart';
import '../Models/ColdCallsModel.dart';
import '../Models/StatusListModel.dart';
import '../Screens/Cold Calls/MyLeads/LeadFilter/Models/agentsModel.dart';
import '../Screens/Cold Calls/MyLeads/LeadFilter/Models/developerModel.dart';
import '../Screens/Cold Calls/MyLeads/LeadFilter/Models/propertyModel.dart';
import '../Screens/Cold Calls/MyLeads/LeadFilter/Models/statusModel.dart';
import '../Screens/Cold Calls/MyLeads/LeadFilter/Models/stausmodel.dart';
import 'LeadsProvider.dart';
import 'UserProvider.dart';

class ColdCallProvider with ChangeNotifier {
  String TAG = 'ColdCallProvider';

  final List<ColdCallsByDate> respList = [];
  final List<NotificationModel> _notifications = [];

  // List<ColdCallsByDate> get responseList => respList;
  List<NotificationModel> get notifications => _notifications;

  bool _isLoading = false;
  var _date = '', _listLength = '';
  List<ColdCallStatus> _reasonStatusList = [];

  String get date => _date;

  String get ListLength => _listLength;
  List<ColdCallStatus> get reasonStatusList => _reasonStatusList;

  bool get IsLoading => _isLoading;

  late String token;
  late String role;

  var name;
  List<ColdCalls> _coldCallsData = [];
  List<ColdCallsByDate> _coldCallsByDate = [];
  int total = 0;
  // List<NewComment> _coldCallscomments = [];
  // List<LeadHistory> _coldCallsHistory = [];
  // List<Agents> _agentsList = [];
  //
  // bool _isLoading = false;
  //
  // bool get IsLoading => _isLoading;
  set setIsLoading(bool value) => _isLoading = value;

  List<ColdCalls> get coldCallsData => _coldCallsData;
  List<ColdCallsByDate> get coldCallsByDate => _coldCallsByDate;
  //
  // List<LeadHistory> get ColdCallsUserHistory => _coldCallsHistory;
  //
  // List<Agents> get AgentsList => _agentsList;
  //
  bool _isFirstLoadRunning = false;
  bool get isFirstLoadRunning => _isFirstLoadRunning;
  int _page = 1;
  late ScrollController controller;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  bool get isLoadMoreRunning => _isLoadMoreRunning;

  bool isAddingContact = false;

  Future<void> getColdCalls(String authToken) async {
    _isFirstLoadRunning = true;
    token = authToken;
    notifyListeners();
    var page = 1;
    var url = '${ApiManager.BASE_URL}${ApiManager.coldCalls}?page=$page';
    debugPrint(url);
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $token',
    };

    try {
      _isLoading = true;
      notifyListeners();
      print('before response --> $filterData');
      print('before response --> $url');
      final response =
          await http.post(Uri.parse(url), headers: headers, body: filterData);

      var responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        var success = responseData['success'];
        var callData = responseData['data'];
        notifyListeners();
        var message = responseData['message'];
        _coldCallsData.clear();
        _coldCallsByDate.clear();
        _page = 1;
        notifyListeners();
        if (callData != 0) {
          var data = callData['data'];
          total = callData['total'];
          if (success == 200) {
            _isLoading = false;
            notifyListeners();
            print(data.length);
            List<ColdCallsByDate> coldCallsByDate = [];

            data.forEach((v) {
              _coldCallsData.add(ColdCalls.fromJson(v));
              var coldCall = ColdCalls.fromJson(v);
              var contains = coldCallsByDate.any((element) =>
                  DateFormat('yyyy-MM-dd')
                      .format(DateTime.parse(element.date)) ==
                  DateFormat('yyyy-MM-dd').format(coldCall.dob != null
                      ? DateTime.parse(coldCall.dob!)
                      : DateTime.parse(coldCall.createdAt!)));
              if (contains) {
                coldCallsByDate
                    .firstWhere((element) =>
                        DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(element.date)) ==
                        DateFormat('yyyy-MM-dd').format(DateTime.parse(
                            coldCall.dob ?? coldCall.createdAt!)))
                    .coldCalls!
                    .add(coldCall);
                // print(coldCallsByDate.first.date);
              } else {
                coldCallsByDate.add(ColdCallsByDate(
                    date: DateFormat('yyyy-MM-dd').format(coldCall.dob != null
                        ? DateTime.parse(coldCall.dob!)
                        : DateTime.parse(coldCall.createdAt!)),
                    coldCalls: [coldCall]));
                // print('new ${coldCallsByDate.first.date}');
              }
            });
            _coldCallsByDate = coldCallsByDate;
            notifyListeners();
          }
          _coldCallsByDate.sort((a, b) => b.date.compareTo(a.date));
          notifyListeners();
        } else {
          total = callData;
          Fluttertoast.showToast(msg: '$message');
        }
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        throw const HttpException('Failed To get ColdCalls');
      }
    } catch (error) {
      _isLoading = false;
      print(error);
      notifyListeners();
      rethrow;
    }
    _isFirstLoadRunning = false;
    notifyListeners();
  }

  void loadMore() async {
    // print('this is load more');
    // print('this is load more ${controller.position.extentAfter}');
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        controller.position.extentAfter < 300) {
      _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      notifyListeners();
      _page += 1;
      notifyListeners(); // Increase _page by 1
      var url = '${ApiManager.BASE_URL}${ApiManager.coldCalls}?page=$_page';
      debugPrint('LoadMore Url : $url');
      final headers = {
        'Authorization-token': '3MPHJP0BC63435345341',
        'Authorization': 'Bearer $token',
      };
      try {
        final response =
            await http.post(Uri.parse(url), headers: headers, body: filterData);
        var responseData = json.decode(response.body);
        if (response.statusCode == 200) {
          var success = responseData['success'];
          var callData = responseData['data'];
          if (callData != 0) {
            var data = callData['data'];
            if (success == 200) {
              data.forEach((v) {
                var coldCall = ColdCalls.fromJson(v);
                var contains = _coldCallsByDate.any((element) =>
                    DateFormat('yyyy-MM-dd')
                        .format(DateTime.parse(element.date)) ==
                    DateFormat('yyyy-MM-dd').format(coldCall.dob != null
                        ? DateTime.parse(coldCall.dob!)
                        : DateTime.parse(coldCall.createdAt!)));
                if (contains) {
                  _coldCallsByDate
                      .firstWhere((element) =>
                          DateFormat('yyyy-MM-dd')
                              .format(DateTime.parse(element.date)) ==
                          DateFormat('yyyy-MM-dd').format(coldCall.dob != null
                              ? DateTime.parse(coldCall.dob!)
                              : DateTime.parse(
                                  coldCall.dob ?? coldCall.createdAt!)))
                      .coldCalls!
                      .add(coldCall);

                  // print(coldCalls.first.coldCalls!.first.date);
                  print('Found');
                } else {
                  _coldCallsByDate.add(ColdCallsByDate(
                      date: DateFormat('yyyy-MM-dd').format(coldCall.dob != null
                          ? DateTime.parse(coldCall.dob!)
                          : DateTime.parse(coldCall.createdAt!)),
                      coldCalls: [coldCall]));
                }
                _coldCallsData.add(coldCall);

                _coldCallsByDate.sort((a, b) => b.date.compareTo(a.date));
                notifyListeners();
              });
              print('coldCalls data length = ${_coldCallsData.length}');
              print(
                  '_coldCallsByDate data length = ${_coldCallsByDate.length}');
              _isLoadMoreRunning =
                  false; // Display a progress indicator at the bottom
              notifyListeners();
            } else {
              throw const HttpException('Failed To get ColdCalls');
            }
          } else {
            _isLoadMoreRunning =
                false; // Display a progress indicator at the bottom
            notifyListeners();
            Fluttertoast.showToast(msg: 'No more ColdCalls available.');
          }
        }
      } on NoSuchMethodError catch (err) {
        _isLoadMoreRunning =
            false; // Display a progress indicator at the bottom
        notifyListeners();
        log(err.toString());
        Fluttertoast.showToast(
          msg: 'Something wrong.',
        );
      }

      // setState(() {
      _isLoadMoreRunning = false;
      notifyListeners();
      // });
    }
  }

  // Future<void> addComment(String token, String leadId, String leadDate,
  //     String leadTime, String comment, BuildContext context) async {
  //   _isLoading = true;
  //   var url = '${ApiManager.BASE_URL}${ApiManager.addComment}';
  //   final headers = {
  //     'Authorization-token': '3MPHJP0BC63435345341',
  //     'Authorization': 'Bearer $token',
  //   };
  //   final body = {
  //     "lead_id": leadId,
  //     "date": leadDate,
  //     "time": leadTime,
  //     "new_comments": comment
  //   };
  //   debugPrint("$TAG AddCommentParameters : $body");
  //   try {
  //     final response =
  //     await http.post(Uri.parse(url), headers: headers, body: body);
  //     var responseData = json.decode(response.body);
  //     if (response.statusCode == 200) {
  //       _isLoading = false;
  //       var success = responseData['success'];
  //       if (success == true) {
  //         _isLoading = false;
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => TestCallScreen(leadId: leadId),
  //           ),
  //         );
  //         notifyListeners();
  //       } else {
  //         _isLoading = false;
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text('error to adding comment'),
  //           ),
  //         );
  //       }
  //       notifyListeners();
  //     } else {
  //       _isLoading = false;
  //       throw const HttpException('Failed To Add note');
  //     }
  //     notifyListeners();
  //   } catch (error) {
  //     rethrow;
  //   }
  // }
  //
  // Future<void> getColdCallsHistory(String token, String LeadId) async {
  //   _coldCallsHistory.clear();
  //   var url = 'http://axtech.range.ae/api/v1/getLeadActivityHistory/$LeadId';
  //   final headers = {
  //     'Authorization-token': '3MPHJP0BC63435345341',
  //     'Authorization': 'Bearer $token',
  //   };
  //   try {
  //     final response = await http.get(Uri.parse(url), headers: headers);
  //     var responseData = json.decode(response.body);
  //     if (response.statusCode == 200) {
  //       var success = responseData['success'];
  //       var callData = responseData['data'];
  //       if (success == 200) {
  //         _isLoading = true;
  //         callData.forEach((v) {
  //           _coldCallsHistory.add(LeadHistory.fromJson(v));
  //         });
  //         debugPrint("$TAG Success : ${response.body}");
  //       }
  //       notifyListeners();
  //     } else {
  //       _isLoading = false;
  //       throw const HttpException('Failed To get ColdCalls');
  //     }
  //     notifyListeners();
  //   } catch (error) {
  //     rethrow;
  //   }
  // }
  //
  // Future<void> getAgentList(String token, String searchText) async {
  //   _isLoading = true;
  //   _agentsList.clear();
  //   var url = 'http://axtech.range.ae/api/v1/getAgents';
  //   final uri =
  //   Uri.parse(url).replace(queryParameters: {'keyword': searchText});
  //
  //   final headers = {
  //     'Authorization-token': '3MPHJP0BC63435345341',
  //     'Authorization': 'Bearer $token',
  //   };
  //
  //   try {
  //     final response = await http.get(
  //       uri,
  //       headers: headers,
  //     );
  //     var responseData = json.decode(response.body);
  //     if (response.statusCode == 200) {
  //       var agentList = responseData['agents'];
  //       agentList.forEach((v) {
  //         _agentsList.add(Agents.fromJson(v));
  //       });
  //       _isLoading = false;
  //       debugPrint("$TAG AgentsList : ${response.body}");
  //       notifyListeners();
  //     } else {
  //       _isLoading = false;
  //       throw const HttpException('Failed To get Agents');
  //     }
  //     notifyListeners();
  //   } catch (error) {
  //     rethrow;
  //   }
  // }
  //
  // Future<void> shareToAgent(
  //     String token, var leadId, var agentId, BuildContext context) async {
  //   var url = '${ApiManager.BASE_URL}${ApiManager.leadShareToAgent}';
  //   final uri = Uri.parse(url)
  //       .replace(queryParameters: {"lead_id": leadId, "agent_id": agentId});
  //
  //   final headers = {
  //     'Authorization-token': '3MPHJP0BC63435345341',
  //     'Authorization': 'Bearer $token',
  //   };
  //   try {
  //     final response = await http.get(
  //       uri,
  //       headers: headers,
  //     );
  //     if (response.statusCode == 200) {
  //       var responseData = json.decode(response.body);
  //       var message = responseData['message'];
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(message),
  //         ),
  //       );
  //       notifyListeners();
  //     } else {
  //       throw const HttpException('Failed To Add note');
  //     }
  //     notifyListeners();
  //   } catch (error) {
  //     rethrow;
  //   }
  // }
  //
  // void UpdateLeadInfo(
  //     var name,
  //     var email,
  //     var contact,
  //     var source,
  //     var status,
  //     var authToken,
  //     var leadId,
  //     var leadName,
  //     var date,
  //     BuildContext context) async {
  //   var url = ApiManager.BASE_URL + '${ApiManager.Leadupdate}/${leadId}';
  //   debugPrint("$TAG UpdateInfoUrl : $url");
  //   _isLoading = true;
  //   final headers = {
  //     'Authorization-token': '3MPHJP0BC63435345341',
  //     'Authorization': 'Bearer $authToken',
  //   };
  //   Map<String, dynamic> body = {
  //     "name": name,
  //     "email": email,
  //     "phone": contact,
  //     "date": date, //"2020-10-12",
  //     "source": source,
  //     "status": status,
  //     "type": "Active",
  //   };
  //   try {
  //     final response =
  //     await http.post(Uri.parse(url), body: body, headers: headers);
  //     var responseData = json.decode(response.body);
  //     if (response.statusCode == 200) {
  //       var message = responseData['message'];
  //       if (responseData['success'] == true) {
  //         _isLoading = false;
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(message),
  //           ),
  //         );
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => CompleteLeadProfile(
  //               leadId: leadId,
  //               leadName: leadName,
  //             ),
  //           ),
  //         );
  //         notifyListeners();
  //       }
  //       //notifyListeners();
  //     } else {
  //       _isLoading = false;
  //       notifyListeners();
  //       throw const HttpException('Auth Failed');
  //     }
  //   } catch (error) {
  //     _isLoading = false;
  //     notifyListeners();
  //     rethrow;
  //   }
  // }
  //
  // Future<void> scheduleCallBack(
  //     String? comment,
  //     BuildContext context,
  //     var leadId,
  //     var planToDo,
  //     var date,
  //     var time,
  //     var authToken,
  //     ) async {
  //   var url = ApiManager.BASE_URL + ApiManager.addLeadActivitySchedule;
  //   debugPrint("$TAG UpdateInfoUrl : $url");
  //   _isLoading = true;
  //   final headers = {
  //     'Authorization-token': '3MPHJP0BC63435345341',
  //     'Authorization': 'Bearer $authToken',
  //   };
  //   Map<String, dynamic> body = {
  //     "lead_id": leadId,
  //     "plan_to_do": planToDo,
  //     "schedule_time": time,
  //     "schedule_date": date,
  //     "comment": comment
  //   };
  //   try {
  //     final response =
  //     await http.post(Uri.parse(url), body: body, headers: headers);
  //     var responseData = json.decode(response.body);
  //     if (response.statusCode == 200) {
  //       var message = responseData['message'];
  //       if (responseData['success'] == true) {
  //         _isLoading = false;
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(message),
  //           ),
  //         );
  //         Navigator.of(context).pop();
  //         notifyListeners();
  //       }
  //     } else {
  //       _isLoading = false;
  //       notifyListeners();
  //       throw const HttpException('Schedule Operation Failed');
  //     }
  //   } catch (error) {
  //     _isLoading = false;
  //     notifyListeners();
  //     rethrow;
  //   }
  // }
  //
  // Future<void> editScheduledColdCalls(String token, String id,
  //     Map<String, String> data, BuildContext context) async {
  //   _isLoading = true;
  //   var url =
  //       'http://axtech.range.ae/api/v1/${ApiManager.updateLeadActivity}/$id';
  //   final headers = {
  //     'Authorization-token': '3MPHJP0BC63435345341',
  //     'Authorization': 'Bearer $token',
  //   };
  //   Map<String, String> body = data;
  //   try {
  //     final response =
  //     await http.post(Uri.parse(url), headers: headers, body: body);
  //     var responseData = json.decode(response.body);
  //     debugPrint(responseData['data'].toString());
  //     var message = responseData['message'];
  //     if (responseData['success'] == true) {
  //       _isLoading = false;
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(message),
  //         ),
  //       );
  //       debugPrint('Scheduled Call Edited');
  //
  //       notifyListeners();
  //     } else {
  //       _isLoading = false;
  //       throw const HttpException('Failed To Scheduled Call Editing.');
  //     }
  //     notifyListeners();
  //   } catch (error) {
  //     _isLoading = false;
  //     rethrow;
  //   }
  // }
  //
  // Future<void> deleteScheduledColdCalls(
  //     String token, String id, BuildContext context) async {
  //   _coldCallsHistory.clear();
  //   var url = ApiManager.BASE_URL + '${ApiManager.deleteLeadActivity}/$id';
  //   final headers = {
  //     'Authorization-token': '3MPHJP0BC63435345341',
  //     'Authorization': 'Bearer $token',
  //   };
  //   try {
  //     final response = await http.post(Uri.parse(url), headers: headers);
  //     var responseData = json.decode(response.body);
  //     debugPrint(responseData['message'].toString());
  //     var message = responseData['message'];
  //     if (response.statusCode == 200) {
  //       _isLoading = false;
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(message),
  //         ),
  //       );
  //       debugPrint('Scheduled Call Deleted.');
  //       notifyListeners();
  //     } else {
  //       _isLoading = false;
  //       throw const HttpException('Failed To Scheduled Call Editing.');
  //     }
  //     notifyListeners();
  //   } catch (error) {
  //     rethrow;
  //   }
  // }
  //
  ///TODO:Filter in ColdCalls
  List<String> categoriesList = [
    'Agent',
    'Date Range',
    // 'Developer',
    // 'Property',
    'Status',
    'Sources',
    'Priority',
    'Keyword'
  ];
  List<AgentsByTeam> agentsByTeamList = [];
  List<TeamLeader> teamLeadersList = [];
  List<AgentById> agentsByIdList = [];
  List<DeveloperModel> developersList = [];
  List<PropertyModel> propertyList = [];
  List<StatusModel> statusList = [];
  List<SourceModel> sourcesList = [];
  List<String> priorityList = [];
  TextEditingController query = TextEditingController();
  TextEditingController queryAgents = TextEditingController(text: 'All');
  TextEditingController queryDevelopers = TextEditingController(text: 'All');
  TextEditingController queryProperty = TextEditingController(text: 'All');
  TextEditingController queryStatus = TextEditingController(text: 'All');
  TextEditingController querySources = TextEditingController(text: 'All');
  TextEditingController queryPriority = TextEditingController(text: 'All');

  String? selectedAgent;
  int? selectedDeveloper;
  int? selectedProperty;
  String? selectedPriority;

  List<StatusModel> multiSelectedStatus = [];
  List<SourceModel> multiSelectedSources = [];

  int selectedIndex = 0;

  DateTime? fromDate;
  DateTime? toDate;

  bool isFlrApplied = false;
  Map<String, dynamic> filterData = {};
  void setFilterData(Map<String, dynamic> json) {
    filterData = json;
    notifyListeners();
  }

  Future<void> initFilterMethods() async {
    await getAgents();
    await getTeamLeaders();
    // await getDevelopers();
    // await getProperties();
    await getSources();
    await getStatus();
    await getPriority();
  }

  Future<void> getAgents() async {
    print('User role is $role');
    var url = '${ApiManager.BASE_URL}${ApiManager.users}';
    final headers = {
      'Authorization-token': ApiManager.Authorization_token,
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      var result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (role != UserType.admin.name) {
          var res = (result['data'] as Map<String, dynamic>).entries.toList();
          res.removeAt(0);
          agentsByTeamList.clear();
          for (var element in res) {
            agentsByTeamList.add(
                AgentsByTeam.fromJson(admin: element.key, json: element.value));
            notifyListeners();
          }
          print(
              'new agentsByTeamList list without all ${agentsByTeamList.length}');
        } else {
          agentsByIdList.clear();
          result['data'].forEach((e) {
            agentsByIdList.add(AgentById.fromJson(e));
            notifyListeners();
          });

          print('agentsByIdList   ${agentsByIdList.length}');
        }
      }
    } catch (e) {
      print('Get filter getAgents error: $e');
    }
  }

  Future<void> getTeamLeaders() async {
    var url = '${ApiManager.BASE_URL}${ApiManager.getTeamleaders}';
    final headers = {
      'Authorization-token': ApiManager.Authorization_token,
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      var result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        teamLeadersList.clear();
        if (result['data'] != 0) {
          result['data'].forEach((e) {
            teamLeadersList.add(TeamLeader.fromJson(e));
            notifyListeners();
          });
        }
        print('teamLeadersList   ${teamLeadersList.length}');
      }
    } catch (e) {
      print('Get filter getTeamLeaders error: $e');
    }
  }

  Future<void> getDevelopers() async {
    var url = ApiManager.BASE_URL + ApiManager.get_developers;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer ${token}',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      var result = jsonDecode(response.body);
      if (result['success'] == 200) {
        developersList.clear();
        result['data'].forEach((e) {
          developersList.add(DeveloperModel.fromJson(e));
          notifyListeners();
        });
        if (kDebugMode) {
          print('DeveloperList length ${developersList.length}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Developer getDevelopers list error: $e");
      }
    }
  }

  Future<void> getProperties() async {
    var url = ApiManager.BASE_URL + ApiManager.properties;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer ${token}',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      var result = jsonDecode(response.body);
      if (result['success'] == 200) {
        propertyList.clear();
        result['data'].forEach((e) {
          propertyList.add(PropertyModel.fromJson(e));
          notifyListeners();
        });
        if (kDebugMode) {
          print('propertyList length ${propertyList.length}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("getProperties list error: $e");
      }
    }
  }

  Future<void> getStatus() async {
    var url = ApiManager.BASE_URL + ApiManager.getStatus;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer ${token}',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      var result = jsonDecode(response.body);
      if (result['success'] == 200) {
        statusList.clear();
        result['data'].forEach((e) {
          statusList.add(StatusModel.fromJson(e));
          notifyListeners();
        });
        if (kDebugMode) {
          print('statusList length ${statusList.length}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("getStatus list error: $e");
      }
    }
  }

  Future<void> getSources() async {
    var url = ApiManager.BASE_URL + ApiManager.source;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer ${token}',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      var result = jsonDecode(response.body);
      if (result['success'] == 200) {
        sourcesList.clear();
        result['data'].forEach((e) {
          sourcesList.add(SourceModel.fromJson(e));
          notifyListeners();
        });
        if (kDebugMode) {
          print('sourcesList length ${sourcesList.length}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("getSources list error: $e");
      }
    }
  }

  Future<void> getPriority() async {
    var url = ApiManager.BASE_URL + ApiManager.coldCallPriorities;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer ${token}',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      var result = jsonDecode(response.body);
      if (result['success'] == 200) {
        priorityList.clear();
        print("priorityList ${priorityList.length}");
        priorityList.add(result['data']['']);
        priorityList.add(result['data']['Very Urgent']);
        priorityList.add(result['data']['Urgent']);
        priorityList.add(result['data']['Normal']);
        priorityList.add(result['data']['No Priority']);
        notifyListeners();
        print("priorityList ${priorityList.length}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("getPriority list error: $e");
      }
    }
  }

  void setIsFlrApplied() {
    // print(jsonEncode(filterData));
    print(selectedAgent);
    print(fromDate);
    print(toDate);
    print(selectedProperty);
    print(selectedPriority);
    print(selectedDeveloper);
    print(multiSelectedStatus);
    print(multiSelectedSources);
    print(query.text);
    print(filterData);
    print(selectedAgent == null &&
        fromDate == null &&
        toDate == null &&
        selectedProperty == null &&
        selectedPriority == null &&
        selectedDeveloper == null &&
        multiSelectedStatus.isEmpty &&
        multiSelectedSources.isEmpty &&
        filterData == {} &&
        query.text.isEmpty);
    if (selectedAgent == null &&
        fromDate == null &&
        toDate == null &&
        selectedProperty == null &&
        selectedPriority == null &&
        selectedDeveloper == null &&
        multiSelectedStatus.isEmpty &&
        multiSelectedSources.isEmpty &&
        query.text == '') {
      if (kDebugMode) {
        print('making false');
      }
      isFlrApplied = false;
      notifyListeners();
    } else {
      if (kDebugMode) {
        print('making true');
      }

      isFlrApplied = true;
      notifyListeners();
    }
    print('Is filter applied : $isFlrApplied');
  }

  Future<bool> isFilterApplied(bool isApplied) async {
    print('is applied $isApplied');
    if (!isApplied) {
      selectedAgent = null;
      fromDate = null;
      toDate = null;
      selectedProperty = null;
      selectedPriority = null;
      selectedDeveloper = null;
      selectedIndex = 0;
      multiSelectedStatus = [];
      multiSelectedSources = [];
      query.text = '';
      filterData.clear();
      setIsFlrApplied();
      notifyListeners();
    } else {
      setIsFlrApplied();
      notifyListeners();
    }
    return true;
  }

  Future<void> applyFilter(ColdCallProvider ccp) async {
    var statusString = '';
    var sourcesString = '';
    if (ccp.multiSelectedStatus.isNotEmpty) {
      for (var element in ccp.multiSelectedStatus) {
        statusString += '${element.id},';
      }
      statusString = statusString.substring(0, statusString.length - 1);
    }
    if (ccp.multiSelectedSources.isNotEmpty) {
      for (var element in ccp.multiSelectedSources) {
        sourcesString += '${element.id},';
      }
      sourcesString = sourcesString.substring(0, sourcesString.length - 1);
    }

    var data = {
      "agent_id": ccp.selectedAgent ?? "",
      "from_date": ccp.fromDate != null ? ccp.fromDate.toString() : "",
      "to_date": ccp.toDate != null ? ccp.toDate.toString() : "",
      // "developer_id":
      //     ccp.selectedDeveloper != null ? ccp.selectedDeveloper.toString() : "",
      // "property_id":
      //     ccp.selectedProperty != null ? ccp.selectedProperty.toString() : "",
      "status": statusString,
      "source": sourcesString,
      "priority": ccp.selectedPriority != null
          ? (ccp.selectedPriority != 'All' ? ccp.selectedPriority : '')
          : "",
      "keyword": ccp.query.text
    };
    ccp.setFilterData(data);
    ccp.isFilterApplied(true);
    await ccp.getColdCalls(token);
  }

  ///TODO:SELECTION Mode
  bool selectionMode = false;
  void setSelectionMode(bool val) {
    selectionMode = val;
    notifyListeners();
  }

  Set<ColdCalls> selectedColdCalls = {};
  void setSelectedColdCalls(ColdCalls coldCall) {
    if (selectedColdCalls.contains(coldCall)) {
      selectedColdCalls.remove(coldCall);
      notifyListeners();
    } else {
      selectedColdCalls.add(coldCall);
      notifyListeners();
    }
    print('Selected coldCalls lenght ${selectedColdCalls.length}');
  }

  ///TODO:assign to team leader
  Future<void> assignToAgent() async {
    var url = ApiManager.BASE_URL + ApiManager.source;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer ${token}',
    };
    // try {
    //   final response = await http.get(Uri.parse(url), headers: headers);
    //   // print(jsonDecode(response.body));
    //   var result = jsonDecode(response.body);
    //   if (result['success'] == 200) {
    //     sourcesList.clear();
    //     result['data'].forEach((e) {
    //       if (kDebugMode) {
    //         // print(' sourcesList data length = ${result['data']}');
    //       }
    //       sourcesList.add(SourceModel.fromJson(e));
    //     });
    //     if (kDebugMode) {
    //       // print('sourcesList length ${sourcesList.length}');
    //     }
    //   }
    // } catch (e) {
    //   if (kDebugMode) {
    //     print("Developer list error: $e");
    //   }
    // }

    Get.back();
    selectionMode = false;
    selectedColdCalls.clear();
    notifyListeners();
    Timer(const Duration(seconds: 1), () {
      AwesomeDialog(
        dismissOnBackKeyPress: true,
        dismissOnTouchOutside: false,
        context: Get.context!,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: '\n\nAssigned Successfully\n',
        // body: Image.asset('assets/images/delete.png'),
        autoHide: const Duration(seconds: 2),
      ).show();
    });
  }

  // Future<void> assignToTeamLeader() async {
  //   var url = ApiManager.BASE_URL + ApiManager.source;
  //   final headers = {
  //     'Authorization-token': '3MPHJP0BC63435345341',
  //     'Authorization': 'Bearer ${token}',
  //   };
  //   // try {
  //   //   final response = await http.get(Uri.parse(url), headers: headers);
  //   //   // print(jsonDecode(response.body));
  //   //   var result = jsonDecode(response.body);
  //   //   if (result['success'] == 200) {
  //   //     sourcesList.clear();
  //   //     result['data'].forEach((e) {
  //   //       if (kDebugMode) {
  //   //         // print(' sourcesList data length = ${result['data']}');
  //   //       }
  //   //       sourcesList.add(SourceModel.fromJson(e));
  //   //     });
  //   //     if (kDebugMode) {
  //   //       // print('sourcesList length ${sourcesList.length}');
  //   //     }
  //   //   }
  //   // } catch (e) {
  //   //   if (kDebugMode) {
  //   //     print("Developer list error: $e");
  //   //   }
  //   // }
  //
  //   Get.back();
  //   selectionMode = false;
  //   selectedColdCalls.clear();
  //   notifyListeners();
  //   Timer(const Duration(seconds: 1), () {
  //     AwesomeDialog(
  //       dismissOnBackKeyPress: true,
  //       dismissOnTouchOutside: false,
  //       context: Get.context!,
  //       dialogType: DialogType.success,
  //       animType: AnimType.rightSlide,
  //       title: '\n\nAssigned Successfully\n',
  //       autoHide: const Duration(seconds: 2),
  //     ).show();
  //   });
  // }
  //
  // Future<void> bulkDelete() async {
  //   var url = ApiManager.BASE_URL + ApiManager.source;
  //   final headers = {
  //     'Authorization-token': '3MPHJP0BC63435345341',
  //     'Authorization': 'Bearer ${token}',
  //   };
  //   // try {
  //   //   final response = await http.get(Uri.parse(url), headers: headers);
  //   //   // print(jsonDecode(response.body));
  //   //   var result = jsonDecode(response.body);
  //   //   if (result['success'] == 200) {
  //   //     sourcesList.clear();
  //   //     result['data'].forEach((e) {
  //   //       if (kDebugMode) {
  //   //         // print(' sourcesList data length = ${result['data']}');
  //   //       }
  //   //       sourcesList.add(SourceModel.fromJson(e));
  //   //     });
  //   //     if (kDebugMode) {
  //   //       // print('sourcesList length ${sourcesList.length}');
  //   //     }
  //   //   }
  //   // } catch (e) {
  //   //   if (kDebugMode) {
  //   //     print("Developer list error: $e");
  //   //   }
  //   // }
  //
  //   // Get.back();
  //   selectionMode = false;
  //   selectedColdCalls.clear();
  //   notifyListeners();
  //   Timer(const Duration(seconds: 1), () {
  //     AwesomeDialog(
  //       dismissOnBackKeyPress: true,
  //       dismissOnTouchOutside: false,
  //       context: Get.context!,
  //       dialogType: DialogType.success,
  //       animType: AnimType.scale,
  //       title: '\nColdCalls Deleted Successfully\n',
  //       // body: Image.asset('assets/images/delete.png'),
  //       autoHide: const Duration(seconds: 2),
  //     ).show();
  //   });
  // }

  int getSelection(int id) => id;

  Future<void> bulkDelete() async {
    var url = ApiManager.BASE_URL + ApiManager.source;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer ${token}',
    };
    // try {
    //   final response = await http.get(Uri.parse(url), headers: headers);
    //   // print(jsonDecode(response.body));
    //   var result = jsonDecode(response.body);
    //   if (result['success'] == 200) {
    //     sourcesList.clear();
    //     result['data'].forEach((e) {
    //       if (kDebugMode) {
    //         // print(' sourcesList data length = ${result['data']}');
    //       }
    //       sourcesList.add(SourceModel.fromJson(e));
    //     });
    //     if (kDebugMode) {
    //       // print('sourcesList length ${sourcesList.length}');
    //     }
    //   }
    // } catch (e) {
    //   if (kDebugMode) {
    //     print("Developer list error: $e");
    //   }
    // }

    // Get.back();
    selectionMode = false;
    selectedColdCalls.clear();
    notifyListeners();
    Timer(const Duration(seconds: 1), () {
      AwesomeDialog(
        dismissOnBackKeyPress: true,
        dismissOnTouchOutside: false,
        context: Get.context!,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: '\nLeads Deleted Successfully\n',
        // body: Image.asset('assets/images/delete.png'),
        autoHide: const Duration(seconds: 2),
      ).show();
    });
  }

  ///TODO:Tile Functions

  Future<void> convertToLead(int id, BuildContext context) async {
    //_isLoading = true;
    late SharedPreferences pref;
    var authToken;
    pref = await SharedPreferences.getInstance();
    authToken = pref.getString('token');
    var url = ApiManager.BASE_URL + ApiManager.coldCallConvetToLead + '/$id';
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $authToken',
      //'Accept': 'application/json',
    };

    // print(ids);
    // print(body);
    // print(url);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
      );
      // print(response.statusCode);
      // print(response.body);
      // print('started2');
      var responseData = json.decode(response.body);
      debugPrint(responseData.toString());
      if (response.statusCode == 200) {
        // print('started3');
        _isLoading = false;
        var success = responseData['success'];
        var message = responseData['message'];

        if (success == true) {
          _isLoading = false;
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(message),
          //   ),
          // );

          AwesomeDialog(
            dismissOnBackKeyPress: true,
            dismissOnTouchOutside: false,
            context: Get.context!,
            dialogType: DialogType.success,
            animType: AnimType.scale,
            title: '\nConverted Successfully\n',
            // body: Image.asset('assets/images/delete.png'),
            autoHide: const Duration(seconds: 2),
          ).show();
        }
        notifyListeners();
      } else {
        _isLoading = false;
        throw const HttpException('Failed To Conversion');
      }
      notifyListeners();
    } catch (error) {
      debugPrint(error.toString());
      _isLoading = false;
      rethrow;
    }
  }

  Future<void> getDeviceNotifications(
      String token, BuildContext context) async {
    _notifications.clear();
    //_isLoading = true;
    var url = ApiManager.BASE_URL + ApiManager.getDeviceNotifications;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $token',
      //'Accept': 'application/json',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      var responseData = json.decode(response.body);
      debugPrint(responseData.toString());
      if (response.statusCode == 200) {
        _isLoading = false;
        var success = responseData['success'];
        // var data = responseData['data'];
        var notificationList = responseData['data'];

        if (success == 200) {
          _isLoading = false;
          notificationList.forEach((v) {
            _notifications.add(NotificationModel.fromJson(v));
          });
          // print(notifications.length);
          if (_notifications.isNotEmpty) {
            debugPrint("$TAG NotificationsLength : ${_notifications.length}");
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No Notifications Available'),
              ),
            );
          }
        }
        notifyListeners();
      } else {
        _isLoading = false;
        throw const HttpException('Failed To get Notifications');
      }
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      rethrow;
    }
  }

  Future<void> deleteDeviceNotifications(
      String token, List<int> ids, BuildContext context) async {
    //_isLoading = true;
    var url = ApiManager.BASE_URL + ApiManager.deleteDeviceNotifications;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $token',
      //'Accept': 'application/json',
    };
    Map<String, dynamic> body = {
      'ids': ids.toString(),
    };
    // print(ids);
    // print(body);
    // print(url);

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      // print(response.statusCode);
      // print(response.body);
      // print('started2');
      var responseData = json.decode(response.body);
      debugPrint(responseData.toString());
      if (response.statusCode == 200) {
        // print('started3');
        _isLoading = false;
        var success = responseData['success'];
        var message = responseData['message'];

        if (success == 200) {
          _isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
            ),
          );
        }
        notifyListeners();
      } else {
        _isLoading = false;
        throw const HttpException('Failed To delete Notifications');
      }
      notifyListeners();
    } catch (error) {
      debugPrint(error.toString());
      _isLoading = false;
      rethrow;
    }
  }

  Future<void> getStatusList(String authToken) async {
    statusList.clear();
    var url = ApiManager.BASE_URL + ApiManager.leadStatus;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $authToken',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      var responseData = json.decode(response.body);
      debugPrint(responseData.toString());
      if (response.statusCode == 200) {
        var success = responseData['success'];
        var list = responseData['data'];
        if (success == 200) {
          _isLoading = true;
          notifyListeners();
          list.forEach((v) {
            // print(v);
            _reasonStatusList.add(ColdCallStatus.fromJson(v));
          });
        }
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        throw const HttpException('Failed To get ColdCalls');
      }
    } catch (error) {
      rethrow;
    }
  }
}
