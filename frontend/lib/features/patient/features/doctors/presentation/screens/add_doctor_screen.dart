import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/add_doctor_cubit.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/add_doctor_state.dart';
import 'package:medi/features/doctor/features/patients/presentation/screens/qr_scanner_screen.dart';
import 'package:medi/features/doctor/features/patients/presentation/screens/request_status_screen.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/info_box.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/option_card.dart';

enum _AddDoctorOption { byId, qr }

enum _AddDoctorFlowState { form, pending, connected }

class AddDoctorScreen extends StatelessWidget {
  const AddDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddDoctorCubit>(),
      child: const AddDoctorView(),
    );
  }
}

class AddDoctorView extends StatefulWidget {
  const AddDoctorView({super.key});

  @override
  State<AddDoctorView> createState() => _AddDoctorViewState();
}

class _AddDoctorViewState extends State<AddDoctorView> {
  final TextEditingController _doctorIdController = TextEditingController();
  final Set<_AddDoctorOption> _expandedOptions = <_AddDoctorOption>{};
  _AddDoctorFlowState _flowState = _AddDoctorFlowState.form;
  String _submittedDoctorId = '';

  @override
  void dispose() {
    _doctorIdController.dispose();
    super.dispose();
  }

  void _toggleOption(_AddDoctorOption option) {
    setState(() {
      if (_expandedOptions.contains(option)) {
        _expandedOptions.remove(option);
      } else {
        _expandedOptions.add(option);
      }
    });
  }

  void _sendRequest() {
    FocusScope.of(context).unfocus();
    final String doctorId = _doctorIdController.text.trim();
    if (doctorId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a doctor ID first')),
      );
      return;
    }

    setState(() {
      _submittedDoctorId = doctorId;
    });

    context.read<AddDoctorCubit>().sendAddRequest(doctorId);
  }

  void _cancelRequest() {
    if (_submittedDoctorId.isEmpty) {
      setState(() {
        _flowState = _AddDoctorFlowState.form;
      });
      return;
    }

    context.read<AddDoctorCubit>().cancelConnectionRequest(_submittedDoctorId);
  }

  void _onViewDoctors() {
    Navigator.of(context).pop();
  }

  void _openQrScanner() async {
    FocusScope.of(context).unfocus();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => QrScannerScreen()),
    );

    if (result != null && result is String) {
      setState(() {
        _submittedDoctorId = result;
      });

      context.read<AddDoctorCubit>().sendAddRequest(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddDoctorCubit, AddDoctorState>(
      listener: (context, state) {
        if (state.status == AddDoctorStatus.success) {
          setState(() {
            _flowState = state.lastAction == AddDoctorAction.cancelRequest
                ? _AddDoctorFlowState.form
                : _AddDoctorFlowState.pending;
            if (state.lastAction == AddDoctorAction.cancelRequest) {
              _submittedDoctorId = '';
            }
          });
          return;
        }

        if (state.status == AddDoctorStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Failed to send request'),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AddDoctorStatus.loading;

        if (_flowState == _AddDoctorFlowState.pending) {
          return RequestStatusScreen(
            isConnected: false,
            patientId: _submittedDoctorId,
            onPrimaryAction: _cancelRequest,
          );
        }

        if (_flowState == _AddDoctorFlowState.connected) {
          return RequestStatusScreen(
            isConnected: true,
            patientId: _submittedDoctorId,
            onPrimaryAction: _onViewDoctors,
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(title: 'Add New Doctor'),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.w16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Connect with a doctor to access their medical services',
                    style: AppStyles.secondary12400,
                  ),
                  SizedBox(height: AppSizes.h32),
                  OptionCard(
                    icon: Icons.search,
                    iconBackgroundColor: const Color(0xFFE3F2FD),
                    title: 'By Doctor ID',
                    description:
                        'Enter the doctor\'s unique ID to send an access request',
                    isExpanded: _expandedOptions.contains(_AddDoctorOption.byId),
                    onTap: () => _toggleOption(_AddDoctorOption.byId),
                    expandedChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: AppSizes.h16),
                        CustomTextField(
                          controller: _doctorIdController,
                          hintText: 'Enter Doctor ID (e.g., DR-12345)',
                          label: 'Doctor ID',
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
                    description: 'Scan the Doctor\'s QR code for instant access',
                    isExpanded: _expandedOptions.contains(_AddDoctorOption.qr),
                    onTap: () => _toggleOption(_AddDoctorOption.qr),
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
                    title: 'Doctor Approval Required',
                    description:
                        'All doctor connections require approval to ensure privacy and security. You\'ll receive access only after the doctor approves your request.',
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
