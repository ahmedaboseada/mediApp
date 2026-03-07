import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class LicenseUploadBox extends StatelessWidget {
  const LicenseUploadBox({
    super.key,
    required this.fileName,
    required this.fileSizeKb,
    required this.onTap,
    required this.onRemove,
  });

  final String? fileName;
  final int? fileSizeKb;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final hasFile = fileName != null && fileSizeKb != null;

    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.h20),
      decoration: BoxDecoration(
        color: AppColors.whiteText,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(color: const Color(0xFF7EB0FF), width: 1.4),
      ),
      child: hasFile
          ? Row(
              children: [
                Container(
                  height: AppSizes.h40,
                  width: AppSizes.w40,
                  decoration: BoxDecoration(
                    color: AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(AppSizes.r10),
                  ),
                  child: Icon(
                    Icons.description_outlined,
                    color: AppColors.primary,
                    size: AppSizes.h24,
                  ),
                ),
                SizedBox(width: AppSizes.w12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.black14600,
                      ),
                      SizedBox(height: AppSizes.h4),
                      Text(
                        '${fileSizeKb!} KB',
                        style: AppStyles.tertiary40012,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: onRemove,
                  child: Text(
                    'Remove',
                    style: AppStyles.black14500.copyWith(
                      color: const Color(0xFFFF6B6B),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Container(
                  height: AppSizes.h70,
                  width: AppSizes.h70,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEAF2FF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.file_upload_outlined,
                    color: AppColors.primary,
                    size: AppSizes.h34,
                  ),
                ),
                SizedBox(height: AppSizes.h14),
                Text(
                  'Click to upload',
                  style: AppStyles.black14600,
                ),
                SizedBox(height: AppSizes.h4),
                Text(
                  'JPG, or PNG (max 4MB)',
                  style: AppStyles.tertiary40012,
                ),
              ],
            ),
    );

    if (hasFile) {
      return content;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.r16),
      child: content,
    );
  }
}
