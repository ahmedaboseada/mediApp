import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';

class UpcomingBooking extends StatelessWidget {
  const UpcomingBooking({super.key});

  static const List<_UpcomingBookingItem> _items = [
    _UpcomingBookingItem(
      doctorName: 'Dr. Marvin Kinney',
      avatarAsset: AppAssets.avatar1,
      ctaText: 'Start',
    ),
    _UpcomingBookingItem(
      doctorName: 'Dr. John Janson',
      avatarAsset: AppAssets.avatar2,
      scheduleText: 'Aug 25, 2026 - 10:00 AM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  style: AppStyles.black18500.copyWith(fontSize: AppSizes.sp20),
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
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              separatorBuilder: (_, _) => SizedBox(height: AppSizes.h10),
              itemBuilder: (context, index) {
                return _UpcomingBookingTile(item: _items[index]);
              },
            ),
          ],
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
            child: Image.asset(
              item.avatarAsset,
              width: AppSizes.w40,
              height: AppSizes.h40,
              fit: BoxFit.cover,
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
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.w14,
                vertical: AppSizes.h8,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSizes.r24),
              ),
              child: Text(item.ctaText!, style: AppStyles.white14500),
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
    required this.avatarAsset,
    this.ctaText,
    this.scheduleText,
  });

  final String doctorName;
  final String avatarAsset;
  final String? ctaText;
  final String? scheduleText;
}
