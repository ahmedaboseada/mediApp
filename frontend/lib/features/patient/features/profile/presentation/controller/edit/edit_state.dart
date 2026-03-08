part of 'edit_cubit.dart';

class EditState {
  const EditState({this.isEditing = false});
  final bool isEditing;
  EditState copyWith({bool? isEditing}) {
    return EditState(isEditing: isEditing ?? this.isEditing);
  }
}
