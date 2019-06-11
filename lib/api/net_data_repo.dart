import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:renting_assistant/localstore/local_store.dart';
import 'package:renting_assistant/model/answer_cover.dart';
import 'package:renting_assistant/model/answer_detail.dart';
import 'package:renting_assistant/model/filter_condition.dart';
import 'package:renting_assistant/model/house_cover_model.dart';
import 'package:renting_assistant/model/house_detail.dart';
import 'package:renting_assistant/model/question_cover.dart';
import 'package:renting_assistant/model/question_detail.dart';
import 'package:renting_assistant/model/user_info.dart';

class NetDataRepo {
  static BaseOptions options = BaseOptions(
      baseUrl: "http://192.168.43.112/api/v1",
      connectTimeout: 10000,
      receiveTimeout: 10000);
  static Dio _dio = Dio(options);

  Future<HouseDetailModel> obtainHouseDetailInfo(String houseId) async {
    HouseDetailModel houseDetailModel;
    Map<String, dynamic> headers = {};
    await LocalStore.readAccessToken().then((value) {
      if (value != null) {
        headers["accessToken"] = value;
      }
    });
    print(headers["accessToken"]);
    Response response = await _dio.get("/house/getHouseDetail",
        options: Options(headers: headers),
        queryParameters: {"houseId": houseId});
    houseDetailModel = HouseDetailModel.fromJson(response.data["data"]);
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
    Map<String, dynamic> headers = {};
    await LocalStore.readAccessToken().then((value) {
      if (value != null) {
        headers["accessToken"] = value;
      }
    });
    Response response = await _dio.request(
      "/house/getHouses",
      options: Options(
        method: "GET",
        contentType: ContentType.parse("application/json"),
        headers: headers,
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
    return houseCovers;
  }

  Future<List<HouseCoverModel>> search(String keyword) async {
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
          method: "GET", contentType: ContentType.parse("application/json")),
      queryParameters: {
        "city": currentCity.replaceAll("市", ""),
        "condition": keyword,
      },
    );
    List<HouseCoverModel> houseCovers = [];
    if (response.data["data"] != null) {
      response.data["data"].forEach((item) {
        houseCovers.add(HouseCoverModel.fromJson(item));
      });
    }
    return houseCovers;
  }

  Future<List<HouseCoverModel>> obtainHouseInfoFilter(
      int page, int size) async {
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
          method: "GET", contentType: ContentType.parse("application/json")),
      queryParameters: paramters,
    );
    List<HouseCoverModel> houseCovers = [];
    if (response.data["data"] != null) {
      response.data["data"].forEach((item) {
        houseCovers.add(HouseCoverModel.fromJson(item));
      });
    }
    return houseCovers;
  }

  Future<bool> sendCheckCode(String email) async {
    Response response = await _dio.get(
      "/account/getCode",
      options: Options(method: "GET"),
      queryParameters: {
        "email": email,
      },
    );
    return response.data["code"] == 0 ? true : false;
  }

  Future<String> signIn(String email, String checkCode, String jpushId) async {
    Response response = await _dio.post("/account/login",
        options: Options(
          method: "POST",
        ),
        queryParameters: {
          "email": email,
          "code": checkCode,
          "registrationId": jpushId,
        });
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
      options: Options(method: "GET", headers: {
        "accessToken": token,
      }),
    );
    print(token);
    if (response.data["code"] == 0) {
      return UserInfo.fromJson(response.data["data"]);
    } else {
      print(response.data["msg"]);
      return null;
    }
  }

  Future<bool> collect(String houseId, int status, String accessToken) async {
    Response response = await _dio.post("/house/collectHouse",
        options: Options(headers: {
          "accessToken": accessToken,
        }),
        queryParameters: {
          "status": status,
          "houseId": houseId,
        });
    if (response.data["code"] == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<HouseCoverModel>> obtainCollectList() async {
    Map<String, dynamic> headers = {};
    await LocalStore.readAccessToken().then((value) {
      if (value != null) {
        headers["accessToken"] = value;
      }
    });
    print('${headers["accessToken"]}');
    Response response = await _dio.get(
      "/userInfo/getCollectHouse",
      options: Options(headers: headers),
    );
    List<HouseCoverModel> houseCovers = [];
    if (response.data["data"] != null) {
      response.data["data"].forEach((item) {
        houseCovers.add(HouseCoverModel.fromJson(item));
      });
    }
    return houseCovers;
  }

  Future<List<HouseCoverModel>> obtainHistoryList() async {
    Map<String, dynamic> headers = {};
    await LocalStore.readAccessToken().then((value) {
      if (value != null) {
        headers["accessToken"] = value;
      }
    });
    Response response = await _dio.get(
      "/userInfo/getBrowserHistory",
      options: Options(headers: headers),
    );
    List<HouseCoverModel> houseCovers = [];
    if (response.data["data"] != null) {
      response.data["data"].forEach((item) {
        houseCovers.add(HouseCoverModel.fromJson(item));
      });
    }
    return houseCovers;
  }

  Future<List<AnswerCover>> obtainAnswerCoverList(int page, int size) async {
    Map<String, dynamic> headers = {};
    List<AnswerCover> answerCovers = [];
    try {
      final response = await _dio.get(
        "/question/getAllQuestion",
      );
      if (response.data["data"] != null) {
        print("Question请求成功${response.data["data"].length}");
        response.data["data"].forEach((item) {
          answerCovers.add(AnswerCover.fromJson(item));
        });
      }
    } on DioError catch (e) {
      print('请求失败---错误码：${e.response.statusCode}---${e.response.data}');
    }
    return answerCovers;
  }

  Future<List<AnswerCover>> obtainAnswerList() async {
    Map<String, dynamic> headers = {};
    await LocalStore.readAccessToken().then((value) {
      if (value != null) {
        headers["accessToken"] = value;
      }
    });
    List<AnswerCover> answerCovers = [];
    try {
      final response = await _dio.get(
        "/answer/getQuestionAnswer",
        options: Options(headers: headers),
      );
      if (response.data["data"] != null) {
        response.data["data"].forEach((item) {
          answerCovers.add(AnswerCover.fromJson(item));
        });
      }
    } on DioError catch (e) {
      print('请求失败---错误码：${e.response.statusCode}---${e.response.data}');
    }
    return answerCovers;
  }

  Future<bool> pushQuestion(String title, String content) async {
    Map<String, dynamic> headers = {};
    await LocalStore.readAccessToken().then((value) {
      if (value != null) {
        headers["accessToken"] = value;
      }
    });
    bool flag = false;
    try {
      final response = await _dio.post('/question/publishQuestion',
          options: Options(
            headers: headers,
          ),
          queryParameters: {
            'title': title,
            'content': content,
            'images': "",
          });
      if (response.data["code"] == 0) {
        flag = true;
      } else {
        flag = false;
      }
    } on DioError catch (e) {
      print('请求失败---错误码：${e.response.statusCode}');
    }
    return flag;
  }

  Future<List<QuestionCover>> obtainQuestionCovers() async {
    Map<String, dynamic> headers = {};
    await LocalStore.readAccessToken().then((value) {
      if (value != null) {
        headers["accessToken"] = value;
      }
    });
    List<QuestionCover> questionCovers = [];
    try {
      final response = await _dio.get(
        "/question/getAllQuestion",
        options: Options(
          headers: headers,
        ),
      );
      if (response.data["code"] == 0) {
        response.data["data"].forEach((item) {
          questionCovers.add(QuestionCover.fromJson(item));
        });
      }
    } on DioError catch (e) {
      print('请求失败---错误码：${e.response.statusCode}');
    }
    return questionCovers;
  }

  Future<List<AnswerCover>> obtainAnswerCovers() async {
    Map<String, dynamic> headers = {};
    await LocalStore.readAccessToken().then((value) {
      if (value != null) {
        headers["accessToken"] = value;
      }
    });
    List<AnswerCover> answerCovers = [];
    try {
      final response = await _dio.get(
        "/answer/getAllAnswer",
        options: Options(
          headers: headers,
        ),
      );
      if (response.data["code"] == 0) {
        response.data["data"].forEach((item) {
          answerCovers.add(AnswerCover.fromJson(item));
        });
      }
    } on DioError catch (e) {
      print('请求失败---错误码：${e.response.statusCode}');
    }
    return answerCovers;
  }

  Future<QuestionDetail> obtainQuestionDetail(String questionId) async {
    Map<String, dynamic> headers = {};
    await LocalStore.readAccessToken().then((value) {
      if (value != null) {
        headers["accessToken"] = value;
      }
    });
    QuestionDetail questionDetail;
    try {
      final response = await _dio.get(
        "/question/detail/$questionId",
        options: Options(headers: headers),
      );
      if (response.data["code"] == 0) {
        questionDetail = QuestionDetail.fromJson(response.data["data"]);
      }
    } on DioError catch (e) {
      print('请求失败---错误码：${e.response.statusCode}');
    }
    return questionDetail;
  }

  Future<AnswerDetail> obtainAnswerDetail(String answerId) async {
    Map<String, dynamic> headers = {};
    await LocalStore.readAccessToken().then((value) {
      if (value != null) {
        headers["accessToken"] = value;
      }
    });
    AnswerDetail answerDetail;
    try {
      final response = await _dio.get("/answer/detail/" + answerId,
          options: Options(headers: headers),
          queryParameters: {"answerId": answerId});
      if (response.data["code"] == 0) {
        answerDetail = AnswerDetail.fromJson(response.data["data"]);
      }
    } on DioError catch (e) {
      print('请求失败---错误码：${e.response.statusCode}');
    }
    return answerDetail;
  }

  Future<bool> publishAnswer(String questionId, String content) async {
    Map<String, dynamic> headers = {};
    await LocalStore.readAccessToken().then((value) {
      if (value != null) {
        headers["accessToken"] = value;
      }
    });
    bool flag = false;
    try {
      final response = await _dio.post('/answer/publishAnswer',
          options: Options(
            headers: headers,
          ),
          queryParameters: {
            "questionId": questionId,
            "content": content,
          });
      if (response.data["code"] == 0) {
        flag = true;
      } else {
        flag = false;
      }
    } on DioError catch (e) {
      print('请求失败---错误码：${e.response.statusCode}');
    }
    return flag;
  }

  Future<UserInfo> updateNickname(String newNickname) async {
    Map<String, dynamic> headers = {};
    await LocalStore.readAccessToken().then((value) {
      if (value != null) {
        headers["accessToken"] = value;
      }
    });
    UserInfo userInfo;
    try {
      final response = await _dio.put('/userInfo/updateNickname',
          options: Options(
            headers: headers,
          ),
          queryParameters: {"newNickname" : newNickname});
      if (response.data["code"] == 0) {
        userInfo = UserInfo.fromJson(response.data["data"]);
      }
    } on DioError catch (e) {
      print('请求失败---错误码：${e.response.statusCode}');
    }
    return userInfo;
  }

  Future<UserInfo> updateEmail(String email) async {
    Map<String, dynamic> headers = {};
    await LocalStore.readAccessToken().then((value) {
      if (value != null) {
        headers["accessToken"] = value;
      }
    });
    UserInfo userInfo;
    try {
      final response = await _dio.put('/userInfo/updateNickname',
          options: Options(
            headers: headers,
          ),
          queryParameters: {"newEmail" : email});
      if (response.data["code"] == 0) {
        userInfo = UserInfo.fromJson(response.data["data"]);
      }
    } on DioError catch (e) {
      print('请求失败---错误码：${e.response.statusCode}');
    }
    return userInfo;
  }
}
