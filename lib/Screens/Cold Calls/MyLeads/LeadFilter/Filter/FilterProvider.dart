import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class FilterProvider extends ChangeNotifier {

  int _index=0;
  int get index=>_index;
  void setIndex(int i){
    _index=i;
    // notifyListeners();
  }
  TextEditingController textFieldQuery = TextEditingController();
  void setTextFieldQuery(String val) {
    // print(val);
    textFieldQuery.text = val;
    notifyListeners();
  }

  MapEntry<int, String>? singleSelectedItem;
  MapEntry<dynamic, dynamic>? singleHSelectedItem;
  void setSingleSelectedItem(MapEntry<int, String>? val) {
    singleSelectedItem = val;
    notifyListeners();
  }
  void setSingleHSelectedItem(MapEntry<dynamic, dynamic>? val) {
    singleHSelectedItem = val;
    notifyListeners();
  }

  Set<MapEntry<int, String>> multipleSelectedItem = {};
  void setMultipleSelectedItem(bool e, MapEntry<int, String> val) {
    if (e) {
      multipleSelectedItem.add(val);
      notifyListeners();
    } else {
      multipleSelectedItem.remove(val);
      notifyListeners();
    }
  }

  Map<String, dynamic> filterData={};
  void setFilterData( Map<String, dynamic>data) {
    filterData = data;
    notifyListeners();
  }


  List<MapEntry<String, String>>? selectedDateRange;


}
