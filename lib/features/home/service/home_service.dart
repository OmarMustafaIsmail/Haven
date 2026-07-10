import '../models/home_data.dart';
import '../models/mock_home_data.dart';

class HomeService {
  const HomeService();

  Future<HomeData> getHomeData() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return MockHomeData.data;
  }

  /// Simulates the Pulse Check-In status response — may update pulse + amounts.
  Future<HomeData> checkInPulse() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    return MockHomeData.dataAfterCheckIn;
  }
}
