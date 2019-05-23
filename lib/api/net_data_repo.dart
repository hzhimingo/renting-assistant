
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:renting_assistant/localstore/local_store.dart';
import 'package:renting_assistant/model/filter_condition.dart';
import 'package:renting_assistant/model/house_cover_model.dart';
import 'package:renting_assistant/model/house_detail.dart';

class NetDataRepo {
  static String devServerAddress = LocalStore.readDevServerAddress() as String;
  static BaseOptions options = BaseOptions(
      baseUrl: "http://192.168.43.112/api/v1",
      connectTimeout: 8000,
      receiveTimeout: 5000);
  static Dio _dio = Dio(options);

  Future<List<HouseCoverModel>> obtainHouseInfo() async {
    Response response =
        await _dio.get("http://www.mocky.io/v2/5cda86e3300000290068c765");
    List<HouseCoverModel> houseCovers = List();
    response.data.forEach((item) {
      houseCovers.add(HouseCoverModel.fromJson(item));
    });
    return houseCovers;
  }

  Future<HouseDetailModel> obtainHouseDetailInfo(String houseId) async {
    print(devServerAddress);
    HouseDetailModel houseDetailModel;
    Response response = await _dio.get(
      "/house/getHouseDetail",
      queryParameters: {
        "houseId": houseId
      }
    );
    houseDetailModel = HouseDetailModel.fromJson(response.data["data"]);
    return houseDetailModel;
  }

  Future<List<HouseCoverModel>> obtainHouseInfoFilter(int page, int size) async {
    String currentCity;
    String geo;
    FilterCondition condition = FilterCondition();
     await LocalStore.readCurrentCity().then((value) {
      if (value == null) {
        currentCity = "北京";
      } else {
        currentCity = value;
      }
    });
    print(currentCity);
    await LocalStore.readCurrentGeo().then((value) {
      geo = value;
    });
    print(geo);
    await LocalStore.readFilterCondition().then((filterCondition) {
      condition = filterCondition;
    });

    Response response = await _dio.request(
      "/house/getHouses",
      options: Options(
        method: "GET",
        contentType: ContentType.parse("application/json")
      ),
      queryParameters: {
        "areaClass": 0,
        "bedRoom": 0,
        "city": currentCity.replaceAll("市", ""),
        "condition": "",
        "highArea": 0,
        "highPrice": 0,
        "isHaveLift": 0,
        "isNearBySubway":0,
        "latitude": "${geo.split(",")[0]}",
        "longitude": "${geo.split(",")[1]}",
        "lowArea": 0,
        "lowPrice": 0,
        "page": 1,
        "priceClass": 0,
        "region": "",
        "rentMode": 0,
        "size": 20
      },
    );
    List<HouseCoverModel> houseCovers = [];
    print(response.request.queryParameters);
    print(response.data["msg"]);
    response.data["data"].forEach((item) {
      houseCovers.add(HouseCoverModel.fromJson(item));
    });
    print(houseCovers.length);
    return houseCovers;
  }
}
