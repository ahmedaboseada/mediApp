import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/models/doctor_summary.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/package_item.dart';

class SelectPackageScreen extends StatefulWidget {
  const SelectPackageScreen({super.key, required this.doctor});

  final DoctorSummary? doctor;

  @override
  State<SelectPackageScreen> createState() => _SelectPackageScreenState();
}

class _SelectPackageScreenState extends State<SelectPackageScreen> {
  int _selectedPackageIndex = 0;

  @override
  Widget build(BuildContext context) {
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
                onChanged: (value) {},
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
                selected: _selectedPackageIndex == 0,
                onTap: () => setState(() => _selectedPackageIndex = 0),
              ),
              SizedBox(height: AppSizes.h12),
              PackageItem(
                icon: AppAssets.offline,
                packageTitle: 'Offline appointment',
                packsubTitle: 'In Person visit with doctor',
                priceTitle: '\$100',
                pricesubTitle: '/30 mins',
                selected: _selectedPackageIndex == 1,
                onTap: () => setState(() => _selectedPackageIndex = 1),
              ),
              Spacer(),
              PrimaryButton(
                text: 'Next',
                onPressed: () => context.push(AppRouter.patientDetailsScreen),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
