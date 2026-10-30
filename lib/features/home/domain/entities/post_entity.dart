class PostEntity {
  final int id;
  final int userId;
  final String title;
  final String body;
  final int views;
  final double rating;

  const PostEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.views = 0,
    this.rating = 0.0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          title == other.title &&
          body == other.body &&
          views == other.views &&
          rating == other.rating;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      title.hashCode ^
      body.hashCode ^
      views.hashCode ^
      rating.hashCode;
}
