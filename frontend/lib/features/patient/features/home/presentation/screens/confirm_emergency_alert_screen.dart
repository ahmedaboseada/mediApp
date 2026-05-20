import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/home/data/repo/sos_repo.dart';
import 'package:medi/features/patient/features/home/presentation/controller/sos/sos_cubit.dart';
import 'package:medi/features/patient/features/home/presentation/screens/alert_sent_screen.dart';

class ConfirmEmergencyAlertScreen extends StatefulWidget {
  final String contactName;
  final String contactMethod;

  const ConfirmEmergencyAlertScreen({
    super.key,
    required this.contactName,
    required this.contactMethod,
  });

  @override
  State<ConfirmEmergencyAlertScreen> createState() =>
      _ConfirmEmergencyAlertScreenState();
}

class _ConfirmEmergencyAlertScreenState
    extends State<ConfirmEmergencyAlertScreen> {
  //      Future<void> _sossucess(String name, String method) async {
  //   await showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (_) =>  AlertSentScreen(contactName: name, contactMethod: method,

  //       ),

  //   );
  // }

  Future<Position> _getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  Future<void> _sendSos(BuildContext ctx) async {
    try {
      final position = await _getCurrentLocation();
      if (!mounted) return;
      await ctx.read<SosCubit>().triggerSos(
        lat: position.latitude,
        lng: position.longitude,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SosCubit(getIt<SosRepo>()),
        child: SafeArea(
          child: BlocListener<SosCubit, SosState>(
            listener: (context, state) {
              if (state is SosTriggeredSuccess) {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => AlertSentScreen(
                    contactName: widget.contactName,
                    contactMethod: widget.contactMethod,
                  ),
                );
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(
                //     builder: (context) => AlertSentScreen(
                //       contactName: widget.contactName,
                //       contactMethod: widget.contactMethod,
                //     ),
                //   ),
                // );
              } else if (state is SosFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            child: Padding(
              padding: EdgeInsets.all(AppSizes.h24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      // Title
                      Text(
                        'Confirm Emergency Alert',
                        style: AppStyles.black24700,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSizes.h16),

                      // Description
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "We will send an emergency message with \nyour live location to ",
                              style: AppStyles.secondary12400,
                            ),
                            TextSpan(
                              text:
                                  '${widget.contactName} via ${widget.contactMethod.toUpperCase()}',
                              style: AppStyles.primaryDark12400,
                            ),
                            // TextSpan(
                            //   text: " via ",
                            //   style: AppStyles.secondary12400,
                            // ),
                            // TextSpan(
                            //   text: widget.contactMethod.toUpperCase(),
                            //   style: AppStyles.primary18700,
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSizes.h40),

                      // Illustration
                      SvgPicture.asset(AppAssets.sos),
                    ],
                  ),
                  // Buttons
                  Row(
                    children: [
                      BlocBuilder<SosCubit, SosState>(
                        builder: (context, state) {
                          final isLoading = state is SosLoading;
                          return Expanded(
                            child: PrimaryButton(
                              text: 'Send SOS',
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      _sendSos(context);
                                    },
                            ),
                          );
                        },
                      ),
                      SizedBox(width: AppSizes.w10),
                      Expanded(
                        child: SecondryButton(
                          text: 'Cancel',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
