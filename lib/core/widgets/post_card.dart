import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String profilePic;
  final String name;
  final String time;
  final String postImage;

  const PostCard({
    super.key,
    required this.profilePic,
    required this.name,
    required this.time,
    required this.postImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              CircleAvatar(radius: 20, backgroundImage: AssetImage(profilePic)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  Text(
                    time,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.more_vert, color: Colors.black),
            ],
          ),

          const SizedBox(height: 12),

          // Post Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(postImage, fit: BoxFit.cover),
          ),

          const SizedBox(height: 12),

          // Stats
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.indigo),
              const SizedBox(width: 4),
              const Text("15.3K ", style: TextStyle(color: Colors.black)),
              const SizedBox(width: 20),
              const Icon(Icons.comment, color: Colors.black),
              const SizedBox(width: 4),
              const Text("300 ", style: TextStyle(color: Colors.black)),
              const SizedBox(width: 20),
              const Icon(Icons.share, color: Colors.black),
              const SizedBox(width: 4),
              const Text("120 ", style: TextStyle(color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }
}
