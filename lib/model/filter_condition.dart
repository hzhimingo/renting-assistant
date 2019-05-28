class FilterCondition {
  int rentMode = 0;
  int bedRoomCount = 0;
  bool isNearBySubway = false;
  bool hasLift = false;
  int priceClass = 0;
  String region = "不限";
  int areaClass = 0;

  Map toJson() {
    Map map = Map();
    map["rentMode"] = this.rentMode;
    map["bedRoomCount"] = this.bedRoomCount;
    map["isNearBySubway"] = this.isNearBySubway;
    map["hasLift"] = this.hasLift;
    map["priceClass"] = this.priceClass;
    map["region"] = this.region;
    map["areaClass"] = this.areaClass;
    return map;
  }

  static FilterCondition fromMap(Map<String, dynamic> map) {
    FilterCondition filterCondition = FilterCondition();
    filterCondition.rentMode = map["rentMode"];
    filterCondition.bedRoomCount = map["bedRoomCount"];
    filterCondition.isNearBySubway = map["isNearBySubway"];
    filterCondition.hasLift = map["hasLift"];
    filterCondition.priceClass = map["priceClass"];
    filterCondition.region = map["region"];
    filterCondition.areaClass = map["areaClass"];
    return filterCondition;
  }

  void resetHouseTypeFilter() {
    rentMode = 2;
    bedRoomCount = 0;
  }

  void resetHouseMoreFilter() {
    isNearBySubway = false;
    hasLift = false;
    areaClass = 0;
  }
}