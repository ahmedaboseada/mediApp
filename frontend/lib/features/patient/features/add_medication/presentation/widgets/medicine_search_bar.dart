import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medi/core/core.dart';

class MedicineSearchBar extends StatefulWidget {
  const MedicineSearchBar({
    super.key,
    this.hintText = AppStrings.searchMedications,
    this.leadingIcon = Icons.search,
    this.onSearchTap,
    this.onActionTap,
    this.onChanged,
    this.onClear,
    this.action,
    this.showAction = true,
    this.enableInput = false,
  });

  final String hintText;
  final IconData leadingIcon;
  final VoidCallback? onSearchTap;
  final VoidCallback? onActionTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final Widget? action;
  final bool showAction;
  final bool enableInput;

  @override
  State<MedicineSearchBar> createState() => _MedicineSearchBarState();
}

class _MedicineSearchBarState extends State<MedicineSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.enableInput ? null : widget.onSearchTap,
             // borderRadius: BorderRadius.circular(AppSizes.r28),
              child: Ink(
                height: AppSizes.h48,
                padding: EdgeInsets.symmetric(horizontal: AppSizes.w14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor,
                  borderRadius: BorderRadius.circular(AppSizes.r28),
                ),
                child: Row(
                  children: [
                    Icon(widget.leadingIcon, color: AppColors.secondaryText),
                    SizedBox(width: AppSizes.w8),
                    Expanded(
                      child: widget.enableInput
                          ? TextField(
                              controller: _controller,
                              onChanged: (value) {
                                widget.onChanged?.call(value);
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                hintText: widget.hintText,
                                hintStyle: AppStyles.secondary12400.copyWith(
                                  fontSize: AppSizes.sp24 * 0.68,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: AppStyles.secondary12400.copyWith(
                                fontSize: AppSizes.sp24 * 0.68,
                                color: AppColors.primaryText,
                              ),
                            )
                          : Text(
                              widget.hintText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.secondary12400.copyWith(
                                fontSize: AppSizes.sp24 * 0.68,
                              ),
                            ),
                    ),
                    if (widget.enableInput && _controller.text.isNotEmpty)
                      GestureDetector(
                        onTap: _clearSearch,
                        child: Icon(
                          Icons.clear,
                          color: AppColors.secondaryText,
                          size: AppSizes.w20,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (widget.showAction) ...[
          SizedBox(width: AppSizes.w12),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onActionTap,
              borderRadius: BorderRadius.circular(AppSizes.r24),
              child: Ink(
                width: AppSizes.w48,
                height: AppSizes.h48,
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor,
                  borderRadius: BorderRadius.circular(AppSizes.r24),
                ),
                child: Center(
                  child: widget.action ??
                      SvgPicture.asset(
                        AppAssets.medication,
                        width: AppSizes.w24,
                        height: AppSizes.h24,
                      ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
