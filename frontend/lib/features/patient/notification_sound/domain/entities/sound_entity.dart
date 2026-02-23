class SoundEntity {
  final String id;
  final String name;
  final String path;
  final bool isCustom;

  SoundEntity({
    required this.id,
    required this.name,
    required this.path,
    this.isCustom = false,
  });
}