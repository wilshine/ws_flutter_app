import 'package:get/get.dart';

import '../ws_controllers/ws_login_controller.dart';

class WSLoginBinding extends Bindings {
  @override
  void dependencies() {
    // return [
      Get.lazyPut(() => WSLoginController());
    // ];
  }
}
