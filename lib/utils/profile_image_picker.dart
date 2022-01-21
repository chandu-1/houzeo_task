import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePicker extends ConsumerWidget {
  final File? file;
  final Function(File) onSelect;
  final String? url;
  const ProfileImagePicker(
      {Key? key, this.file, this.url, required this.onSelect})
      : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () async {
            var _imageSource = await showModalBottomSheet<ImageSource>(
              context: context,
              builder: (context) => Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: InkWell(
                        onTap: () => Navigator.pop(context, ImageSource.camera),
                        child: const CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.add_a_photo),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: InkWell(
                        onTap: () =>
                            Navigator.pop(context, ImageSource.gallery),
                        child: const CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.image),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
            if (_imageSource == null) {
              return;
            }
            final _picker = ImagePicker();
            final pickedFile = await _picker.pickImage(source: _imageSource);
            if (pickedFile != null) {
              var cropped = await ImageCropper.cropImage(
                sourcePath: pickedFile.path,
                compressFormat: ImageCompressFormat.png,
                aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
                cropStyle: CropStyle.circle,
                androidUiSettings: const AndroidUiSettings(
                  toolbarTitle: 'Crop Image',
                  initAspectRatio: CropAspectRatioPreset.original,
                  lockAspectRatio: false,
                ),
              );
              if (cropped != null) {
                onSelect(cropped);
              }
            }
          },
          child: CircleAvatar(
            radius: 30,
            child: url == null && file == null
                ? const CircleAvatar(
                    child: Icon(Icons.add_a_photo),
                  )
                : null,
            backgroundImage: file != null
                ? FileImage(file!)
                : (url != null ? NetworkImage(url!) : null) as ImageProvider?,
          ),
        ),
      ),
    );
  }
}
