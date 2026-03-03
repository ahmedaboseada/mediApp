class ApiError {
  final String message;
  final List<String> errors;

  ApiError(this.message, [this.errors = const []]);
  
  @override
  String toString() {
    return 'ApiError{message: $message, errors: $errors}';
  }
}
