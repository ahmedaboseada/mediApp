import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title = '',
    this.actionIcon,
    this.onpressed,
  });
  final String title;
  final IconData? actionIcon;
  final VoidCallback? onpressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Semantics(
        button: true,
        label: 'Back',
        child: Tooltip(
          message: 'Back',
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              context.pop();
            },
          ),
        ),
      ),
      title: Text(title),
      centerTitle: true,
      actions: [
        if (actionIcon != null)
          Semantics(
            button: true,
            label: 'More options',
            child: Tooltip(
              message: 'More options',
              child: IconButton(icon: Icon(actionIcon), onPressed: onpressed),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
