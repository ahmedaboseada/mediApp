import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/services/notification_inbox_service.dart';
import 'package:medi/features/patient/features/notification/presentation/models/notification_item.dart';
import 'package:medi/features/patient/features/notification/presentation/widgets/notification_header.dart';
import 'package:medi/features/patient/features/notification/presentation/widgets/notification_list_card.dart';

enum DoctorNotificationCategory { all, patients, appointments, system }

extension DoctorNotificationCategoryLabel on DoctorNotificationCategory {
  String get label {
    switch (this) {
      case DoctorNotificationCategory.all:
        return 'All';
      case DoctorNotificationCategory.patients:
        return 'Patients';
      case DoctorNotificationCategory.appointments:
        return 'Appointments';
      case DoctorNotificationCategory.system:
        return 'System';
    }
  }
}

class DoctorNotificationScreen extends StatefulWidget {
  const DoctorNotificationScreen({super.key});

  @override
  State<DoctorNotificationScreen> createState() => _DoctorNotificationScreenState();
}

class _DoctorNotificationScreenState extends State<DoctorNotificationScreen> {
  DoctorNotificationCategory _selectedCategory = DoctorNotificationCategory.all;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: NotificationInboxService.ensureReady(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.w16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSizes.h8),
                  ValueListenableBuilder<Box<dynamic>>(
                    valueListenable: HiveService.listenableSettingsBox(
                      keys: [HiveService.unreadNotificationsCountKey],
                    ),
                    builder: (context, box, child) {
                      final unreadCount =
                          box.get(HiveService.unreadNotificationsCountKey, defaultValue: 0)
                              as int;
                      return NotificationHeader(
                        unreadCount: unreadCount,
                        onBackPressed: () => Navigator.of(context).pop(),
                      );
                    },
                  ),
                  SizedBox(height: AppSizes.h20),
                  _DoctorNotificationCategoryBar(
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (category) {
                      setState(() => _selectedCategory = category);
                    },
                  ),
                  SizedBox(height: AppSizes.h12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        await NotificationInboxService.markAllAsRead();
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Marked as read')),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.tertiaryText,
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text('Mark all as read'),
                    ),
                  ),
                  SizedBox(height: AppSizes.h4),
                  Expanded(
                    child: ValueListenableBuilder<Box<dynamic>>(
                      valueListenable: HiveService.listenableNotificationInboxBox(
                        keys: [NotificationInboxService.notificationsKey],
                      ),
                      builder: (context, box, child) {
                        final raw = box.get(
                          NotificationInboxService.notificationsKey,
                          defaultValue: <dynamic>[],
                        );

                        final notifications = (raw is List ? raw : const <dynamic>[])
                            .whereType<Map>()
                            .map(
                              (entry) => NotificationInboxItem.fromMap(
                                Map<String, dynamic>.from(entry),
                              ),
                            )
                            .where((item) => _matchesCategory(item, _selectedCategory))
                            .toList(growable: false);

                        if (notifications.isEmpty) {
                          return const NotificationEmptyState();
                        }

                        final groupedToday = notifications
                            .where((item) => item.section == NotificationSection.today)
                            .toList(growable: false);
                        final groupedYesterday = notifications
                            .where((item) => item.section == NotificationSection.yesterday)
                            .toList(growable: false);

                        return ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            if (groupedToday.isNotEmpty) ...[
                              const NotificationSectionHeader(title: 'TODAY'),
                              SizedBox(height: AppSizes.h12),
                              ...groupedToday.map(
                                (item) => Padding(
                                  padding: EdgeInsets.only(bottom: AppSizes.h12),
                                  child: NotificationListCard(item: item),
                                ),
                              ),
                            ],
                            if (groupedYesterday.isNotEmpty) ...[
                              if (groupedToday.isNotEmpty) SizedBox(height: AppSizes.h8),
                              const NotificationSectionHeader(title: 'YESTERDAY'),
                              SizedBox(height: AppSizes.h12),
                              ...groupedYesterday.map(
                                (item) => Padding(
                                  padding: EdgeInsets.only(bottom: AppSizes.h12),
                                  child: NotificationListCard(item: item),
                                ),
                              ),
                            ],
                            SizedBox(height: AppSizes.h24),
                          ],
                        );
                      },
                    ),
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

bool _matchesCategory(
  NotificationInboxItem item,
  DoctorNotificationCategory category,
) {
  if (category == DoctorNotificationCategory.all) {
    return true;
  }

  final eventType = item.eventType?.toLowerCase() ?? '';
  final title = item.title.toLowerCase();
  final body = item.body.toLowerCase();
  final searchable = '$eventType $title $body';

  switch (category) {
    case DoctorNotificationCategory.patients:
      return searchable.contains('medication') ||
          searchable.contains('doctorrequest') ||
          searchable.contains('caregiverrequest') ||
          searchable.contains('patient');
    case DoctorNotificationCategory.appointments:
      return searchable.contains('appointment') ||
          searchable.contains('booking') ||
          searchable.contains('session') ||
          searchable.contains('schedule');
    case DoctorNotificationCategory.system:
      return searchable.contains('withdrawal') ||
          searchable.contains('system') ||
          searchable.contains('wallet') ||
          searchable.contains('payment');
    case DoctorNotificationCategory.all:
      return true;
  }
}

class _DoctorNotificationCategoryBar extends StatelessWidget {
  const _DoctorNotificationCategoryBar({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final DoctorNotificationCategory selectedCategory;
  final ValueChanged<DoctorNotificationCategory> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: DoctorNotificationCategory.values
            .map(
              (category) => Padding(
                padding: EdgeInsets.only(right: AppSizes.w8),
                child: _CategoryChip(
                  label: category.label,
                  selected: selectedCategory == category,
                  onTap: () => onCategorySelected(category),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : const Color(0xFFDCE6F5),
      borderRadius: BorderRadius.circular(AppSizes.r40),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.r40),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w14,
            vertical: AppSizes.h8,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.whiteText : AppColors.primaryText,
              fontSize: AppSizes.sp12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}