class DovizData {
  final String? text1;
  final String? text2;
  double? text3;

  DovizData(this.text1, this.text2, this.text3);
}

class MockData {
  static List<DovizData> dovizList = [
    DovizData("assets/images/euro.png", "Euro", 32.7),
    DovizData("assets/images/dolar.png", "Dolar", 35.7),
    DovizData("assets/images/dolar.png", "Dolar", 35.7),
  ];
}

class Repository {
  Future<List<DovizData>> getDataList() async {
    await Future.delayed(const Duration(seconds: 2));
    return await Future.value(MockData.dovizList);
  }
}

class ViewModel {
  late Repository repository;
  ViewModel() {
    repository = Repository();
  }
  Future<List<DovizData>> getDataList() => repository.getDataList();
}
