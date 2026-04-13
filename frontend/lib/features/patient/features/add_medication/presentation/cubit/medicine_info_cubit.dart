import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/features/patient/features/add_medication/data/repo/medicine_repo.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medicine_info_state.dart';

class MedicineInfoCubit extends Cubit<MedicineInfoState> {
  late Medication _sourceMedication;
  final MedicineRepo _medicineRepo;

  MedicineInfoCubit(this._medicineRepo, {Medication? medication})
    : super(
        medication != null
            ? MedicineInfoState.fromMedication(medication)
            : MedicineInfoState.initial(),
      ) {
    _sourceMedication = medication ?? const Medication();
    loadMedicationSchedule();
  }

  void _emitIfOpen(MedicineInfoState newState) {
    if (!isClosed) {
      emit(newState);
    }
  }

  Future<void> loadMedicationSchedule() async {
    final medicationId = state.medication.id.trim();
    final fallbackTimes = _fallbackScheduleTimes();

    if (medicationId.isEmpty) {
      _emitIfOpen(
        state.copyWith(
          scheduleTimes: fallbackTimes,
          nextScheduleTime: _nextUntakenTime(fallbackTimes),
          isTaken: _nextUntakenEntry(fallbackTimes)?.taken ?? false,
        ),
      );
      return;
    }

    final now = DateTime.now();
    final date =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final result = await _medicineRepo.getMedicationScheduleForDate(date: date);
    result.fold(
      (_) {
        _emitIfOpen(
          state.copyWith(
            scheduleTimes: fallbackTimes,
            nextScheduleTime: _nextUntakenTime(fallbackTimes),
            isTaken: _nextUntakenEntry(fallbackTimes)?.taken ?? false,
          ),
        );
      },
      (response) {
        final scheduleTimes = _extractScheduleTimes(
          response,
          medicationId: medicationId,
          medicationName: state.medication.name,
        );
        final resolvedTimes = scheduleTimes.isNotEmpty
            ? scheduleTimes
            : fallbackTimes;
        final nextUntaken = _nextUntakenEntry(resolvedTimes);

        _emitIfOpen(
          state.copyWith(
            scheduleTimes: resolvedTimes,
            nextScheduleTime:
                nextUntaken?.time ?? _nextUntakenTime(resolvedTimes),
            isTaken: nextUntaken?.taken ?? false,
          ),
        );
      },
    );
  }

  Future<Either<ApiError, String>> toggleMedicineTaken(
    bool value, {
    String? time,
  }) async {
    final previousTaken = state.isTaken;
    _emitIfOpen(state.copyWith(isTaken: value));

    if (state.medication.id.trim().isEmpty) {
      return Right('Medication status updated locally');
    }

    final selectedTime = (time ?? state.nextScheduleTime).trim();
    if (selectedTime.isEmpty) {
      _emitIfOpen(state.copyWith(isTaken: previousTaken));
      return Left(
        ServerFailure('Unable to determine the next medication time'),
      );
    }

    final now = DateTime.now();
    final date =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final result = await _medicineRepo.markAsTaken(
      medicationId: state.medication.id,
      date: date,
      time: selectedTime,
      taken: value,
    );

    if (result.isLeft()) {
      _emitIfOpen(state.copyWith(isTaken: previousTaken));
      return result;
    }
    return result;
  }

  void toggleCriticalMode(bool value) {
    final updated = state.medication.copyWith(isCriticalMode: value);
    _emitIfOpen(state.copyWith(medication: updated));
    _persistMedication(updated);
  }

  Future<Either<ApiError, String>> refillStock({required int amount}) async {
    if (amount <= 0) {
      return Left(ServerFailure('Please enter a valid stock amount'));
    }

    final previous = state.medication;
    final updatedStock = state.stock + amount;
    final updated = state.medication.copyWith(
      stock: updatedStock,
      currentStock: updatedStock.toString(),
      stockStatus: _statusForStock(updatedStock),
    );

    final medicationId = previous.id.trim();
    if (medicationId.isNotEmpty) {
      final result = await _medicineRepo.updateMedicineFromMedication(
        medicationId: medicationId,
        medication: updated,
      );
      if (result.isLeft()) {
        return result;
      }
    }

    _emitIfOpen(state.copyWith(medication: updated));
    await _persistMedication(updated);
    return const Right('Stock refilled successfully');
  }

  Future<void> _persistMedication(Medication updated) async {
    await HiveService.updateMedication(
      original: _sourceMedication,
      updated: updated,
    );
    _sourceMedication = updated;
  }

  Future<void> applyEditedMedication(Medication updated) async {
    _sourceMedication = updated;
    _emitIfOpen(state.copyWith(medication: updated));
  }

  MedicationStockStatus _statusForStock(int stock) {
    if (stock <= 5 && stock > 0) return MedicationStockStatus.low;
    if (stock <= 20 && stock > 5) return MedicationStockStatus.medium;
    if (stock > 20) return MedicationStockStatus.good;
    return MedicationStockStatus.low;
  }

  void addScheduleItem() {
    final reminders = [...state.reminders];
    reminders.add(reminders.length.isEven ? '6:00 AM' : '9:00 PM');
    emit(
      state.copyWith(
        medication: state.medication.copyWith(reminders: reminders),
      ),
    );
  }

  Future<Either<ApiError, String>> deleteMedication() async {
    if (_sourceMedication.id.trim().isNotEmpty) {
      final result = await _medicineRepo.deleteMedication(
        medicationId: _sourceMedication.id,
      );
      if (result.isLeft()) {
        return result;
      }
    }

    await LocalNotificationService().cancelMedicationReminders(
      _sourceMedication,
    );
    await HiveService.deleteMedication(_sourceMedication);
    _emitIfOpen(state.copyWith(isDeleted: true));
    _emitIfOpen(state.copyWith(isDeleted: false));
    return const Right('Medication deleted successfully');
  }

  List<MedicationScheduleTime> _fallbackScheduleTimes() {
    return state.reminders
        .map((time) => MedicationScheduleTime(time: time, taken: false))
        .toList();
  }

  List<MedicationScheduleTime> _extractScheduleTimes(
    dynamic response, {
    required String medicationId,
    required String medicationName,
  }) {
    final scheduleRows = response is Map<String, dynamic>
        ? response['schedule'] ?? response['medications'] ?? response['data']
        : response;

    if (scheduleRows is! List) {
      return const <MedicationScheduleTime>[];
    }

    final matched = scheduleRows.whereType<Map>().firstWhere((item) {
      final map = item.cast<String, dynamic>();
      final rowMedicationId =
          (map['medicationId'] ?? map['medicineId'] ?? map['_id'] ?? map['id'])
              ?.toString()
              .trim();
      final rowName = (map['name'] ?? map['medicationName'])?.toString().trim();
      return rowMedicationId == medicationId ||
          rowName == medicationName.trim();
    }, orElse: () => const <String, dynamic>{});

    if (matched.isEmpty) {
      return const <MedicationScheduleTime>[];
    }

    final times = (matched['times'] as List?) ?? const [];
    final parsedTimes = times
        .whereType<Map>()
        .map((entry) {
          final map = entry.cast<String, dynamic>();
          return MedicationScheduleTime(
            time: (map['time'] as String?)?.trim() ?? '',
            taken: map['taken'] as bool? ?? false,
          );
        })
        .where((entry) => entry.time.isNotEmpty)
        .toList();

    return _sortScheduleTimes(parsedTimes);
  }

  List<MedicationScheduleTime> _sortScheduleTimes(
    List<MedicationScheduleTime> times,
  ) {
    final sorted = List<MedicationScheduleTime>.from(times);
    sorted.sort((left, right) {
      return _timeOfDayFor(left.time).compareTo(_timeOfDayFor(right.time));
    });
    return sorted;
  }

  MedicationScheduleTime? _nextUntakenEntry(
    List<MedicationScheduleTime> times,
  ) {
    final now = TimeOfDay.now();
    final futureUntaken = times.where((entry) {
      return !entry.taken && _timeOfDayFor(entry.time).compareTo(now) >= 0;
    }).toList();

    if (futureUntaken.isNotEmpty) {
      futureUntaken.sort((left, right) {
        return _timeOfDayFor(left.time).compareTo(_timeOfDayFor(right.time));
      });
      return futureUntaken.first;
    }

    final untaken = times.where((entry) => !entry.taken).toList();
    if (untaken.isNotEmpty) {
      untaken.sort((left, right) {
        return _timeOfDayFor(left.time).compareTo(_timeOfDayFor(right.time));
      });
      return untaken.first;
    }

    return times.isNotEmpty ? times.first : null;
  }

  String _nextUntakenTime(List<MedicationScheduleTime> times) {
    return _nextUntakenEntry(times)?.time ?? '';
  }

  TimeOfDay _timeOfDayFor(String rawTime) {
    final parsed = _parseTimeOfDay(rawTime);
    return parsed ?? const TimeOfDay(hour: 0, minute: 0);
  }

  TimeOfDay? _parseTimeOfDay(String rawTime) {
    final normalized = rawTime.trim();
    if (normalized.isEmpty) {
      return null;
    }

    final match = RegExp(
      r'^(\d{1,2})(?::(\d{2}))?\s*([AaPp][Mm])?$',
    ).firstMatch(normalized);
    if (match == null) {
      return null;
    }

    final hourRaw = int.tryParse(match.group(1) ?? '');
    final minute = int.tryParse(match.group(2) ?? '0');
    final period = match.group(3)?.toLowerCase();

    if (hourRaw == null || minute == null) {
      return null;
    }

    var hour = hourRaw;
    if (period == 'pm' && hour != 12) {
      hour += 12;
    } else if (period == 'am' && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour.clamp(0, 23), minute: minute.clamp(0, 59));
  }
}
