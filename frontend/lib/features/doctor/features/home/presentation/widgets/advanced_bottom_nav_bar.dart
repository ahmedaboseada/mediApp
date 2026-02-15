import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medi/core/constants/app_assets.dart';
import 'package:medi/features/doctor/features/home/presentation/cubit/cubit/home_nav_cubit_cubit.dart';

class AdvancedBottomNavBar extends StatelessWidget {
  const AdvancedBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTab = context.watch<HomeNavCubit>().state;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.85),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: HomeTab.values
                    .map((tab) => _NavItem(tab: tab, currentTab: currentTab))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final HomeTab tab;
  final HomeTab currentTab;

  const _NavItem({required this.tab, required this.currentTab});

  @override
  Widget build(BuildContext context) {
    final isSelected = tab == currentTab;

    final (icon, label) = switch (tab) {
      HomeTab.home => (AppAssets.home, "Home"),
      HomeTab.doctor => (AppAssets.docs, "Doctor"),
      HomeTab.chat => (AppAssets.chats, "Chat"),
      HomeTab.profile => (AppAssets.profile, "Profile"),
    };

    return GestureDetector(
      onTap: () => context.read<HomeNavCubit>().changeTab(tab),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2F80ED) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 300),
              scale: isSelected ? 1.1 : 1,
              child: SvgPicture.asset(
                icon,
                height: 22,
                colorFilter: isSelected
                    ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                    : null,
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: isSelected
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        label,
                        key: ValueKey(label),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
