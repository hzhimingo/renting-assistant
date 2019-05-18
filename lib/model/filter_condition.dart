class FilterCondition {
  /// 【0】整租、【1】合租、【2】不限
  int rentMode;

  /// 筛选的卧室数量
  List<int> bedRooms;

  /// 筛选城市
  String city;

  /// 区
  String dict;

  ///街道
  String street;

  /// 1-8
  int priceLevel;

  /// 房屋面积
  double houseArea;

  /// 【0】不限，【1】没有
  int lift;

  FilterCondition(this.rentMode, this.bedRooms, this.city, this.dict,
      this.street, this.priceLevel, this.houseArea, this.lift);


}