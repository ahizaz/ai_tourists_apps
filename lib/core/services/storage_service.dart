import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  late GetStorage _box;

  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  void saveAccessToken(String token) {
    _box.write('access_token', token);
  }

  String? getAccessToken() {
    return _box.read('access_token');
  }

  void removeAccessToken() {
    _box.remove('access_token');
  }

  void clearAll() {
    _box.erase();
  }
}