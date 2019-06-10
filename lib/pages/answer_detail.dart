import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:renting_assistant/api/net_data_repo.dart';
import 'package:renting_assistant/even_bus/even_bus.dart';
import 'package:renting_assistant/localstore/local_store.dart';
import 'package:renting_assistant/model/answer_detail.dart';
import 'package:renting_assistant/pages/edit_answer.dart';
import 'package:renting_assistant/pages/question_detail.dart';
import 'package:renting_assistant/widgets/answer_detail.dart';

/// 回答详情页面
class AnswerDetailPage extends StatefulWidget {
  final String answerId;

  AnswerDetailPage(this.answerId);

  @override
  _AnswerDetailPageState createState() => _AnswerDetailPageState();
}

class _AnswerDetailPageState extends State<AnswerDetailPage> {
  int _currentIndex = 1;
  Future<AnswerDetail> _answerDetailFuture;
  AnswerDetail _answerDetail;

  @override
  void initState() {
    super.initState();
    _loadData(widget.answerId);
  }

  _listen() {
    eventBus.on<ChangeTab>().listen((event) {
      setState(() {
        _currentIndex = event.index;
      });
    });
  }

  _loadData(String answerId) {
    _answerDetailFuture = NetDataRepo().obtainAnswerDetail(answerId);
    _answerDetailFuture.then((value) {
      setState(() {
        _answerDetail = value;
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
      body: FutureBuilder(
        future: _answerDetailFuture,
        builder: (BuildContext context, AsyncSnapshot<AnswerDetail> snap) {
          switch (snap.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(
                child: SpinKitThreeBounce(
                  color: Colors.cyan[300],
                  size: 30.0,
                ),
              );
            case ConnectionState.done:
              return Container(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  children: <Widget>[
                    QuestionTop(
                      questionId: _answerDetail.questionId,
                      questionTitle: _answerDetail.questionTitle,
                      answerCount: _answerDetail.answerCount,
                    ),
                    AnswerDetailBox(
                      nickname: _answerDetail.nickname,
                      avatar: _answerDetail.avatar,
                      time: _answerDetail.answerTime,
                      answerContent: _answerDetail.answerContent,
                    ),
                    AnswerOptionInfo(
                      goodCount: _answerDetail.goodCount,
                      replyCount: _answerDetail.replyCount,
                    ),
                    _buildListView(),
                  ],
                ),
              );
          }
        },
      ),
    );
  }

  Widget _buildListView() {
    return _currentIndex == 0 ? ThumbUseList() : ReplyList();
  }
}

class QuestionTop extends StatelessWidget {
  final String questionTitle;
  final String questionId;
  final int answerCount;

  QuestionTop({Key key, this.questionTitle, this.questionId, this.answerCount})
      : super(key: key);

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
          Container(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            alignment: Alignment.centerLeft,
            child: Text(
              questionTitle,
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
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      ///跳转到问题的详情查看全部的回答
                      return QuestionDetailPage(questionId);
                    }));
                  },
                  child: Text(
                    '查看全部$answerCount个答案',
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
                  onPressed: () async {
                    await LocalStore.readAccessToken().then((value) {
                      if (value == null) {
                        Navigator.of(context).pushNamed("/sign-in");
                      } else {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return EditAnswer(
                            question: questionTitle,
                            questionId: questionId,
                          );
                        }));
                      }
                    });

                  },
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
  final int goodCount;
  final int replyCount;

  AnswerOptionInfo({Key key, this.goodCount, this.replyCount})
      : super(key: key);

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
                  child: Text('赞  ${widget.goodCount}'),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: _currentIndex == 0
                            ? Colors.cyan[300]
                            : Colors.white,
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
                  child: Text('回复  ${widget.replyCount}'),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: _currentIndex == 1
                            ? Colors.cyan[300]
                            : Colors.white,
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
