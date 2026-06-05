import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/features/patient/features/add_medication/data/repo/medicine_repo.dart';
import 'package:medi/features/patient/features/home/presentation/controller/alerts/low_stock_alerts_state.dart';

class LowStockAlertsCubit extends Cubit<LowStockAlertsState> {
  LowStockAlertsCubit(this._medicineRepo) : super(LowStockAlertsInitial());

  final MedicineRepo _medicineRepo;

  Future<void> checkLowStockAlerts() async {
    emit(LowStockAlertsLoading());

    final result = await _medicineRepo.getActiveMedications();

    result.fold(
      (error) => emit(LowStockAlertsFailure(message: error.message)),
      (medications) {
        final lowStockMedications = medications.where((med) {
          final isPillOrTablet = med.medicationType == MedicationType.pill ||
              med.medicationType == MedicationType.tablet;
          
          return isPillOrTablet && med.stockStatus == MedicationStockStatus.low;
        }).toList();

        emit(LowStockAlertsSuccess(lowStockMedications: lowStockMedications));
      },
    );
  }
}
