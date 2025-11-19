import 'package:believersHub/modules/location/data/location_service.dart';
import 'package:believersHub/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_event.dart';
import '../bloc/location_state.dart';

class SelectLocationScreen extends StatelessWidget {
  SelectLocationScreen({super.key});

  final TextEditingController searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationBloc, LocationState>(
      listener: (context, state) {
        if (state.selectedPlace != null) {
          AppSnackbar.showSuccess(context, state.selectedPlace!.name);
          Navigator.pop(context, state.selectedPlace!);
        }
      },
      builder: (context, state) {
        return Scaffold(
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
              "Select location",
              style: GoogleFonts.molengo(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                /// Search Field
                TextField(
                  controller: searchCtrl,
                  style: GoogleFonts.molengo(fontSize: 16),
                  onChanged: (value) =>
                      context.read<LocationBloc>().add(SearchLocationEvent(value)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search",
                    hintStyle: GoogleFonts.molengo(
                      color: Colors.grey.shade500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                if (state.suggestions.isNotEmpty)
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: state.suggestions.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final s = state.suggestions[index];

                        return locationTile(
                          s.description,
                          () => context.read<LocationBloc>().add(
                            SelectSuggestionEvent(s.placeId),
                          ),
                        );
                      },
                    ),
                  )
                else ...[
                  /// Current Location
                  GestureDetector(
                    onTap: () async {
                      bool granted = await LocationService.askLocationPermission();
                      if (granted) {
                        context.read<LocationBloc>().add(
                          SelectCurrentLocationEvent(),
                        );
                      } else {
                        AppSnackbar.showError(
                          context,
                          "Location permission not granted",
                        );
                      }
                    },
                    child: locationTile("Current Location", null),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget locationTile(String title, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on_outlined, size: 22, color: Colors.black),
            const SizedBox(width: 12),
            Expanded(
              child: styledAddress(title),
            ),
          ],
        ),
      ),
    );
  }
}
Widget styledAddress(String address) {
  List<String> parts = address.split(',');

  // First 2 parts
  String firstLine = parts.length >= 2
      ? '${parts[0].trim()}, ${parts[1].trim()}'
      : address;

  // Remaining parts
  String secondLine = parts.length > 2
      ? parts.sublist(2).map((e) => e.trim()).join(', ')
      : '';

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        firstLine,
        style:  GoogleFonts.molengo(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      if (secondLine.isNotEmpty)
        Text(
          secondLine,
          style:  GoogleFonts.molengo(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
    ],
  );
}

