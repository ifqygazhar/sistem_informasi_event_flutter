import 'package:get/get.dart';
import 'package:sistem_informasi/pages/event/controller/event_controller.dart';

class EventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventManagementController>(() => EventManagementController());
  }
}
