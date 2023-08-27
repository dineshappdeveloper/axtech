import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:crm_application/Provider/UserProvider.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/LeadFilter/Models/agentsModel.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/TestCallDetailsScreen/TestCallScreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../ApiManager/Apis.dart';
import '../Models/AgentListModel.dart';
import '../Models/LeadHistoryModel.dart';
import '../Models/LeadsModel.dart';
import '../Screens/Cold Calls/MyLeads/TestCallDetailsScreen/CompleteleadProfile.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/LeadFilter/Models/developerModel.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/LeadFilter/Models/propertyModel.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/LeadFilter/Models/statusModel.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/LeadFilter/Models/stausmodel.dart';
import 'package:flutter/foundation.dart';
import '../../../ApiManager/Apis.dart';
import '../../../Models/LeadsModel.dart';

class LeadsProvider with ChangeNotifier {
  late String token;
  late String role;

  String TAG = 'LeadsProvider';
  String TAG1 = 'CompleteleadProfile';
  var name;
  List<Lead> _leadsData = [];
  List<LeadsByDate> _leadsByDate = [];
  int total = 0;
  List<NewComment> _leadscomments = [];
  List<LeadHistory> _leadsHistory = [];
  List<Agents> _agentsList = [];

  bool _isLoading = false;

  bool get IsLoading => _isLoading;
  set setIsLoading(bool value) => _isLoading = value;

  List<Lead> get leadsData => _leadsData;
  List<LeadsByDate> get leadsByDate => _leadsByDate;

  List<LeadHistory> get LeadsUserHistory => _leadsHistory;

  List<Agents> get AgentsList => _agentsList;

  bool _isFirstLoadRunning = false;
  bool get isFirstLoadRunning => _isFirstLoadRunning;
  int _page = 1;
  late ScrollController controller;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  bool get isLoadMoreRunning => _isLoadMoreRunning;

  bool isAddingContact = false;

    Future<void> updateLeadAccept(
      String token, int id, BuildContext context) async {
    var url = ApiManager.BASE_URL + '${ApiManager.updateLeadAccept}/$id';

    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $token',
    };
    try {
      log(url.toString());
      log(token);
      final response = await http.post(Uri.parse(url), headers: headers);
      var responseData = json.decode(response.body);
      debugPrint(responseData['message'].toString());
      var message = responseData['message'];
      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
        debugPrint('Scheduled Call Deleted.');
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();

        throw const HttpException('Failed To Scheduled Call Editing.');
      }
      _isLoading = false;
      notifyListeners();
    } catch (error, s) {
      print('A');
      print(error.toString());
      print(s.toString());
      rethrow;
    }
  }

  Future<void> getLeads() async {
    _isFirstLoadRunning = true;
    notifyListeners();
    var page = 1;
    var url = '${ApiManager.BASE_URL}${ApiManager.leads}?page=$page';
    debugPrint(url);
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $token',
    };

    try {
      print('before response --> $filterData');
      print('before response --> $url');
      _isLoading = true;
      notifyListeners();
      final response =
          await http.post(Uri.parse(url), headers: headers, body: filterData);

      var responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        var success = responseData['success'];
        var leadData = responseData['data'];
        notifyListeners();
        var message = responseData['message'];
        _leadsData.clear();
        _leadsByDate.clear();
        _page = 1;
        notifyListeners();
        if (responseData['data'] != 0) {
          var data = leadData['data'];
          total = leadData['total'];
          if (success == 200) {
            _isLoading = false;
            notifyListeners();
            print(data.length);
            List<LeadsByDate> leads = [];

            data.forEach((v) {
              _leadsData.add(Lead.fromJson(v));
              var lead = Lead.fromJson(v);
              var contains = leads.any((element) =>
                  DateFormat('yyyy-MM-dd')
                      .format(DateTime.parse(element.date!)) ==
                  DateFormat('yyyy-MM-dd').format(lead.date));
              if (contains) {
                leads
                    .firstWhere((element) =>
                        DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(element.date!)) ==
                        DateFormat('yyyy-MM-dd').format(lead.date))
                    .leads!
                    .add(lead);
              } else {
                leads.add(
                    LeadsByDate(date: lead.date.toString(), leads: [lead]));
              }
            });
            _leadsByDate = leads;
            notifyListeners();
          }
          _leadsByDate.sort((a, b) =>
              DateTime.parse(b.date!).compareTo(DateTime.parse(a.date!)));
          notifyListeners();
        } else {
          total = leadData;
          Fluttertoast.showToast(msg: '$message');
        }
      } else {
        _isLoading = false;
        notifyListeners();
        throw const HttpException('Failed To get Leads');
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
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        controller.position.extentAfter < 50) {
      _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      notifyListeners();
      _page += 1;
      notifyListeners(); // Increase _page by 1
      var url = '${ApiManager.BASE_URL}${ApiManager.leads}?page=$_page';
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
          var leadData = responseData['data'];
          if (leadData != 0) {
            var data = leadData['data'];
            if (success == 200) {
              data.forEach((v) {
                var lead = Lead.fromJson(v);
                var contains = _leadsByDate.any((element) =>
                    DateFormat('yyyy-MM-dd')
                        .format(DateTime.parse(element.date!)) ==
                    DateFormat('yyyy-MM-dd').format(lead.date));
                if (contains) {
                  _leadsByDate
                      .firstWhere((element) =>
                          DateFormat('yyyy-MM-dd')
                              .format(DateTime.parse(element.date!)) ==
                          DateFormat('yyyy-MM-dd').format(lead.date))
                      .leads!
                      .add(lead);

                  // print(leads.first.leads!.first.date);
                  print('Found');
                } else {
                  _leadsByDate.add(
                      LeadsByDate(date: lead.date.toString(), leads: [lead]));
                }
                _leadsData.add(lead);

                _leadsByDate.sort((a, b) =>
                    DateTime.parse(b.date!).compareTo(DateTime.parse(a.date!)));
                notifyListeners();
              });
              print('leads data length = ${_leadsData.length}');
              print('_leadsByDate data length = ${_leadsByDate.length}');
              _isLoadMoreRunning =
                  false; // Display a progress indicator at the bottom
              notifyListeners();
            } else {
              throw const HttpException('Failed To get Leads');
            }
          } else {
            _isLoadMoreRunning =
                false; // Display a progress indicator at the bottom
            notifyListeners();
            Fluttertoast.showToast(msg: 'No more Leads available.');
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

  Future<void> removeLeadFromList(String id) async {
    // _leadsHistory.clear();
    // notifyListeners();

    var url = ApiManager.BASE_URL + '${ApiManager.singleLeadsAddToCalling}/$id';
    final headers = {
      'Authorization-token': ApiManager.Authorization_token,
      'Authorization': 'Bearer $token',
    };
    try {
      _isLoading = true;
      notifyListeners();
      final response = await http.post(Uri.parse(url), headers: headers);
      debugPrint('remove from list error ${response.body}');
      var responseData = json.decode(response.body);
      debugPrint(responseData['message'].toString());
      var message = responseData['message'];
      if (response.statusCode == 200) {
        if (responseData['success']) {
          Fluttertoast.showToast(msg: message);
          await getLeads();
        } else {
          Fluttertoast.showToast(msg: message);
        }
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();

        throw const HttpException('Failed To remove Call Editing.');
      }
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addComment(String token, String leadId, String leadDate,
      String leadTime, String comment, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    var url = '${ApiManager.BASE_URL}${ApiManager.addComment}';
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $token',
    };
    final body = {
      "lead_id": leadId,
      "date": leadDate,
      "time": leadTime,
      "new_comments": comment
    };
    debugPrint("$TAG AddCommentParameters : $body");
    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      var responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();

        var success = responseData['success'];
        if (success == true) {
          _isLoading = false;
          notifyListeners();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TestCallScreen(leadId: leadId,leadType: 'lead'),
            ),
          );
          notifyListeners();
        } else {
          _isLoading = false;
          notifyListeners();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('error to adding comment'),
            ),
          );
        }
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();

        throw const HttpException('Failed To Add note');
      }
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getLeadsHistory(String token, String leadId) async {
    _leadsHistory.clear();
    var url = 'http://axtech.range.ae/api/v1/getLeadActivityHistory/$leadId';
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      var responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        var success = responseData['success'];
        var leadData = responseData['data'];
        if (success == 200) {
          _isLoading = true;
          notifyListeners();
          leadData.forEach((v) {
            _leadsHistory.add(LeadHistory.fromJson(v));
          });

          debugPrint("$TAG Success : ${response.body}");
        }
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();

        throw const HttpException('Failed To get Leads');
      }
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getAgentList(String token, String searchText) async {
    _isLoading = true;
    _agentsList.clear();
    var url = 'http://axtech.range.ae/api/v1/getAgents';
    final uri =
        Uri.parse(url).replace(queryParameters: {'keyword': searchText});

    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(
        uri,
        headers: headers,
      );
      var responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        var agentList = responseData['agents'];
        agentList.forEach((v) {
          _agentsList.add(Agents.fromJson(v));
        });
        _isLoading = false;
        debugPrint("$TAG AgentsList : ${response.body}");
        notifyListeners();
      } else {
        _isLoading = false;
        throw const HttpException('Failed To get Agents');
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> shareToAgent(
      String token, var leadId, var agentId, BuildContext context) async {
    var url = '${ApiManager.BASE_URL}${ApiManager.leadShareToAgent}';
    final uri = Uri.parse(url)
        .replace(queryParameters: {"lead_id": leadId, "agent_id": agentId});

    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(
        uri,
        headers: headers,
      );
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        var message = responseData['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
        notifyListeners();
      } else {
        throw const HttpException('Failed To Add note');
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  void updateLeadInfo(
      var name,
      var email,
      var contact,
      var source,
      var status,
      var authToken,
      var leadId,
      var leadName,
      var comment,
      var date,
      var agentId,
      BuildContext context) async {
    var url = ApiManager.BASE_URL + '${ApiManager.Leadupdate}/${leadId}';
    debugPrint("$TAG UpdateInfoUrl : $url");
    _isLoading = true;
    notifyListeners();

    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $authToken',
    };
    Map<String, dynamic> body = {
      // "name": name,
      // "email": email,
      // "phone": contact,
      // "date": date, //"2020-10-12",
      // "source": source,
      "status": status,
      // "type": "Active",
      "comment": comment
    };
    try {
      final response =
          await http.post(Uri.parse(url), body: body, headers: headers);
      var responseData = json.decode(response.body);
      print('response for uppdate $responseData');
      if (response.statusCode == 200) {
        var message = responseData['message'];
        if (responseData['success'] == true) {
          _isLoading = false;
          notifyListeners();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CompleteLeadProfile(
                leadId: leadId,
                leadName: leadName,
                agentId: agentId,
              ),
            ),
          );
          notifyListeners();
        }
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();

        notifyListeners();
        throw const HttpException('Auth Failed');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> scheduleCallBack(
    String? comment,
    BuildContext context,
    var leadId,
    var planToDo,
    var date,
    var time,
    var authToken,
  ) async {
    var url = ApiManager.BASE_URL + ApiManager.addLeadActivitySchedule;
    debugPrint("$TAG UpdateInfoUrl : $url");
    _isLoading = true;
    notifyListeners();

    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $authToken',
    };
    Map<String, dynamic> body = {
      "lead_id": leadId,
      "plan_to_do": planToDo,
      "schedule_time": time,
      "schedule_date": date,
      "comment": comment
    };
    try {
      final response =
          await http.post(Uri.parse(url), body: body, headers: headers);
      var responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        var message = responseData['message'];
        if (responseData['success'] == true) {
          _isLoading = false;
          notifyListeners();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
            ),
          );
          Navigator.of(context).pop();
        }
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        throw const HttpException('Schedule Operation Failed');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> editScheduledLeads(String token, String id,
      Map<String, String> data, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    var url =
        'http://axtech.range.ae/api/v1/${ApiManager.updateLeadActivity}/$id';
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $token',
    };
    Map<String, String> body = data;
    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      var responseData = json.decode(response.body);
      debugPrint(responseData['data'].toString());
      var message = responseData['message'];
      if (responseData['success'] == true) {
        _isLoading = false;
        notifyListeners();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
        debugPrint('Scheduled Call Edited');

        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();

        throw const HttpException('Failed To Scheduled Call Editing.');
      }
      _isLoading = false;

      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();

      rethrow;
    }
  }

  Future<void> deleteScheduledLeads(
      String token, String id, BuildContext context) async {
    _leadsHistory.clear();
    notifyListeners();

    var url = ApiManager.BASE_URL + '${ApiManager.deleteLeadActivity}/$id';
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.post(Uri.parse(url), headers: headers);
      var responseData = json.decode(response.body);
      debugPrint(responseData['message'].toString());
      var message = responseData['message'];
      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
        debugPrint('Scheduled Call Deleted.');
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();

        throw const HttpException('Failed To Scheduled Call Editing.');
      }
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  ///TODO:Filter in Leads
  List<String> categoriesList = [
    'Agent',
    'Date Range',
    'Developer',
    'Property',
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
    await getDevelopers();
    await getProperties();
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
    var url = ApiManager.BASE_URL + ApiManager.get_priorities;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer ${token}',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      var result = jsonDecode(response.body);
      if (result['success'] == 200) {
        priorityList.clear();
        priorityList.add(result['data']['']);
        priorityList.add(result['data']['Cold']);
        priorityList.add(result['data']['Warm']);
        priorityList.add(result['data']['Hot']);
        priorityList.add(result['data']['Not Interested']);
        print("priorityList ${priorityList.length}");
        notifyListeners();
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

  Future<void> applyFilter(LeadsProvider lp) async {
    var statusString = '';
    var sourcesString = '';
    if (lp.multiSelectedStatus.isNotEmpty) {
      for (var element in lp.multiSelectedStatus) {
        statusString += '${element.id},';
      }
      statusString = statusString.substring(0, statusString.length - 1);
    }
    if (lp.multiSelectedSources.isNotEmpty) {
      for (var element in lp.multiSelectedSources) {
        sourcesString += '${element.id},';
      }
      sourcesString = sourcesString.substring(0, sourcesString.length - 1);
    }

    var data = {
      "agent_id": lp.selectedAgent ?? "",
      "from_date": lp.fromDate != null ? lp.fromDate.toString() : "",
      "to_date": lp.toDate != null ? lp.toDate.toString() : "",
      "developer_id":
          lp.selectedDeveloper != null ? lp.selectedDeveloper.toString() : "",
      "property_id":
          lp.selectedProperty != null ? lp.selectedProperty.toString() : "",
      "status": statusString,
      "source": sourcesString,
      "priority": lp.selectedPriority ?? "",
      "keyword": lp.query.text
    };
    lp.setFilterData(data);
    lp.isFilterApplied(true);
    await lp.getLeads();
  }

  ///TODO:SELECTION Mode
  bool selectionMode = false;
  void setSelectionMode(bool val) {
    selectionMode = val;
    notifyListeners();
  }

  Set<Lead> selectedLeads = {};
  void setSelectedLeads(Lead lead) {
    if (selectedLeads.contains(lead)) {
      selectedLeads.remove(lead);
      notifyListeners();
    } else {
      selectedLeads.add(lead);
      notifyListeners();
    }
    print('Selected leads lenght ${selectedLeads.length}');
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
    selectedLeads.clear();
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

  Future<void> assignToTeamLeader() async {
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
    selectedLeads.clear();
    notifyListeners();
    Timer(const Duration(seconds: 1), () {
      AwesomeDialog(
        dismissOnBackKeyPress: true,
        dismissOnTouchOutside: false,
        context: Get.context!,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: '\n\nAssigned Successfully\n',
        autoHide: const Duration(seconds: 2),
      ).show();
    });
  }

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
    selectedLeads.clear();
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

  int getSelection(int id) => id;
}

class TeamLeader {
  int? id;
  String? name;

  TeamLeader({this.id, this.name});

  TeamLeader.fromJson(Map<String, dynamic> json) {
    var fname = json['first_name'] ?? "";
    var lname = json['last_name'] ?? "";
    id = json['id'];
    name = fname + " " + lname;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = name!.split(' ').first;
    data['last_name'] = name!.split(' ').last;
    return data;
  }
}
