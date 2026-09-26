import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebasePaths {
  FirebasePaths._();

  //Actual Db URL from firebase console
  static String get databaseUrl => dotenv.env['FIREBASE_DATABASE_URL'] ?? '';
  static const String users = 'users';
  static const String rides = 'rides';

  static String rideMembers(String rideId) => '$rides/$rideId/members';
}