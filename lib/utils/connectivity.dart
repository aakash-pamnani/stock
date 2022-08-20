import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> checkInternetConnection() async {
  var result = await Connectivity().checkConnectivity();

  if (result == ConnectivityResult.none) {
    return false;
  } else {
    return true;
  }
}
