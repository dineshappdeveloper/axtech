import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:crm_application/Models/SSSModel.dart';
import 'package:crm_application/Provider/UserProvider.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/LeadFilter/Models/agentsModel.dart';
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
import 'package:flutter/foundation.dart';
import '../../../ApiManager/Apis.dart';
import '../../../Models/LeadsModel.dart';

class ClosedLeadsProvider with ChangeNotifier {
  late String token;
  late String role;

  String TAG = 'ClosedLeadsProvider';
  var name;
  List<SSSModel> _ClosedLeadsData = [];
  List<SSSByDate> _ClosedLeadsByDate = [];
  int total = 0;

  bool _isLoading = false;

  bool get IsLoading => _isLoading;
  set setIsLoading(bool value) => _isLoading = value;

  List<SSSModel> get closedLeadsData => _ClosedLeadsData;
  List<SSSByDate> get closedLeadsByDate => _ClosedLeadsByDate;
  bool _isFirstLoadRunning = false;
  bool get isFirstLoadRunning => _isFirstLoadRunning;
  int _page = 1;
  late ScrollController controller;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  bool get isLoadMoreRunning => _isLoadMoreRunning;

  bool isAddingContact = false;

  Future<void> getClosedLeads() async {
    _isFirstLoadRunning = true;
    notifyListeners();
    var page = 1;
    var url = '${ApiManager.BASE_URL}${ApiManager.closelaed}?page=$page';
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
      print(responseData);

      if (response.statusCode == 200) {
        var success = responseData['success'];
        var ClosedLeadsData = responseData['data'];
        notifyListeners();
        var message = responseData['message'];
        _ClosedLeadsData.clear();
        _ClosedLeadsByDate.clear();
        _page = 1;
        notifyListeners();
        if (responseData['data'] != 0) {
          var data = ClosedLeadsData['data'];
          total = ClosedLeadsData['total'];
          if (success == 200) {
            _isLoading = false;
            notifyListeners();
            print(data.length);
            List<SSSByDate> ClosedLeadsList = [];

            data.forEach((v) {
             try{

               _ClosedLeadsData.add(SSSModel.fromJson(v));
               var closedLead = SSSModel.fromJson(v);
               var contains = ClosedLeadsList.any((element) =>
               DateFormat('yyyy-MM-dd')
                   .format(DateTime.parse(element.date!)) ==
                   DateFormat('yyyy-MM-dd')
                       .format(DateTime.parse(closedLead.dateOfClientMeeting!)));
               if (contains) {
                 ClosedLeadsList.firstWhere((element) =>
                 DateFormat('yyyy-MM-dd')
                     .format(DateTime.parse(element.date!)) ==
                     DateFormat('yyyy-MM-dd').format(
                         DateTime.parse(closedLead.dateOfClientMeeting!)))
                     .sss!
                     .add(closedLead);
               } else {
                 ClosedLeadsList.add(SSSByDate(
                     date: closedLead.dateOfClientMeeting, sss: [closedLead]));
               }
             }catch(e){
               print('eeee-- $e');
             }
            });
            _ClosedLeadsByDate = ClosedLeadsList;
            notifyListeners();
          }
          _ClosedLeadsByDate.sort((a, b) =>
              DateTime.parse(b.date!).compareTo(DateTime.parse(a.date!)));
          notifyListeners();
        } else {
          total = ClosedLeadsData;
          _isLoading = false;
          notifyListeners();
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
      var url =
          '${ApiManager.BASE_URL}${ApiManager.serviceSatisfactionSurvey}?page=$_page';
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
          var closedLeadsData = responseData['data'];
          if (closedLeadsData != 0) {
            var data = closedLeadsData['data'];
            if (success == 200) {
              data.forEach((v) {
                var closedLeads = SSSModel.fromJson(v);
                var contains = closedLeadsByDate.any((element) =>
                    DateFormat('yyyy-MM-dd')
                        .format(DateTime.parse(element.date!)) ==
                    DateFormat('yyyy-MM-dd').format(
                        DateTime.parse(closedLeads.dateOfClientMeeting!)));
                if (contains) {
                  _ClosedLeadsByDate.firstWhere((element) =>
                          DateFormat('yyyy-MM-dd')
                              .format(DateTime.parse(element.date!)) ==
                          DateFormat('yyyy-MM-dd').format(
                              DateTime.parse(closedLeads.dateOfClientMeeting!)))
                      .sss!
                      .add(closedLeads);

                  print(closedLeads.dateOfClientMeeting);
                  print('Found');
                } else {
                  _ClosedLeadsByDate.add(SSSByDate(
                      date: closedLeads.dateOfClientMeeting,
                      sss: [closedLeads]));
                }
                _ClosedLeadsData.add(closedLeads);

                _ClosedLeadsByDate.sort((a, b) =>
                    DateTime.parse(b.date!).compareTo(DateTime.parse(a.date!)));
                notifyListeners();
              });
              print('sss data length = ${_ClosedLeadsData.length}');
              print(
                  '_ClosedLeadsByDate data length = ${_ClosedLeadsByDate.length}');
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
        _isLoadMoreRunning = false;
        notifyListeners();
      } on NoSuchMethodError catch (err) {
        _isLoadMoreRunning = false;
        notifyListeners();
        log(err.toString());
        Fluttertoast.showToast(
          msg: 'Something wrong.',
        );
      } catch (e) {
        _isLoadMoreRunning = false;
        notifyListeners();
        print('Load more cache error : $e');
      }
    }
  }

  ///TODO:Filter in Leads
  List<String> categoriesList = [
    'Agent',
    'Date Range',
  ];
  List<AgentsByTeam> agentsByTeamList = [];
  List<TeamLeader> teamLeadersList = [];
  List<AgentById> agentsByIdList = [];
  TextEditingController queryAgents = TextEditingController(text: 'All');

  String? selectedAgent;

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

  void setIsFlrApplied() {
    if (selectedAgent == null && fromDate == null && toDate == null) {
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
      filterData.clear();
      queryAgents.text = 'All';
      setIsFlrApplied();
      notifyListeners();
    } else {
      setIsFlrApplied();
      notifyListeners();
    }
    return true;
  }

  Future<void> applyFilter(ClosedLeadsProvider lp) async {
    var data = {
      "agent_id": lp.selectedAgent ?? "",
      "from_date": lp.fromDate != null ? lp.fromDate.toString() : "",
      "to_date": lp.toDate != null ? lp.toDate.toString() : "",
    };
    lp.setFilterData(data);
    lp.isFilterApplied(true);
    await lp.getClosedLeads();
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
    print('Selected sss lenght ${selectedLeads.length}');
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
