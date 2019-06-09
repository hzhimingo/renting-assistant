import 'answer_cover.dart';

class QuestionDetail {
  final String questionId;
  final String questionTitle;
  final String questionContent;
  final int answerCount;
  final String uid;
  final String nickname;
  final String avatar;
  final String publishDate;
  final List<AnswerCover> answers;

  QuestionDetail({
    this.questionId,
    this.questionTitle,
    this.questionContent,
    this.answerCount,
    this.uid,
    this.nickname,
    this.avatar,
    this.publishDate,
    this.answers,
  });

  factory QuestionDetail.fromJson(Map<String, dynamic> json) {
    List<AnswerCover> _answers = [];
    json["answers"].forEach((item) {
      _answers.add(AnswerCover.fromJson(item));
    });
    return QuestionDetail(
      questionId: json["questionId"],
      questionTitle: json["questionTitle"],
      questionContent: json["questionContent"],
      answerCount: json["answerCount"],
      uid: json["uid"],
      nickname: json["nickname"],
      avatar: json["avatar"],
      publishDate: json["publishDate"],
      answers: _answers,
    );
  }
}
