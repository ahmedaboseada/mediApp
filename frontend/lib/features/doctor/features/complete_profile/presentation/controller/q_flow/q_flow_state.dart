part of 'q_flow_cubit.dart';

 class QFlowState  {
  const QFlowState({required this.step});
 final int step;
 QFlowState copyWith({int? step}) {
    return QFlowState(step: step ?? this.step);
  }
}


