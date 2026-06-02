import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/patient/features/doctors/data/repo/doctors_repo.dart';
import 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final DoctorsRepository doctorsRepository;

  ReviewCubit({required this.doctorsRepository}) : super(ReviewInitial());

  Future<void> submitReview(String doctorId, int rating,) async {
    emit(ReviewSubmitting());
    final result = await doctorsRepository.createReview(doctorId, rating,);
    result.fold(
      (err) => emit(ReviewFailure(err.message)),
      (_) => emit(ReviewSuccess('Rating submitted')),
    );
  }
}
