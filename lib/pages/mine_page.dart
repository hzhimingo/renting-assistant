import 'package:flutter/material.dart';

class MinePage extends StatefulWidget {
  @override
  State<MinePage> createState() {
    return _MinePageState();
  }
}

class _MinePageState extends State<MinePage> with AutomaticKeepAliveClientMixin{
  final _iconTextStyle = TextStyle(fontSize: 15.0, color: Colors.black38);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: ()=> Navigator.of(context).pushNamed("/setting"),
              icon: Icon(
                Icons.settings,
                color: Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
                left: 20.0, top: 20.0, bottom: 16.0, right: 20.0),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed("/sign-in"),
                  child: Container(
                    margin: EdgeInsets.only(right: 25.0),
                    width: 65.0,
                    height: 65.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(65.0),
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://avatar.gitee.com/uploads/29/4790229_leonzm.png!avatar100?1548256827",
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed("/sign-in"),
                  child: Text(
                    "登录/注册",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                EdgeInsets.only(left: 8.0, right: 8.0, top: 15.0, bottom: 15.0),
            color: Colors.white,
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.favorite_border,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        "关注",
                        style: _iconTextStyle,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.history,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        "足迹",
                        style: _iconTextStyle,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.question_answer,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        "消息",
                        style: _iconTextStyle,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.chat_bubble_outline,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        "话题",
                        style: _iconTextStyle,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
