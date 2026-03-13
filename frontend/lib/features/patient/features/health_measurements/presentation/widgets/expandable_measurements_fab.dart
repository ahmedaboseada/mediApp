// import 'package:flutter/material.dart';
// import 'package:medi/core/core.dart';

// class FabActionItem {
//   const FabActionItem({required this.label, required this.icon, this.onTap});

//   final String label;
//   final IconData icon;
//   final VoidCallback? onTap;
// }

// class ExpandableMeasurementsFab extends StatelessWidget {
//   const ExpandableMeasurementsFab({
//     super.key,
//     required this.isOpen,
//     required this.onToggle,
//     required this.actions,
//   });

//   final bool isOpen;
//   final VoidCallback onToggle;
//   final List<FabActionItem> actions;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: <Widget>[
//         AnimatedSwitcher(
//           duration: const Duration(milliseconds: 320),
//           switchInCurve: Curves.easeOutBack,
//           switchOutCurve: Curves.easeIn,
//           transitionBuilder: (Widget child, Animation<double> animation) {
//             return FadeTransition(
//               opacity: animation,
//               child: ScaleTransition(scale: animation, child: child),
//             );
//           },
//           child: isOpen
//               ? Padding(
//                   key: const ValueKey<String>('openActions'),
//                   padding: EdgeInsets.only(bottom: AppSizes.h12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: List<Widget>.generate(actions.length, (
//                       int index,
//                     ) {
//                       final FabActionItem action = actions[index];
//                       return Padding(
//                         padding: EdgeInsets.only(bottom: AppSizes.h10),
//                         child: TweenAnimationBuilder<double>(
//                           tween: Tween<double>(
//                             begin: AppSizes.p0,
//                             end: AppSizes.p1,
//                           ),
//                           duration: Duration(milliseconds: 220 + (index * 70)),
//                           curve: Curves.easeOut,
//                           builder:
//                               (
//                                 BuildContext context,
//                                 double value,
//                                 Widget? child,
//                               ) {
//                                 return Opacity(
//                                   opacity: value,
//                                   child: Transform.scale(
//                                     scale: value,
//                                     child: child,
//                                   ),
//                                 );
//                               },
//                           child: _ActionChip(
//                             label: action.label,
//                             icon: action.icon,
//                             onTap: action.onTap,
//                           ),
//                         ),
//                       );
//                     }),
//                   ),
//                 )
//               : const SizedBox.shrink(key: ValueKey<String>('closedActions')),
//         ),
//         Material(
//           color: AppColors.primary,
//           borderRadius: BorderRadius.circular(AppSizes.r200),
//           child: InkWell(
//             borderRadius: BorderRadius.circular(AppSizes.r200),
//             onTap: onToggle,
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 260),
//               width: AppSizes.w56,
//               height: AppSizes.h56,
//               decoration: BoxDecoration(
//                 color: AppColors.primary,
//                 borderRadius: BorderRadius.circular(AppSizes.r200),
//               ),
//               child: Icon(
//                 isOpen ? Icons.close_rounded : Icons.add_rounded,
//                 color: AppColors.whiteText,
//                 size: AppSizes.sp24,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _ActionChip extends StatelessWidget {
//   const _ActionChip({
//     required this.label,
//     required this.icon,
//     required this.onTap,
//   });

//   final String label;
//   final IconData icon;
//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: AppColors.surfaceColor,
//       borderRadius: BorderRadius.circular(AppSizes.r200),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(AppSizes.r200),
//         onTap: onTap,
//         child: Container(
//           padding: EdgeInsets.symmetric(
//             horizontal: AppSizes.w12,
//             vertical: AppSizes.h10,
//           ),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(AppSizes.r200),
//             border: Border.all(
//               color: AppColors.borderColor,
//               width: AppSizes.p1,
//             ),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Icon(icon, size: AppSizes.sp16, color: AppColors.primary),
//               SizedBox(width: AppSizes.w8),
//               Text(
//                 label,
//                 style: TextStyle(
//                   color: AppColors.primaryText,
//                   fontSize: AppSizes.sp12,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
