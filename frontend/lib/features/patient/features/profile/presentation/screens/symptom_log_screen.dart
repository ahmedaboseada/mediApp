import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/health_measurements/data/repo/logs_repo.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/controller/health_measurements/health_measurements_cubit.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/controller/health_measurements/health_measurements_state.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/widgets/symptom_item.dart';

class SymptomLogScreen extends StatelessWidget {
  const SymptomLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Daily Symptoms'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.w16),
          child: BlocProvider(
            create: (context) =>
                HealthMeasurementsCubit(getIt<LogsRepo>())..loadSymptoms(),
            child:
                BlocBuilder<HealthMeasurementsCubit, HealthMeasurementsState>(
                  builder: (context, state) {
                    final symptoms = state.symptoms;
                    if (symptoms.isEmpty) {
                      return Center(child: Text('No symptoms logged yet.'));
                    }
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final symptom = symptoms[index];
                        return SymptomItem(data: symptom);
                      },
                      itemCount: symptoms.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    );
                  },
                ),
          ),
        ),
      ),
    );
  }
}

//HealthMeasurementsCubit.logSymptoms()
//SymptomItem
