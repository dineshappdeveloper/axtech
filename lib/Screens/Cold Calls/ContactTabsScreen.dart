import 'package:crm_application/Screens/Cold%20Calls/DialerScreen.dart';
import 'package:flutter/material.dart';
import '../../Utils/Colors.dart';
import '../../Utils/ImageConst.dart';
import 'ExpectedCallScreen.dart';
import 'Intraction/InteractionsScreen.dart';
import 'MyLeads/MyLeadScreen.dart';

class ContactTabsScreen extends StatefulWidget {
  String pageIndex;

  ContactTabsScreen({Key? key, required this.pageIndex}) : super(key: key);

  @override
  State<ContactTabsScreen> createState() => _ContactTabsScreenState();
}

class _ContactTabsScreenState extends State<ContactTabsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.pageIndex == 'leads' ? 1 : 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: themeColor,
          elevation: 1,
          titleSpacing: 0,
          title: const Text('Contact'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list_rounded)),
            const SizedBox(width: 10),
          ],
          bottom: TabBar(
            isScrollable: false,
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: const EdgeInsets.symmetric(horizontal: 18),
            tabs: [
              Tab(
                iconMargin: const EdgeInsets.all(10),
                icon: Image.asset(
                  ImageConst.call_icon,
                  height: 20,
                  color: Colors.white,
                ),
                child: const Text(
                  'Interactions',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Tab(
                iconMargin: const EdgeInsets.all(10),
                icon: Image.asset(
                  ImageConst.leads_icon,
                  height: 20,
                  color: Colors.white,
                ),
                child: const Text(
                  'My Leads',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              /*Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Tab(
                  iconMargin: const EdgeInsets.all(10),
                  icon: Image.asset(
                    'assets/images/down-arrow.png',
                    height: 20,
                    color: Colors.white,
                  ),
                  child: const Text(
                    'Expected Cold Call',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),*/
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            InteractionsScreen(),
            MyLeadScreen(),
            //ExpectedCallScreen(),
          ],
        ),
        floatingActionButton: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DialerScreen(),
                ));
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 9.0,
                ),
              ],
            ),
            height: 50,
            width: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/keypad.png',
                  height: 20,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'Cold Call',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


