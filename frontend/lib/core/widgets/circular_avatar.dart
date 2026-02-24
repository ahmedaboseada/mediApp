import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medi/core/core.dart';

class CircularAvatar extends StatefulWidget {
  const CircularAvatar({
    super.key,
    this.selectedImagePath,
    this.networkImageUrl,
    this.size,
    this.onImagePicked,
    this.imageQuality,
  });

  final String? selectedImagePath;
  final String? networkImageUrl;
  final double? size;
  final ValueChanged<String>? onImagePicked;
  final int? imageQuality;

  @override
  State<CircularAvatar> createState() => _CircularAvatarState();
}

class _CircularAvatarState extends State<CircularAvatar> {
  String? _pickedImagePath;

  Future<void> _pickImage(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Take a photo'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) {
      return;
    }

    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: source,
      imageQuality: widget.imageQuality,
    );

    if (file == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _pickedImagePath = file.path;
    });

    widget.onImagePicked?.call(file.path);
  }

  @override
  Widget build(BuildContext context) {
    final avatarSize = widget.size ?? AppSizes.h120;
    final imagePath = widget.selectedImagePath ?? _pickedImagePath;

    return Stack(
      children: [
        Container(
          height: avatarSize,
          width: avatarSize,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: ClipOval(
            child: imagePath != null
                ? Image.file(File(imagePath), fit: BoxFit.cover)
                : (widget.networkImageUrl != null &&
                      widget.networkImageUrl!.isNotEmpty)
                ? Image.network(
                    widget.networkImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, err, builder) =>
                        const Icon(Icons.person),
                  )
                : Image.asset(AppAssets.avatar1, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => _pickImage(context),
            child: Container(
              height: AppSizes.h34,
              width: AppSizes.w34,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                height: AppSizes.h18,
                width: AppSizes.w18,
                AppAssets.lineEdit,
                fit: BoxFit.scaleDown,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
