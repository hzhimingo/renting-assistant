import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:renting_assistant/api/net_data_repo.dart';
import 'package:renting_assistant/even_bus/even_bus.dart';

class EditQuestionTitle extends StatefulWidget {
  @override
  _EditQuestionTitleState createState() => _EditQuestionTitleState();
}

class _EditQuestionTitleState extends State<EditQuestionTitle> {
  TextEditingController _controller = TextEditingController();

  _listen() {
    eventBus.on<NotifyPop>().listen((event){
      _controller.text = '';
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    _listen();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('提问'),
        actions: <Widget>[
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 16.0),
              alignment: Alignment.center,
              child: Text(
                '下一步',
                style: TextStyle(
                  color: Colors.cyan[400],
                  fontSize: 16.0,
                ),
              ),
            ),
            onTap: () {
              if (_controller.value.text == '') {
                _showToast('标题不能为空噢！');
              } else {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return EditQuestionContent(_controller.value.text);
                }));
              }
            },
          ),
        ],
        elevation: 0.4,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: TextField(
          autofocus: true,
          maxLines: 1,
          maxLength: 60,
          controller: _controller,
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]),
            ),
            hintText: '输入你想问的问题',
            hintStyle: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }

  _showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.6),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}

class EditQuestionContent extends StatefulWidget {
  final String title;

  EditQuestionContent(this.title);

  @override
  _EditQuestionContentState createState() => _EditQuestionContentState();
}

class _EditQuestionContentState extends State<EditQuestionContent> {
  TextEditingController _contentController = TextEditingController();
  TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = "${widget.title}?";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('提问'),
        actions: <Widget>[
          Container(
            width: 70.0,
            margin: EdgeInsets.only(right: 16.0),
            alignment: Alignment.center,
            child: FlatButton(
              color: Colors.cyan[300],
              onPressed: () {
                if (_titleController.value.text != '' && _contentController.value.text != '') {
                  String title = _titleController.value.text;
                  String content = _contentController.value.text;
                  if (!_titleController.value.text.endsWith("?")) {
                    title = title + "?";
                  }
                  NetDataRepo().pushQuestion(title, content).then((value) {
                    if (value) {
                      _titleController.text = '';
                      _contentController.text = '';
                      Navigator.of(context).pop();
                      eventBus.fire(NotifyPop());
                    } else {
                      _showToast("发布失败");
                    }
                  });
                } else {
                  _showToast('还没有将内容补充完整噢');
                }
              },
              child: Text(
                '发布',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          ),
        ],
        elevation: 0.4,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: 10.0,
              ),
              child: TextField(
                autofocus: true,
                maxLength: 61,
                controller: _titleController,
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]),
                  ),
                ),
              ),
            ),
            TextField(
              controller: _contentController,
              maxLines: 10,
              style: TextStyle(
                fontSize: 16.0,
                letterSpacing: 0.9,
              ),
              decoration: InputDecoration(
                hintText: '描述你的问题...',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.6),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
