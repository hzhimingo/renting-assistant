class AnswerCover {
  final String answerId;
  final String answerContent;
  final String answerTime;
  final String uid;
  final String avatar;
  final String nickname;
  final int goodCount;
  final int replyCount;
  final String questionId;
  final String questionTitle;
  final int goodStatus;

  AnswerCover(
      {this.answerId,
      this.answerContent,
      this.answerTime,
      this.uid,
      this.avatar,
      this.nickname,
      this.goodCount,
      this.replyCount,
      this.questionId,
      this.questionTitle,
      this.goodStatus});

  factory AnswerCover.fromJson(Map<String, dynamic> json) {
    return AnswerCover(
      answerId: json["answerId"],
      answerContent: json["answerContent"],
      answerTime: json["answerTime"],
      uid: json["uid"],
      avatar: json["avatar"],
      nickname: json["nickname"],
      goodCount: json["goodCount"],
      replyCount: json["replyCount"],
      questionId: json["questionId"],
      questionTitle: json["questionTitle"],
      goodStatus: json["goodStatus"],
    );
  }
}
