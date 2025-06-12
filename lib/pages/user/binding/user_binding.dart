import 'package:get/get.dart';
import 'package:sistem_informasi/pages/user/controller/user_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());
  }
}
