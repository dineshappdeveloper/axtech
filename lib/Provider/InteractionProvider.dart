import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiManager/Apis.dart';
import '../Models/InteractionModel.dart';
import '../Models/LeadsModel.dart';
import '../Screens/Cold Calls/MyLeads/LeadFilter/Models/agentsModel.dart';
import 'LeadsProvider.dart';
import 'UserProvider.dart';

class InteractionProvider with ChangeNotifier {
  String TAG = 'InteractionProvider';
  List<Missed> _interactionData = [];
  List<Missed> _upcominginterData = [];
  List<Missed> _todayinterData = [];
  List<Missed> _overAllData = [];
  bool _isLoading = false;

  bool get IsLoading => _isLoading;

  List<Missed> get InteractionData => _interactionData;

  List<Missed> get UpcomingInter => _upcominginterData;

  List<Missed> get TodayInter => _todayinterData;
  List<Missed> get OverAllData => _overAllData;

  Future<void> getInteractionMissed(String token) async {
    // tocken = token;
    _interactionData.clear();
    _upcominginterData.clear();
    _todayinterData.clear();

    //_isLoading = true;
    var url = ApiManager.BASE_URL + ApiManager.interaction;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: filterData);
      var responseData = json.decode(response.body);
      debugPrint('InteractionProvider : ---' + responseData.toString());
      if (response.statusCode == 200) {
        var success = responseData['success'];
        var interactionData = responseData['missed'];
        var upcominginterData = responseData['upcoming'];

        // print(interactionData);
        // print(upcominginterData);
        var todayinterData = responseData['today'];

        if (success == 200) {
          _isLoading = true;
          notifyListeners();
          interactionData.forEach((v) {
            _interactionData.add(Missed.fromJson(v));
          });
          upcominginterData.forEach((v) {
            // _upcominginterData.add(Upcoming.fromJson(v));
          });
          todayinterData.forEach((v) {
            // _todayinterData.add(Upcoming.fromJson(v));
          });

          debugPrint("$TAG Success : ${response.body}");
          debugPrint("$TAG interactionData Length : ${interactionData.length}");
          debugPrint(
              "$TAG upcominginterData Length : ${upcominginterData.length}");
          debugPrint("$TAG today Length : ${todayinterData.length}");
          _isLoading = false;
          notifyListeners();
        }
        notifyListeners();
      } else {
        _isLoading = false;
        throw const HttpException('Failed To get Leads');
      }
      // print('----------------------------');
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      rethrow;
    }
  }

  Future<void> getInteraction(String authToken) async {
    _isFirstLoadRunning = true;
    token = authToken;
    notifyListeners();
    var page = 1;
    var url = '${ApiManager.BASE_URL}${ApiManager.interaction}?page=$page';
    debugPrint(url);
    final headers = {
      'Authorization-token': ApiManager.Authorization_token,
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
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
        _interactionData.clear();
        _todayinterData.clear();
        _upcominginterData.clear();
        _overAllData.clear();

        _page = 1;
        notifyListeners();
        if (callData != 0) {
          var data = callData['data'];
          total = callData['total'];
          notifyListeners();

          print(data);
          if (success == 200) {
            _isLoading = false;
            notifyListeners();
            print(data.length);

            for (var v in data) {
              // print('v--->$v');
              if (ymdDate(v['schedule_date'])
                  .isBefore(ymdDate(DateTime.now().toString()))) {
                print(v);
                _interactionData.add(Missed.fromJson(v));
                _interactionData
                    .sort((a, b) => b.scheduleDate!.compareTo(a.scheduleDate!));
                notifyListeners();
              }

              if (ymdDate(v['schedule_date'])
                  .isAtSameMomentAs(ymdDate(DateTime.now().toString()))) {
                print(v);
                _todayinterData.add(Missed.fromJson(v));
                _todayinterData
                    .sort((a, b) => b.scheduleDate!.compareTo(a.scheduleDate!));

                notifyListeners();
              }
              if (ymdDate(v['schedule_date'])
                  .isAfter(ymdDate(DateTime.now().toString()))) {
                print(v);
                _upcominginterData.add(Missed.fromJson(v));
                _upcominginterData
                    .sort((a, b) => b.scheduleDate!.compareTo(a.scheduleDate!));
                notifyListeners();
              }

            }
            _overAllData.addAll(_upcominginterData);
            _overAllData.addAll(_todayinterData);
            _overAllData.addAll(_interactionData);
            _overAllData
                .sort((a, b) => b.scheduleDate!.compareTo(a.scheduleDate!));
            notifyListeners();
          }
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
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        controller.position.extentAfter < 50) {
      _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      notifyListeners();
      _page += 1;
      notifyListeners(); // Increase _page by 1
      var url = '${ApiManager.BASE_URL}${ApiManager.interaction}?page=$_page';
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
            // total = callData['total'];
            print(data);
            if (success == 200) {
              _isLoadMoreRunning = false;
              notifyListeners();
              print(data.length);

              for (var v in data) {
                // print('v--->$v');
                if (ymdDate(v['schedule_date'])
                    .isBefore(ymdDate(DateTime.now().toString()))) {
                  print(v);
                  _interactionData.add(Missed.fromJson(v));
                  _interactionData
                      .sort((a, b) => b.scheduleDate!.compareTo(a.scheduleDate!));
                  notifyListeners();
                }

                if (ymdDate(v['schedule_date'])
                    .isAtSameMomentAs(ymdDate(DateTime.now().toString()))) {
                  print(v);
                  _todayinterData.add(Missed.fromJson(v));
                  _todayinterData
                      .sort((a, b) => b.scheduleDate!.compareTo(a.scheduleDate!));

                  notifyListeners();
                }
                if (ymdDate(v['schedule_date'])
                    .isAfter(ymdDate(DateTime.now().toString()))) {
                  print(v);
                  _upcominginterData.add(Missed.fromJson(v));
                  _upcominginterData
                      .sort((a, b) => b.scheduleDate!.compareTo(a.scheduleDate!));
                  notifyListeners();
                }

              }
              _overAllData.clear();
              _overAllData.addAll(_upcominginterData);
              _overAllData.addAll(_todayinterData);
              _overAllData.addAll(_interactionData);
              _overAllData
                  .sort((a, b) => b.scheduleDate!.compareTo(a.scheduleDate!));
              notifyListeners();
            }
            _isLoadMoreRunning = false;
            notifyListeners();
          } else {

            var message = responseData['message'];
            // total = callData;
            Fluttertoast.showToast(msg: '$message');
            _isLoadMoreRunning = false;
            notifyListeners();
          }
        }
      } on NoSuchMethodError catch (err) {
        _isLoadMoreRunning =
        false;
        notifyListeners();
        log(err.toString());
        Fluttertoast.showToast(
          msg: 'Something wrong.',
        );
      }catch(e){
        _isLoadMoreRunning = false;
        notifyListeners();
      }

      // setState(() {
      _isLoadMoreRunning = false;
      notifyListeners();
      // });
    }
  }

  DateTime ymdDate(String date) {
    return DateTime.parse(
        DateFormat('yyyy-MM-dd').format(DateTime.parse(date)));
  }

  String ymdStringDate(String date) {
    return DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
  }

  Future<void> updateInteractionStatus(
      {required String id, required String newStatus}) async {
    var pref = await SharedPreferences.getInstance();
    var authToken = pref.getString('token');
    var url = ApiManager.BASE_URL + ApiManager.updateLeadActivityHistory;
    debugPrint("$TAG UpdateInfoUrl : $url");
    // _isLoading = true;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $authToken',
      'Accept': 'application/json',
    };
    Map<String, dynamic> body = {"id": id, "followup_status": newStatus};

    try {
      final response =
          await http.post(Uri.parse(url), body: body, headers: headers);
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        debugPrint("$TAG UpdateProfileParameters : $responseData");
        notifyListeners();
      } else {
        print('Some thing went wrong. Status code --> ${response.statusCode}');
        notifyListeners();
      }
    } on HttpException catch (e) {
      print(e);
      notifyListeners();
    }
    getInteraction(authToken!);
    notifyListeners();
  }

  late String token;
  late String role;

  int total = 0;

  set setIsLoading(bool value) => _isLoading = value;

  // List<SSSModel> get closedLeadsData => _ClosedLeadsData;
  // List<SSSByDate> get closedLeadsByDate => _ClosedLeadsByDate;
  bool _isFirstLoadRunning = false;
  bool get isFirstLoadRunning => _isFirstLoadRunning;
  int _page = 1;
  late ScrollController controller;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  bool get isLoadMoreRunning => _isLoadMoreRunning;

  bool isAddingContact = false;

  ///TODO:Filter in Leads
  List<String> categoriesList = [
    'Agent',
    'Date Range',
    'Type',
    'Status',
  ];
  List<AgentsByTeam> agentsByTeamList = [];
  List<TeamLeader> teamLeadersList = [];
  List<AgentById> agentsByIdList = [];
  TextEditingController queryAgents = TextEditingController(text: 'All');

  String? selectedAgent;
  String? selectedType;
  String? selectedStatus;

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
    if (selectedAgent == null &&
        fromDate == null &&
        toDate == null &&
        selectedType == null &&
        selectedStatus == null) {
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
      selectedType = null;
      selectedStatus = null;
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

  Future<void> applyFilter(InteractionProvider ip) async {
    var data = {
      "agent_id": ip.selectedAgent ?? "",
      "from_date": ip.fromDate != null ? ip.fromDate.toString() : "",
      "to_date": ip.toDate != null ? ip.toDate.toString() : "",
      "plan_to_do": ip.selectedType ?? '',
      "followup_status": ip.selectedStatus ?? ''
    };
    // filterData=data;
    ip.setFilterData(data);
    print(filterData);

    ip.isFilterApplied(true);
    await getInteraction(token);
    // await ip.getUserActivity();
  }
}
