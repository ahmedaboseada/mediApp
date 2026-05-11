import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medi/core/constants/app_keys.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/shared/auth/data/models/auth_token_model.dart';
import 'package:medi/features/shared/auth/data/models/auth_response_model.dart';
import 'package:medi/features/shared/auth/data/models/verify_otp_reponse.dart';
import 'package:medi/features/shared/auth/data/models/doctor_model.dart';
import 'package:medi/features/shared/auth/data/models/user_model.dart';
import 'package:medi/features/shared/auth/data/models/patient_model.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo.dart';
 import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
 import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class AuthRepoImpl implements AuthRepo {
  final ApiService apiService;
  AuthRepoImpl(this.apiService);
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '155393712719-3hmq2d3blnlsf7hbf1e6g1bmgre8lk6r.apps.googleusercontent.com',
  );

  @override
  Future<Either<ApiError, String>> signInWithEmailAndPassword({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      final endpoint = role == UserRole.patient
          ? '/users/signin'
          : '/users/signin';
      final dynamic response = await apiService.post(endpoint, {
        'email': email,
        'password': password,
      });
      log(response.toString());

      // Check if response is an error
      if (response is ServerFailure) {
        return Left(response);
      }

      // Check if 2FA is required
      if (response['requiresOtp'] == true &&
          response['challengeToken'] != null) {
        // Save challengeToken for 2FA verification using Hive
        await HiveService.saveChallengeToken(response['challengeToken']);
        // Return special indicator for 2FA required
        return Right('2FA_REQUIRED:${response['challengeToken']}');
      }

      // Extract tokens
      final accessToken = response['accessToken'];
      final refreshToken = response['refreshToken'];

      // Save tokens using Hive
      await HiveService.saveAccessToken(accessToken);
      await HiveService.saveRefreshToken(refreshToken);

      // Extract and save user data using Hive
      final user = UserModel.fromJson(response['user']);
      await HiveService.saveUserData(user);

      // Save user role using Hive
      final userRole = user.type == 'doctor'
          ? UserRole.doctor
          : UserRole.patient;
      await HiveService.saveUserRole(userRole);

      // Save role-specific profile data if present in the response.
      if (response['patient'] != null) {
        final patient = PatientModel.fromJson(response['patient']);
        await HiveService.savePatientData(patient);
        await HiveService.saveMedications(patient.medications);
      }
      if (response['doctor'] != null) {
        final doctor = DoctorModel.fromJson(response['doctor']);
        await HiveService.saveDoctorData(doctor);
      }
    await ZegoUIKitPrebuiltCallInvitationService().init(
 
    appID: AppKeys.appId /*input your AppID*/,
    appSign: AppKeys.appSign /*input your AppSign*/,
    userID: user.id,
    userName: '${user.firstName} ${user.lastName}',
    
    plugins: [ZegoUIKitSignalingPlugin()],
   
  );

      log('Access Token saved via Hive: $accessToken');
      return Right(accessToken);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, AuthTokensModel>> signInWithGoogle({
    required UserRole userType,
  }) async {
    try {
      await _googleSignIn.signOut();
      final user = await _googleSignIn.signIn();

      if (user == null) {
        return Left(ServerFailure('Login cancelled'));
      }

      final auth = await user.authentication;
      log('Google Sign In ID Token: ${auth.idToken}');

      if (auth.idToken == null) {
        return Left(ServerFailure('idToken is null'));
      }

      final dynamic response = await apiService.post('/users/google', {
        'idToken': auth.idToken,
        'userType': userType == UserRole.patient ? 'patient' : 'doctor',
      });

      if (response is ServerFailure) {
        return Left(response);
      }
      log('Google Sign In Response: ${response.toString()}');

      final token = AuthTokensModel.fromJson(response);

      if (token.accessToken.isEmpty) {
        return Left(ServerFailure('Missing accessToken in Google response'));
      }

      await HiveService.saveAccessToken(token.accessToken);

      if (token.refreshToken != null && token.refreshToken!.isNotEmpty) {
        await HiveService.saveRefreshToken(token.refreshToken!);
      }

      log('Google Sign In Token saved via Hive: ${token.accessToken}');
      return Right(token);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      final token = HiveService.getAccessToken();
      log('Access Token for Logout: $token');
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final response = await apiService.post(
        '/users/logout',
        {},
        headers: headers,
      );

      if (response is ServerFailure) {
        throw response;
      }

      // Clear all data using Hive
      await HiveService.clearAllData();
      await _googleSignIn.signOut();
       ZegoUIKitPrebuiltCallInvitationService().uninit();

    } catch (e) {
      log('Logout error: $e');
    }
  }

  @override
  Future<Either<ApiError, String>> completeBasicProfile({
    required String phone,
    required int yearOfBirth,
    required String gender,
    File? profilePicture,
  }) async {
    try {
      final data = <String, dynamic>{
        'phone': phone,
        'yearOfBirth': yearOfBirth,
        'gender': gender,
      };

      if (profilePicture != null) {
        final fileName = profilePicture.path.split(RegExp(r'[\\/]')).last;
        data['avatar'] = await MultipartFile.fromFile(
          profilePicture.path,
          filename: fileName,
        );
      }

      final formData = FormData.fromMap(data);

      final dynamic response = await apiService.patch(
        '/patients/complete/basic',
        formData,
        headers: {'Content-Type': 'multipart/form-data'},
      );

      log('Complete Basic Profile Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message = response['message'] ?? 'Profile completed successfully';
      return Right(message);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, AuthResponseModel>> getMe() async {
    try {
      final dynamic response = await apiService.get('/users/me');
      log('Get Me Response: ${response.toString()}');
      if (response is ServerFailure) {
        return Left(response);
      }

      final profile = AuthResponseModel.fromJson(
        response as Map<String, dynamic>,
      );

      await HiveService.saveUserData(profile.user);

      if (profile.user.type == 'doctor' && profile.doctor != null) {
        await HiveService.saveDoctorData(profile.doctor!);
      }
      if (profile.user.type == 'patient' && profile.patient != null) {
        await HiveService.savePatientData(profile.patient!);
        await HiveService.saveMedications(profile.patient!.medications);
      }

      return Right(profile);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, AuthResponseModel>> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? gender,
    String? dob,
    String? profilePicture,
    String? specialization,
    String? clinicName,
    String? medicalLicenseId,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (firstName != null) data['firstName'] = firstName;
      if (lastName != null) data['lastName'] = lastName;
      if (email != null) data['email'] = email;
      if (phone != null) data['phone'] = phone;
      if (gender != null) data['gender'] = gender;
      if (dob != null) data['DOB'] = dob;
      if (profilePicture != null) data['profilePicture'] = profilePicture;
      if (specialization != null) data['specialization'] = specialization;
      if (clinicName != null) data['clinicName'] = clinicName;
      if (medicalLicenseId != null) data['medicalLicenseId'] = medicalLicenseId;

      final dynamic response = await apiService.patch(
        '/users/updateProfile',
        data,
        headers: {'Content-Type': 'application/json'},
      );

      if (response is ServerFailure) {
        return Left(response);
      }
      log('Update Profile Response: ${response.toString()}');

      final profile = AuthResponseModel.fromJson(
        response as Map<String, dynamic>,
      );

      await HiveService.saveUserData(profile.user);

      if (profile.user.type == 'doctor' && profile.doctor != null) {
        await HiveService.saveDoctorData(profile.doctor!);
      }
      if (profile.user.type == 'patient' && profile.patient != null) {
        await HiveService.savePatientData(profile.patient!);
        await HiveService.saveMedications(profile.patient!.medications);
      }

      return Right(profile);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, AuthResponseModel>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String confirmPassword,
    required UserRole type,
  }) async {
    try {
      final data = {
        'type': type == UserRole.patient ? 'patient' : 'doctor',
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      };

      final dynamic response = await apiService.post('/users/signup', data);

      log(response.toString());

      if (response is ServerFailure) {
        return Left(response);
      }

      final authResponse = AuthResponseModel.fromJson(response);

      // Save signup auth payload to local storage.
      await HiveService.saveAuthResponse(authResponse);

      log('Sign up successful - Data saved via Hive');
      log('Access Token: ${authResponse.accessToken}');

      return Right(authResponse);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, VerifyOtpResponse>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final data = {'email': email, 'otp': otp};
      final dynamic response = await apiService.post(
        '/users/forgetPassword/verify',
        data,
      );

      if (response is ServerFailure) {
        return Left(response);
      }

      final verifyOtpResponse = VerifyOtpResponse.fromJson(response);
      log(response.toString());
      return Right(verifyOtpResponse);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> verify2FAOTP({
    required String challengeToken,
    required String otp,
  }) async {
    try {
      final data = {'challengeToken': challengeToken, 'otp': otp};
      final dynamic response = await apiService.post('/users/signin/otp', data);

      log('2FA OTP Verify Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      // Extract tokens after successful 2FA verification
      final accessToken = response['accessToken'];
      final refreshToken = response['refreshToken'];

      // Save tokens using Hive
      await HiveService.saveAccessToken(accessToken);
      await HiveService.saveRefreshToken(refreshToken);

      // Extract and save user data using Hive
      final user = UserModel.fromJson(response['user']);
      await HiveService.saveUserData(user);

      // Save user role using Hive
      final userRole = user.type == 'doctor'
          ? UserRole.doctor
          : UserRole.patient;
      await HiveService.saveUserRole(userRole);

      // Save patient data if available using Hive
      if (response['patient'] != null) {
        final patient = PatientModel.fromJson(response['patient']);
        await HiveService.savePatientData(patient);
        await HiveService.saveMedications(patient.medications);
      }

      // Clear challengeToken after successful verification using Hive
      await HiveService.clearChallengeToken();

      log('2FA Success - Access Token saved via Hive: $accessToken');
      return Right(accessToken);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final data = {
        'resetToken': resetToken,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      };
      final dynamic response = await apiService.post(
        '/users/resetPassword',
        data,
      );

      if (response is ServerFailure) {
        return Left(response);
      }

      final message = response['message'] ?? 'Password reset successfully';
      log(response.toString());
      return Right(message);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> forgetPassword({
    required String email,
  }) async {
    try {
      final data = {'email': email};
      final dynamic response = await apiService.post(
        '/users/forgetPassword',
        data,
      );

      if (response is ServerFailure) {
        return Left(response);
      }

      final message =
          response['message'] ?? 'Password reset link sent to your email';
      log(response.toString());
      return Right(message);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> resendOtp({required String email}) async {
    try {
      final data = {'email': email};
      final dynamic response = await apiService.post('/users/requestOTP', data);

      if (response is ServerFailure) {
        return Left(response);
      }

      final message = response['message'] ?? 'OTP sent successfully';
      log(response.toString());
      return Right(message);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

// import 'dart:developer';

// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:medi/core/core.dart';
// import 'package:medi/features/shared/auth/data/models/auth_token_model.dart';
// import 'package:medi/features/shared/auth/data/models/register_response.dart';
// import 'package:medi/features/shared/auth/data/models/verify_otp_reponse.dart';

// import 'package:medi/features/shared/auth/data/repo/auth_repo.dart';

// class AuthRepoImpl implements AuthRepo {
//   final ApiService apiService;
//   AuthRepoImpl(this.apiService);
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: ['email', 'profile'],
//     serverClientId:
//         '155393712719-3hmq2d3blnlsf7hbf1e6g1bmgre8lk6r.apps.googleusercontent.com',
//   );

//   @override
//   Future<Either<ApiError, String>> signInWithEmailAndPassword({
//     required String email,
//     required String password,
//     required UserRole role,
//   }) async {
//     try {
//       final endpoint = role == UserRole.patient
//           ? '/users/signin'
//           : '/users/signin';
//       final dynamic response = await apiService.post(endpoint, {
//         'email': email,
//         'password': password,
//       });
//       log(response.toString());

//       // Check if response is an error
//       if (response is ServerFailure) {
//         return Left(response);
//       }

//       // Check if 2FA is required
//       if (response['requiresOtp'] == true &&
//           response['challengeToken'] != null) {
//         // Save challengeToken for 2FA verification
//         await PrefHelper.saveChallengeToken(response['challengeToken']);
//         // Return special indicator for 2FA required
//         return Right('2FA_REQUIRED:${response['challengeToken']}');
//       }

//       // Extract tokens
//       final accessToken = response['accessToken'];
//       final refreshToken = response['refreshToken'];

//       // Save tokens
//       await PrefHelper.saveAccessToken(accessToken);
//       await PrefHelper.saveRefreshToken(refreshToken);

//       // Extract user data
//       final user = response['user'];
//       await PrefHelper.saveUserProfile(
//         firstName: user['firstName'],
//         lastName: user['lastName'],
//         email: user['email'],
//         profileImage: user['profilePicture'],
//       );

//       // Save user role
//       final userRole = user['type'] == 'doctor'
//           ? UserRole.doctor
//           : UserRole.patient;
//       await PrefHelper.saveUserRole(userRole);

//       // Save patient data if available
//       if (response['patient'] != null) {
//         await PrefHelper.savePatientData(response['patient']);
//       }

//       log(
//         'Access Token: $accessToken--------------------------------------------------------------------------',
//       );
//       return Right(accessToken);
//     } on DioException catch (e) {
//       final serverFailure = ServerFailure.fromDioError(e);
//       return Left(serverFailure);
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<ApiError, AuthTokensModel>> signInWithGoogle() async {
//     try {
//       await _googleSignIn.signOut();
//       final user = await _googleSignIn.signIn();

//       if (user == null) {
//         return Left(ServerFailure('Login cancelled'));
//       }

//       final auth = await user.authentication;
//       log(
//         'Google Sign In ID Token: ${auth.idToken}--------------------------------------------------------------------------',
//       );

//       if (auth.idToken == null) {
//         return Left(ServerFailure('idToken is null'));
//       }

//       final dynamic response = await apiService.post(
//         '/api/auth/google/mobile',
//         {'idToken': auth.idToken},
//       );

//       if (response is ServerFailure) {
//         return Left(response);
//       }

//       final token = AuthTokensModel.fromJson(response);
//       await PrefHelper.saveAccessToken(token.accessToken);
//       await PrefHelper.saveRefreshToken(token.refreshToken);
//       log(
//         'Google Sign In Token: ${token.accessToken}--------------------------------------------------------------------------',
//       );
//       return Right(token);
//     } on DioException catch (e) {
//       final serverFailure = ServerFailure.fromDioError(e);
//       return Left(serverFailure);
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<void> signOut() async {
//     try {
//       final token = await PrefHelper.getAccessToken();
//       log('Access Token for Logout: $token');
//       final headers = {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       };

//       final response = await apiService.post(
//         '/users/logout',
//         {},
//         headers: headers,
//       );

//       if (response is ServerFailure) {
//         throw response;
//       }

//       await PrefHelper.clearTokens();
//       await _googleSignIn.signOut();
//       await PrefHelper.markOnboardingAsNotCompleted();
//     } catch (e) {
//       log('Logout error: $e');
//       //rethrow;
//     }
//   }

//   @override
//   Future<Either<ApiError, String>> completeBasicProfile({
//     required String phone,
//     required int yearOfBirth,
//     required String gender,
//     String? profilePicture,
//   }) async {
//     try {
//       final token = await PrefHelper.getAccessToken();
//       final data = {
//         'phone': phone,
//         'yearOfBirth': yearOfBirth,
//         'gender': gender,
//         if (profilePicture != null) 'profilePicture': profilePicture,
//       };

//       final headers = {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       };

//       final dynamic response = await apiService.patch(
//         '/patients/complete/basic',
//         data,
//         headers: headers,
//       );

//       log('Complete Basic Profile Response: ${response.toString()}');

//       if (response is ServerFailure) {
//         return Left(response);
//       }

//       final message = response['message'] ?? 'Profile completed successfully';
//       return Right(message);
//     } on DioException catch (e) {
//       final serverFailure = ServerFailure.fromDioError(e);
//       return Left(serverFailure);
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }

//   @override // Future<Either<ApiError, RegisterResponse>> signUpWithEmailAndPassword({
//   //   required String email,
//   //   required String password,
//   //   required String firstName,
//   //   required String lastName,
//   //   required String confirmPassword,
//   //   required UserRole type,
//   // }) async {
//   //   try {
//   //     final data = {
//   //       'username': "$firstName $lastName",
//   //       'email': email,
//   //       'password': password,
//   //       'confirmPassword': confirmPassword,
//   //       // 'firstName': firstName,
//   //       // 'lastName': lastName,
//   //     };
//   //     final endpoint = type == UserRole.patient
//   //         ? 'register'
//   //         : '/api/auth/register/doctor';
//   //     final Response response = await apiService.post(endpoint, data);
//   //     log(response.toString());
//   //     final registerResponse = RegisterResponse.fromJson(response.data);
//   //     return Right(registerResponse);
//   //   } on DioException catch (e) {
//   //     final serverFailure = ServerFailure.fromDioError(e);
//   //     return Left(serverFailure);
//   //   } catch (e) {
//   //     return Left(ServerFailure(e.toString()));
//   //   }
//   // }
//   Future<Either<ApiError, RegisterResponse>> signUpWithEmailAndPassword({
//     required String email,
//     required String password,
//     required String firstName,
//     required String lastName,
//     required String confirmPassword,
//     required UserRole type,
//   }) async {
//     try {
//       final data = {
//         'type': type == UserRole.patient ? 'patient' : 'doctor',
//         'firstName': firstName,
//         'lastName': lastName,
//         'email': email,
//         'password': password,
//         'confirmPassword': confirmPassword,
//       };

//       final dynamic response = await apiService.post('/users/signup', data);

//       log(response.toString());

//       if (response is ServerFailure) {
//         return Left(response);
//       }

//       final registerResponse = RegisterResponse.fromJson(response);

//       // Save tokens
//       await PrefHelper.saveAccessToken(registerResponse.accessToken);
//       await PrefHelper.saveRefreshToken(registerResponse.refreshToken);

//       // Save user data
//       await PrefHelper.saveUserProfile(
//         firstName: registerResponse.user.firstName,
//         lastName: registerResponse.user.lastName,
//         email: registerResponse.user.email,
//         profileImage: registerResponse.user.profilePicture,
//       );

//       // Save user role
//       final role = registerResponse.user.type == 'doctor'
//           ? UserRole.doctor
//           : UserRole.patient;
//       await PrefHelper.saveUserRole(role);

//       // Save patient data
//       await PrefHelper.savePatientData(registerResponse.patient.toJson());

//       log(
//         'Access Token: ${registerResponse.accessToken}--------------------------------------------------------------------------',
//       );

//       return Right(registerResponse);
//     } on DioException catch (e) {
//       final serverFailure = ServerFailure.fromDioError(e);
//       return Left(serverFailure);
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<ApiError, VerifyOtpResponse>> verifyOtp({
//     required String email,
//     required String otp,
//   }) async {
//     try {
//       final data = {'email': email, 'otp': otp};
//       final dynamic response = await apiService.post(
//         '/users/forgetPassword/verify',
//         data,
//       );

//       if (response is ServerFailure) {
//         return Left(response);
//       }

//       final verifyOtpResponse = VerifyOtpResponse.fromJson(response);
//       log(response.toString());
//       return Right(verifyOtpResponse);
//     } on DioException catch (e) {
//       final serverFailure = ServerFailure.fromDioError(e);
//       return Left(serverFailure);
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<ApiError, String>> verify2FAOTP({
//     required String challengeToken,
//     required String otp,
//   }) async {
//     try {
//       final data = {'challengeToken': challengeToken, 'otp': otp};
//       final dynamic response = await apiService.post('/users/signin/otp', data);

//       log('2FA OTP Verify Response: ${response.toString()}');

//       if (response is ServerFailure) {
//         return Left(response);
//       }

//       // Extract tokens after successful 2FA verification
//       final accessToken = response['accessToken'];
//       final refreshToken = response['refreshToken'];

//       // Save tokens
//       await PrefHelper.saveAccessToken(accessToken);
//       await PrefHelper.saveRefreshToken(refreshToken);

//       // Extract user data
//       final user = response['user'];
//       await PrefHelper.saveUserProfile(
//         firstName: user['firstName'],
//         lastName: user['lastName'],
//         email: user['email'],
//         profileImage: user['profilePicture'],
//       );

//       // Save user role
//       final userRole = user['type'] == 'doctor'
//           ? UserRole.doctor
//           : UserRole.patient;
//       await PrefHelper.saveUserRole(userRole);

//       // Save patient data if available
//       if (response['patient'] != null) {
//         await PrefHelper.savePatientData(response['patient']);
//       }

//       // Clear challengeToken after successful verification
//       await PrefHelper.clearChallengeToken();

//       log('2FA Success - Access Token: $accessToken');
//       return Right(accessToken);
//     } on DioException catch (e) {
//       final serverFailure = ServerFailure.fromDioError(e);
//       return Left(serverFailure);
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<ApiError, String>> resetPassword({
//     required String resetToken,
//     required String newPassword,
//     required String confirmPassword,
//   }) async {
//     try {
//       final data = {
//         'resetToken': resetToken,
//         'newPassword': newPassword,
//         'confirmPassword': confirmPassword,
//       };
//       final dynamic response = await apiService.post(
//         '/users/resetPassword',
//         data,
//       );

//       if (response is ServerFailure) {
//         return Left(response);
//       }

//       final message = response['message'] ?? 'Password reset successfully rere';
//       log(response.toString());
//       return Right(message);
//     } on DioException catch (e) {
//       final serverFailure = ServerFailure.fromDioError(e);
//       return Left(serverFailure);
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<ApiError, String>> forgetPassword({
//     required String email,
//   }) async {
//     try {
//       final data = {'email': email};
//       final dynamic response = await apiService.post(
//         '/users/forgetPassword',
//         data,
//       );

//       if (response is ServerFailure) {
//         return Left(response);
//       }

//       final message =
//           response['message'] ?? 'Password reset link sent to your email';
//       log(response.toString());
//       return Right(message);
//     } on DioException catch (e) {
//       final serverFailure = ServerFailure.fromDioError(e);
//       return Left(serverFailure);
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<ApiError, String>> resendOtp({required String email}) async {
//     try {
//       final data = {'email': email};
//       final dynamic response = await apiService.post('/users/requestOTP', data);

//       if (response is ServerFailure) {
//         return Left(response);
//       }

//       final message = response['message'] ?? 'OTP sent successfully';
//       log(response.toString());
//       return Right(message);
//     } on DioException catch (e) {
//       final serverFailure = ServerFailure.fromDioError(e);
//       return Left(serverFailure);
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }
// }
