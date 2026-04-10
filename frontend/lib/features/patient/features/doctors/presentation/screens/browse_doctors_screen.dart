import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/models/doctor_summary.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/doctor_hover_card.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/doctors_search_bar.dart';

class BrowseDoctorsScreen extends StatelessWidget {
  const BrowseDoctorsScreen({super.key});

  static final List<DoctorSummary> _doctors = [
    const DoctorSummary(
      id: 'dr_john_janson',
      name: 'Dr. John\nJanson',
      specialty: 'Endocrinologist',
      rating: 4.8,
      reviewsCount: 92,
      imageAsset: AppAssets.avatar2,
    ),
    const DoctorSummary(
      id: 'dr_danil_elgrov',
      name: 'Dr. Danil\nElgrov',
      specialty: 'General Physician',
      rating: 4.7,
      reviewsCount: 85,
      imageAsset: AppAssets.avatar1,
    ),
    const DoctorSummary(
      id: 'dr_marvin_kinney',
      name: 'Dr. Marvin\nKinney',
      specialty: 'Cardiologist',
      rating: 4.6,
      reviewsCount: 82,
      imageAsset: AppAssets.avatar1,
    ),
    const DoctorSummary(
      id: 'dr_david_helton',
      name: 'Dr. David\nHelton',
      specialty: 'Physician',
      rating: 4.6,
      reviewsCount: 70,
      imageAsset: AppAssets.avatar2,
    ),
    const DoctorSummary(
      id: 'dr_mariem_ali',
      name: 'Dr. Mariem\nAli',
      specialty: 'Arthropathic',
      rating: 4.5,
      reviewsCount: 40,
      imageAsset: AppAssets.avatar3,
    ),
    const DoctorSummary(
      id: 'dr_randa_john',
      name: 'Dr. Randa\nJohn',
      specialty: 'Physician',
      rating: 4.5,
      reviewsCount: 32,
      imageAsset: AppAssets.avatar1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w16,
            vertical: AppSizes.h12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              const DoctorsSearchBar(),
              SizedBox(height: AppSizes.h32),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.only(bottom: AppSizes.h12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSizes.w12,
                    mainAxisSpacing: AppSizes.h12,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: _doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = _doctors[index];
                    return DoctorHoverCard(
                      name: doctor.name,
                      specialty: doctor.specialty,
                      rating: doctor.rating,
                      reviewsCount: doctor.reviewsCount,
                      imageAsset: doctor.imageAsset,
                      onTap: () => context.push('/doctors/profile', extra: doctor),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
