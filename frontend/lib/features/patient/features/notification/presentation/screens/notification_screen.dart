import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/services/notification_inbox_service.dart';
import 'package:medi/features/patient/features/notification/presentation/models/notification_item.dart';
import 'package:medi/features/patient/features/notification/presentation/widgets/notification_category_bar.dart';
import 'package:medi/features/patient/features/notification/presentation/widgets/notification_header.dart';
import 'package:medi/features/patient/features/notification/presentation/widgets/notification_list_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationCategory _selectedCategory = NotificationCategory.all;

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
                  NotificationCategoryBar(
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
                            .where((item) => item.matchesCategory(_selectedCategory))
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