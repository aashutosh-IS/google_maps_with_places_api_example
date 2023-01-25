import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(Widget routeName) {
      return navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) => routeName,
      ));
  }

  Future<void> setupLocator() async {
    locator.registerLazySingleton(() => NavigationService());
  }
  
}
