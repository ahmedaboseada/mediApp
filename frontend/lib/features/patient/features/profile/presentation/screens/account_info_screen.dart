import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medi/core/core.dart';
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

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = HiveService.getUserProfile();

    setState(() {
      _nameController.text = userData['firstName'] ?? '';
      _lastNameController.text = userData['lastName'] ?? '';
      _emailController.text = userData['email'] ?? '';
      _phoneController.text = userData['phone'] ?? '';
      _countryController.text = userData['country'] ?? 'Egypt';
      _dobController.text = userData['dateOfBirth'] ?? '';
      _genderController.text = userData['gender'] ?? '';
    });
  }

  Future<void> _saveUserData() async {
    await HiveService.saveUserProfile(
      firstName: _nameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      country: _countryController.text,
      dateOfBirth: _dobController.text,
      gender: _genderController.text,
    );
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
    return Scaffold(
      appBar: CustomAppBar(),

      body: BlocProvider(
        create: (context) => EditCubit(),
        child: BlocBuilder<EditCubit, EditState>(
          builder: (context, state) {
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Account Information',
                                  style: AppStyles.black14500.copyWith(
                                    fontSize: AppSizes.sp18,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                if (!state.isEditing) ...[
                                  IconButton(
                                    onPressed: () =>
                                        context.read<EditCubit>().toggleEdit(),
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
                                    autofillHints: const [AutofillHints.name],
                                    hintText: AppStrings.firstNameHint,
                                    controller: _nameController,
                                    validator: (value) =>
                                        value.validateFirstName(),
                                    label: AppStrings.firstNameHint,
                                    readOnly: !state.isEditing,
                                  ),
                                ),
                                SizedBox(width: AppSizes.w16),
                                Expanded(
                                  child: CustomTextField(
                                    autofillHints: const [AutofillHints.name],
                                    hintText: AppStrings.lastNameHint,
                                    controller: _lastNameController,
                                    validator: (value) =>
                                        value.validateLastName(),
                                    label: AppStrings.lastNameHint,
                                    readOnly: !state.isEditing,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: AppSizes.h24),
                            PhoneField(
                              phonecontroller: _phoneController,
                              enabled: state.isEditing,
                            ),

                            SizedBox(height: AppSizes.h24),
                            CustomTextField(
                              hintText: 'Egypt',
                              label: 'Country',
                              controller: _countryController,
                              readOnly: !state.isEditing,
                            ),
                            SizedBox(height: AppSizes.h24),
                            DatePickerField(
                              dateController: _dobController,
                              onDateSelected: (date) {
                                _dobController.text = date.toString();
                              },
                            ),
                            SizedBox(height: AppSizes.h24),
                            GenderField(
                              value: _genderController.text,
                              isEditing: state.isEditing,
                            ),
                            SizedBox(height: AppSizes.h24),
                            if (state.isEditing) ...[
                              PrimaryButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await _saveUserData();
                                    if (mounted) {
                                      context.read<EditCubit>().toggleEdit();
                                    }
                                  }
                                },
                                text: 'Save ',
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
        ),
      ),
    );
  }
}
