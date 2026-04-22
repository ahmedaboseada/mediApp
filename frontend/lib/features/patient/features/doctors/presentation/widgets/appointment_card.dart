import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/presentation/screens/my_bookings_screen.dart';

class AppointmentCard extends StatefulWidget {
  final AppointmentInfo appointment;
  final VoidCallback onSecondaryActionPressed;
  final VoidCallback onPrimaryActionPressed;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onSecondaryActionPressed,
    required this.onPrimaryActionPressed,
  });

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  late bool _remindMe;

  @override
  void initState() {
    super.initState();
    _remindMe = widget.appointment.remindMe;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppSizes.r40),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with date and remind toggle
          Padding(
            padding: EdgeInsets.all(AppSizes.w12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.appointment.dateTime,
                  style: AppStyles.black14500,
                ),
                if(widget.appointment.status == 'upcoming')...[
                  Row(
                    children: [
                      Text('Remind me', style: AppStyles.secondary12400.copyWith(fontSize: AppSizes.sp10)),
                      SizedBox(width: AppSizes.w8),
                      Switch(
                      value: _remindMe,
                      onChanged: (value) {
                        setState(() {
                          _remindMe = value;
                        });
                      },
                      activeThumbColor: AppColors.whiteText,
                      activeTrackColor: AppColors.primary,
                      inactiveThumbColor: AppColors.whiteText,
                      trackOutlineWidth: WidgetStateProperty.all(0),
                    ),
                  ],
                ),
                ],
              ],
            ),
        
          ),
        
          Divider(
            color: AppColors.disabledColor,
            height: 1,
            indent: AppSizes.w12,
            endIndent: AppSizes.w12,
          ),
          // Doctor info
          Padding(
            padding: EdgeInsets.all(AppSizes.w12),
            child: Row(
              children: [
                Container(
                  width: AppSizes.w90,
                  height: AppSizes.h90,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppSizes.r8),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person_outline,
                      size: AppSizes.w32,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.w12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.appointment.doctorName,
                        style: AppStyles.black14500,
                      ),
                      SizedBox(height: AppSizes.h4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: AppSizes.w16,
                            color: AppColors.secondaryText,
                          ),
                          SizedBox(width: AppSizes.w4),
                          Expanded(
                            child: Text(
                              widget.appointment.location,
                              style: AppStyles.secondary12400,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.h4),
                      Row(
                        children: [
                          Icon(
                            Icons.badge_outlined,
                            size: AppSizes.w16,
                            color: AppColors.secondaryText,
                          ),
                          SizedBox(width: AppSizes.w4),
                          RichText(
                            text: TextSpan(
                              style: AppStyles.secondary12400,
                              children: [
                                const TextSpan(text: 'Booking ID: '),
                                TextSpan(
                                  text: widget.appointment.bookingId,
                                  style: AppStyles.secondary12400.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: AppColors.disabledColor,
            height: 1,
            indent: AppSizes.w12,
            endIndent: AppSizes.w12,
          ),
          // Action buttons
          Padding(
            padding: EdgeInsets.all(AppSizes.w12),
            child: Row(
              children: [
                if(widget.appointment.status == 'upcoming'|| widget.appointment.status == 'completed')...[
                Expanded(
                  child: SecondryButton(
                    onPressed: widget.onSecondaryActionPressed,
                   
                    child: Text(widget.appointment.status == 'upcoming' ? 'Cancel' : 'Re-Book',
                      style: AppStyles.primary20700.copyWith(
                        fontSize: AppSizes.sp14,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.w10),
                ],
                
                Expanded(
                  child: PrimaryButton(
                    onPressed: widget.onPrimaryActionPressed,
                  
                    child: Text( (widget.appointment.status == 'upcoming') ? 'Reschedule' : 'Add Review',
                     
                      style: AppStyles.white14500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
