import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:renting_assistant/api/net_data_repo.dart';
import 'package:renting_assistant/even_bus/even_bus.dart';
import 'package:renting_assistant/model/answer_cover.dart';
import 'package:renting_assistant/model/question_cover.dart';
import 'package:renting_assistant/model/question_detail.dart';
import 'package:renting_assistant/pages/answer_detail.dart';
import 'package:renting_assistant/pages/edit_answer.dart';
import 'package:renting_assistant/widgets/answer_cover.dart';


///问题的详情页面（包含全部的回答）
class QuestionDetailPage extends StatefulWidget {
  final String questionId;

  QuestionDetailPage(this.questionId);

  @override
  _QuestionDetailPageState createState() => _QuestionDetailPageState();
}

class _QuestionDetailPageState extends State<QuestionDetailPage> {

  Future<QuestionDetail> _questionDetailFuture;
  QuestionDetail _questionDetail;

  @override
  void initState() {
    super.initState();
    _loadData(widget.questionId);
  }

  _loadData(String questionId) {
    _questionDetailFuture = NetDataRepo().obtainQuestionDetail(questionId);
    _questionDetailFuture.then((value) {
      setState(() {
        _questionDetail = value;
      });
    });
  }

  _listen() {
    eventBus.on<RefreshQuestion>().listen((event){
      _loadData(widget.questionId);
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
        title: Text('全部回答'),
        centerTitle: true,
        elevation: 0.4,
      ),
      body: FutureBuilder(
        future: _questionDetailFuture,
        builder: (BuildContext context, AsyncSnapshot<QuestionDetail> snap) {
          switch(snap.connectionState) {
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
                padding: EdgeInsets.only(bottom: 50.0,),
                child: ListView(
                  children: <Widget>[
                    _questionInfoTop(),
                    _answerList(),
                  ],
                ),
              );
          }
        },
      ),
      bottomSheet: _bottomSheet(),
    );
  }

  Widget _bottomSheet() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return EditAnswer(
            questionId: _questionDetail.questionId,
            question: _questionDetail.questionTitle,
          );
        }));
      },
      child: Container(
        color: Colors.white,
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.edit, size: 20.0,),
            SizedBox(width: 5.0,),
            Text('添加回答', style: TextStyle(fontSize: 16.0),),
          ],
        ),
      ),
    );
  }

  Widget _questionInfoTop() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Text(
              _questionDetail.questionTitle,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _questionUserInfo(),
          _questionContent(),
        ],
      ),
    );
  }

  Widget _questionContent() {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
      child: Text(
        _questionDetail.questionContent,
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    );
  }

  Widget _questionUserInfo() {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            child: Container(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(_questionDetail.avatar),
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    width: 100.0,
                    child: Text(
                      _questionDetail.nickname,
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                _questionDetail.publishDate,
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _answerList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _questionDetail.answers.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: _buildAnswer,
    );
  }

  Widget _buildAnswer(BuildContext context, int index) {
    if (_questionDetail.answers.length != 0) {
      AnswerCover _answerCover = _questionDetail.answers[index];
      return _answer(_answerCover);
    } else {
      return Container(
        child: Center(
          child: Text('还没有人回答噢'),
        ),
      );
    }
  }

  Widget _answerUserInfo(String avatar, String nickname, String time) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 35.0,
            height: 35.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    avatar),
              ),
              shape: BoxShape.circle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 120.0,
                  child: Text(
                    nickname,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      time,
                      style: TextStyle(fontSize: 12.0, color: Colors.grey[500]),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _answer(AnswerCover answerCover) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return AnswerDetailPage(answerCover.answerId);
        }));
      },
      child: Container(
        child: Column(
          children: <Widget>[
            _answerUserInfo(answerCover.avatar, answerCover.nickname, answerCover.answerTime),
            AnswerContent(answerCover.answerContent),
            AnswerOption(
              answerCover: answerCover,
            ),
          ],
        ),
        margin: EdgeInsets.only(bottom: 10.0),
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
        ),
        decoration: BoxDecoration(color: Colors.white),
      ),
    );
  }
}
