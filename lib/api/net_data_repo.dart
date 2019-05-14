import 'package:dio/dio.dart';
import 'package:renting_assistant/localstore/local_store.dart';
import 'package:renting_assistant/model/house_cover_model.dart';

class NetDataRepo {
  static String devServerAddress = LocalStore.readDevServerAddress() as String;
  /*static BaseOptions options = BaseOptions(
    baseUrl: "https://devServerAddress/api/v1",
    connectTimeout: 5000,
    receiveTimeout: 3000
  );*/
  static Dio _dio = Dio();

  Future<List<HouseCoverModel>> obtainHouseInfo() async {
    Response response =
        await _dio.get("http://www.mocky.io/v2/5cda86e3300000290068c765");
    List<HouseCoverModel> houseCovers = List();
    response.data.forEach((item) {
      houseCovers.add(HouseCoverModel.fromJson(item));
    });
    return houseCovers;
  }
}
