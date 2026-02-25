class QuestionnaireModel {
  List<String>? healthConditions;
  List<String>? longTermMeds;
  List<String>? allergies;
  bool? ongoingHealthConditions;
  bool? hasAllergies;
  bool? wantsAllergyAlerts;
  bool caregiverMode;

  QuestionnaireModel({
    this.healthConditions,
    this.longTermMeds,
    this.allergies,
    this.hasAllergies,
    this.wantsAllergyAlerts,
    this.ongoingHealthConditions,
    this.caregiverMode = false,
  });
}
