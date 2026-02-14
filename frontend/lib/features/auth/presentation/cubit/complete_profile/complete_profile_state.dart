class ProfileFormState {
  final String phone;
  final String gender;
  final bool isValid;

  const ProfileFormState({
    this.phone = '',
    this.gender = '',
    this.isValid = false,
  });

  ProfileFormState copyWith({String? phone, String? gender, bool? isValid}) {
    return ProfileFormState(
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      isValid: isValid ?? this.isValid,
    );
  }
}
