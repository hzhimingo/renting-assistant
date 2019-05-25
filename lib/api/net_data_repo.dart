
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:renting_assistant/localstore/local_store.dart';
import 'package:renting_assistant/model/filter_condition.dart';
import 'package:renting_assistant/model/house_cover_model.dart';
import 'package:renting_assistant/model/house_detail.dart';

class NetDataRepo {
  /*static String devServerAddress = LocalStore.readDevServerAddress() as String;*/
  static BaseOptions options = BaseOptions(
      baseUrl: "http://192.168.31.83/api/v1",
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
    HouseDetailModel houseDetailModel;
    Response response = await _dio.get(
      "/house/getHouseDetail",
      queryParameters: {
        "houseId": houseId
      }
    );
    houseDetailModel = HouseDetailModel.fromJson(response.data["data"]);
    print("请求成功>>>>>>>>>>>>>>>>>>成功获取到了房源详细信息");
    await Future.delayed(Duration(milliseconds: 100));
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
        "isHaveLift": condition.hasLift ? 1 : 0,
        "isNearBySubway": condition.isNearBySubway ? 1 : 0,
        "latitude": "${geo.split(",")[0]}",
        "longitude": "${geo.split(",")[1]}",
        "lowArea": 0,
        "lowPrice": 0,
        "page": page,
        "priceClass": 0,
        "region": "",
        "rentMode": 0,
        "size": size
      },
    );
    List<HouseCoverModel> houseCovers = [];
    if (response.data["data"] != null) {
      response.data["data"].forEach((item) {
        houseCovers.add(HouseCoverModel.fromJson(item));
      });
    }
    print("请求成功>>>>>>>>>>>>>>>>>>获取到的房源数量为${houseCovers.length}");
    return houseCovers;
  }
}
