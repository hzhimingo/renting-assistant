import 'package:flutter/material.dart';
import 'package:renting_assistant/pages/house_info_page.dart';
import 'package:renting_assistant/widgets/house_info_tag.dart';

class HouseCoverHorizontal extends StatelessWidget {
  final _infoLabelTextStyle = TextStyle(
    fontSize: 12.0,
    color: Colors.grey[600],
  );
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return HouseInfoPage();
          }),
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: 16.0, right: 16.0),
        padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      /*  height: 120.0,*/
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200],
            ),
          ),
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://image1.ljcdn.com/rent-user-avatar/33b47fbb-6c35-4772-8a46-026da88fe70a.780x439.jpg",
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "整租 ·   高楼层双东向两居室  观小区花园 无遮挡 户型方正",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "3室2厅1卫/",
                          style: _infoLabelTextStyle,
                        ),
                        Text(
                          "156㎡/",
                          style: _infoLabelTextStyle,
                        ),
                        Text(
                          "13层",
                          style: _infoLabelTextStyle,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Row(
                      children: <Widget>[
                        HouseInfoTag(
                          tagContent: "近地铁",
                          tagColor: Colors.cyan[500],
                          backgroundColor: Colors.cyan[100],
                        ),
                        HouseInfoTag(
                          tagContent: "靠近商圈",
                          tagColor: Colors.blue[500],
                          backgroundColor: Colors.blue[100],
                        ),
                        HouseInfoTag(
                          tagContent: "随时入住",
                          tagColor: Colors.green[500],
                          backgroundColor: Colors.green[100],
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0,),
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
                            text: "40000",
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
