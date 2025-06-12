import 'package:get/route_manager.dart';
import 'package:sistem_informasi/pages/auth/binding/auth_binding.dart';
import 'package:sistem_informasi/pages/auth/login.dart';
import 'package:sistem_informasi/pages/auth/register.dart';
import 'package:sistem_informasi/pages/event/binding/event_binding.dart';
import 'package:sistem_informasi/pages/event/event_created_and_edit.dart';
import 'package:sistem_informasi/pages/event/event_detail.dart';
import 'package:sistem_informasi/pages/event/event_management.dart';
import 'package:sistem_informasi/pages/home/binding/home_binding.dart';
import 'package:sistem_informasi/pages/home/home.dart';
import 'package:sistem_informasi/pages/splash/splash.dart';
import 'package:sistem_informasi/pages/user/binding/user_binding.dart';
import 'package:sistem_informasi/pages/user/user_management.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String eventDetail = '/event/:id';
  static const String eventManagement = '/event-management';
  static const String createEvent = '/create-event';
  static const String editEvent = '/edit-event';
  static const String userManagement = '/user-management';

  static final routes = [
    GetPage(
      name: splash,
      page: () => const SplashPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: home,
      page: () => const HomePage(),
      bindings: [HomeBinding(), AuthBinding()],
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: eventDetail,
      page: () => const EventDetailPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: login,
      page: () => const LoginPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: register,
      page: () => const RegisterPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: eventManagement,
      page: () => const EventManagementPage(),
      transition: Transition.rightToLeft,
      binding: EventBinding(),
    ),
    GetPage(
      name: createEvent,
      page: () => const EventCreatedAndEditWidget(),
      transition: Transition.rightToLeft,
      binding: EventBinding(),
    ),
    GetPage(
      name: editEvent,
      page: () => const EventCreatedAndEditWidget(),
      transition: Transition.rightToLeft,
      binding: EventBinding(),
    ),
    GetPage(
      name: userManagement,
      page: () => const UserManagementPage(),
      transition: Transition.rightToLeft,
      binding: UserBinding(),
    ),
  ];
}
