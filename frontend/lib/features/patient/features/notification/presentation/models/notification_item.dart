enum NotificationCategory { all, medication, health, doctor }

extension NotificationCategoryLabel on NotificationCategory {
  String get label {
    switch (this) {
      case NotificationCategory.all:
        return 'All';
      case NotificationCategory.medication:
        return 'Medication';
      case NotificationCategory.health:
        return 'Health';
      case NotificationCategory.doctor:
        return 'Doctor';
    }
  }
}

enum NotificationSection { today, yesterday }

extension NotificationSectionLabel on NotificationSection {
  String get label {
    switch (this) {
      case NotificationSection.today:
        return 'TODAY';
      case NotificationSection.yesterday:
        return 'YESTERDAY';
    }
  }
}

// enum NotificationSource { local, push }

// extension NotificationSourceLabel on NotificationSource {
//   String get label {
//     switch (this) {
//       case NotificationSource.local:
//         return 'Local';
//       case NotificationSource.push:
//         return 'Push';
//     }
//   }
// }

class NotificationInboxItem {
  const NotificationInboxItem({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    // required this.source,
    required this.createdAt,
    this.isRead = false,
    this.entityType,
    this.entityId,
    this.eventType,
    this.data = const <String, dynamic>{},
  });

  final String id;
  final String title;
  final String body;
  final NotificationCategory category;
//  final NotificationSource source;
  final DateTime createdAt;
  final bool isRead;
  final String? entityType;
  final String? entityId;
  final String? eventType;
  final Map<String, dynamic> data;

  bool matchesCategory(NotificationCategory selectedCategory) {
    return selectedCategory == NotificationCategory.all ||
        selectedCategory == category;
  }

  NotificationSection get section {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final createdDay = DateTime(createdAt.year, createdAt.month, createdAt.day);

    if (createdDay == today) {
      return NotificationSection.today;
    }

    if (createdDay == today.subtract(const Duration(days: 1))) {
      return NotificationSection.yesterday;
    }

    return createdAt.isAfter(today) ? NotificationSection.today : NotificationSection.yesterday;
  }

  String get timeLabel {
    final difference = DateTime.now().difference(createdAt);
    if (difference.inMinutes < 1) return 'Now';
    if (difference.inHours < 1) return '${difference.inMinutes}m';
    if (difference.inDays < 1) return '${difference.inHours}h';
    return '${difference.inDays}d';
  }

  NotificationInboxItem copyWith({
    String? id,
    String? title,
    String? body,
    NotificationCategory? category,
    // NotificationSource? source,
    DateTime? createdAt,
    bool? isRead,
    String? entityType,
    String? entityId,
    String? eventType,
    Map<String, dynamic>? data,
  }) {
    return NotificationInboxItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      category: category ?? this.category,
    //  source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      eventType: eventType ?? this.eventType,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'category': category.name,
      //'source': source.name,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      if (entityType != null) 'entityType': entityType,
      if (entityId != null) 'entityId': entityId,
      if (eventType != null) 'eventType': eventType,
      if (data.isNotEmpty) 'data': data,
    };
  }

  factory NotificationInboxItem.fromMap(Map<String, dynamic> json) {
    return NotificationInboxItem(
      id: (json['id'] ?? json['_id'] ?? DateTime.now().microsecondsSinceEpoch)
          .toString(),
      title: (json['title'] ?? json['notificationTitle'] ?? 'Notification')
          .toString(),
      body: (json['body'] ?? json['notificationBody'] ?? '').toString(),
      category: NotificationCategory.values.firstWhere(
        (category) => category.name == (json['category'] ?? '').toString(),
        orElse: () => NotificationCategory.medication,
      ),
      // source: NotificationSource.values.firstWhere(
      //   (source) => source.name == (json['source'] ?? '').toString(),
      //   orElse: () => NotificationSource.local,
      // ),
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ??
          DateTime.now(),
      isRead: json['isRead'] as bool? ?? false,
      entityType: json['entityType']?.toString(),
      entityId: json['entityId']?.toString(),
      eventType: json['eventType']?.toString(),
      data: (json['data'] as Map?)?.cast<String, dynamic>() ??
          const <String, dynamic>{},
    );
  }
}