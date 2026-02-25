import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import '../controller/sound_cubit/sound_state.dart';
import 'sound_item.dart';

class SoundList extends StatelessWidget {
  final SoundLoaded state;

  const SoundList({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: AppSizes.h16),
      children: [
        /// DEFAULT + CUSTOM
        ...state.sounds.map((sound) => SoundItem(sound: sound, state: state)),

        // const SizedBox(height: 20),
      ],
    );
  }
}
