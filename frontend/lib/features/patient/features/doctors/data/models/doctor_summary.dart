class DoctorSummary {
  const DoctorSummary({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewsCount,
    required this.imageAsset,
  });

  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int reviewsCount;
  final String imageAsset;

  factory DoctorSummary.fromMap(Map<String, dynamic> map) {
    return DoctorSummary(
      id: map['id'] as String,
      name: map['name'] as String,
      specialty: map['specialty'] as String,
      rating: (map['rating'] as num).toDouble(),
      reviewsCount: (map['reviews'] as num).toInt(),
      imageAsset: map['image'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'specialty': specialty,
      'rating': rating,
      'reviews': reviewsCount,
      'image': imageAsset,
    };
  }
}
