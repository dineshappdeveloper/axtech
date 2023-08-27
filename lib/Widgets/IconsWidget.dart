import 'package:crm_application/Screens/Cold%20Calls/ContactTabsScreen.dart';
import 'package:crm_application/Screens/Cold%20Calls/Intraction/InteractionsScreen.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/MyLeadScreen.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/dumpedCall/DumpedLeadScreen.dart';
import 'package:crm_application/Screens/DashBoard/LeavesPage.dart';
import 'package:crm_application/Utils/Colors.dart';
import 'package:crm_application/Utils/ImageConst.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Screens/Cold Calls/ColdCallScreen.dart';
import '../Screens/Cold Calls/DialerScreen.dart';
import '../Screens/DashBoard/Reports/UsersActivity.dart';

Column LeadWidget(String name, BuildContext context) {
  return Column(
    children: [
      Expanded(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                // builder: (context) => ContactTabsScreen(pageIndex: 'leads'),
                builder: (context) => MyLeadScreen(),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: themeColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 10),
                  blurRadius: 30,
                  color: themeColor.withOpacity(0.23),
                ),
              ],
            ),
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(25),
                child: Image.asset(
                  ImageConst.leads_icon,
                  color: Colors.white,
                  height: 40,
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      Text(
        name,
        style: const TextStyle(
          //fontFamily: 'avenir',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}
Column DumpLeadWidget(String name, BuildContext context) {
  return Column(
    children: [
      Expanded(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                // builder: (context) => ContactTabsScreen(pageIndex: 'leads'),
                builder: (context) => DumpedLeadScreen(),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: themeColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 10),
                  blurRadius: 30,
                  color: themeColor.withOpacity(0.23),
                ),
              ],
            ),
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(25),
                child: Image.asset(
                  ImageConst.dump_leads_icon,
                  color: Colors.white,
                  height: 40,
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      Text(
        name,
        style: const TextStyle(
          //fontFamily: 'avenir',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

Column InteractionWidget(String name, BuildContext context) {
  return Column(
    children: [
      Expanded(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    // ContactTabsScreen(pageIndex: 'interaction'),
                    InteractionsScreen(),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: themeColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 10),
                  blurRadius: 30,
                  color: themeColor.withOpacity(0.23),
                ),
              ],
            ),
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(25),
                child: Image.asset(
                  ImageConst.call_icon,
                  color: Colors.white,
                  height: 40,
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      Text(
        name,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

Column DialerWidget(String name, BuildContext context) {
  return Column(
    children: [
      Expanded(
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DialerScreen(),
                ));
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: themeColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 10),
                  blurRadius: 30,
                  color: themeColor.withOpacity(0.23),
                ),
              ],
            ),
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(25),
                child: Image.asset(
                  ImageConst.keypad_icon,
                  color: Colors.white,
                  height: 40,
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      Text(
        name,
        style: const TextStyle(
          //fontFamily: 'avenir',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

Column ReportWidget(String name) {
  return Column(
    children: [
      Expanded(
        child: InkWell(
          onTap: () {
            // Get.to(UsersActivity());
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: /*Color(0xfff1f3f6)*/ themeColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 10),
                  blurRadius: 30,
                  color: themeColor.withOpacity(0.23),
                ),
              ],
            ),
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(25),
                child: Image.asset(
                  ImageConst.report_icon,
                  color: Colors.white,
                  height: 50,
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      Text(
        name,
        style: const TextStyle(
          //fontFamily: 'avenir',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

Column CallsWidget(String name, BuildContext context) {
  return Column(
    children: [
      Expanded(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ColdCallScreen(),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: themeColor,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 30,
                  color: themeColor.withOpacity(0.23),
                ),
              ],
            ),
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(25),
                child: Image.asset(
                  ImageConst.cold_call,
                  color: Colors.white,
                  height: 50,
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      Text(
        name,
        style: const TextStyle(
          //fontFamily: 'avenir',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

Column LeavesWidget(String name, BuildContext context) {
  return Column(
    children: [
      Expanded(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LeavesPage()));
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: /*Color(0xfff1f3f6)*/ themeColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 10),
                  blurRadius: 30,
                  color: themeColor.withOpacity(0.23),
                ),
              ],
            ),
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(25),
                child: Image.asset(
                  ImageConst.office_leave,
                  color: Colors.white,
                  height: 55,
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      Text(
        name,
        style: const TextStyle(
          //fontFamily: 'avenir',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}
