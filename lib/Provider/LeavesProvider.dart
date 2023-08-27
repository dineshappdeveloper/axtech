import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:crm_application/Provider/UserProvider.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/LeadFilter/Models/agentsModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiManager/Apis.dart';
import '../Models/LeadsModel.dart';
import '../Models/LeavesModel.dart';
import 'package:flutter/foundation.dart';
import '../../../ApiManager/Apis.dart';
import '../../../Models/LeadsModel.dart';

class LeavesProvider with ChangeNotifier {
  late String token;
  late String role;

  String TAG = 'LeavesProvider';

  TextEditingController descriptionController = TextEditingController();
  DateTime fDate = DateTime.now();
  DateTime tDate = DateTime.now().add(const Duration(days: 1));
  String? dropdownValue;
  String statusText = 'Select Leave Status';
  String leavesType = "Sick Leave";

  bool filter = false;

  int waiting = 0;
  int total = 0;
  int approved = 0;
  int notApproved = 0;

  List approvalList = ['Waiting for Approval', 'Approved', 'Not Approved'];

  List<LeavesTypeModel> leavesTypeList = [];
  List<Leaves> allLeaves = [];
  var name;

  bool _isLoading = false;

  bool get IsLoading => _isLoading;
  void setIsLoading (bool val){
    _isLoading=val;
    notifyListeners();
  }
  bool _isFirstLoadRunning = false;
  bool get isFirstLoadRunning => _isFirstLoadRunning;
  int _page = 1;
  late ScrollController controller;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  bool get isLoadMoreRunning => _isLoadMoreRunning;

  Future<List<LeavesTypeModel>> getLeavesTypeList() async {
    var pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;

    leavesTypeList.clear();

    var url = ApiManager.BASE_URL + ApiManager.getLeavesTypes;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      var responseData = json.decode(response.body);
      // debugPrint('Leaves Total : ---' + responseData.toString());
      if (response.statusCode == 200) {
        var leavetypes = responseData['leavetypes'];

        leavetypes.forEach((type) {
          // print((type));
          leavesTypeList.add(LeavesTypeModel.fromJson(type));
          notifyListeners();
        });
        if (kDebugMode) {
          print('leavesTypeList ${leavesTypeList.length}');
        }
        return leavesTypeList;
      } else {
        throw const HttpException('Failed To get Leads');
      }
      // print('----------------------------');
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getAllLeaves() async {
    _page = 1;
    var url = ApiManager.BASE_URL + ApiManager.getAllLeaves + '?page=$_page';
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
    try {
      _isFirstLoadRunning = true;
      notifyListeners();
      print('before response --> $filterData');
      print('before response --> $url');
      _isLoading = true;
      notifyListeners();
      final response =
          await http.post(Uri.parse(url), headers: headers, body: filterData);
      var responseData = json.decode(response.body);
      print('After response --> $responseData');
      if (response.statusCode == 200) {
        var leaves = responseData['leaves'];
        var approvedleaves = responseData['approvedleaves'];
        var waitingleaves = responseData['waitingleaves'];
        var notapprovedleaves = responseData['notapprovedleaves'];
        allLeaves.clear();
        _page = 1;
        notifyListeners();
        approvedleaves['data'].forEach((leave) {
          allLeaves.add(Leaves.fromJson(leave));
        });
        waitingleaves['data'].forEach((leave) {
          allLeaves.add(Leaves.fromJson(leave));
        });
        notapprovedleaves['data'].forEach((leave) {
          allLeaves.add(Leaves.fromJson(leave));
        });
        allLeaves.sort((a, b) => b.postingDate!.compareTo(a.postingDate!));
        total = leaves['total'];
        var count = responseData['count'];
        approved = count['approvedleaves'];
        waiting = count['waitingleaves'];
        notApproved = count['notapprovedleaves'];
        _isLoading = false;
        _isFirstLoadRunning = false;
        notifyListeners();
        if (kDebugMode) {
          print('allLeaves ${allLeaves.length}');
        }
      } else {
        _isLoading = false;
        _isFirstLoadRunning = false;
        notifyListeners();
        throw const HttpException('Failed To get Leaves');
      }
      // print('----------------------------');
    } catch (error) {
      _isLoading = false;
      _isFirstLoadRunning = false;
      notifyListeners();
      rethrow;
    }
  }

  void loadMore() async {
    // print('this is load more');
    // print('this is load more ${controller.position.extentAfter}');
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        controller.position.extentAfter < 300) {
      _isLoadMoreRunning = true;
      notifyListeners();
      print('this is load more  $_isLoadMoreRunning');
      _page += 1;
      notifyListeners(); // Increase _page by 1
      var url = ApiManager.BASE_URL + ApiManager.getAllLeaves + '?page=$_page';
      final headers = {
        'Authorization-token': '3MPHJP0BC63435345341',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      };
      debugPrint('LoadMore Url : $url');

      try {
        final response =
            await http.post(Uri.parse(url), headers: headers, body: filterData);
        var responseData = json.decode(response.body);
        if (response.statusCode == 200) {
          var leaves = responseData['leaves'];
          var approvedleaves = responseData['approvedleaves'];
          var waitingleaves = responseData['waitingleaves'];
          var notapprovedleaves = responseData['notapprovedleaves'];
          notifyListeners();
          approvedleaves['data'].forEach((leave) {
            allLeaves.add(Leaves.fromJson(leave));
          });
          waitingleaves['data'].forEach((leave) {
            allLeaves.add(Leaves.fromJson(leave));
          });
          notapprovedleaves['data'].forEach((leave) {
            allLeaves.add(Leaves.fromJson(leave));
          });
          allLeaves.sort((a, b) => b.postingDate!.compareTo(a.postingDate!));
          _isLoading = false;
          _isLoadMoreRunning = false;
          notifyListeners();
          if (kDebugMode) {
            print('allLeaves ${allLeaves.length}');
          }
        } else {
          _isLoading = false;
          _isLoadMoreRunning = false;
          notifyListeners();
          throw const HttpException('Failed To get Leaves');
        }
      } on NoSuchMethodError catch (err) {
        _isLoadMoreRunning = false;
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

  ///TODO:Filter in Leads
  List<String> categoriesList = [
    'Agent',
    'Date Range',
    'Status',
    'Leaves Type'
  ];
  List<AgentsByTeam> agentsByTeamList = [];
  List<AgentById> agentsByIdList = [];
  TextEditingController queryAgents = TextEditingController(text: 'All');
  TextEditingController queryLeave = TextEditingController(text: 'All');
  String? selectedAgent;
  int filterIndex = 0;
  int? leaveTypeId;

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

  void setIsFlrApplied() {
    // print(jsonEncode(filterData));
    print(selectedAgent);
    print(fromDate);
    print(toDate);
    print(filterData);
    print(selectedAgent == null &&
        fromDate == null &&
        toDate == null &&
        leaveTypeId == null &&
        dropdownValue == null &&
        filterData == {});
    if (selectedAgent == null &&
        fromDate == null &&
        leaveTypeId == null &&
        dropdownValue == null &&
        toDate == null) {
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
      leaveTypeId = null;
      dropdownValue = null;

      filterData.clear();
      setIsFlrApplied();
      notifyListeners();
    } else {
      setIsFlrApplied();
      notifyListeners();
    }
    return true;
  }

  Future<void> applyFilter(LeavesProvider lp) async {
    var data = {
      "agent_id": lp.selectedAgent ?? "",
      "from_date": lp.fromDate != null ? lp.fromDate.toString() : "",
      "to_date": lp.toDate != null ? lp.toDate.toString() : "",
      "status": dropdownValue ?? '',
      "leave_type": leaveTypeId != null ? leaveTypeId.toString() : ''
    };
    lp.setFilterData(data);
    lp.isFilterApplied(true);
    await lp.getAllLeaves();
  }

  ///TODO:SELECTION Mode
  bool selectionMode = false;
  void setSelectionMode(bool val) {
    selectionMode = val;
    notifyListeners();
  }

  Set<Lead> selectedLeads = {};
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
