class HouseCoverModel {
  final String houseId;
  final String houseTitle;
  final String houseType;
  final String houseCoverImage;
  final double houseArea;
  final String houseFloor;
  final int isNearBySubway;
  final int isNearByBusinessDistrict;
  final int rentMode;
  final double housePrice;
  final String checkin;

  HouseCoverModel({
    this.houseId,
    this.houseTitle,
    this.houseType,
    this.houseCoverImage,
    this.houseArea,
    this.houseFloor,
    this.isNearBySubway,
    this.isNearByBusinessDistrict,
    this.rentMode,
    this.housePrice,
    this.checkin,
  });

  factory HouseCoverModel.fromJson(Map<String, dynamic> json) {
    return HouseCoverModel(
      houseId: json["houseId"],
      houseTitle: json["houseTitle"],
      houseType: json["houseType"],
      houseCoverImage: json["houseCoverImage"],
      houseArea: json["houseArea"],
      houseFloor: json["houseFloor"],
      isNearBySubway: json["isNearBySubway"],
      isNearByBusinessDistrict: json["isNearByBusinessDistrict"],
      rentMode: json["rentMode"],
      housePrice: json["housePrice"],
      checkin: json["checkin"],
    );
  }
}
