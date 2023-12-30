import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils/app_colors.dart';
import 'providers/contact_provider.dart';
import 'services/api_service.dart';

import 'screens/home_page.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ContactProvider(ApiService())),
      ],
      child: MaterialApp(
        title: 'Contact Form',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          appBarTheme: AppBarTheme(
            centerTitle: true,
            elevation: 0,
            titleTextStyle: const TextStyle(
              color: AppColors.blackColor,
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
            iconTheme: const IconThemeData(color: AppColors.blackColor),
            backgroundColor: Theme.of(context).canvasColor,
          ),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}
