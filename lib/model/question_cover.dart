class QuestionCover {
  final String questionId;
  final String questionTitle;
  final String questionContent;
  final int answerCount;
  final String uid;
  final String avatar;
  final String nickname;
  final String publishDate;

  QuestionCover(
      {this.questionId,
      this.questionTitle,
      this.questionContent,
      this.answerCount,
      this.uid,
      this.avatar,
      this.nickname,
      this.publishDate});

  factory QuestionCover.fromJson(Map<String, dynamic> json) {
    return QuestionCover(
      questionId: json["questionId"],
      questionTitle: json["questionTitle"],
      questionContent: json["questionContent"],
      answerCount: json["answerCount"],
      uid: json["uid"],
      avatar: json["avatar"],
      nickname: json["nickname"],
      publishDate: json["publishDate"],
    );
  }
}
