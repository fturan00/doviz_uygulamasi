import 'dart:convert';
import 'package:http/http.dart' as http;

class DovizModel {
  final String name;
  final double? buying;
  final double? selling;

  DovizModel({
    required this.name,
    required this.buying,
    required this.selling,
  });

  factory DovizModel.fromJson(Map<String, dynamic> json) {
    return DovizModel(
      name: json['name'],
      buying: json['buying'] != null
          ? (json['buying'] is int ? (json['buying'] as int).toDouble() : json['buying'])
          : null,
      selling: json['selling'] != null
          ? (json['selling'] is int ? (json['selling'] as int).toDouble() : json['selling'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'buying': buying,
      'selling': selling,
    };
  }
}

class DovizApiService {
  Future<dynamic> getDovizApiData() async {
    const dovizApiKey = "0TZVcZk3qYZXotUn5ms3wI:7DEAijFmnlJFow4oEBBz1G";
    const dovizApiUrl =
        'https://api.collectapi.com/economy/allCurrency';

    final response = await http.get(Uri.parse(dovizApiUrl), headers: {
      'authorization': 'apikey $dovizApiKey',
      'content-type': 'application/json'
    });

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("veri gelmedi");
    }
  }
}

class DovizRepository {
  Future<List<DovizModel>> getDovizList() async {

    final String jsonDoviz = await DovizApiService().getDovizApiData();
    final Map<String, dynamic> decodedJson = jsonDecode(jsonDoviz);
    final List<dynamic> jsonDovizList = decodedJson['result'];

    List<DovizModel> dovizList = [];

    for (var json in jsonDovizList) {
      DovizModel dovizler = DovizModel.fromJson(json);
      dovizList.add(dovizler);
    }
    return dovizList;
    
  }
}


class DovizViewModel {
  late List<DovizModel> dovizList;
  final DovizRepository dovizRepository = DovizRepository();

  DovizViewModel() {
    dovizList = [];
    fetchData();
  }

  fetchData() async {
    final response = await dovizRepository.getDovizList();
    dovizList = response.toList();
  }

  Future <List<DovizModel>> getDovizList() =>  dovizRepository.getDovizList();
}
