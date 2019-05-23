class FilterCondition {
  bool isSelectAllEntireRent = false;
  bool isSelectAllSharedRent = false;
  List<bool> entireRents = [false, false, false, false];
  List<bool> sharedRents = [false, false, false, false];
  bool isNearBySubway = false;
  bool hasLift = false;
  List<bool> houseAreas = [false, false, false, false, false];
  int lowPrice = 0;
  int highPrice = 0;

  Map toJson() {
    Map map = Map();
    map["isSelectAllEntireRent"] = this.isSelectAllEntireRent;
    map["isSelectAllSharedRent"] = this.isSelectAllSharedRent;
    map["entireRents"] = this.entireRents;
    map["sharedRents"] = this.sharedRents;
    map["isNearBySubway"] = this.isNearBySubway;
    map["hasLift"] = this.hasLift;
    map["houseAreas"] = this.houseAreas;
    return map;
  }

  static FilterCondition fromMap(Map<String, dynamic> map) {
    FilterCondition filterCondition = FilterCondition();
    filterCondition.isSelectAllEntireRent = map["isSelectAllEntireRent"];
    filterCondition.isSelectAllSharedRent = map["isSelectAllSharedRent"];
    for (int i = 0; i < map["entireRents"].length; i++) {
      filterCondition.entireRents[i] = map["entireRents"][i] as bool;
    }
    for (int i = 0; i < map["sharedRents"].length; i++) {
      filterCondition.sharedRents[i] = map["sharedRents"][i] as bool;
    }
    for (int i = 0; i < map["houseAreas"].length; i++) {
      filterCondition.houseAreas[i] = map["houseAreas"][i] as bool;
    }
    filterCondition.isNearBySubway = map["isNearBySubway"];
    filterCondition.hasLift = map["hasLift"];
    return filterCondition;
  }

  void resetHouseTypeFilter() {
    isSelectAllEntireRent = false;
    isSelectAllSharedRent = false;
    entireRents = [false, false, false, false];
    sharedRents = [false, false, false, false];
  }

  void resetHouseMoreFilter() {
    isNearBySubway = false;
    hasLift = false;
    houseAreas = [false, false, false, false, false];
  }
}