import 'dart:io';
import 'dart:typed_data';

import 'package:believersHub/modules/location/ui/SelectLocationScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewPostScreen extends StatelessWidget {
  final String filePath;
  final bool isVideo;
  final Uint8List? thumb;

  const NewPostScreen({
    super.key,
    required this.filePath,
    required this.isVideo,
    this.thumb,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:  SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Discard",
                    style: GoogleFonts.molengo(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D8BFF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Next",
                    style: GoogleFonts.molengo(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
          icon: Icon(Icons.arrow_back_ios, size: 18),
        ),
        title: Text(
          "New Post",
          style: GoogleFonts.padauk(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: ListView(
          children: [
            !isVideo
                ? Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(filePath), // replace
                        width: 220,
                        height: 280,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        thumb!,
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                    ),
                  ),

            const SizedBox(height: 20),

            /// Caption Input
            TextField(
              maxLines: 3,
              style: GoogleFonts.molengo(fontSize: 15),
              decoration: InputDecoration(
                hintText: "Add a caption...",
                hintStyle: GoogleFonts.molengo(
                  color: Colors.grey.shade500,
                  fontSize: 15,
                ),
                border: InputBorder.none,
              ),
            ),

            const SizedBox(height: 8),

            /// Card container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Add Tags
                  Text(
                    "Add tags",
                    style: GoogleFonts.molengo(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    maxLines: 3,
                    style: GoogleFonts.molengo(fontSize: 15),
                    decoration: InputDecoration(
                      hintText: "#trending",
                      hintStyle: GoogleFonts.molengo(
                        color: Colors.grey.shade500,
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.tag,
                      size: 20,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Select Thumbnail Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Thumbnail",
                        style: GoogleFonts.molengo(fontSize: 15),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 18),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// Thumbnail preview
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(thumb!, width: 60, fit: BoxFit.cover),
                  ),

                  const SizedBox(height: 20),

                  /// Location row
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectLocationScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Add location",
                          style: GoogleFonts.molengo(fontSize: 15),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 18),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Location chips
                  Wrap(
                    runSpacing: 8,
                    spacing: 8,
                    children: [
                      locationChip("Driven cafe"),
                      locationChip("Kapil Towers"),
                      locationChip("Hyderabad"),
                      locationChip("Search"),
                    ],
                  ),
                ],
              ),
            ),
            /// Bottom Buttons


            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  Widget locationChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade200,
      ),
      child: Text(text, style: GoogleFonts.molengo(fontSize: 13)),
    );
  }
}
