import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:renting_assistant/api/net_data_repo.dart';
import 'package:renting_assistant/even_bus/even_bus.dart';
import 'package:renting_assistant/localstore/local_store.dart';
import 'package:renting_assistant/model/user_info.dart';
import 'package:renting_assistant/pages/collect_page.dart';
import 'package:renting_assistant/pages/history_page.dart';
import 'package:renting_assistant/pages/message_page.dart';
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

import 'edit_info_page.dart';

class MinePage extends StatefulWidget {
  @override
  State<MinePage> createState() {
    return _MinePageState();
  }
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  final _iconTextStyle = TextStyle(fontSize: 15.0, color: Colors.black38);
  String accessToken;
  UserInfo userInfo;
  String debugLable = 'Unknown';
  final JPush jpush = new JPush();

  @override
  void initState() {
    loadAccessToken();
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    // Platform messages may fail, so we use a try/catch PlatformException.
    jpush.getRegistrationID().then((rid) {
      setState(() {
        debugLable = "flutter getRegistrationID: $rid";
      });
      LocalStore.saveJpushId(rid);
    });

    jpush.setup(
      appKey: "fc69e6d87cf4c3fb4fc01519",
      channel: "theChannel",
      production: false,
      debug: true,
    );
    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));

    try {
      jpush.addEventHandler(
        onReceiveNotification: (Map<String, dynamic> message) async {
          print("flutter onReceiveNotification: $message");
          setState(() {
            debugLable = "flutter onReceiveNotification: $message";
          });
        },
        onOpenNotification: (Map<String, dynamic> message) async {
          print("flutter onOpenNotification: $message");
          setState(() {
            debugLable = "flutter onOpenNotification: $message";
          });
        },
        onReceiveMessage: (Map<String, dynamic> message) async {
          print("flutter onReceiveMessage: $message");
          setState(() {
            debugLable = "flutter onReceiveMessage: $message";
          });
        },
      );
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      debugLable = platformVersion;
    });
  }

  loadAccessToken() async {
    await LocalStore.readAccessToken().then((value) {
      if (value != null) {
        accessToken = value;
        loadUserInfo(value); //加载UserInfo
      } else {}
    });
  }

  loadUserInfo(String accessToken) {
    LocalStore.readUserInfo().then((value) {
      if (value == null) {
        NetDataRepo().obtainUserInfo(accessToken).then((value) {
          if (value != null) {
            LocalStore.saveUserInfo(value);
            setState(() {
              userInfo = value;
            });
          }
        });
      } else {
        setState(() {
          userInfo = value;
        });
      }
    });
  }

  _listen() {
    eventBus.on<LogOutEvent>().listen((event) {
      setState(() {
        accessToken = null;
        userInfo = null;
      });
    });
    eventBus.on<SignInEvent>().listen((event) {
      loadAccessToken();
    });
    eventBus.on<NotifyEditNicknameSuccess>().listen((event){
      if (mounted) {
        loadAccessToken();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _listen();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () => Navigator.of(context).pushNamed("/setting"),
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
                  onTap: () {
                    if (userInfo == null) {
                      Navigator.of(context)
                          .pushNamed("/sign-in")
                          .then((value) {});
                    } else {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return EditUserInfoPage(userInfo);
                      }));
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 25.0),
                    width: 65.0,
                    height: 65.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(65.0),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          userInfo != null
                              ? userInfo.avatar
                              : "https://avatar.gitee.com/uploads/29/4790229_leonzm.png!avatar100?1548256827",
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (userInfo == null) {
                      Navigator.of(context)
                          .pushNamed("/sign-in")
                          .then((value) {});
                    } else {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return EditUserInfoPage(userInfo);
                      }));
                    }
                  },
                  child: Container(
                    width: 200.0,
                    child: Text(
                      userInfo != null ? userInfo.nickname : "登录/注册",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
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
                    child: GestureDetector(
                  onTap: () {
                    if (userInfo == null) {
                      Navigator.of(context).pushNamed('/sign-in');
                    } else {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return CollectPage();
                      }));
                    }
                  },
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
                )),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (userInfo == null) {
                        Navigator.of(context).pushNamed('/sign-in');
                      } else {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return HistoryPage();
                        }));
                      }
                    },
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
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (userInfo == null) {
                        Navigator.of(context).pushNamed('/sign-in');
                      } else {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return MessagePage();
                        }));
                      }
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(
                          IconData(0xe61a, fontFamily: 'iconfont'),
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          "消息",
                          style: _iconTextStyle,
                        )
                      ],
                    ),
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
          Container(
            margin: EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
            ),
            padding: EdgeInsets.only(
              left: 10.0,
              right: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    top: 12.0,
                    bottom: 12.0,
                  ),
                  padding: EdgeInsets.only(
                    top: 15.0,
                    bottom: 15.0,
                    left: 12.0,
                    right: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "入住指南",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        height: 130.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              "https://public.danke.com.cn/public-20180602-Fq4QhFaLMJ-ucd5T-14Oqr7-SX9p",
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: EdgeInsets.only(bottom: 15.0),
            padding: EdgeInsets.only(
              left: 10.0,
              right: 10.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.only(
                left: 12.0,
                right: 12.0,
                top: 15.0,
                bottom: 15.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "生活",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Container(
                    height: 150.0,
                    margin: EdgeInsets.only(top: 15.0),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _buildSwiperItems(),
                    )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  List<Widget> _buildSwiperItems() {
    List<Widget> _items = [
      _swiperItem(
        "https://ra-1257167414.cos.ap-shanghai.myqcloud.com/banner/banner01.png",
        "丰修99元上门换电池",
      ),
      _swiperItem(
        "https://ra-1257167414.cos.ap-shanghai.myqcloud.com/banner/banner02.png",
        "货拉拉联合礼包",
      ),
      _swiperItem(
        "https://ra-1257167414.cos.ap-shanghai.myqcloud.com/banner/banner03.png",
        "演员de蛋生——即兴表演",
      ),
    ];
    return _items;
  }

  Widget _swiperItem(String image, String info) {
    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0),
      child: Column(
        children: <Widget>[
          Container(
            width: 140.0,
            height: 90.0,
            margin: EdgeInsets.only(bottom: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  image,
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Text(info, overflow: TextOverflow.ellipsis,),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
