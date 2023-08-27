import 'package:crm_application/Models/NewModels/UsrModel.dart';
import 'package:flutter/material.dart';

enum UserType{admin,hr,teamleader,jrteamleader,agent,staff}

class UserProvider extends ChangeNotifier{
late String role;
late UserModel user;


}