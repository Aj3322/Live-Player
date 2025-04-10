import 'package:flutter/material.dart';

import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../../../../core/constants/url.dart';

class VideoOverlay extends StatefulWidget {
  const VideoOverlay({super.key});

  @override
  State<VideoOverlay> createState() => _VideoOverlayState();
}

class _VideoOverlayState extends State<VideoOverlay> {
   // final controller = VlcPlayerController.network(
   // URL,
   //   hwAcc: HwAcc.full,
   //   options: VlcPlayerOptions(
   //     advanced: VlcAdvancedOptions([
   //       VlcAdvancedOptions.networkCaching(2000),
   //     ]),
   //     video: VlcVideoOptions([
   //       VlcVideoOptions.dropLateFrames(true),
   //       VlcVideoOptions.skipFrames(true),
   //     ]),
   //   ),
   // );
  @override
  Widget build(BuildContext context) {

    return Material(
      color: Colors.transparent,
      child: Container(
        height: 150,
        width: 200,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // VlcPlayer(
            //   controller: controller!,
            //   aspectRatio: 16 / 9,
            //   placeholder: const Center(child: CircularProgressIndicator()),
            // ),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => FlutterOverlayWindow.closeOverlay(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
