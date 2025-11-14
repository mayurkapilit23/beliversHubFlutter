import 'package:flutter/material.dart';

class ReelCard extends StatelessWidget {
  final String image;
  final String title;
  final String likes;
  final String comments;

  const ReelCard({
    super.key,
    required this.image,
    required this.title,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(fit: BoxFit.cover, image: AssetImage(image)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.6), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.favorite, size: 14, color: Colors.white),
                Text(" $likes   ", style: const TextStyle(color: Colors.white)),
                const Icon(Icons.comment, size: 14, color: Colors.white),
                Text(" $comments", style: const TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
