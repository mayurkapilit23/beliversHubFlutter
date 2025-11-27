import 'package:believersHub/services/SecureStorageService.dart';
import 'package:believersHub/user_interests_api.dart';

import 'modules/location/data/location_service.dart';

class PreLoads {
  static String location="";
  static List<String> interestsList=[];

  static Future<void> preLoadData() async {
    final user = await SecureStorageService.getUser();
    final interestsFuture = await UserInterestsApi().getUserInterests(user?['id']);
    interestsList = interestsFuture.keys.take(5).toList();
    final locationData = await LocationService.getCurrentLocation();
    location = locationData!.name;
  }
}
