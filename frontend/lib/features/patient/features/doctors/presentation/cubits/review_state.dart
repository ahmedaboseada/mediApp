abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewSubmitting extends ReviewState {}

class ReviewSuccess extends ReviewState {
  final String? message;
  ReviewSuccess([this.message]);
}

class ReviewFailure extends ReviewState {
  final String message;
  ReviewFailure(this.message);
}
