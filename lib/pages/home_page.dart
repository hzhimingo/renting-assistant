import 'package:flutter/material.dart';
import 'package:renting_assistant/widgets/home_page_appbar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:renting_assistant/widgets/house_cover_horizontal.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomePageAppBar(),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 8.0, bottom: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: 160.0,
            child: Swiper(
              itemBuilder: _swiperItemBuilder,
              itemCount: 3,
              autoplay: true,
              duration: 500,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Text(
              "为你推荐",
              style: TextStyle(
                  fontSize: 19.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: _recommendHouseBuilder,
          ),
          Container(
            height: 45.0,
            margin: EdgeInsets.only(
                left: 50.0, right: 50.0, top: 16.0, bottom: 16.0),
            child: FlatButton(
              onPressed: () => Navigator.of(context).pushNamed("/findHouse"),
              child: Text(
                "更多品质房源",
                style: TextStyle(fontSize: 15.0),
              ),
              color: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45.0),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _recommendHouseBuilder(BuildContext context, int index) {
    return HouseCoverHorizontal();
  }

  Widget _swiperItemBuilder(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: NetworkImage(
            "http://via.placeholder.com/350x150",
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
