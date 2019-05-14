import 'package:flutter/material.dart';

class HouseInfoLabel extends StatelessWidget {

  final _labelHeight = 35.0;
  final _alignment = Alignment.centerLeft;
  final _labelTitleStyle = TextStyle(
    color: Colors.grey,
    fontSize: 16.0,
  );
  final _labelContentStyle = TextStyle(
      fontSize: 16.0
  );


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0),
      child: Column(
        children: <Widget>[
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  alignment: _alignment,
                  height: _labelHeight,
                  child: Text.rich(

                      TextSpan(
                          children: <TextSpan>[
                            TextSpan(text: "发布:  ", style: _labelTitleStyle),
                            TextSpan(text: "1个月前", style: _labelContentStyle)
                          ]
                      )
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: _alignment,
                  height: _labelHeight,
                  child: Text.rich(
                      TextSpan(
                          children: <TextSpan>[
                            TextSpan(text: "车位:  ", style: _labelTitleStyle),
                            TextSpan(text: "暂无数据", style: _labelContentStyle)
                          ]
                      )
                  ),
                ),
              ),

            ],
          ),
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  alignment: _alignment,
                  height: _labelHeight,
                  child: Text.rich(
                      TextSpan(
                          children: <TextSpan>[
                            TextSpan(text: "用水:  ", style: _labelTitleStyle),
                            TextSpan(text: "暂无数据", style: _labelContentStyle)
                          ]
                      )
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: _alignment,
                  height: _labelHeight,
                  child: Text.rich(
                      TextSpan(
                          children: <TextSpan>[
                            TextSpan(text: "用电:  ", style: _labelTitleStyle),
                            TextSpan(text: "暂无数据", style: _labelContentStyle)
                          ]
                      )
                  ),
                ),
              ),

            ],
          ),
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  alignment: _alignment,
                  height: _labelHeight,
                  child: Text.rich(
                      TextSpan(
                          children: <TextSpan>[
                            TextSpan(text: "燃气:  ", style: _labelTitleStyle),
                            TextSpan(text: "有", style: _labelContentStyle)
                          ]
                      )
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: _alignment,
                  height: _labelHeight,
                  child: Text.rich(
                      TextSpan(
                          children: <TextSpan>[
                            TextSpan(text: "采暖:  ", style: _labelTitleStyle),
                            TextSpan(text: "暂无数据", style: _labelContentStyle)
                          ]
                      )
                  ),
                ),
              ),
            ],
          ),
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  alignment: _alignment,
                  height: _labelHeight,
                  child: Text.rich(
                      TextSpan(
                          children: <TextSpan>[
                            TextSpan(text: "看房:  ", style: _labelTitleStyle),
                            TextSpan(text: "需提前预约", style: _labelContentStyle)
                          ]
                      )
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}