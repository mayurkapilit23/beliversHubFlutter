import 'dart:async';
import 'package:believersHub/features/uploadVideo/model/upload_status.dart';

import '../services/upload_service.dart';

class UploadPoller {
  final String uploadId;
  final int userId;
  final Duration interval;

  UploadPoller({
    required this.uploadId,
    required this.userId,
    this.interval = const Duration(seconds: 2),
  });

  Stream<UploadStatusResponse> start() async* {
    while (true) {
      final status = await UploadService.getUploadStatus(uploadId);

      yield status;


      if (status.status == "done" || status.status == "failed") {
        break;
      }

      await Future.delayed(interval);
    }
  }
}
