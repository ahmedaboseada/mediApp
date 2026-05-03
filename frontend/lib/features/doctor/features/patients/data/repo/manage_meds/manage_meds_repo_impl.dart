import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medi/core/core.dart';

import 'manage_meds_repo.dart';

class ManageMedsRepoImpl implements ManageMedsRepo {
	final ApiService apiService;

	ManageMedsRepoImpl(this.apiService);

	@override
	Future<Either<ApiError, String>> addMedication({
		required String patientId,
		required String name,
		required String type,
		required String dosage,
		required String frequency,
		List<String>? daily,
	}) async {
		try {
			final Map<String, dynamic> data = {
				'name': name,
				'type': type,
				'dosage': dosage,
				'frequency': frequency,
			};

			if (daily != null && daily.isNotEmpty) {
				data['daily'] = daily;
			}

			final dynamic response = await apiService.post('/patients/$patientId/medications', data);

			log('Add Patient Medication Response: ${response.toString()}');

			if (response is ServerFailure) {
				return Left(response);
			}

			final message =
					(response is Map<String, dynamic> ? response['message'] : null) ??
					'Medication added successfully';

			return Right(message.toString());
		} on DioException catch (e) {
			return Left(ServerFailure.fromDioError(e));
		} catch (e) {
			return Left(ServerFailure(e.toString()));
		}
	}

	@override
	Future<Either<ApiError, String>> updateMedication({
		required String medicationId,
		required String patientId,
		String? name,
		String? type,
		String? dosage,
		String? frequency,
		List<String>? daily,
		String? instructions,
	}) async {
		try {
			final Map<String, dynamic> data = {'patientId': patientId};

			if (name != null && name.trim().isNotEmpty) {
				data['name'] = name;
			}
			if (type != null && type.trim().isNotEmpty) {
				data['type'] = type;
			}
			if (dosage != null && dosage.trim().isNotEmpty) {
				data['dosage'] = dosage;
			}
			if (frequency != null && frequency.trim().isNotEmpty) {
				data['frequency'] = frequency;
			}
			if (daily != null && daily.isNotEmpty) {
				data['daily'] = daily;
			}
			if (instructions != null && instructions.trim().isNotEmpty) {
				data['instructions'] = instructions;
			}

			final dynamic response = await apiService.put(
				'/medications/$medicationId',
				data,
			);

			log('Update Patient Medication Response: ${response.toString()}');

			if (response is ServerFailure) {
				return Left(response);
			}

			final message =
					(response is Map<String, dynamic> ? response['message'] : null) ??
					'Medication updated successfully';

			return Right(message.toString());
		} on DioException catch (e) {
			return Left(ServerFailure.fromDioError(e));
		} catch (e) {
			return Left(ServerFailure(e.toString()));
		}
	}

	@override
	Future<Either<ApiError, String>> deleteMedication({
		required String medicationId,
		required String patientId,
	}) async {
		try {
			final dynamic response = await apiService.delete('/medications/$medicationId', {
				'patientId': patientId,
			});

			log('Delete Patient Medication Response: ${response.toString()}');

			if (response is ServerFailure) {
				return Left(response);
			}

			final message =
					(response is Map<String, dynamic> ? response['message'] : null) ??
					'Medication deleted successfully';

			return Right(message.toString());
		} on DioException catch (e) {
			return Left(ServerFailure.fromDioError(e));
		} catch (e) {
			return Left(ServerFailure(e.toString()));
		}
	}
}

