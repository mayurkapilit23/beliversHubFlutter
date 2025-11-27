import 'dart:typed_data';

import 'package:believersHub/blocs/auth/auth_bloc.dart' show AuthBloc;
import 'package:believersHub/blocs/auth/auth_event.dart';
import 'package:believersHub/features/NewPostScreen/NewPostScreen.dart';
import 'package:believersHub/features/reels/Ui/reels_page.dart';
import 'package:flutter/material.dart';
import 'package:believersHub/core/theme/app_colors.dart';
import 'package:believersHub/core/widgets/post_card.dart';
import 'package:believersHub/core/widgets/reel_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../core/widgets/story_circle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // _preloadImages();
  }

  Future<void> _preloadImages() async {
    await precacheImage(const AssetImage("assets/images/profile.jpg"), context);
    // ignore: use_build_context_synchronously
    await precacheImage(
      const AssetImage("assets/images/destination.jpg"),
      context,
    );
  }

  Future<void> _pickMedia() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400]!,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.pink),
              title: Text('Choose from Gallery'),
              onTap: () => _selectFromGallery(context),
            ),
            ListTile(
              leading: Icon(Icons.video_library, color: Colors.purple),
              title: Text('Choose Video'),
              onTap: () => _selectVideo(context),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFromGallery(BuildContext context) async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    print('SELECTED FILE $file');
    if (file != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              NewPostScreen(filePath: file.path, isVideo: false),
        ),
      );
    }
  }

  Future<Uint8List?> getVideoThumbnail(String? path) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: path.toString(),
      imageFormat: ImageFormat.PNG,
      maxWidth: 400, // size of thumbnail
      quality: 75,
    );

    return uint8list;
  }

  Future<void> _selectVideo(BuildContext context) async {
    final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);
    if (file != null) {
      final thumb = await getVideoThumbnail(file.path);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              NewPostScreen(filePath: file.path, isVideo: true, thumb: thumb),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          if (index == 1) {
            _pickMedia();
          }if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (builder)=>ReelsPage()));
          }
        },
        backgroundColor: Colors.white,
        indicatorColor: Colors.indigoAccent.withOpacity(0.2),
        selectedIndex: 0,
        height: 65,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.home, color: Colors.indigoAccent),
            label: "",
          ),
          NavigationDestination(
            icon: Icon(Icons.add, color: Colors.grey),
            selectedIcon: Icon(Icons.add, color: Colors.grey),
            label: "",
          ),
          NavigationDestination(
            icon: Icon(Icons.play_circle_outline, color: Colors.grey),
            selectedIcon: Icon(Icons.play_circle, color: Colors.indigoAccent),
            label: "",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: Colors.grey),
            selectedIcon: Icon(Icons.person, color: Colors.indigoAccent),
            label: "",
          ),
        ],
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
          children: [
            // Title Row
            Row(
              children: [
                const Text(
                  "Reels",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  color: Colors.black,
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogoutRequested());
                  },
                  icon: const Icon(Icons.favorite_border),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.notifications_none, color: Colors.black),
                const SizedBox(width: 16),
              ],
            ),

            const SizedBox(height: 20),

            // Story Row
            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  StoryCircle(
                    image: "assets/images/profile.jpg",
                    name: "Add Yours",
                    isAdd: true,
                  ),
                  StoryCircle(
                    image: "assets/images/profile.jpg",
                    name: "Merico",
                  ),
                  StoryCircle(
                    image: "assets/images/profile.jpg",
                    name: "James",
                  ),
                  StoryCircle(
                    image: "assets/images/profile.jpg",
                    name: "Billie",
                  ),
                  StoryCircle(
                    image: "assets/images/profile.jpg",
                    name: "Wills",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Reels Horizontal Scroll
            SizedBox(
              height: 190,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  ReelCard(
                    image: "assets/images/destination.jpg",
                    title: "James",
                    likes: "7K",
                    comments: "123",
                  ),
                  ReelCard(
                    image: "assets/images/destination.jpg",
                    title: "merico",
                    likes: "9K",
                    comments: "123",
                  ),
                  ReelCard(
                    image: "assets/images/destination.jpg",
                    title: "Wills",
                    likes: "6K",
                    comments: "123",
                  ),
                ],
              ),
            ),

            // Post Card
            const PostCard(
              profilePic: "assets/images/profile.jpg",
              name: "James",
              time: "20 minutes ago",
              postImage: "assets/images/destination.jpg",
            ),

            const PostCard(
              profilePic: "assets/images/profile.jpg",
              name: "James",
              time: "20 minutes ago",
              postImage: "assets/images/destination.jpg",
            ),

            const PostCard(
              profilePic: "assets/images/profile.jpg",
              name: "James",
              time: "20 minutes ago",
              postImage: "assets/images/destination.jpg",
            ),
          ],
        ),
      ),
    );
  }
}
