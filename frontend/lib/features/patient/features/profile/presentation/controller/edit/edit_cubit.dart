
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_state.dart';

class EditCubit extends Cubit<EditState> {
  EditCubit() : super(const EditState(isEditing: false));
  void toggleEdit() {
    emit(state.copyWith(isEditing: !state.isEditing));
  }
}
