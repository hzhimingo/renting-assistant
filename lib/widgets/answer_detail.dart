import 'package:flutter/material.dart';
import 'package:renting_assistant/widgets/answer_cover.dart';

class AnswerDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      padding:
          EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0, bottom: 15.0),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          UserInfoBox("A"),
          AnswerRichText(),
        ],
      ),
    );
  }
}

class AnswerRichText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, right: 10.0),
      child: Text(
        'tmpppppppppppppppppppppppppppppppppppppppppphalskjdhflaksjdhflaksjdasdhfalksjdhflaksjdhflaksjdhp',
        style: TextStyle(
          fontSize: 17.0,
          letterSpacing: 0.9,
        ),
      ),
    );
  }
}


