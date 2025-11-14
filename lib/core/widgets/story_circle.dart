import 'package:flutter/material.dart';

class StoryCircle extends StatelessWidget {
  final String image;
  final String name;
  final bool isAdd;

  const StoryCircle({
    super.key,
    required this.image,
    required this.name,
    this.isAdd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(6),
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.indigoAccent, width: 2),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(image),
                ),
              ),
            ),
            if (isAdd)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.indigo,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, size: 15, color: Colors.white),
                ),
              ),
          ],
        ),
        Text(name, style: const TextStyle(color: Colors.black)),
      ],
    );
  }
}
