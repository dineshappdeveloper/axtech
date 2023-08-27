import 'package:duration_button/duration_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../Utils/Colors.dart';
import 'FilterProvider.dart';

class FilterFormWidget extends StatefulWidget {
  const FilterFormWidget({
    Key? key,
    required this.onFilterClear,
    required this.applyFilter,
    this.stringFormData,
    this.singleSelectionListData,
    this.multiSelectionListData,
    this.singleHiraricyListData,
  }) : super(key: key);
  final Map<String, dynamic>? stringFormData;
  final Map<String, List<MapEntry<int, String>>>? singleSelectionListData;
  final Map<String, List<MapEntry<int, String>>>? multiSelectionListData;
  final Map<String, List<MapEntry<String, List<MapEntry<dynamic, dynamic>>>>>?
      singleHiraricyListData;
  final Future<void> Function() onFilterClear;
  final void Function(Map<String, dynamic> data) applyFilter;

  @override
  State<FilterFormWidget> createState() => _FilterFormWidgetState();
}

class _FilterFormWidgetState extends State<FilterFormWidget> {
  int selectedIndex = 0;

  Map<String, dynamic> submitData = {};

  Map<String, dynamic> stringFormData = {
    '1': 'hiii',
    '12': 'hiii',
    '13': 'hiii',
  };
  Map<String, List<MapEntry<int, String>>> singleSelectionListData = {
    'Single': [
      MapEntry(1, "Option 1"),
      MapEntry(2, "Option 2"),
      MapEntry(3, "Option 3"),
    ],
    'Single2': [
      MapEntry(1, "Option 1"),
      MapEntry(2, "Option 2"),
      MapEntry(3, "Option 3"),
      MapEntry(4, "Option 4"),
      MapEntry(5, "Option 5"),
      MapEntry(6, "Option 6"),
      MapEntry(7, "Option 7"),
    ],
    'Single3': [
      MapEntry(1, "Option 1"),
      MapEntry(2, "Option 2"),
      MapEntry(3, "Option 3"),
      MapEntry(4, "Option 4"),
      MapEntry(5, "Option 5"),
    ],
  };
  Map<String, List<MapEntry<String, List<MapEntry<dynamic, dynamic>>>>>
      singleHiraricyListData = {
    'First hierarchy': [
      MapEntry("Ricky Verghese", [
        MapEntry("1941", "Ahmed Abdelghfar Mohamed"),
        MapEntry("15596", "Syeda Bushra Fatima"),
        MapEntry("2476", "Shubhangi Singh"),
        MapEntry("2580", "Afraa Mahboob"),
        MapEntry("284", "Sarah Nafeh"),
        MapEntry("3347", "Suhail Ahmed Sheikh"),
        MapEntry("3338", "Naveed Andrabi")
      ]),
      MapEntry("Vicky Verghese", [
        MapEntry("1y91", "Ahmed Abdelghfar Mohamed"),
        MapEntry("1e96", "Syeda Bushra Fatima"),
        MapEntry("2y76", "Shubhangi Singh"),
        MapEntry("2e80", "Afraa Mahboob"),
        MapEntry("2e84", "Sarah Nafeh"),
        MapEntry("33e7", "Suhail Ahmed Sheikh"),
        MapEntry("3e38", "Naveed Andrabi")
      ]),
      MapEntry("Shyam Verghese", [
        MapEntry("19rw1", "Ahmed Abdelghfar Mohamed"),
        MapEntry("1er96", "Syeda Bushra Fatima"),
        MapEntry("2e76", "Shubhangi Singh"),
        MapEntry("2r80", "Afraa Mahboob"),
        MapEntry("2wr4", "Sarah Nafeh"),
        MapEntry("33e7", "Suhail Ahmed Sheikh"),
        MapEntry("33r8", "Naveed Andrabi")
      ]),
    ]
  };
  Map<String, List<MapEntry<int, String>>> multiSelectionListData = {
    'Multiple': [
      MapEntry(1, "Option 1"),
      MapEntry(2, "Option 2"),
      MapEntry(3, "Option 3"),
      MapEntry(4, "Option 4"),
      MapEntry(5, "Option 5"),
    ],
    'Multiple2': [
      MapEntry(1, "Option 1"),
      MapEntry(2, "Option 2"),
      MapEntry(3, "Option 3"),
      MapEntry(4, "Option 4"),
      MapEntry(5, "Option 5"),
      MapEntry(6, "Option 6"),
      MapEntry(7, "Option 7"),
    ],
    'Multiple3': [
      MapEntry(1, "Option 1"),
      MapEntry(2, "Option 2"),
      MapEntry(3, "Option 3"),
    ],
  };
  Map<String, List<MapEntry<String, String>>> dateSelectionListData = {
    'Date': [
      MapEntry('From (Date)', DateTime.now().toString()),
      MapEntry('To (Date)', DateTime.now().toString()),
    ]
  };
  @override
  void initState() {
    super.initState();
    submitData = Provider.of<FilterProvider>(context, listen: false).filterData;
    print('on init submitData $submitData');
    if (widget.stringFormData != null) {
      stringFormData = widget.stringFormData!;
    }
    if (widget.singleSelectionListData != null) {
      // singleSelectionListData = widget.singleSelectionListData!;
    }
    if (widget.multiSelectionListData != null) {
      multiSelectionListData = widget.multiSelectionListData!;
    }
    if (widget.multiSelectionListData != null) {
      singleHiraricyListData = widget.singleHiraricyListData!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterProvider>(builder: (context, fp, _) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Text('Filters', style: Get.theme.textTheme.headline6),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Row(
          children: [
            // DurationButton(
            //     onPressed: () {
            //       setState(() {});
            //     },
            //     child: Text(''),
            //     duration: Duration(milliseconds: 500)),
            Expanded(
              flex: 2,
              child: filterLeftSection([
                if (stringFormData.isNotEmpty)
                  ...stringFormData.entries.map((e) => MapEntry(
                      e.key,
                      submitData.entries.any((element) => element.key == e.key)
                          ? submitData.entries
                              .firstWhere((element) => element.key == e.key)
                              .value
                          : '${e.key} is null')),
                if (singleSelectionListData.isNotEmpty)
                  ...singleSelectionListData.entries.map((e) =>
                      MapEntry(e.key, fp.singleSelectedItem != null ? 1 : 0)),
                if (multiSelectionListData.isNotEmpty)
                  ...multiSelectionListData.entries.map(
                      (e) => MapEntry(e.key, fp.multipleSelectedItem.length)),
                if (singleHiraricyListData.isNotEmpty)
                  ...singleHiraricyListData.entries.map((e) =>
                      MapEntry(e.key, fp.singleHSelectedItem != null ? 1 : 0)),
                if (dateSelectionListData.isNotEmpty)
                  ...dateSelectionListData.entries.map((e) =>
                      MapEntry(e.key, fp.singleHSelectedItem != null ? 1 : 0)),
              ]),
            ),
            VerticalDivider(width: 1, color: themeColor),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                // child:Text('testing'),
                child: Consumer<FilterProvider>(builder: (context, fp, _) {
                  if (selectedIndex < stringFormData.length) {
                    if (submitData.entries.any((element) =>
                        element.key ==
                        stringFormData.entries.toList()[selectedIndex].key)) {
                      print('StringFormFilter yes');
                      fp.textFieldQuery.text = submitData.entries
                          .firstWhere((element) =>
                              element.key ==
                              stringFormData.entries
                                  .toList()[selectedIndex]
                                  .key)
                          .value;
                    } else {
                      // print('StringFormFilter no');

                      fp.textFieldQuery = TextEditingController(text: '');
                    }
                    return Column(
                      children: [
                        StringFormFilter(
                          filterValue: (val) {
                            print('val.length  ${val.isNotEmpty}');
                            print(
                                'val.length  ${stringFormData.entries.toList()[selectedIndex].key}');
                            val != ''
                                ? submitData.addAll({
                                    stringFormData.entries
                                        .toList()[selectedIndex]
                                        .key: val
                                  })
                                : submitData.removeWhere((k, v) =>
                                    k ==
                                    stringFormData.entries
                                        .toList()[selectedIndex]
                                        .key);
                            // setState((){});
                            if (kDebugMode) {
                              // print(val);
                              print(submitData);
                            }
                          },
                        ),
                      ],
                    );
                  } else if (selectedIndex >= stringFormData.length &&
                      selectedIndex <
                          (stringFormData.length +
                              singleSelectionListData.length)) {
                    fp.setIndex(stringFormData.length +
                        singleSelectionListData.length -
                        1 -
                        selectedIndex);

                    if (submitData.entries.any((element) =>
                        element.key ==
                        singleSelectionListData.entries
                            .toList()
                            .reversed
                            .toList()[fp.index]
                            .key)) {
                      var item = submitData.entries
                          .firstWhere((element) =>
                              element.key ==
                              singleSelectionListData.entries
                                  .toList()
                                  .reversed
                                  .toList()[fp.index]
                                  .key)
                          .value;
                      print('yes');
                      print(singleSelectionListData.entries
                          .toList()
                          .reversed
                          .toList()[fp.index]
                          .key);
                      print(item);
                      fp.singleSelectedItem = singleSelectionListData.entries
                          .toList()
                          .reversed
                          .toList()[fp.index]
                          .value
                          .firstWhere((element) => element.value == item);
                      fp.textFieldQuery.text = fp.singleSelectedItem!.value;
                    } else {
                      fp.singleSelectedItem = null;
                      fp.textFieldQuery.text = '';
                    }
                    print(fp.index);
                    return Column(
                      children: [
                        // DurationButton(onPressed: (){}, child: Text('sdfof'), duration: Duration(milliseconds: 500)),
                        Expanded(
                          child: SingleSelectionForm(
                            selectionList: singleSelectionListData.entries
                                .toList()
                                .reversed
                                .toList()[fp.index]
                                .value,
                            selectedValue: (MapEntry<int, String>? val) {
                              val != null
                                  ? submitData.addAll({
                                      singleSelectionListData.entries
                                          .toList()
                                          .reversed
                                          .toList()[fp.index]
                                          .key: val.value
                                    })
                                  : submitData.remove(singleSelectionListData
                                      .entries
                                      .toList()
                                      .reversed
                                      .toList()[fp.index]
                                      .key);
                              if (kDebugMode) {
                                print(val);
                                print(submitData);
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  } else if (selectedIndex >=
                          (stringFormData.length +
                              singleSelectionListData.length) &&
                      selectedIndex <
                          (stringFormData.length +
                              singleSelectionListData.length +
                              multiSelectionListData.length)) {
                    var index = stringFormData.length +
                        singleSelectionListData.length +
                        multiSelectionListData.length -
                        1 -
                        selectedIndex;

                    print('selected index ---> $selectedIndex');
                    print('index for multiple ---> $index');
                    if (submitData.entries.any((element) =>
                        element.key ==
                        multiSelectionListData.entries
                            .toList()
                            .reversed
                            .toList()[index]
                            .key)) {
                      print('yes');

                      var item = submitData.entries
                          .firstWhere((element) =>
                              element.key ==
                              multiSelectionListData.entries
                                  .toList()
                                  .reversed
                                  .toList()[index]
                                  .key)
                          .value as List<MapEntry<int, String>>;
                      // if (kDebugMode) {
                      print(item);
                      // }
                      // fp.multipleSelectedItem = item.toSet();
                      fp.multipleSelectedItem.clear();
                      for (var e in item) {
                        fp.multipleSelectedItem.add(MapEntry(e.key, e.value));
                        // print(fp.multipleSelectedItem.length);
                        // fp.multipleSelectedItem = {};
                      }
                    } else {
                      fp.multipleSelectedItem = {};
                      // print('No');
                    }
                    fp.textFieldQuery.text = '';

                    return MultiSelectionForm(
                      selectionList: multiSelectionListData.entries
                          .toList()
                          .reversed
                          .toList()[index]
                          .value,
                      selectedValue: (Set<MapEntry<int, String>> val) {
                        submitData.addAll({
                          multiSelectionListData.entries
                              .toList()
                              .reversed
                              .toList()[index]
                              .key: val.toSet().toList()
                        });
                        if (kDebugMode) {
                          // print(val);
                          // print(submitData);
                        }
                      },
                    );
                  } else if (selectedIndex >=
                          (stringFormData.length +
                              singleSelectionListData.length +
                              multiSelectionListData.length) &&
                      selectedIndex <
                          (stringFormData.length +
                              singleSelectionListData.length +
                              multiSelectionListData.length +
                              singleHiraricyListData.length)) {
                    var index = stringFormData.length +
                        singleSelectionListData.length +
                        multiSelectionListData.length +
                        singleHiraricyListData.length -
                        1 -
                        selectedIndex;

                    print('singleHiraricyListData index ---> $selectedIndex');
                    print('index for singleHiraricyListData ---> $index');
                    if (submitData.entries.any((element) =>
                        element.key ==
                        singleHiraricyListData.entries
                            .toList()
                            .reversed
                            .toList()[index]
                            .key)) {
                      print('yes');

                      var item = submitData.entries
                          .firstWhere((element) =>
                              element.key ==
                              singleHiraricyListData.entries
                                  .toList()
                                  .reversed
                                  .toList()[index]
                                  .key)
                          .value;

                      // print(item);

                      var mapEntry = singleHiraricyListData.entries
                          .toList()
                          .reversed
                          .toList()[index]
                          .value
                          .firstWhere((element) => element.value
                              .any((element) => element.key == item))
                          .value
                          .lastWhere((element) => element.key == item);
                      fp.singleHSelectedItem = mapEntry;
                      // print(mapEntry);
                      // }
                    } else {
                      fp.singleHSelectedItem = null;
                      print('No');
                    }
                    fp.textFieldQuery.text = '';

                    return SingleHirerchySelectionForm(
                      selectionList: singleHiraricyListData.entries
                          .toList()
                          .reversed
                          .toList()[index]
                          .value,
                      selectedValue: (MapEntry<dynamic, dynamic>? val) {
                        val != null
                            ? submitData.addAll({
                                singleHiraricyListData.entries
                                    .toList()
                                    .reversed
                                    .toList()[index]
                                    .key: val.key
                              })
                            : submitData.remove(singleHiraricyListData.entries
                                .toList()
                                .reversed
                                .toList()[index]
                                .key);
                        if (kDebugMode) {
                          // print(val);
                          print(submitData);
                        }
                      },
                    );
                  }

                  return DateRangeForm(
                    selectedValue: (List<MapEntry<String, String>>? val) {
                      val != null
                          ? submitData.addAll({
                              dateSelectionListData.entries.toList().first.key:
                                  val
                            })
                          : submitData.remove(
                              dateSelectionListData.entries.toList().first.key);
                      if (kDebugMode) {
                        // print(val);
                        print(submitData);
                      }
                    },
                    selectionList:
                        dateSelectionListData.entries.toList().first.value,
                  );
                }),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          height: 70,
          child: Column(
            children: [
              const Divider(height: 1, thickness: 1),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () async {
                        Provider.of<FilterProvider>(context, listen: false)
                            .multipleSelectedItem
                            .clear();
                        Provider.of<FilterProvider>(context, listen: false)
                            .singleSelectedItem = null;
                        Provider.of<FilterProvider>(context, listen: false)
                            .textFieldQuery
                            .clear();
                        Provider.of<FilterProvider>(context, listen: false)
                            .filterData
                            .clear();
                        Future.delayed(const Duration(seconds: 1), () {
                          Get.back();
                        });
                        widget.onFilterClear();
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.clear,
                            size: 13,
                          ),
                          Text(' Clear Filters'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),),

                      onPressed: () async {
                        if (kDebugMode) {
                          print(submitData);
                        }
                        Provider.of<FilterProvider>(context, listen: false)
                            .setFilterData(submitData);
                        widget.applyFilter(submitData);
                        Get.back();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28.0),
                        child: Text(
                          'Apply',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  ListView filterLeftSection(
    List<MapEntry<String, dynamic>> categoriesList,
  ) {
    return ListView(
      children: [
        ...categoriesList.map(
          (e) => Column(
            children: [
              Stack(
                children: [
                  ListTile(
                    tileColor: selectedIndex == categoriesList.indexOf(e)
                        ? themeColor.withOpacity(0.1)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedIndex = categoriesList.indexOf(e);
                      });
                    },
                    title: SizedBox(
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.key,
                            style: TextStyle(
                                color:
                                    selectedIndex == categoriesList.indexOf(e)
                                        ? Get.theme.primaryColor
                                        : null),
                          ),
                        ],
                      ),
                    ),
                    trailing: Text(
                      e.value == '${e.key} is null'
                          ? ''
                          : e.value.runtimeType == ''.runtimeType
                              ? '💤'
                              : '${e.value == 0 ? '' : e.value}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        color: selectedIndex == categoriesList.indexOf(e)
                            ? themeColor.withOpacity(1)
                            : null,
                        width: 7,
                        height: 58,
                      ),
                    ],
                  ),
                ],
              ),
              Divider(thickness: 0.1, color: themeColor, height: 1),
            ],
          ),
        ),
      ],
    );
  }
}

class StringFormFilter extends StatelessWidget {
  const StringFormFilter({Key? key, required this.filterValue})
      : super(key: key);
  final void Function(String val) filterValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:
          Provider.of<FilterProvider>(context, listen: false).textFieldQuery,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
      onChanged: (val) {
        filterValue(Provider.of<FilterProvider>(context, listen: false)
            .textFieldQuery
            .text);
      },
    );
  }
}

class SingleSelectionForm extends StatefulWidget {
  const SingleSelectionForm(
      {Key? key, required this.selectedValue, required this.selectionList})
      : super(key: key);
  final void Function(MapEntry<int, String>? val) selectedValue;
  final List<MapEntry<int, String>> selectionList;

  @override
  State<SingleSelectionForm> createState() => _SingleSelectionFormState();
}

class _SingleSelectionFormState extends State<SingleSelectionForm> {
  TextEditingController queryController = TextEditingController();
  List<MapEntry<int, String>> selectionList = [];
  @override
  void initState() {
    super.initState();

    selectionList = widget.selectionList;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterProvider>(builder: (context, fp, _) {
      // print(fp.singleSelectedItem);

      return Column(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                TextFormField(
                  controller: fp.textFieldQuery,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                  onChanged: (val) async {
                    if (val.isNotEmpty) {
                      var list = filterSearchResult(widget.selectionList, val);
                      setState(() {
                        selectionList = list;
                      });
                    } else {
                      setState(() {
                        selectionList = widget.selectionList;
                        fp.textFieldQuery.text = '';
                      });
                    }
                    if (kDebugMode) {
                      print(
                          'New single selected list length = = = ${selectionList.length}');
                    }
                  },
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: themeColor.withOpacity(0.1),
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    tileColor: themeColor.withOpacity(0.1),
                    onTap: () {
                      // setState(() {
                      // lp.selectedAgent = null;
                      fp.textFieldQuery.text = '';
                      // });
                      // selectedItem=null;
                      fp.singleSelectedItem = null;
                      widget.selectedValue(fp.singleSelectedItem);
                      setState(() {});
                    },
                    leading: const Text(''),
                    title: const Text('None'),
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ...selectionList.map(
                  (e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: themeColor.withOpacity(0.1),
                        ),
                        child: RadioListTile<MapEntry<int, String>>(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          tileColor: themeColor.withOpacity(0.1),
                          value: e,
                          groupValue: fp.singleSelectedItem,
                          onChanged: (val) {
                            // setState(() {
                            fp.singleSelectedItem = val!;
                            fp.textFieldQuery.text =
                                fp.singleSelectedItem!.value;
                            fp.setSingleSelectedItem(val);
                            fp.setTextFieldQuery(val.value);
                            // });

                            widget.selectedValue(fp.singleSelectedItem!);
                          },
                          title: Text(e.value),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class SingleHirerchySelectionForm extends StatefulWidget {
  const SingleHirerchySelectionForm(
      {Key? key, required this.selectedValue, required this.selectionList})
      : super(key: key);
  final void Function(MapEntry<dynamic, dynamic>? val) selectedValue;
  final List<MapEntry<String, List<MapEntry<dynamic, dynamic>>>> selectionList;

  @override
  State<SingleHirerchySelectionForm> createState() =>
      _SingleHirerchySelectionFormState();
}

class _SingleHirerchySelectionFormState
    extends State<SingleHirerchySelectionForm> {
  TextEditingController queryController = TextEditingController();
  List<MapEntry<String, List<MapEntry<dynamic, dynamic>>>> selectionList = [];
  @override
  void initState() {
    super.initState();
    selectionList = widget.selectionList;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterProvider>(builder: (context, fp, _) {
      // print(fp.singleHSelectedItem);

      return Column(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                TextFormField(
                  controller: fp.textFieldQuery,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                  onChanged: (val) async {
                    // if (val.isNotEmpty) {
                    //   var list = filterSearchResult(widget.selectionList, val);
                    //   setState(() {
                    //     selectionList = list;
                    //   });
                    // } else {
                    //   setState(() {
                    //     selectionList = widget.selectionList;
                    //     fp.textFieldQuery.text = '';
                    //   });
                    // }
                    // if (kDebugMode) {
                    //   print(
                    //       'New single selected list length = = = ${selectionList.length}');
                    // }
                  },
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: themeColor.withOpacity(0.1),
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    tileColor: themeColor.withOpacity(0.1),
                    onTap: () {
                      // setState(() {
                      // lp.selectedAgent = null;
                      fp.textFieldQuery.text = '';
                      // });
                      // selectedItem=null;
                      fp.singleHSelectedItem = null;
                      widget.selectedValue(fp.singleHSelectedItem);
                      setState(() {});
                    },
                    leading: const Text(''),
                    title: const Text('None'),
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ...selectionList.map(
                  (e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        color: Colors.white,
                        child: ExpansionTile(
                          collapsedBackgroundColor: Colors.white,
                          title: Text(e.key),
                          children: [
                            ...e.value.map(
                              (ele) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: themeColor.withOpacity(0.1),
                                  ),
                                  child:
                                      RadioListTile<MapEntry<dynamic, dynamic>>(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    tileColor: themeColor.withOpacity(0.1),
                                    value: ele,
                                    groupValue: fp.singleHSelectedItem,
                                    onChanged: (val) {
                                      // setState(() {
                                      fp.singleHSelectedItem = ele;
                                      // fp.textFieldQuery.text =
                                      fp.singleHSelectedItem!.value;
                                      fp.setSingleHSelectedItem(ele);
                                      fp.setTextFieldQuery(ele.value);
                                      // });

                                      widget.selectedValue(
                                          fp.singleHSelectedItem);
                                    },
                                    title: Text(ele.value.toString()),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          // child: Text(e.name!),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class MultiSelectionForm extends StatefulWidget {
  const MultiSelectionForm(
      {Key? key, required this.selectedValue, required this.selectionList})
      : super(key: key);
  final void Function(Set<MapEntry<int, String>> val) selectedValue;
  final List<MapEntry<int, String>> selectionList;

  @override
  State<MultiSelectionForm> createState() => _MultiSelectionFormState();
}

class _MultiSelectionFormState extends State<MultiSelectionForm> {
  TextEditingController queryController = TextEditingController();
  Set<MapEntry<int, String>> selectedItems = {};
  String selectAll = 'All';
  List<MapEntry<int, String>> selectionList = [];
  @override
  void initState() {
    super.initState();
    Provider.of<FilterProvider>(context, listen: false)
                .multipleSelectedItem
                .length ==
            widget.selectionList.length
        ? selectAll = 'None'
        : selectAll = 'All';
    selectionList = widget.selectionList;
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.selectionList.length);
    return Consumer<FilterProvider>(builder: (context, fp, _) {
      // print(fp.multipleSelectedItem.length);
      return Column(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                TextFormField(
                  controller: fp.textFieldQuery,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                  onChanged: (val) async {
                    if (val.isNotEmpty) {
                      var list = filterSearchResult(widget.selectionList, val);
                      setState(() {
                        selectionList = list;
                      });
                    } else {
                      setState(() {
                        selectionList = widget.selectionList;
                        fp.textFieldQuery.text = '';
                      });
                    }
                    if (kDebugMode) {
                      print(
                          'New multiselected list length = = = ${selectionList.length}');
                    }
                  },
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: selectionList.length == widget.selectionList.length
                        ? themeColor.withOpacity(0.2)
                        : themeColor.withOpacity(0.05),
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    tileColor: themeColor.withOpacity(0.1),
                    onTap: selectionList.length == widget.selectionList.length
                        ? () {
                            setState(() {
                              selectAll == "All"
                                  ? selectAll = 'None'
                                  : selectAll = 'All';
                            });
                            selectAll == "None"
                                ? fp.multipleSelectedItem =
                                    widget.selectionList.toSet()
                                : fp.multipleSelectedItem.clear();
                            setState(() {});
                            widget.selectedValue(fp.multipleSelectedItem);
                          }
                        : null,
                    // leading: const Text(''),
                    title: Center(child: Text(selectAll)),
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ...selectionList.map(
                  (e) {
                    // print(fp.multipleSelectedItem.any((element) =>
                    //     element.key.toString() + element.value.toString() ==
                    //     e.key.toString() + e.value.toString()));
                    // print(e);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: themeColor.withOpacity(0.1),
                        ),
                        child: CheckboxListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          tileColor: themeColor.withOpacity(0.1),
                          value: fp.multipleSelectedItem
                              .any((element) => element.value == e.value),
                          onChanged: (val) {
                            // print(fp.multipleSelectedItem
                            //     .any((element) => element.value == e.value));
                            // print(val);
                            if (fp.multipleSelectedItem
                                .any((element) => element.value == e.value)) {
                              fp.multipleSelectedItem.removeWhere(
                                  (element) => element.value == e.value);
                            } else {
                              fp.multipleSelectedItem.add(e);
                            }
                            // print(fp.multipleSelectedItem);
                            setState(() {});
                            widget.selectedValue(fp.multipleSelectedItem);
                          },
                          title: Text(e.value),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class DateRangeForm extends StatefulWidget {
  const DateRangeForm(
      {Key? key, required this.selectionList, required this.selectedValue})
      : super(key: key);
  final void Function(List<MapEntry<String, String>>? val) selectedValue;
  final List<MapEntry<String, String>> selectionList;

  @override
  State<DateRangeForm> createState() => _DateRangeFormState();
}

class _DateRangeFormState extends State<DateRangeForm> {
  List<MapEntry<String, String>> selectionList = [];
  @override
  void initState() {
    super.initState();

    selectionList = widget.selectionList;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterProvider>(builder: (context, fp, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selectionList.first.key,
            style: Get.theme.textTheme.headline6,
          ),
          const SizedBox(height: 10),
          TextFormField(
            readOnly: true,
            controller: TextEditingController(),
            decoration: InputDecoration(
                hintText: fp.selectedDateRange != null
                    ? DateFormat('yyyy-MM-dd').format(
                        DateTime.parse(fp.selectedDateRange!.first.value))
                    : 'From',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
            onTap: () async {
              var dateRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now().add(const Duration(days: 365)));
              if (dateRange != null) {
                print(dateRange);
                setState(() {
                  MapEntry<String, String> mapEntry1 = MapEntry(
                      selectionList.first.key, dateRange.start.toString());
                  MapEntry<String, String> mapEntry2 = MapEntry(
                      selectionList.last.key, dateRange.end.toString());
                  if (fp.selectedDateRange != null) {
                    fp.selectedDateRange!.first = mapEntry1;
                    fp.selectedDateRange!.last = mapEntry2;
                    // lp.toDate = dateRange.end;
                  } else {
                    print(mapEntry1);
                    print(mapEntry2);
                    fp.selectedDateRange = [mapEntry1, mapEntry2];
                    // fp.selectedDateRange?.add(mapEntry2);
                  }
                });
                print(fp.selectedDateRange);
                widget.selectedValue(fp.selectedDateRange!);
              }
            },
          ),
          const Divider(),
          Text(
            selectionList.last.key,
            style: Get.theme.textTheme.headline6,
          ),
          const SizedBox(height: 10),
          TextFormField(
            readOnly: true,
            controller: TextEditingController(),
            decoration: InputDecoration(
                hintText: fp.selectedDateRange != null
                    ? DateFormat('yyyy-MM-dd').format(
                        DateTime.parse(fp.selectedDateRange!.last.value))
                    : 'To',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
            onTap: () async {
              var dateRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now().add(const Duration(days: 365)));
              if (dateRange != null) {
                setState(() {
                  MapEntry<String, String> mapEntry1 = MapEntry(
                      selectionList.first.key, dateRange.start.toString());
                  MapEntry<String, String> mapEntry2 = MapEntry(
                      selectionList.first.key, dateRange.end.toString());
                  if (fp.selectedDateRange != null) {
                    fp.selectedDateRange!.first = mapEntry1;
                    fp.selectedDateRange!.last = mapEntry2;
                    // lp.toDate = dateRange.end;
                  } else {
                    fp.selectedDateRange?.add(mapEntry1);
                    fp.selectedDateRange?.add(mapEntry2);
                  }
                });
                widget.selectedValue(fp.selectedDateRange!);
              }
            },
          ),
        ],
      );
    });
  }
}

List<MapEntry<int, String>> filterSearchResult(
    List<MapEntry<int, String>> list, String query) {
  if (list.any((element) =>
      element.key
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase().trim()) ||
      element.value
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase().trim()))) {
    var items = list
        .where((element) =>
            element.key
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase().trim()) ||
            element.value
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase().trim()))
        .toList();
    print('Searched items are ${items.length}');
    return items;
  }
  print('Didn\'t found any item');
  return [];
}
