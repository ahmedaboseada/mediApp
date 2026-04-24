import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/doctor/features/patients/presentation/cubit/add_patient_cubit.dart';
import 'package:medi/features/doctor/features/patients/presentation/cubit/add_patient_state.dart';
import 'package:medi/features/doctor/features/patients/presentation/screens/qr_scanner_screen.dart';
import 'package:medi/features/doctor/features/patients/presentation/screens/request_status_screen.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/info_box.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/option_card.dart';

enum _AddPatientOption { byId, qr }

enum _AddPatientFlowState { form, pending, connected }

class AddPatientScreen extends StatelessWidget {
  const AddPatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddPatientCubit>(),
      child: const AddPatientView(),
    );
  }
}

class AddPatientView extends StatefulWidget {
  const AddPatientView({super.key});

  @override
  State<AddPatientView> createState() => _AddPatientViewState();
}

class _AddPatientViewState extends State<AddPatientView> {
  final TextEditingController _patientIdController = TextEditingController();
  final Set<_AddPatientOption> _expandedOptions = <_AddPatientOption>{};
  _AddPatientFlowState _flowState = _AddPatientFlowState.form;
  String _submittedPatientId = '';

  @override
  void dispose() {
    _patientIdController.dispose();
    super.dispose();
  }

  void _toggleOption(_AddPatientOption option) {
    setState(() {
      if (_expandedOptions.contains(option)) {
        _expandedOptions.remove(option);
      } else {
        _expandedOptions.add(option);
      }
    });
  }

  void _sendRequest() {
    final String patientId = _patientIdController.text.trim();
    if (patientId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a patient ID first')),
      );
      return;
    }

    setState(() {
      _submittedPatientId = patientId;
    });

    context.read<AddPatientCubit>().sendAddRequest(patientId);
  }

  void _cancelRequest() {
    setState(() {
      _flowState = _AddPatientFlowState.form;
    });
  }

  void _onViewPatients() {
    Navigator.of(context).pop();
  }

  void _openQrScanner() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => QrScannerScreen()),
    );

    if (result != null && result is String) {
      setState(() {
        _submittedPatientId = result;
      });

      context.read<AddPatientCubit>().sendAddRequest(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_flowState == _AddPatientFlowState.pending) {
      return RequestStatusScreen(
        isConnected: false,
        patientId: _submittedPatientId,
        onBack: _cancelRequest,
        onPrimaryAction: _cancelRequest,
      );
    }

    if (_flowState == _AddPatientFlowState.connected) {
      return RequestStatusScreen(
        isConnected: true,
        patientId: _submittedPatientId,
        onBack: _cancelRequest,
        onPrimaryAction: _onViewPatients,
      );
    }

    return BlocConsumer<AddPatientCubit, AddPatientState>(
      listener: (context, state) {
        if (state.status == AddPatientStatus.success) {
          setState(() {
            _flowState = _AddPatientFlowState.pending;
          });
        } else if (state.status == AddPatientStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Failed to send request'),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AddPatientStatus.loading;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(title: 'Add New Patient'),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.w16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Connect with a patient to access their medical records',
                    style: AppStyles.secondary12400,
                  ),
                  SizedBox(height: AppSizes.h32),
                  OptionCard(
                    icon: Icons.search,
                    iconBackgroundColor: const Color(0xFFE3F2FD),
                    title: 'By Patient ID',
                    description:
                        'Enter the patient\'s unique ID to send an access request',
                    isExpanded: _expandedOptions.contains(
                      _AddPatientOption.byId,
                    ),
                    onTap: () => _toggleOption(_AddPatientOption.byId),
                    expandedChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: AppSizes.h16),
                        CustomTextField(
                          controller: _patientIdController,
                          hintText: 'Enter Patient ID (e.g., PT-12345)',
                          label: 'Patient ID',
                        ),
                        SizedBox(height: AppSizes.h16),
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : PrimaryButton(
                                onPressed: _sendRequest,
                                text: 'Send Request',
                              ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizes.h16),
                  OptionCard(
                    icon: Icons.qr_code,
                    iconBackgroundColor: const Color(0xFFE8F5E9),
                    title: 'Scan QR Code',
                    description:
                        'Scan the Patient\'s QR code for instant access',
                    isExpanded: _expandedOptions.contains(_AddPatientOption.qr),
                    onTap: () => _toggleOption(_AddPatientOption.qr),
                    expandedChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: AppSizes.h16),
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : PrimaryButton(
                                onPressed: _openQrScanner,
                                text: 'Open QR Scanner',
                              ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizes.h40),
                  InfoBox(
                    title: 'Patient Approval Required',
                    description:
                        'All patient connections require approval to ensure privacy and security. You\'ll receive access only after the patient approves your request.',
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
