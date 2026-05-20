import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:medi/core/core.dart';

class DoctorHoverCard extends StatefulWidget {
  const DoctorHoverCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewsCount,
    required this.imageAsset,
    this.onTap,
  });

  final String name;
  final String specialty;
  final double rating;
  final int reviewsCount;
  final String imageAsset;
  final VoidCallback? onTap;

  @override
  State<DoctorHoverCard> createState() => _DoctorHoverCardState();
}

class _DoctorHoverCardState extends State<DoctorHoverCard> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (!mounted || _isPressed == value) {
      return;
    }
    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive = _isPressed;
    final Color cardColor = isActive
        ? AppColors.primary
        : AppColors.surfaceColor;
    final Color titleColor = isActive
        ? AppColors.whiteText
        : AppColors.primaryText;
    final Color subtitleColor = isActive
        ? AppColors.whiteText
        : AppColors.quaternaryText;
    final Color arrowBgColor = isActive
        ? AppColors.surfaceColor
        : Color(0xFFF3F5F9);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.r40),
        onTap: widget.onTap,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(AppSizes.w14),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(AppSizes.r40),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryText.withOpacity(
                  isActive ? 0.12 : 0.08,
                ),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: AppSizes.r20,
                    backgroundColor: AppColors.secondary,
                    backgroundImage:
                        (widget.imageAsset.isNotEmpty &&
                            widget.imageAsset.startsWith('http'))
                        ? CachedNetworkImageProvider(widget.imageAsset)
                        : AssetImage(
                                widget.imageAsset.isNotEmpty
                                    ? widget.imageAsset
                                    : AppAssets.avatar1,
                              )
                              as ImageProvider,
                  ),
                  SizedBox(width: AppSizes.w16),
                  Expanded(
                    child: Text(
                      widget.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.black14500.copyWith(color: titleColor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.h16),
              Text(
                widget.specialty,
                style: AppStyles.tertiary14500.copyWith(
                  fontSize: AppSizes.sp16,
                  color: subtitleColor,
                ),
              ),
              SizedBox(height: AppSizes.h20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: const Color(0xFFF4B400),
                              size: AppSizes.h18,
                            ),
                            SizedBox(width: AppSizes.w8),
                            Text(
                              widget.rating.toStringAsFixed(1),
                              style: AppStyles.black14500.copyWith(
                                color: titleColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.h8),
                        Text(
                          '${widget.reviewsCount} Reviews',
                          style: AppStyles.tertiary40012.copyWith(
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    height: AppSizes.h40,
                    width: AppSizes.w40,
                    decoration: BoxDecoration(
                      color: arrowBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_outward_rounded,
                      color: AppColors.secondaryText,
                      size: AppSizes.h16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
