import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:crm_application/ApiManager/Apis.dart';
import 'package:crm_application/Models/NewModels/UsrModel.dart';
import 'package:crm_application/Screens/Auth/LoginScreen.dart';
import 'package:crm_application/Screens/Profile/UserProfile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/Constant.dart';
import 'UserProvider.dart';

class AuthProvider with ChangeNotifier {
  var _token, otp;
  late int _userId;
  var _fName, _lName;
  late SharedPreferences prefs;
  String TAG = "AuthProvider";
  bool _isLoading = false;
  var box, _firstNames, _lastNames, _userIds;
  late Map<String, dynamic> res;

  String get Token => _token;

  int get userIds => _userIds;

  String get firstName => _firstNames;

  String get lastName => _lastNames;

  bool get isLoading => _isLoading;

  Future<void> login(String email, String password, String fcmToken,
      BuildContext context) async {
    _isLoading = true;
    var url = ApiManager.BASE_URL + ApiManager.Login;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Accept': 'application/json',
    };
    Map<String, dynamic> body = {
      'input': email,
      'password': password,
      'device_token': fcmToken,
    };
    try {
      final response =
          await http.post(Uri.parse(url), body: body, headers: headers);
      var responseData = json.decode(response.body);
      debugPrint("$TAG Parameters : $body");
      log("$TAG Response : $responseData");
      if (response.statusCode == 200) {
        _isLoading = false;
        if (responseData['success'] == 200) {
          var result = responseData['results'];
          prefs = await SharedPreferences.getInstance();

          // print( Provider.of<UserProvider>(context,listen: false).user);
          try {
            Provider.of<UserProvider>(context, listen: false).role =
                result['role'];
            Provider.of<UserProvider>(context, listen: false).user =
                UserModel.fromJson(responseData['results']);
            prefs.setString(
                'user',
                jsonEncode(Provider.of<UserProvider>(context, listen: false)
                    .user
                    .toJson()));
            // print(Provider.of<UserProvider>(context, listen: false).user.role);
            // print(Provider.of<UserProvider>(context, listen: false).user);
          } catch (e) {
            print(e);
          }
          _token = result['token'];
          var data = result['data'];
          _userId = data['id'];
          _fName = data['first_name'];
          _lName = data['last_name'];
          prefs.setString('password', password);
          prefs.setString('token', _token);
          prefs.setInt('userId', _userId);
          prefs.setString('fname', _fName);
          prefs.setString('lname', _lName);
          prefs.setString('email', data['email']);
          prefs.setString('image', data['user_profile'] ?? '');
          prefs.setString('address', data['address'] ?? '');
          prefs.setString('availability', data['availability']);
          prefs.setInt('sssPermission', data['permission_menu']);
          prefs.setInt('clPermission', data['permission_for_cl']);
          notifyListeners();
        }
      } else {
        _isLoading = false;
        throw const HttpException('Auth Failed');
      }
    } catch (error) {
      _isLoading = false;
      rethrow;
    }
  }

  void UpdateProfile(var userId, var fName, var lName, var phone,
      var altcontact, var address, var authToken, BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    var url = ApiManager.BASE_URL + ApiManager.updateProfileInfo;
    debugPrint("$TAG UpdateInfoUrl : $url");
    _isLoading = true;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $authToken',
      'Accept': 'application/json',
    };
    Map<String, dynamic> body = {
      "user_id": userId, //"247",
      "first_name": fName, //"Agent",
      "last_name": lName, //"one",
      "phone": phone, //"12345678911",
      "at_contact": altcontact, //"12345678911",
      "address": address, //"dsd",
    };
    try {
      final response =
          await http.post(Uri.parse(url), body: body, headers: headers);
      var responseData = json.decode(response.body);
      debugPrint("$TAG UpdateProfileParameters : $body");
      if (response.statusCode == 200) {
        log('$TAG UpdateProfileResponse : $responseData');
        if (responseData['success'] == 200) {
          _isLoading = false;
          String? address = responseData['data']['address'];
          prefs.setString('fname', responseData['data']['first_name']);
          prefs.setString('lname', responseData['data']['last_name']);
          prefs.setString('address', address!);
          prefs.setInt('phone', int.parse(responseData['data']['phone']));
          prefs.setInt(
              'sssPermission', responseData['data']['permission_menu']);
          prefs.setInt(
              'clPermission', responseData['data']['permission_for_cl']);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfile(),
            ),
          );
          notifyListeners();
        }
      } else {
        _isLoading = false;
        log('Error Message: ${response.body}');
        notifyListeners();
        throw const HttpException('Fail to UpdateProfile');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> changeAvailability(
      var availability, var authToken, BuildContext context) async {
    var url = ApiManager.BASE_URL + ApiManager.updateAvailabilities;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $authToken',
      'Accept': 'application/json',
    };
    Map<String, dynamic> body = {
      'availability': availability,
    };
    try {
      final response =
          await http.post(Uri.parse(url), body: body, headers: headers);
      var responseData = json.decode(response.body);
      debugPrint("$TAG Parameters : $body");
      debugPrint(responseData.toString());
      if (response.statusCode == 401) {
        if (responseData['success'] == 200) {
          var message = responseData['message'];
          var data = responseData['data'];
          prefs = await SharedPreferences.getInstance();
          prefs.setString('availability', data['availability']);
          Navigator.pushReplacementNamed(context, '/home');
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(message)));
          debugPrint("$TAG Success : ${response.body}");
          notifyListeners();
        }
      } else {
        //throw const HttpException('Failed To Send availability');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> ForgetPass(String email) async {
    var url = ApiManager.BASE_URL + ApiManager.forget;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      //'Accept': 'application/json',
    };
    Map<String, dynamic> body = {
      'input': email,
    };
    try {
      final response =
          await http.post(Uri.parse(url), body: body, headers: headers);
      var responseData = json.decode(response.body);
      debugPrint("$TAG Parameters : $body");
      debugPrint(responseData.toString());

      if (response.statusCode == 200) {
        if (responseData['success'] == 200) {
          var userId = responseData['results']['user_id'];
          otp = responseData['results']['otp'];
          debugPrint("$TAG Success : ${response.body}");
          res = {
            'userId': userId,
            'otp': otp,
          };
          notifyListeners();
        }
      } else {
        throw const HttpException('Failed To Send email');
      }
    } catch (error) {
      rethrow;
    }
    return res;
  }

  Future<void> updatePass(
      var userId, var password, var confirmPass, BuildContext context) async {
    _isLoading = true;
    var url = ApiManager.BASE_URL + ApiManager.updatePassword;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      //'Authorization': 'Bearer $authToken',
      'Accept': 'application/json',
    };
    Map<String, dynamic> body = {
      "user_id": userId, //247,
      "new_password": password,
      "confirm_password": confirmPass,
    };
    try {
      final response =
          await http.post(Uri.parse(url), body: body, headers: headers);
      var responseData = json.decode(response.body);
      debugPrint("$TAG Parameters : $body");
      debugPrint(responseData.toString());
      if (response.statusCode == 200) {
        if (responseData['success'] == 200) {
          _isLoading = false;
          var message = responseData['message'];
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(message)));
          debugPrint("$TAG Success : ${response.body}");
          notifyListeners();
        }
      } else {
        _isLoading = false;
        notifyListeners();
        //throw const HttpException('Failed To Send availability');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> Logout() async {
    print(_token);
    prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    print(_token);
    // await prefs.setString(Const.FCM_TOKEN, _token);
  }

  getToken(Future<void> tokens) async {
    prefs = await SharedPreferences.getInstance();
    String token = tokens.toString();
    prefs.setString('FCM_TOKEN', token);
    print('NEW_TOKEN: $token');
  }

  void UpdateInteractionStatus(var authToken, BuildContext context,
      {required String newStatus}) async {
    prefs = await SharedPreferences.getInstance();
    var url = ApiManager.BASE_URL + ApiManager.interaction;
    debugPrint("$TAG UpdateInfoUrl : $url");
    // _isLoading = true;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $authToken',
      'Accept': 'application/json',
    };
    Map<String, dynamic> body = {
      "followup_status": newStatus,
    };
    try {
      final response =
          await http.post(Uri.parse(url), body: body, headers: headers);
      var responseData = json.decode(response.body);
      debugPrint("$TAG UpdateProfileParameters : $body");
      if (response.statusCode == 200) {
        log('$TAG UpdateProfileResponse : $responseData');
        if (responseData['success'] == 200) {
          // _isLoading = false;
          // String? address = responseData['data']['address'];
          // prefs.setString('fname', responseData['data']['first_name']);
          // prefs.setString('lname', responseData['data']['last_name']);
          // prefs.setString('address', address!);
          // prefs.setInt('phone', int.parse(responseData['data']['phone']));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Status updated successfully'),
            ),
          );
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => UserProfile(),
          //   ),
          // );
          notifyListeners();
        }
      } else {
        // _isLoading = false;
        log('Error Message: ${response.body}');
        notifyListeners();
        throw const HttpException('Fail to UpdateStatus');
      }
    } catch (error) {
      // _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
