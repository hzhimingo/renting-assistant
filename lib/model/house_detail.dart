class HouseDetailModel {
  final String houseId;
  final String houseTitle;
  final double housePrice;
  final String houseType;
  final double houseArea;
  final String publishDate;
  final String checkin;
  final String floor;
  final int hasLift;
  final String parking;
  final String waterType;
  final String electricType;
  final int hasGas;
  final String tenancy;
  final String lookHouse;
  final List<dynamic> houseImages;
  final int hasTv;
  final int hasRefrigertor;
  final int hasWasher;
  final int hasAircondition;
  final int hasHeater;
  final int hasBed;
  final int hasHeating;
  final int hasInternet;
  final int hasWardobe;
  final String longitude;
  final String latitude;
  final String address;
  final int isNearBySubway;
  final int isNearByBusinessDistrict;
  final String houseIntroduce;
  final int collectStatus;
  final String contactName;
  final String contactTelephone;

  HouseDetailModel({
    this.houseId,
    this.houseTitle,
    this.housePrice,
    this.houseType,
    this.houseArea,
    this.publishDate,
    this.checkin,
    this.floor,
    this.hasLift,
    this.parking,
    this.waterType,
    this.electricType,
    this.hasGas,
    this.tenancy,
    this.lookHouse,
    this.houseImages,
    this.hasTv,
    this.hasRefrigertor,
    this.hasWasher,
    this.hasAircondition,
    this.hasHeater,
    this.hasBed,
    this.hasHeating,
    this.hasInternet,
    this.hasWardobe,
    this.longitude,
    this.latitude,
    this.address,
    this.isNearBySubway,
    this.isNearByBusinessDistrict,
    this.houseIntroduce,
    this.collectStatus,
    this.contactName,
    this.contactTelephone,
  });

  factory HouseDetailModel.fromJson(Map<String, dynamic> json) {
    return HouseDetailModel(
      houseId: json["houseId"],
      houseTitle: json["houseTitle"],
      housePrice: json["housePrice"],
      houseType: json["houseType"],
      houseArea: json["houseArea"],
      publishDate: json["publishDate"],
      checkin: json["checkin"],
      floor: json["floor"],
      hasLift: json["hasLift"],
      parking: json["parking"],
      waterType: json["waterType"],
      electricType: json["electricType"],
      hasGas: json["hasGas"],
      tenancy: json["tenancy"],
      lookHouse: json["lookHouse"],
      houseImages: json["houseImages"],
      hasTv: json["hasTv"],
      hasRefrigertor: json["hasRefrigertor"],
      hasWasher: json["hasWasher"],
      hasAircondition: json["hasAircondition"],
      hasHeater: json["hasHeater"],
      hasBed: json["hasBed"],
      hasHeating: json["hasHeating"],
      hasInternet: json["hasInternet"],
      hasWardobe: json["hasWardobe"],
      longitude: json["longitude"],
      latitude: json["latitude"],
      address: json["address"],
      isNearBySubway: json["isNearBySubway"],
      isNearByBusinessDistrict: json["isNearByBusinessDistrict"],
      houseIntroduce: json["houseIntroduce"],
      collectStatus: json["collectStatus"],
      contactName: json["contactName"],
      contactTelephone: json["contactTelephone"],
    );
  }
}
