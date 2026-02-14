class ApiError {
  final String message;

  ApiError(this.message);
  @override
  String toString() {
    return 'ApiError{message: $message}';
  }
}
