import 'package:believersHub/features/uploadVideo/model/upload_status.dart';
import 'package:flutter/material.dart';
import '../../utils/upload_poller.dart';

class UploadProcessingScreen extends StatefulWidget {
  final String uploadId;
  final int userId;

  const UploadProcessingScreen({
    super.key,
    required this.uploadId,
    required this.userId,
  });

  @override
  State<UploadProcessingScreen> createState() => _UploadProcessingScreenState();
}

class _UploadProcessingScreenState extends State<UploadProcessingScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UploadStatusResponse>(
      stream: UploadPoller(
        uploadId: widget.uploadId,
        userId: widget.userId,
      ).start(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final status = snapshot.data!;

        if (status.status == "processing") {
          return const Scaffold(
            body: Center(
              child: Text(
                "Processing your reel...\nThis may take a few seconds.",
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (status.status == "done") {
          final thumbs = status.media!.thumbnails;

          return Scaffold(
            appBar: AppBar(title: Text("Select Thumbnail")),
            body: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: thumbs.length,
              itemBuilder: (context, index) {
                return Image.network(thumbs[index].url, fit: BoxFit.cover);
              },
            ),
          );
        }

        if (status.status == "failed") {
          return const Scaffold(
            body: Center(
              child: Text("Processing failed. Please try again."),
            ),
          );
        }

        return const Scaffold(
          body: Center(child: Text("Unknown status")),
        );
      },
    );
  }
}
