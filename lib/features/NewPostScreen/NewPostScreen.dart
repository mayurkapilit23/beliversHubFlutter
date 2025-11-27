// new_post_screen.dart
import 'dart:io';
import 'dart:typed_data';
import 'dart:developer';
import 'package:believersHub/features/uploadVideo/bloc/upload_video_bloc.dart' show FileUploadBloc;
import 'package:believersHub/features/uploadVideo/bloc/upload_video_events.dart';
import 'package:believersHub/features/uploadVideo/bloc/upload_video_states.dart';
import 'package:believersHub/features/uploadVideo/model/video_upload_request.dart';
import 'package:believersHub/features/uploadVideo/model/video_upload_response.dart';
import 'package:believersHub/modules/location/ui/SelectLocationScreen.dart';
import 'package:believersHub/features/uploadVideo/model/upload_status.dart';
import 'package:believersHub/services/SecureStorageService.dart';
import 'package:believersHub/utils/upload_poller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class NewPostScreen extends StatefulWidget {
  final String filePath;
  final bool isVideo;
  final Uint8List? thumb;

  const NewPostScreen({super.key, required this.filePath, required this.isVideo, this.thumb});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController captionText = TextEditingController();

  VideoUploadResponse? _videoUploadResponse;

  @override
  void initState() {
    super.initState();

    final videoRequest = VideoUploadRequest(
      contentType: "video/mp4",
      fileSize: File(widget.filePath).lengthSync(),
      filename: File(widget.filePath).path.split('/').last,
    );
    log("videoRequest: $videoRequest");

    // 1) Request upload session from backend
    context.read<FileUploadBloc>().add(CallVideoUploadRequest(videoRequest));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FileUploadBloc, FileUploadStates>(
      listener: (context, state) async {
        // react to lifecycle states and trigger next events (no setState)
        if (state is VideoUploadRequestSuccess) {
          _videoUploadResponse = state.videoUploadResponse;
          // Immediately upload to S3 (repository will emit progress events)
          context.read<FileUploadBloc>().add(
            CallVideoUploadToS3(state.videoUploadResponse.uploadUrl, File(widget.filePath)),
          );
        }

        // After S3 upload success we need to inform backend (complete)
        if (state is VideoUploadUploadingState) {
          // uploading UI handled by BlocBuilder
        }

        if (state is VideoUploadProcessingState) {
          // Start polling (if not already)
          if (_videoUploadResponse != null) {
            startPolling(_videoUploadResponse!.uploadId);
            // call complete endpoint so backend will start processing
            context.read<FileUploadBloc>().add(
              CallVideoUploadComplete(
                _videoUploadResponse!.uploadId,
                _videoUploadResponse!.fileKey,
              ),
            );
          }
        }

        if (state is VideoUploadDoneState) {
          // upload + processing done; UI will pick done state and enable Next
          // nothing to do here
        }

        // errors
        if (state is VideoUploadRequestFailed ||
            state is VideoUploadS3Failed ||
            state is VideoUploadCompleteFailed) {
          final msg = (state as dynamic).message ?? "Upload error";
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg.toString())));
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        // bottom bar uses BlocBuilder to enable/disable Next
        bottomNavigationBar: BlocBuilder<FileUploadBloc, FileUploadStates>(
          builder: (context, state) {
            final enabled = state is VideoUploadDoneState;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final shouldDiscard = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "Discard upload?",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: Text(
                                  "Are you sure you want to cancel this upload? This action cannot be undone.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: Text("Discard", style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              );
                            },
                          );

                          if (shouldDiscard != true) return;

                          // After confirm, do the actual discard logic
                          final state = context.read<FileUploadBloc>().state;

                          if (state is VideoUploadUploadingState ||
                              state is VideoUploadProgressState) {
                            // Cancel ongoing upload
                            context.read<FileUploadBloc>().add(CancelUploadEvent());
                            Navigator.pop(context);
                            return;
                          }

                          if (state is VideoUploadProcessingState ||
                              state is VideoUploadDoneState) {
                            context.read<FileUploadBloc>().add(
                              CallDiscardUpload(_videoUploadResponse!.uploadId),
                            );
                            Navigator.pop(context);
                            return;
                          }

                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Discard",
                            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: enabled
                            ? () {
                                
                              }
                            : null,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: enabled ? const Color(0xFF3D8BFF) : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Next",
                            style: GoogleFonts.inter(
                              color: Colors.white.withValues(alpha: enabled ? 1 : 0.6),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios, size: 18),
          ),
          title: Text(
            "New Post",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        body: Stack(
          children: [
            // Main content is driven by processing/done states via BlocBuilder
            BlocBuilder<FileUploadBloc, FileUploadStates>(
              builder: (context, state) {
                // ⭐ 1️⃣ UPLOADING TO S3 → show blocking screen
                if (state is VideoUploadUploadingState ||
                    state is VideoUploadProgressState) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 20),
                          const Text(
                            "Your video is uploading...\nThis will take few seconds",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // ⭐ 2️⃣ PROCESSING (AFTER S3 UPLOAD) → SHOW ACTUAL UI WITH SHIMMER
                if (state is VideoUploadProcessingState) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: buildPostEditor(isProcessing: true), // <-- IMPORTANT
                  );
                }

                // ⭐ 3️⃣ COMPLETED → show full UI normally
                if (state is VideoUploadDoneState) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: buildPostEditor(
                      isProcessing: false,
                      processedStatus: state.uploadStatusResponse,
                    ),
                  );
                }
                // ⭐ 4️⃣ INITIAL STATE → show local thumbnail version
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: buildPostEditor(isProcessing: false),
                );
              },
            ),


            // TOP-OVERLAY: upload progress + processing indicator (above AppBar)
            BlocBuilder<FileUploadBloc, FileUploadStates>(
              builder: (context, state) {
                if (state is VideoUploadProgressState) {
                  return Positioned(
                    top: MediaQuery.of(context).padding.top + 5,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text(
                          "Uploading video… ${(state.progress * 100).toStringAsFixed(0)}%",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: LinearProgressIndicator(value: state.progress, minHeight: 5),
                        ),
                      ],
                    ),
                  );
                }


                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
  Widget buildPostEditor({
    bool isProcessing = false,
    UploadStatusResponse? processedStatus,
  }) {

    // Resolve thumbnail logic:
    // 1) Shimmer during processing
    // 2) Worker thumbnail when processing done
    // 3) Fallback to local thumbnail
    Widget buildThumbnail() {
      if (isProcessing) {
        // ⭐ SHIMMER THUMBNAIL
        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 60,
              height: 60,
              color: Colors.grey.shade300,
            ),
          ),
        );
      }

      // ⭐ AFTER PROCESSING DONE → SHOW REAL THUMBNAIL
      // if (processedStatus != null &&
      //     processedStatus.media != null &&
      //     processedStatus.media!.thumbnails.isNotEmpty) {
      //   return ClipRRect(
      //     borderRadius: BorderRadius.circular(8),
      //     child: Image.network(
      //      "${ApiEndpoints.uploadUrl}/${processedStatus.media!.thumbnails.first.url}",
      //       width: 60,
      //       height: 60,
      //       fit: BoxFit.cover,
      //     ),
      //   );
      // }

      // ⭐ FALLBACK → local memory thumbnail
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          widget.thumb!,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      );
    }

    // ⭐ ABOVE - THE REST OF YOUR UI IS EXACT SAME (unchanged)
    return ListView(
      children: [
        isProcessing?  Column(
         children: [
           const Text(
             "Processing video…",
             textAlign: TextAlign.center,
             style: TextStyle(fontSize: 14),
           ),
           const Padding(
             padding: EdgeInsets.symmetric(horizontal: 12.0),
             child: LinearProgressIndicator(minHeight: 5),
           ),
         ],
       ):SizedBox.shrink(),

        // TOP THUMBNAIL / VIDEO PREVIEW (unchanged)
        !widget.isVideo
            ? Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(widget.filePath),
              width: 220,
              height: 280,
              fit: BoxFit.cover,
            ),
          ),
        )
            : Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:
                 Image.memory(
              widget.thumb!,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // CAPTION INPUT
        TextField(
          controller: captionText,
          maxLines: 3,
          style: GoogleFonts.inter(fontSize: 15),
          decoration: InputDecoration(
            hintText: "Add a caption...",
            hintStyle: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 15),
            border: InputBorder.none,
          ),
        ),

        const SizedBox(height: 8),

        // MAIN CARD
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ADD TAGS
              Text(
                "Add tags",
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                onChanged: (value) {
                  if (value.endsWith(",")) {
                    String existing = value;
                    existing = "$existing #";
                    controller.text = existing;
                  }
                },
                controller: controller,
                maxLines: 3,
                style: GoogleFonts.inter(fontSize: 15),
                decoration: InputDecoration(
                  hintText: "#trending",
                  hintStyle: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 15),
                  border: InputBorder.none,
                ),
              ),

              const SizedBox(height: 20),

              // SELECT THUMBNAIL ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Thumbnail", style: GoogleFonts.inter(fontSize: 15)),
                  // const Icon(Icons.arrow_forward_ios, size: 18),
                ],
              ),

              const SizedBox(height: 12),

              // ⭐ THUMBNAIL SLOT (shimmer or real)
              buildThumbnail(),

              const SizedBox(height: 20),

              // LOCATION
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SelectLocationScreen()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Add location", style: GoogleFonts.inter(fontSize: 15)),
                    const Icon(Icons.arrow_forward_ios, size: 18),
                  ],
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),

        const SizedBox(height: 18),
      ],
    );
  }

  void startPolling(String uploadId) async {
    final userId = await SecureStorageService.getUser();
    UploadPoller(uploadId: uploadId, userId: userId?['id']).start().listen((status) {
      if(!mounted)return;
      context.read<FileUploadBloc>().add(CallVideoUploadPollingEVent(status.status, status));
    });
  }
}
