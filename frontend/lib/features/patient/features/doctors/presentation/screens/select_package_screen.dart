import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/models/doctor_summary.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/booking_cubit.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/package_item.dart';

class SelectPackageScreen extends StatefulWidget {
  const SelectPackageScreen({super.key, required this.doctor});

  final Doctordata doctor;

  @override
  State<SelectPackageScreen> createState() => _SelectPackageScreenState();
}

class _SelectPackageScreenState extends State<SelectPackageScreen> {
  @override
  void initState() {
    super.initState();
    final Doctordata doctor = widget.doctor;

    context.read<BookingCubit>().setDoctor(doctor);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(title: 'Select Package'),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.w16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(' Select Duration', style: AppStyles.black18500),
                  // SizedBox(height: AppSizes.h16,),
                  CustomDropdown(
                    label: '',
                    hint: '15 minute',
                    items: AppStrings.consultationDurations,
                    onChanged: (value) {
                      context.read<BookingCubit>().updateDuration(value);
                    },
                  ),
                  SizedBox(height: AppSizes.h24),
                  Text('Select Package', style: AppStyles.black18500),
                  SizedBox(height: AppSizes.h14),
                  PackageItem(
                    icon: AppAssets.video,
                    packageTitle: 'Online appointment',
                    packsubTitle: 'Video call with doctor',
                    priceTitle: '\$60',
                    pricesubTitle: '/30 mins',
                    selected: state.selectedPackageIndex == 0,
                    onTap: () =>
                        context.read<BookingCubit>().updatePackageSelection(0),
                  ),
                  SizedBox(height: AppSizes.h12),
                  PackageItem(
                    icon: AppAssets.offline,
                    packageTitle: 'Offline appointment',
                    packsubTitle: 'In Person visit with doctor',
                    priceTitle: '\$100',
                    pricesubTitle: '/30 mins',
                    selected: state.selectedPackageIndex == 1,
                    onTap: () =>
                        context.read<BookingCubit>().updatePackageSelection(1),
                  ),
                  Spacer(),
                  PrimaryButton(
                    text: 'Next',
                    onPressed: () => context.push(
                      AppRouter.patientDetailsScreen,
                      extra: state.appointmentReviewData,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
