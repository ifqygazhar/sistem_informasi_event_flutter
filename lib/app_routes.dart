import 'package:get/route_manager.dart';
import 'package:sistem_informasi/pages/event/event_detail.dart';
import 'package:sistem_informasi/pages/home/binding/home_binding.dart';
import 'package:sistem_informasi/pages/home/home.dart';
import 'package:sistem_informasi/pages/splash/splash.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String eventDetail = '/event/:id';
  static const String createEvent = '/create-event';
  static const String editEvent = '/edit-event';

  static final routes = [
    GetPage(
      name: splash,
      page: () => const SplashPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: home,
      page: () => const HomePage(),
      binding: HomeBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: eventDetail,
      page: () => const EventDetailPage(),
      transition: Transition.rightToLeft,
    ),
    // GetPage(name: eventDetail, page: () => const EventDetailPage()),
    // GetPage(name: createEvent, page: () => const CreateEventPage()),
    // GetPage(name: editEvent, page: () => const EditEventPage()),
    // GetPage(name: login, page: () => const LoginPage()),
    // GetPage(name: register, page: () => const RegisterPage()),
  ];
}
