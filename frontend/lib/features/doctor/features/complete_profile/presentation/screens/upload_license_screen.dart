import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/complete_profile/data/repo/doctor_complete_profile_repo_impl.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/controller/license/upload_license_cubit.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/controller/license/upload_license_state.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/widgets/license_notice_card.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/widgets/license_upload_box.dart';

class UploadLicenseScreen extends StatelessWidget {
	const UploadLicenseScreen({super.key});

	@override
	Widget build(BuildContext context) {
		return BlocProvider(
			create: (_) => UploadLicenseCubit(
				DoctorCompleteProfileRepoImpl(ApiService()),
			),
			child: BlocConsumer<UploadLicenseCubit, UploadLicenseState>(
				listener: (context, state) {
					if (state.errorMessage != null) {
						ScaffoldMessenger.of(context).showSnackBar(
							SnackBar(content: Text(state.errorMessage!)),
						);
					}

					if (state.isSuccess) {
						context.go(AppRouter.allowNotificationScreen);
					}
				},
				builder: (context, state) {
					final hasFile = state.licenseFile != null;

					return Scaffold(
						appBar: AppBar(
							backgroundColor: AppColors.background,
							elevation: 0,
							leading: Padding(
								padding: EdgeInsets.all(AppSizes.h8),
								child: Material(
									color: AppColors.whiteText,
									shape: const CircleBorder(),
									child: InkWell(
										customBorder: const CircleBorder(),
										onTap: () => context.pop(),
										child: Icon(Icons.arrow_back_ios_new, size: AppSizes.h16),
									),
								),
							),
						),
						body: SafeArea(
							child: Padding(
								padding: EdgeInsets.symmetric(
									horizontal: AppSizes.w20,
									vertical: AppSizes.h18,
								),
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.stretch,
									children: [
										SizedBox(height: AppSizes.h24),
										Text(
											'Upload Your Medical License',
											textAlign: TextAlign.center,
											style: AppStyles.primary20700.copyWith(
												fontSize: AppSizes.sp22,
											),
										),
										SizedBox(height: AppSizes.h32),
										LicenseUploadBox(
											fileName: state.licenseFile?.name,
											fileSizeKb: state.fileSizeKb,
											onTap: () {
												context.read<UploadLicenseCubit>().pickLicenseFile();
											},
											onRemove: () {
												context.read<UploadLicenseCubit>().removeSelectedFile();
											},
										),
										SizedBox(height: AppSizes.h24),
										const LicenseNoticeCard(),
										const Spacer(),
										PrimaryButton(
											text: 'Submit for Verification',
											onPressed: hasFile && !state.isSubmitting
													? () {
														context.read<UploadLicenseCubit>().submitLicense();
													}
													: null,
											child: state.isSubmitting
													? const SizedBox(
														height: 20,
														width: 20,
														child: CircularProgressIndicator(
															strokeWidth: 2,
															color: Colors.white,
														),
													)
													: null,
										),
										SizedBox(height: AppSizes.h8),
									],
								),
							),
						),
					);
				},
			),
		);
	}
}
