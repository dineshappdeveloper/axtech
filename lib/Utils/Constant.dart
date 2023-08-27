import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:crm_application/Widgets/contactLstPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class Const {
  static const FCM_TOKEN = 'FCM_TOKEN';
}

int myId=0;


Future<void> saveContactInPhone(Contact contact, BuildContext context) async {
  List<Contact> matchedContact;
  bool contactFound;
  try {
    print("saving Contact");
    PermissionStatus permission = await Permission.contacts.status;

    if (permission != PermissionStatus.granted) {
      await Permission.contacts.request();
      PermissionStatus permission = await Permission.contacts.status;

      if (permission == PermissionStatus.granted) {
        List<Contact> contacts = await ContactsService.getContacts();
        matchedContact = contacts
            .where((con) => con.phones!.any(
                (item) => contact.phones!.any((it) => item.value == it.value)))
            .toList();
        print(matchedContact.length);
        if (matchedContact.isEmpty) {
          contactFound = true;
          print(matchedContact.length);
          await ContactsService.addContact(contact)
              .then((value) => print('Contact Added!'));
          matchedContact.add(contact);
        }
        print(matchedContact.length);
        if (matchedContact.length == 1) {
          var newcontacts = await ContactsService.getContacts();
          var matchedC = newcontacts
              .where((con) => con.phones!.any((item) =>
                  contact.phones!.any((it) => item.value == it.value)))
              .toList();
          print(matchedC.first.toMap());
          print(contacts.length);
          print(newcontacts.length);
          await ContactsService.openExistingContact(
            matchedC.first,
          )
              .then((value) =>
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Contact Saved.'),
                    duration: Duration(seconds: 3),
                  )))
              .whenComplete(() => print('Ssssssssssssssaved!'))
              .onError((error, stackTrace) async => newcontacts.length >
                      contacts.length
                  ? await ContactsService.deleteContact(
                      matchedC.first,
                    ).then((value) =>
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Contact did not saved.'),
                        duration: Duration(seconds: 3),
                      )))
                  : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(''),
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.white,
                    )));
        }
        // print(contacts.length);
        // print(matchedContact.asMap());

        // print(savedContact.toMap());
      } else {
        print(permission);
      }
    } else {
      List<Contact> contacts = await ContactsService.getContacts();
      matchedContact = contacts
          .where((con) => con.phones!.any(
              (item) => contact.phones!.any((it) => item.value == it.value)))
          .toList();
      print(matchedContact.length);
      if (matchedContact.isEmpty) {
        contactFound = true;
        print(matchedContact.length);
        await ContactsService.addContact(contact)
            .then((value) => print('Contact Added!'));
        matchedContact.add(contact);
      }
      print(matchedContact.length);
      if (matchedContact.length == 1) {
        var newcontacts = await ContactsService.getContacts();
        var matchedC = newcontacts
            .where((con) => con.phones!.any(
                (item) => contact.phones!.any((it) => item.value == it.value)))
            .toList();
        print(matchedC.first.toMap());
        print(contacts.length);
        print(newcontacts.length);
        await ContactsService.openExistingContact(
          matchedC.first,
        )
            .then((value) =>
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Contact Saved.'),
                  duration: Duration(seconds: 3),
                )))
            .whenComplete(() => print('Ssssssssssssssaved!'))
            .onError((error, stackTrace) async => newcontacts.length >
                    contacts.length
                ? await ContactsService.deleteContact(
                    matchedC.first,
                  ).then((value) =>
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Contact did not saved.'),
                      duration: Duration(seconds: 3),
                    )))
                : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(''),
                    duration: Duration(seconds: 3),
                    backgroundColor: Colors.white,
                  )));
      }
      // print(contacts.length);
      // print(matchedContact.asMap());

      // print(savedContact.toMap());
    }
    print("object");
  } on FormOperationException catch (e) {
    print(e);
    // return true;
    // rethrow;
  }
  // FormOperationException: FormOperationErrorCode.FORM_OPERATION_CANCELED
}

///TODO:TExt
Text Htext(String text, {Color? color}) {
  return Text(
    text,
    style: Get.theme.textTheme.headline4!
        .copyWith(color: color ?? Colors.white, fontWeight: FontWeight.bold),
  );
}

Text Ttext(String text, {Color? color}) {
  return Text(
    text,
    style: Get.theme.textTheme.bodyText1!
        .copyWith(color: color ?? Colors.white, fontWeight: FontWeight.bold),
  );
}

String maskString(String item, bool isEmail) {
  String maskedString = '';
  if (isEmail) {
    if (item.contains('@')) {
      String firstSplit = item.split('@').first;
      String lastSplit = item.split('@').last;
      if (firstSplit.length < 5) {
        firstSplit = firstSplit.split('').first + '*******';
      } else {
        firstSplit = firstSplit.substring(0, 3) + '*******';
      }
      maskedString = firstSplit + lastSplit;
    }
  } else {
    if (item.length > 7) {
      maskedString = item.substring(0, 3) +
          '******' +
          item.substring(item.length - 3, item.length - 1);
    }
  }
  print('masked String $maskedString');

  return maskedString;
}
