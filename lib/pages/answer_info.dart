import 'package:flutter/material.dart';
import 'package:renting_assistant/even_bus/even_bus.dart';
import 'package:renting_assistant/pages/question_info.dart';
import 'package:renting_assistant/widgets/answer_detail.dart';

class AnswerInfo extends StatefulWidget {
  @override
  _AnswerInfoState createState() => _AnswerInfoState();
}

class _AnswerInfoState extends State<AnswerInfo> {

  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
  }

  _listen() {
    eventBus.on<ChangeTab>().listen((event) {
      setState(() {
        _currentIndex = event.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _listen();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Answer'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: <Widget>[
            QuestionTop(),
            AnswerDetail(),
            AnswerOptionInfo(),
            _buildLisView(),
          ],
        ),
      ),
    );
  }

  Widget _buildLisView() {
    return _currentIndex == 0 ? ThumbUseList() : ReplyList();
  }
}

class QuestionTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 1.0),
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 10.0,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Text(
              '相信酷安有很多酷基在上学吧，你们上学期间最喜欢用的笔是啥，拿出来亮亮相呗？',
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.9,
              ),
            ),
          ),
          Divider(),
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 200,
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return QuestionInfo();
                    }));
                  },
                  child: Text(
                    '查看全部292个答案',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: 1.0,
                  height: 30.0,
                  color: Colors.grey[300],
                ),
              ),
              Expanded(
                flex: 200,
                child: FlatButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.edit,
                        size: 18.0,
                        color: Colors.cyan[400],
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        '添加问答',
                        style: TextStyle(
                          color: Colors.cyan[400],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class AnswerOptionInfo extends StatefulWidget {
  @override
  _AnswerOptionInfoState createState() => _AnswerOptionInfoState();
}

class _AnswerOptionInfoState extends State<AnswerOptionInfo> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        margin: EdgeInsets.only(
          top: 10.0,
        ),
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        color: Colors.white,
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                  eventBus.fire(ChangeTab(0));
                },
                child: Container(
                  height: 40.0,
                  alignment: Alignment.center,
                  child: Text('赞116'),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: _currentIndex == 0 ? Colors.cyan[300] : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                  eventBus.fire(ChangeTab(1));
                },
                child: Container(
                  height: 40.0,
                  alignment: Alignment.center,
                  child: Text('回复113'),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: _currentIndex == 1 ? Colors.cyan[300] : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ThumbUseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 10,
        itemBuilder: _thumbUserBuilder,
      ),
    );
  }

  Widget _thumbUserBuilder(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 35.0,
                height: 35.0,
                margin: EdgeInsets.only(right: 10.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://avatar.gitee.com/uploads/29/4790229_leonzm.png!avatar100?1548256827'),
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              Text("下个ID见"),
            ],
          ),
          Divider(
            color: Colors.grey[200],
          ),
        ],
      ),
    );
  }
}

class ReplyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text('回复'),
      ),
    );
  }
}
