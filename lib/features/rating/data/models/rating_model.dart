import 'package:rental_car/features/rating/domain/entities/rating_entity.dart';

class RatingModel {
  const RatingModel({
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
  final String? createdAt;

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'] as int?,
      rentalId: json['rentalId'] as int? ?? (json['rental_id'] as int? ?? 0),
      score: json['score'] as int? ?? 5,
      comment: json['comment'] as String? ?? '',
      userId: json['userId'] as int? ?? (json['user_id'] as int?),
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': ?id,
      'rentalId': rentalId,
      'score': score,
      'comment': comment,
      'userId': ?userId,
    };
  }

  RatingEntity toEntity() {
    return RatingEntity(
      id: id,
      rentalId: rentalId,
      score: score,
      comment: comment,
      userId: userId,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
    );
  }
}
