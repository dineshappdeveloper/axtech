import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crm_application/ApiManager/Apis.dart';
import 'package:crm_application/Utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Models/DialModel.dart';
import '../Models/LeadInfoModel.dart';
import '../Screens/Cold Calls/DialerScreen.dart';

class DialProvider extends ChangeNotifier {
  List<DialModel> allCalls = [];
  Timer? timer;
  // int dialogCount = 0;
  bool dialogOpen = false;
  Future<List<DialModel>> refreshData() async {
    var data = await DatabaseHelper.getItems();
    allCalls.clear();
    for (var element in data) {
      if (element['status'] == 0) {
        allCalls.add(DialModel.fromJson(element));
        // dialogCount=1;
      }
      notifyListeners();
    }
    print('all calls length ${allCalls.length}');
    return allCalls;
  }

  Future<void> makeDialCall(String number, String type, {String? name}) async {
    var calldone = await callANumber(number);
    print('Call done $calldone');

    if (true) {
      await DatabaseHelper.createItem(
        callId: int.parse(number),
        type: type,
        startTime: DateTime.now().toString(),
        connected: 1,
        endTime: DateTime.now().toString(), name: name??'',
      ).then((value) async => await refreshData());
    }
  }

  void fetchDialedCalls() async {
    timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) async {
        await refreshData();
        if (allCalls.isNotEmpty && !dialogOpen) {
          // dialogCount=0;
          submitCallInfoDialog(allCalls.first);
        } else {
          // dialogCount=0;
        }
      },
    );
  }

  void submitCallInfoDialog(DialModel dial,{String? leadNumber}) async {
    showDialog(
      context: Get.context!,

      barrierDismissible: false,
      builder: (context) {
        return DialledCallSubmitDialog(
          dial: dial,
          leadNumber: leadNumber,
        );
      },
    );
  }

  Future<void> makeCallAndSave(
      {required DialModel dial, String? customerName}) async {
    var pref = await SharedPreferences.getInstance();
    var authToken = pref.getString('token');
    var url = ApiManager.BASE_URL + ApiManager.addCallingHistory;
    debugPrint("Dial Provider UpdateInfoUrl : $url");
    final headers = {
      'Authorization-token': ApiManager.Authorization_token,
      'Authorization': 'Bearer $authToken',
    };
    Map<String, dynamic> body = {
      "type": dial.type.toLowerCase(),
      "phone": dial.type == "Lead" ? '' : dial.callId.toString(),
      "customer_name": customerName,
      "call_id": dial.type != "Lead" ? '' : dial.callId.toString(),
      "start_time": dial.startTime,
      "end_time": dial.endTime,
      "is_connected": dial.connected.toString()
    };

    try {
      debugPrint("Dial Provider parameters : $body");
      final response =
          await http.post(Uri.parse(url), body: body, headers: headers);
      print(response.body);
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        debugPrint("Dial Provider  : $responseData");
        await DatabaseHelper.updateItem(dial);
        dialogOpen = false;
        notifyListeners();
        Fluttertoast.showToast(msg: responseData['message']);
      } else {
        print('Some thing went wrong. Status code --> ${response.statusCode}');
        notifyListeners();
      }
    } on HttpException catch (e) {
      print(e);
      notifyListeners();
    }
    notifyListeners();
  }
}
