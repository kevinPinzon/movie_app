import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfoRepository {
  //This methos validate the internet connection
  Future<bool> get hasConnection;
}

class NetworkInfoRepositoryImpl extends NetworkInfoRepository {
  @override
  Future<bool> get hasConnection async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }
}
