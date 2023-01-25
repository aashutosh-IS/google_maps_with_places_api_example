import 'package:flutter/material.dart';
import 'package:google_maps_mvp/cubit/maps_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/maps_screen.dart';
import 'service/navigation_service.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
    await NavigationService().setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps Demo',
      debugShowCheckedModeBanner: false,
      navigatorKey: locator<NavigationService>().navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<MapsCubit>(
        create: (context) => MapsCubit()..getUserCurrentLocation(),
        child: const MapScreen(),
      ),
    );
  }
}
