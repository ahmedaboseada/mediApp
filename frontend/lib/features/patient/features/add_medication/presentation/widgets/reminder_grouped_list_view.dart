import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class ReminderGroupedListView<T> extends StatelessWidget {
  const ReminderGroupedListView({
    super.key,
    required this.items,
    required this.titleBuilder,
    required this.timesBuilder,
    required this.onRemoveTime,
  });

  final List<T> items;
  final String Function(T item) titleBuilder;
  final List<String> Function(T item) timesBuilder;
  final void Function(int groupIndex, int timeIndex) onRemoveTime;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(items.length, (groupIndex) {
        final item = items[groupIndex];
        final times = timesBuilder(item);

        return Padding(
          padding: EdgeInsets.only(bottom: AppSizes.h12),
          child: Container(
            padding: EdgeInsets.all(AppSizes.w12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.r10),
              border: Border.all(color: AppColors.borderColor),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleBuilder(item),
                  style: AppStyles.black14500.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSizes.h8),
                ...List.generate(times.length, (timeIndex) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppSizes.h6),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: AppColors.primary,
                          size: AppSizes.w18,
                        ),
                        SizedBox(width: AppSizes.w8),
                        Expanded(
                          child: Text(
                            times[timeIndex],
                            style: AppStyles.black14500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => onRemoveTime(groupIndex, timeIndex),
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: AppSizes.w20,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      }),
    );
  }
}
