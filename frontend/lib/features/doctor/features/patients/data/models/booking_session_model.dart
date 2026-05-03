class BookingSessionModel {
  BookingSessionModel({required this.bookingId, required this.expiresAt});

  final String bookingId;
  final String expiresAt;

  factory BookingSessionModel.fromJson(Map json) {
    return BookingSessionModel(
      bookingId: (json['bookingId'] ?? '').toString(),
      expiresAt: (json['expiresAt'] ?? '').toString(),
    );
  }
}
