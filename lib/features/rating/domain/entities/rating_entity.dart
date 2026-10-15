class RatingEntity {
  const RatingEntity({
    this.id,
    required this.rentalId,
    required this.score,
    required this.comment,
    this.userId,
    this.createdAt,
  });

  final int? id;
  final int rentalId;
  final int score;
  final String comment;
  final int? userId;
  final DateTime? createdAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RatingEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          rentalId == other.rentalId &&
          score == other.score &&
          comment == other.comment &&
          userId == other.userId;

  @override
  int get hashCode => Object.hash(id, rentalId, score, comment, userId);

  @override
  String toString() =>
      'RatingEntity(id: $id, rentalId: $rentalId, score: $score, comment: $comment, userId: $userId)';
}
