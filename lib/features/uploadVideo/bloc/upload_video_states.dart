// upload_video_states.dart
import 'package:believersHub/features/uploadVideo/model/upload_status.dart';
import 'package:believersHub/features/uploadVideo/model/video_upload_response.dart';
import 'package:equatable/equatable.dart';

abstract class FileUploadStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class VideoUploadInitState extends FileUploadStates {}

class VideoUploadLoadingState extends FileUploadStates {}

class VideoUploadRequestSuccess extends FileUploadStates {
  final VideoUploadResponse videoUploadResponse;
  VideoUploadRequestSuccess(this.videoUploadResponse);
  @override
  List<Object?> get props => [videoUploadResponse];
}

class VideoUploadRequestFailed extends FileUploadStates {
  final String message;
  VideoUploadRequestFailed(this.message);
  @override
  List<Object?> get props => [message];
}

class VideoUploadS3Success extends FileUploadStates {}

class VideoUploadS3Failed extends FileUploadStates {
  final String message;
  VideoUploadS3Failed(this.message);
  @override
  List<Object?> get props => [message];
}

class VideoUploadComplete extends FileUploadStates {}

class VideoUploadCompleteFailed extends FileUploadStates {
  final String message;
  VideoUploadCompleteFailed(this.message);
  @override
  List<Object?> get props => [message];
}

// processing states (legacy polling)
class FileProcessingLoading extends FileUploadStates {}

class FileProcessingSuccess extends FileUploadStates {
  final String status;
  final UploadStatusResponse uploadStatusResponse;
  FileProcessingSuccess(this.status, this.uploadStatusResponse);
  @override
  List<Object?> get props => [status, uploadStatusResponse];
}

// NEW states for progress + processing lifecycle
class VideoUploadProgressState extends FileUploadStates {
  final double progress; // 0 - 1
  VideoUploadProgressState(this.progress);
  @override
  List<Object?> get props => [progress];
}
class VideoUploadCancelledState extends FileUploadStates {}

class VideoUploadUploadingState extends FileUploadStates {}

class VideoUploadProcessingState extends FileUploadStates {}

class VideoUploadDoneState extends FileUploadStates {
  final UploadStatusResponse uploadStatusResponse;
  VideoUploadDoneState(this.uploadStatusResponse);
  @override
  List<Object?> get props => [uploadStatusResponse];
}
class DiscardUploadSuccess extends FileUploadStates {}
class DiscardUploadFailed extends FileUploadStates {
  final String message;
  DiscardUploadFailed(this.message);
}
