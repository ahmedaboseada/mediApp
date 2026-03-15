import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/shared/auth/data/models/user_model.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo_impl.dart';
import 'package:medi/features/shared/auth/presentation/cubit/user_profile/user_profile_cubit.dart';
import 'package:medi/features/shared/auth/presentation/cubit/user_profile/user_profile_state.dart';
import 'package:medi/features/patient/features/profile/presentation/controller/edit/edit_cubit.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _populateLocalUserData();
  }

  void _populateLocalUserData() {
    final profileData = HiveService.getUserProfile();
    final user = HiveService.getUserData();
    if (user != null) {
      _populateFields(user);
    }

    if ((profileData['country'] ?? '').isNotEmpty) {
      _countryController.text = profileData['country']!;
    } else if (_countryController.text.isEmpty) {
      _countryController.text = 'Egypt';
    }
  }

  Future<void> _saveUserDataLocally() async {
    await HiveService.saveUserProfile(
      firstName: _nameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      country: _countryController.text.trim(),
      dateOfBirth: _dobController.text.trim(),
      gender: _genderController.text.trim(),
    );
  }

  void _populateFields(UserModel user) {
    _nameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _emailController.text = user.email;
    _phoneController.text = user.phone ?? '';
    _dobController.text = _formatDob(user.dob);
    _genderController.text = user.gender ?? '';

    if (_countryController.text.isEmpty) {
      _countryController.text = 'Egypt';
    }
  }

  String _formatDob(String? dob) {
    if (dob == null) {
      return '';
    }

    final trimmedDob = dob.trim();
    if (trimmedDob.isEmpty) {
      return '';
    }

    if (RegExp(r'^\d{4}$').hasMatch(trimmedDob)) {
      return trimmedDob;
    }

    final parsedDate = DateTime.tryParse(trimmedDob);
    if (parsedDate != null) {
      return parsedDate.year.toString();
    }

    return trimmedDob;
  }

  Future<void> _saveProfile(UserProfileCubit userProfileCubit) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await userProfileCubit.updateProfile(
        firstName: _nameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        gender: _genderController.text.trim().isEmpty
            ? null
            : _genderController.text.trim(),
        dob: _dobController.text.trim().isEmpty
            ? null
            : _dobController.text.trim(),
      );
    } catch (_) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => EditCubit()),
        BlocProvider(
          create: (_) => UserProfileCubit(getIt<AuthRepoImpl>())..getMe(),
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(),
        body: BlocListener<UserProfileCubit, UserProfileState>(
          listener: (context, state) async {
            if (state is UserProfileLoaded) {
              _populateFields(state.profile.user);
            } else if (state is UserProfileUpdated) {
              if (mounted) {
                setState(() {
                  _isSubmitting = false;
                });
              }

              _populateFields(state.profile.user);
              await _saveUserDataLocally();

              if (!mounted) {
                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );

              final isEditing = context.read<EditCubit>().state.isEditing;
              if (context.canPop()) {
                context.pop();
              } else if (isEditing) {
                context.read<EditCubit>().toggleEdit();
              }
            } else if (state is UserProfileError) {
              if (mounted) {
                setState(() {
                  _isSubmitting = false;
                });
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<EditCubit, EditState>(
            builder: (context, editState) {
              return BlocBuilder<UserProfileCubit, UserProfileState>(
                builder: (context, profileState) {
                  final isSaving =
                      _isSubmitting && profileState is UserProfileLoading;

                  return SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(AppSizes.w16),
                        child: Card(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.w16,
                              vertical: AppSizes.h16,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Account Information',
                                        style: AppStyles.black14500.copyWith(
                                          fontSize: AppSizes.sp18,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      if (!editState.isEditing) ...[
                                        IconButton(
                                          onPressed: () => context
                                              .read<EditCubit>()
                                              .toggleEdit(),
                                          icon: SvgPicture.asset(
                                            AppAssets.tablerEdit,
                                            colorFilter: const ColorFilter.mode(
                                              Colors.black,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: AppSizes.h24),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomTextField(
                                          autofillHints: const [
                                            AutofillHints.name,
                                          ],
                                          hintText: AppStrings.firstNameHint,
                                          controller: _nameController,
                                          validator: (value) =>
                                              value.validateFirstName(),
                                          label: AppStrings.firstNameHint,
                                          readOnly: !editState.isEditing,
                                        ),
                                      ),
                                      SizedBox(width: AppSizes.w16),
                                      Expanded(
                                        child: CustomTextField(
                                          autofillHints: const [
                                            AutofillHints.name,
                                          ],
                                          hintText: AppStrings.lastNameHint,
                                          controller: _lastNameController,
                                          validator: (value) =>
                                              value.validateLastName(),
                                          label: AppStrings.lastNameHint,
                                          readOnly: !editState.isEditing,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: AppSizes.h24),
                                  PhoneField(
                                    phonecontroller: _phoneController,
                                    enabled: editState.isEditing,
                                  ),
                                  SizedBox(height: AppSizes.h24),
                                  CustomTextField(
                                    hintText: 'Egypt',
                                    label: 'Country',
                                    controller: _countryController,
                                    readOnly: !editState.isEditing,
                                  ),
                                  SizedBox(height: AppSizes.h24),
                                  DatePickerField(
                                    dateController: _dobController,
                                    enabled: editState.isEditing,
                                    onDateSelected: (date) {
                                      _dobController.text = date.year
                                          .toString();
                                    },
                                  ),
                                  SizedBox(height: AppSizes.h24),
                                  GenderField(
                                    value: _genderController.text,
                                    isEditing: editState.isEditing,
                                    onGenderChanged: (gender) {
                                      setState(() {
                                        _genderController.text = gender;
                                      });
                                    },
                                  ),
                                  SizedBox(height: AppSizes.h24),
                                  if (editState.isEditing) ...[
                                    PrimaryButton(
                                      onPressed: isSaving
                                          ? null
                                          : () => _saveProfile(
                                              context.read<UserProfileCubit>(),
                                            ),
                                      text: 'Save',
                                      child: isSaving
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : null,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
