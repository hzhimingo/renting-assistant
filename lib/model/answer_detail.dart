class AnswerDetail {
  final String questionId;
  final String questionTitle;
  final String questionContent;
  final int answerCount;
  final String uid;
  final String avatar;
  final String nickname;
  final String answerTime;
  final String answerId;
  final String answerContent;
  final int goodCount;
  final int replyCount;

  AnswerDetail({
    this.questionId,
    this.questionTitle,
    this.questionContent,
    this.answerCount,
    this.uid,
    this.avatar,
    this.nickname,
    this.answerTime,
    this.answerId,
    this.answerContent,
    this.goodCount,
    this.replyCount,
  });

  factory AnswerDetail.fromJson(Map<String, dynamic> json) {
    return AnswerDetail(
      questionId: json["questionId"],
      questionTitle: json["questionTitle"],
      questionContent: json["questionContent"],
      answerCount: json["answerCount"],
      uid: json["uid"],
      avatar: json["avatar"],
      nickname: json["nickname"],
      answerTime: json["answerTime"],
      answerId: json["answerId"],
      answerContent: json["answerContent"],
      goodCount: json["goodCount"],
      replyCount: json["replyCount"],
    );
  }
}
