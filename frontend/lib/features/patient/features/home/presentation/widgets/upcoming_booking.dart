import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:medi/core/core.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:medi/features/patient/features/doctors/data/repo/doctors_repo.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/my_bookings_cubit.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/my_bookings_state.dart';

class UpcomingBooking extends StatelessWidget {
  const UpcomingBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MyBookingsCubit(doctorsRepository: getIt<DoctorsRepository>())
            ..fetchBookings(),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.w24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming Booking',
                    style: AppStyles.black18500.copyWith(
                      fontSize: AppSizes.sp20,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/doctors/my-bookings'),
                    child: Text(
                      'View booking',
                      style: AppStyles.primaryDark12400.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.h10),
              BlocBuilder<MyBookingsCubit, MyBookingsState>(
                builder: (context, state) {
                  if (state is MyBookingsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is MyBookingsSuccess) {
                    final upcoming = state.bookings
                        .where((b) => b.status.toLowerCase() == 'upcoming')
                        .toList();
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: upcoming.length,
                      separatorBuilder: (_, _) =>
                          SizedBox(height: AppSizes.h10),
                      itemBuilder: (context, index) {
                        final bookingData = upcoming[index].date.date;
                        final bookingTime = upcoming[index].date.time;
                        final timeParts = bookingTime.split(':');
                        final bookingDateTime = DateTime(
                          bookingData.year,
                          bookingData.month,
                          bookingData.day,
                          int.parse(timeParts[0]),
                          int.parse(timeParts[1]),
                        );
                        final now = DateTime.now();
                        final isNowOrStrated =
                            now.isAfter(
                              bookingDateTime.subtract(Duration(minutes: 5)),
                            ) ||
                            now.isAtSameMomentAs(bookingDateTime);
                        return _UpcomingBookingTile(
                          item: _UpcomingBookingItem(
                            doctorName:
                                "${upcoming[index].doctor.user.firstName} ${upcoming[index].doctor.user.lastName}",
                            doctorUserId: upcoming[index].doctor.user.id,
                            avatarAsset:
                                upcoming[index].doctor.user.profilePicture,

                            ctaText: isNowOrStrated ? 'start' : null,
                            scheduleText:
                                '${DateFormat('MMM d, yyyy').format(upcoming[index].date.date)} - ${upcoming[index].date.time}',
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UpcomingBookingTile extends StatelessWidget {
  const _UpcomingBookingTile({required this.item});

  final _UpcomingBookingItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w10,
        vertical: AppSizes.h8,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.r10),
            child: item.avatarAsset.isNotEmpty &&
                    item.avatarAsset.toLowerCase().startsWith('http')
                ? CachedNetworkImage(
                    imageUrl: item.avatarAsset,
                    width: AppSizes.w40,
                    height: AppSizes.h40,
                    fit: BoxFit.cover,
                    fadeInDuration: Duration.zero,
                    placeholder: (_, _) => Image.asset(
                      AppAssets.avatar1,
                      width: AppSizes.w40,
                      height: AppSizes.h40,
                      fit: BoxFit.cover,
                    ),
                    errorWidget: (_, _, _) => Image.asset(
                      AppAssets.avatar1,
                      width: AppSizes.w40,
                      height: AppSizes.h40,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    AppAssets.avatar1,
                    width: AppSizes.w40,
                    height: AppSizes.h40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
          ),
          SizedBox(width: AppSizes.w10),
          Expanded(
            child: Text(
              item.doctorName,
              style: AppStyles.black14500,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (item.ctaText != null)
            ZegoSendCallInvitationButton(
              text: item.ctaText!,
              textStyle: AppStyles.white14500,
              iconVisible: false,
              isVideoCall: true,
              buttonSize: const Size(60, 30),
              clickableBackgroundColor: AppColors.primary,
              resourceID: 'medi_call',
              invitees: [
                ZegoUIKitUser(
                  id: item.doctorUserId,
                  name: item.doctorName,
                )
              ],
            )
          else
            Text(item.scheduleText ?? '', style: AppStyles.secondary12400),
        ],
      ),
    );
  }
}

class _UpcomingBookingItem {
  const _UpcomingBookingItem({
    required this.doctorName,
    required this.doctorUserId,
    required this.avatarAsset,
    this.ctaText,
    this.scheduleText,
  });

  final String doctorName;
  final String doctorUserId;
  final String avatarAsset;
  final String? ctaText;
  final String? scheduleText;
}
