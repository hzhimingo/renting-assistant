class HouseInfo {

  final String houseTitle;
  final String houseArea;
  final String rentPrice;
  final String layout;
  final List<String> imageUrls;

  HouseInfo({
    this.houseTitle,
    this.houseArea,
    this.rentPrice,
    this.layout,
    this.imageUrls
  });
}

final List<HouseInfo> houses = [
  HouseInfo(
    houseTitle: '整租 · 高楼层双东向两居室 观小区花园 无遮挡 户型方正',
    houseArea: '157㎡',
    rentPrice: '24000元/月',
    layout: '2室1厅2卫',
    imageUrls: [
      "https://image1.ljcdn.com/110000-inspection/prod-02c2db37-5ea0-4f4b-8420-2b59714256f2.jpg.780x439.jpg",
      "https://image1.ljcdn.com/110000-inspection/prod-4befa5e3-5576-41bb-b608-9346ac4a37ae.jpg.780x439.jpg",
      "https://image1.ljcdn.com/110000-inspection/prod-d45bff8c-289f-4f33-a10e-018f79fe6b1f.jpg.780x439.jpg",
      "https://image1.ljcdn.com/110000-inspection/prod-718f4fd6-7f4f-4313-9ac4-e8a1c7c77fc5.jpg.780x439.jpg",
      "https://image1.ljcdn.com/110000-inspection/prod-ac8a079f-2f98-454d-99a6-5ed30d15e3c0.jpg.780x439.jpg",
      "https://image1.ljcdn.com/110000-inspection/prod-9f56163d-9632-4eeb-bef5-5a18248a3883.jpg.780x439.jpg"
    ]
  )
];