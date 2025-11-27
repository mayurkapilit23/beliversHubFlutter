import 'package:believersHub/helpers/watch_timer.dart';
import 'package:believersHub/modules/location/data/location_service.dart';
import 'package:believersHub/services/SecureStorageService.dart';
import 'package:believersHub/services/watch_time_service.dart';
import 'package:believersHub/user_interests_api.dart';
import 'package:believersHub/utils/user_interest_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/reels_bloc.dart';
import '../bloc/reels_event.dart';
import '../bloc/reels_state.dart';
import '../models/reel_model.dart';
import 'package:video_player/video_player.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  int currentIndex = 0;
  final watchTimer = WatchTimer();
  final watchService = WatchTimeService();

  String currentUserId = "11111111-1111-1111-1111-111111111111"; // replace from auth later

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  void preloadNext(int index, List<ReelModel> reels) {
    if (index + 1 < reels.length) {
      final nextReel = reels[index + 1];

      final controller = VideoPlayerController.network(nextReel.mediaUrl);
      controller.initialize().then((_) {
        print("🔥 Preloaded video: ${nextReel.id}");
        controller.dispose(); // dispose after preload to avoid memory leak
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ReelsBloc, ReelsState>(
        builder: (context, state) {
          if (state is ReelsInitial || state is ReelsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ReelsError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          if (state is ReelsLoaded) {
            return PageView.builder(
              scrollDirection: Axis.vertical,
              onPageChanged: (newIndex) async {
                final state = context.read<ReelsBloc>().state;

                if (state is ReelsLoaded) {
                  final seconds = watchTimer.stop();

                  if (seconds > 0 && currentIndex < state.reels.length) {
                    final prev = state.reels[currentIndex];
                    await watchService.sendWatchTime(
                      userId: currentUserId,
                      postId: prev.id,
                      seconds: seconds,
                    );
                  }

                  watchTimer.start();
                  currentIndex = newIndex;
                  preloadNext(newIndex, state.reels);
                }
              },
              itemCount: state.reels.length,
              itemBuilder: (_, index) => ReelPlayer(reel: state.reels[index]),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  @override
  void dispose() {
    final blocState = context.read<ReelsBloc>().state;

    if (blocState is ReelsLoaded) {
      final seconds = watchTimer.stop();
      if (seconds > 0) {
        final lastReel = blocState.reels[currentIndex];
        watchService.sendWatchTime(userId: currentUserId, postId: lastReel.id, seconds: seconds);
      }
    }

    super.dispose();
  }

  Future<void> loadInitialData() async {
    // 1️⃣ PARALLEL background fetch
    final futures = await Future.wait([
      _fetchUserInterests(),
      LocationService.getCurrentLocation().then((value) => value?.name),
    ]);

    final interests = futures[0] as Map<String, double>;
    final location = futures[1] as String;

    final interestList = interests.keys.take(5).toList();
    // 2️⃣ Load reels with personalized filters
    context.read<ReelsBloc>().add(LoadReelsEvent(interests: interestList, location: location));
  }

  Future<Map<String, double>> _fetchUserInterests() async {
    final user = await SecureStorageService.getUser();
    currentUserId = user?['id'];
    // If cached interests available → return immediately
    if (UserInterestCache.isFresh) {
      return UserInterestCache.interests!;
    }

    final data = await UserInterestsApi().getUserInterests(currentUserId);
    UserInterestCache.interests = data;
    UserInterestCache.lastUpdated = DateTime.now();
    return data;
  }
}

class ReelPlayer extends StatefulWidget {
  final ReelModel reel;

  const ReelPlayer({super.key, required this.reel});

  @override
  State<ReelPlayer> createState() => _ReelPlayerState();
}

class _ReelPlayerState extends State<ReelPlayer> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.network(widget.reel.mediaUrl)
      ..initialize().then((_) {
        setState(() {});
        controller.play();
        controller.setLooping(true);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        controller.value.isInitialized
            ? VideoPlayer(controller)
            : const Center(child: CircularProgressIndicator()),

        Positioned(
          left: 16,
          bottom: 60,
          right: 16,
          child: Text(
            widget.reel.caption,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
