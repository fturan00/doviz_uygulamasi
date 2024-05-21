import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finans/doviz_veri_getir.dart';

class DovizStorage {
  Future<void> saveInitialDovizList(List<DovizModel> dovizList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonList = dovizList.map((doviz) => doviz.toJson()).toList();
    prefs.setString('initialDovizList', json.encode(jsonList));
  }

  Future<List<DovizModel>?> loadInitialDovizList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dovizListString = prefs.getString('initialDovizList');
    if (dovizListString != null) {
      List<dynamic> jsonList = json.decode(dovizListString);
      return jsonList.map((json) => DovizModel.fromJson(json)).toList();
    }
    return null;
  }
}
