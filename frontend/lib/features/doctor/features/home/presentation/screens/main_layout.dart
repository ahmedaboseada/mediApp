// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:medi/core/constants/app_assets.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int currentIndex = 0;

//   final List<Widget> screens = [
//     const Center(child: Text("Home Screen", style: TextStyle(fontSize: 24))),
//     const Center(child: Text("Doctor Screen", style: TextStyle(fontSize: 24))),
//     const Center(child: Text("Chat Screen", style: TextStyle(fontSize: 24))),
//     const Center(child: Text("Profile Screen", style: TextStyle(fontSize: 24))),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true, // عشان البار يبقى floating فوق المحتوى
//       body: screens[currentIndex],
//       bottomNavigationBar: AdvancedBottomNavBar(
//         currentIndex: currentIndex,
//         onTap: (i) {
//           setState(() => currentIndex = i);
//         },
//       ),
//     );
//   }
// }

// /// ================= Advanced Bottom Nav Bar =================
// class AdvancedBottomNavBar extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTap;

//   const AdvancedBottomNavBar({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(40),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(.85),
//                 borderRadius: BorderRadius.circular(40),

//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _item(AppAssets.home, "Home", 0),
//                   _item(AppAssets.docs, "Doctor", 1),
//                   _item(AppAssets.chats, "Chat", 2),
//                   _item(AppAssets.profile, "Profile", 3),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _item(String svg, String label, int index) {
//     final isSelected = currentIndex == index;

//     return GestureDetector(
//       onTap: () => onTap(index),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 350),
//         curve: Curves.easeOutCubic,
//         padding: EdgeInsets.symmetric(
//           horizontal: isSelected ? 16 : 10,
//           vertical: 8,
//         ),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFF2F80ED) : Colors.transparent,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Row(
//           children: [

//                 AnimatedScale(
//                   duration: const Duration(milliseconds: 300),
//                   scale: isSelected ? 1.1 : 1,
//                   child: SvgPicture.asset(
//                     svg,
//                     height: 22,
//                     colorFilter: isSelected ? ColorFilter.mode(
//                       Colors.white,
//                       BlendMode.srcIn,
//                     ):null,
//                   ),
//                 ),

//             AnimatedSwitcher(
//               duration: const Duration(milliseconds: 250),
//               child: isSelected
//                   ? Padding(
//                       padding: const EdgeInsets.only(left: 8),
//                       child: Text(
//                         label,
//                         key: ValueKey(label),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     )
//                   : const SizedBox.shrink(),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/doctor/features/home/presentation/cubit/cubit/home_nav_cubit_cubit.dart';
import 'package:medi/features/doctor/features/home/presentation/screens/chat_screen.dart';
import 'package:medi/features/doctor/features/home/presentation/screens/patient_screen.dart';
import 'package:medi/features/doctor/features/home/presentation/screens/profile_screen.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/advanced_bottom_nav_bar.dart';
import 'package:medi/features/doctor/features/home/presentation/screens/home_screen.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeNavCubit(),
      child: const _MainLayoutView(),
    );
  }
}

class _MainLayoutView extends StatelessWidget {
  const _MainLayoutView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: BlocBuilder<HomeNavCubit, HomeTab>(
        builder: (context, tab) {
          return switch (tab) {
            HomeTab.home => HomeScreen(),
            HomeTab.doctor => const PatientScreen(),
            HomeTab.chat => const ChatScreen(),
            HomeTab.profile => const ProfileScreen(),
          };
        },
      ),
      bottomNavigationBar: AdvancedBottomNavBar(),
    );
  }
}
