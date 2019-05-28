
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:renting_assistant/localstore/local_store.dart';
import 'package:renting_assistant/model/filter_condition.dart';
import 'package:renting_assistant/model/house_cover_model.dart';
import 'package:renting_assistant/model/house_detail.dart';
import 'package:renting_assistant/model/user_info.dart';

class NetDataRepo {
  /*static String devServerAddress = LocalStore.readDevServerAddress() as String;*/
  static BaseOptions options = BaseOptions(
      baseUrl: "http://192.168.43.112/api/v1",
      connectTimeout: 10000,
      receiveTimeout: 10000);
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
    Map<String, dynamic> headers = {};
    await LocalStore.readAccessToken().then((value) {
      if (value != null) {
        headers["accessToken"] = value;
      }
    });
    Response response = await _dio.get(
      "/house/getHouseDetail",
      options: Options(
        headers: headers
      ),
      queryParameters: {
        "houseId": houseId
      }
    );
    houseDetailModel = HouseDetailModel.fromJson(response.data["data"]);
    print("请求成功>>>>>>>>>>>>>>>>>>成功获取到了房源详细信息");
    print(response.request.headers["accessToken"]);
    await Future.delayed(Duration(milliseconds: 100));
    return houseDetailModel;
  }

  Future<List<HouseCoverModel>> obtainHouseRecommend(int page, int size) async {
    String currentCity;
    await LocalStore.readCurrentCity().then((value) {
      if (value == null) {
        currentCity = "北京";
      } else {
        currentCity = value;
      }
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
        "isHaveLift": 1,
        "isNearBySubway": 0,
        "page": page,
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

  Future<List<HouseCoverModel>> search(int page, int size, String keyword) async {
    String currentCity;
    await LocalStore.readCurrentCity().then((value) {
      if (value == null) {
        currentCity = "北京";
      } else {
        currentCity = value;
      }
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
        "isHaveLift": 1,
        "isNearBySubway": 0,
        "page": page,
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
    await LocalStore.readCurrentGeo().then((value) {
      geo = value;
    });
    await LocalStore.readFilterCondition().then((filterCondition) {
      condition = filterCondition;
    });
    Map<String, dynamic> paramters = {
      "areaClass": condition.areaClass,
      "bedRoom": 0,
      "city": currentCity.replaceAll("市", ""),
      "highArea": 0,
      "highPrice": 0,
      "isHaveLift": condition.hasLift ? 1 : 0,
      "isNearBySubway": condition.isNearBySubway ? 1 : 0,
      "latitude": "${geo.split(",")[0]}",
      "longitude": "${geo.split(",")[1]}",
      "lowArea": 0,
      "lowPrice": 0,
      "page": page,
      "priceClass": condition.priceClass,
      "rentMode": condition.rentMode,
      "size": size,
    };
    if (condition.region != "不限") {
      paramters["region"] = condition.region;
    }
    if (condition.bedRoomCount != 0) {
      paramters["bedRoom"] = condition.bedRoomCount;
    }
    Response response = await _dio.request(
      "/house/getHouses",
      options: Options(
        method: "GET",
        contentType: ContentType.parse("application/json")
      ),
      queryParameters: paramters,
    );
    List<HouseCoverModel> houseCovers = [];
    if (response.data["data"] != null) {
      response.data["data"].forEach((item) {
        houseCovers.add(HouseCoverModel.fromJson(item));
      });
    }
    print(response.request.queryParameters);
    print("请求成功>>>>>>>>>>>>>>>>>>获取到的房源数量为${houseCovers.length}");
    return houseCovers;
  }
  
  Future<bool> sendCheckCode(String email) async {
    Response response = await _dio.get(
      "/account/getCode",
      options: Options(
        method: "GET"
      ),
      queryParameters: {
        "email": email,
      },
    );
    return response.data["code"] == 0 ? true : false;
  }

  Future<String> signIn(String email, String checkCode) async {
    Response response = await _dio.post(
      "/account/login",
      options: Options(
        method: "POST",
      ),
      queryParameters: {
        "email": email,
        "code": checkCode,
      }
    );
    if (response.data["code"] == 0) {
      return response.data["data"]["accessToken"];
    } else {
      print(response.data["msg"]);
      return null;
    }
  }

  Future<UserInfo> obtainUserInfo(String token) async {
    Response response = await _dio.get(
      "/userInfo/getUserInfo",
      options: Options(
        method: "GET",
        headers: {
          "accessToken": token,
        }
      ),
    );
    if (response.data["code"] == 0) {
      return UserInfo.fromJson(response.data["data"]);
    } else {
      print(response.data["msg"]);
      return null;
    }
  }

  Future<bool> collect(String houseId, int status, String accessToken) async {
    Response response = await _dio.post(
      "/house/collectHouse",
      options: Options(
        headers: {
          "accessToken": accessToken,
        }
      ),
      queryParameters: {
        "status": status,
        "houseId": houseId,
      }
    );
    if (response.data["code"] == 0) {
      return true;
    } else {
      return false;
    }
  }
}
