import 'package:azeri/presentation/bloc/music_bloc.dart';
import 'package:azeri/presentation/pages/listing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'di.dart' as di;

void main() {
  di.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.amber));

    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => di.locator<MusicBloc>(),
          )
        ],
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Azeri",
          home: ListingPage(),
        ));
  }
}
