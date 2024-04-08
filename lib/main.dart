import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nova/pages/login_page.dart';
import 'package:nova/services/internet_service.dart';

Future<void> main() async {
  runApp(const MyApp());
}

// Entry point of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InternetCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Nova',
        home: BlocBuilder<InternetCubit, InternetState>(
          builder: (context, state) {
            return const LoginPage();
          },
        ),
      ),
    );
  }
}
