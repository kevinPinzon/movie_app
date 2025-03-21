import 'dart:io';

/// Repositorio abstracto para validar la conexión a la red o Internet
abstract class NetworkInfoRepository {
  Future<bool> get hasConnection;
}

/// Implementación de la validación de conexión a Internet
class NetworkInfoRepositoryImpl extends NetworkInfoRepository {
  @override
  Future<bool> get hasConnection async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
