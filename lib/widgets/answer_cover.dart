import 'package:flutter/material.dart';
import 'package:renting_assistant/model/answer_cover.dart';
import 'package:renting_assistant/pages/answer_detail.dart';

class AnswerCoverBox extends StatelessWidget {
  final AnswerCover _answerCover;

  AnswerCoverBox(this._answerCover);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return AnswerDetailPage(_answerCover.answerId);
        }));
      },
      child: Container(
        child: Column(
          children: <Widget>[
            UserInfoBox(
              type: "A",
              nickname: _answerCover.nickname,
              avatar: _answerCover.avatar,
              time: _answerCover.answerTime,
            ),
            Question(_answerCover.questionTitle),
            AnswerContent(_answerCover.answerContent),
            AnswerOption(
              answerCover: _answerCover,
            ),
          ],
        ),
        margin: EdgeInsets.only(bottom: 10.0),
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 22.0,
        ),
        decoration: BoxDecoration(color: Colors.white),
      ),
    );
  }
}

/// 用户信息部分
class UserInfoBox extends StatelessWidget {
  final String nickname;
  final String avatar;
  final String time;
  final String type;
  UserInfoBox({Key key, this.nickname, this.avatar, this.time, this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 35.0,
            height: 35.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  avatar,
                ),
              ),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0),
            width: 150.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  nickname,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      time,
                      style: TextStyle(fontSize: 12.0, color: Colors.grey[500]),
                    ),
                    Container(
                      child: Text(
                        type == "Q" ? '提问' : '回答',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 5.0, right: 5.0),
                      padding: EdgeInsets.only(
                          left: 4.0, right: 4.0, top: 1.0, bottom: 1.0),
                      decoration: BoxDecoration(
                        color: type == 'Q' ? Colors.green : Colors.blue,
                        borderRadius: BorderRadius.circular(3.0),
                      ),
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
}

/// 问题部分
class Question extends StatelessWidget {
  final String content;

  Question(this.content);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
      alignment: Alignment.centerLeft,
      child: Text(
        content,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// 内嵌的第一个回答，简略信息
class AnswerContent extends StatelessWidget {
  final String answerContent;

  AnswerContent(this.answerContent);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
      alignment: Alignment.centerLeft,
      child: Text(
        answerContent,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16.0,
          letterSpacing: 0.9,
        ),
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200])),
      ),
    );
  }
}

/// 点赞、回复、分享部分
class AnswerOption extends StatefulWidget {
  final AnswerCover answerCover;

  AnswerOption({Key key, this.answerCover}) : super(key: key);

  @override
  _AnswerOptionState createState() => _AnswerOptionState();
}

class _AnswerOptionState extends State<AnswerOption> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: FlatButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      IconData(0xe756, fontFamily: 'iconfont'),
                      color: Colors.grey[400],
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 3.0,
                    ),
                    Text(
                      '${widget.answerCover.goodCount == 0 ? "" : widget.answerCover.goodCount}',
                      style: TextStyle(color: Colors.grey[400], fontSize: 15.0),
                    ),
                  ],
                ),
              )),
          Expanded(
            flex: 1,
            child: FlatButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AnswerDetailPage(widget.answerCover.answerId);
                }));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    IconData(0xe603, fontFamily: 'iconfont'),
                    color: Colors.grey[400],
                    size: 28.0,
                  ),
                  SizedBox(
                    width: 3.0,
                  ),
                  Text(
                    '${widget.answerCover.replyCount == 0 ? "" : widget.answerCover.replyCount}',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.share,
                    color: Colors.grey[400],
                    size: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
