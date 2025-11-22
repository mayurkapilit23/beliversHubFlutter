// upload_video_events.dart
import 'dart:io';

import 'package:believersHub/features/uploadVideo/model/upload_status.dart';
import 'package:believersHub/features/uploadVideo/model/video_upload_request.dart';
import 'package:equatable/equatable.dart';

abstract class FileUploadEvents extends Equatable {
  @override
  List<Object?> get props => [];
}
class CallDiscardUpload extends FileUploadEvents {
  final String uploadId;
  CallDiscardUpload(this.uploadId);
}

// 1) Request upload session from backend
class CallVideoUploadRequest extends FileUploadEvents {
  final VideoUploadRequest videoUploadRequest;
  CallVideoUploadRequest(this.videoUploadRequest);
  @override
  List<Object?> get props => [videoUploadRequest];
}

// 2) Upload to S3 using signed URL
class CallVideoUploadToS3 extends FileUploadEvents {
  final String signedUrl;
  final File file;
  CallVideoUploadToS3(this.signedUrl, this.file);
  @override
  List<Object?> get props => [signedUrl, file];
}

// 3) Mark upload complete (tell backend)
class CallVideoUploadComplete extends FileUploadEvents {
  final String uploadId;
  final String fileKey;
  CallVideoUploadComplete(this.uploadId, this.fileKey);
  @override
  List<Object?> get props => [uploadId, fileKey];
}

// 4) Polling event (from UploadPoller)
class CallVideoUploadPollingEVent extends FileUploadEvents {
  final String status;
  final UploadStatusResponse uploadStatusResponse;
  CallVideoUploadPollingEVent(this.status, this.uploadStatusResponse);
  @override
  List<Object?> get props => [status, uploadStatusResponse];
}

// Progress & lifecycle events (internal)
class UploadProgressEvent extends FileUploadEvents {
  final double progress; // 0.0 - 1.0
  UploadProgressEvent(this.progress);
  @override
  List<Object?> get props => [progress];
}

class UploadStartedEvent extends FileUploadEvents {
  @override
  List<Object?> get props => [];
}

class UploadCompletedEvent extends FileUploadEvents {
  @override
  List<Object?> get props => [];
}

class ProcessingStartedEvent extends FileUploadEvents {
  @override
  List<Object?> get props => [];
}
class CancelUploadEvent extends FileUploadEvents {}

class ProcessingCompletedEvent extends FileUploadEvents {
  final UploadStatusResponse uploadStatusResponse;
  ProcessingCompletedEvent(this.uploadStatusResponse);
  @override
  List<Object?> get props => [uploadStatusResponse];
}
