import 'package:flutter_bloc/flutter_bloc.dart';

part 'q_flow_state.dart';

class QFlowCubit extends Cubit<QFlowState> {
  QFlowCubit() : super(QFlowState(step: 0));
   void next() => emit(state.copyWith(step: state.step + 1));
  void back() => emit(state.copyWith(step: state.step - 1));
}
