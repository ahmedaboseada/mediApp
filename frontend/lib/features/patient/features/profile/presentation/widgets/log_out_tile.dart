import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/shared/auth/presentation/cubit/log_out/log_out_cubit.dart';

class LogOutTile extends StatelessWidget {
  const LogOutTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: Text(
          'Logout',
          style: AppStyles.black16400.copyWith(color: Colors.red),
        ),

        onTap: () {
          context.read<LogOutCubit>().logOut();
        },
      ),
    );
  }
}
