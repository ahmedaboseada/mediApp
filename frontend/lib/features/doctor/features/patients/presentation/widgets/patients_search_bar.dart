// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';


// class PatientsSearchBar extends StatefulWidget {
//   const PatientsSearchBar({
//     super.key,
//     required this.onSearch,
//     required this.onClear,
//   });

//   final Function(String) onSearch;
//   final VoidCallback onClear;

//   @override
//   State<PatientsSearchBar> createState() => _PatientsSearchBarState();
// }

// class _PatientsSearchBarState extends State<PatientsSearchBar> {
//   late final TextEditingController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _handleClear() {
//     _controller.clear();
//     widget.onClear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF5F5F5),
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(
//           color: const Color(0xFFE8E8E8),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             Icons.search,
//             color: const Color(0xFF999999),
//             size: 20.sp,
//           ),
//           SizedBox(width: 8.w),
//           Expanded(
//             child: TextField(
//               controller: _controller,
//               onChanged: widget.onSearch,
//               decoration: InputDecoration(
//                 hintText: 'Search by name or ID',
//                 hintStyle: TextStyle(
//                   fontSize: 14.sp,
//                   color: const Color(0xFF999999),
//                   fontWeight: FontWeight.w400,
//                 ),
//                 border: InputBorder.none,
//                 isDense: true,
//                 contentPadding: EdgeInsets.zero,
//               ),
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: const Color(0xFF1A1A1A),
//               ),
//             ),
//           ),
//           if (_controller.text.isNotEmpty)
//             GestureDetector(
//               onTap: _handleClear,
//               child: Icon(
//                 Icons.clear,
//                 color: const Color(0xFF999999),
//                 size: 20.sp,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
