enum SyncActionType {
  add,
  update,
  delete,
  markAsTaken,
}

extension SyncActionTypeX on SyncActionType {
  String get storageValue => switch (this) {
        SyncActionType.add => 'add',
        SyncActionType.update => 'update',
        SyncActionType.delete => 'delete',
        SyncActionType.markAsTaken => 'mark_as_taken',
      };

  static SyncActionType fromAny(Object? value) {
    if (value is SyncActionType) return value;
    final normalized = value?.toString().trim().toLowerCase();
    return switch (normalized) {
      'add' => SyncActionType.add,
      'update' => SyncActionType.update,
      'delete' => SyncActionType.delete,
      'mark_as_taken' => SyncActionType.markAsTaken,
      'markastaken' => SyncActionType.markAsTaken,
      _ => SyncActionType.add,
    };
  }
}
