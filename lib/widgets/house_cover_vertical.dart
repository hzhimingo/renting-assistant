import 'package:flutter/material.dart';
import 'package:renting_assistant/model/house_cover_model.dart';
import 'package:renting_assistant/pages/house_info_page.dart';
import 'house_info_tag.dart';


class HouseCoverVertical extends StatelessWidget {
  final HouseCoverModel _houseCoverModel;

  HouseCoverVertical(this._houseCoverModel);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return HouseInfoPage(_houseCoverModel.houseId);
          }),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: 160.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                    _houseCoverModel.houseCoverImage,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 5.0,
                bottom: 2.0,
              ),
              child: Text(
                _houseCoverModel.houseTitle,
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 8.0),
              alignment: Alignment.topLeft,
              height: 20.0,
              child: Text(
                "${_houseCoverModel.houseType}" + '/' + "${_houseCoverModel.houseArea}" + '㎡/${_houseCoverModel.houseFloor}层',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 8.0,
                right: 8.0,
              ),
              child: Row(
                children: _houseCoverTags(),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 8.0,
                right: 8.0,
              ),
              height: 30.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '3KM内',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "￥",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "${_houseCoverModel.housePrice}",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "/月",
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _houseCoverTags () {
    List<Widget> tags = [];
    if (_houseCoverModel.isNearBySubway == 1) {
      tags.add(HouseInfoTag(
        tagContent: "近地铁",
        tagColor: Colors.cyan[500],
        backgroundColor: Colors.cyan[100],
      ));
    }
    if (_houseCoverModel.isNearByBusinessDistrict == 1) {
      tags.add(HouseInfoTag(
        tagContent: "靠近商圈",
        tagColor: Colors.blue[500],
        backgroundColor: Colors.blue[100],
      ));
    }
    if (_houseCoverModel.checkin == "随时入住") {
      tags.add(HouseInfoTag(
        tagContent: "随时入住",
        tagColor: Colors.green[500],
        backgroundColor: Colors.green[100],
      ));
    }
    if (_houseCoverModel.rentMode == 1) {
      tags.add(HouseInfoTag(
        tagContent: "整租",
        tagColor: Colors.green[500],
        backgroundColor: Colors.green[100],
      ));
    } else if (_houseCoverModel.rentMode == 2) {
      tags.add(HouseInfoTag(
        tagContent: "合租",
        tagColor: Colors.green[500],
        backgroundColor: Colors.green[100],
      ));
    }
    return tags;
  }
}
