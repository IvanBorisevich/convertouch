import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:convertouch/di.dart' as di;

class NetworkHelper {
  static final NetworkHelper I = di.locator.get<NetworkHelper>();

  final Connectivity connectivity;

  const NetworkHelper(this.connectivity);

  Future<bool> isConnected() async {
    final ConnectivityResult status = await connectivity.checkConnectivity();
    return status != ConnectivityResult.none;
  }
}
