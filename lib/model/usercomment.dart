class Usercomment {
  final String commenterImg;
  final String commenterName;
  final String commentTime;
  final String commentContent;

  const Usercomment({
    required this.commenterImg,
    required this.commenterName,
    required this.commentTime,
    required this.commentContent,
  });

  Map<String, dynamic> toJson() => {
        'commenterImg': commenterImg,
        'commenterName': commenterName,
        'commentTime': commentTime,
        'commentContent': commentContent,
      };

  factory Usercomment.fromJson(Map<String, dynamic> json) {
    return Usercomment(
      commenterImg: json['commenterImg'] as String? ?? '',
      commenterName: json['commenterName'] as String? ?? 'User',
      commentTime: json['commentTime'] as String? ?? 'Just now',
      commentContent: json['commentContent'] as String? ?? '',
    );
  }
}
