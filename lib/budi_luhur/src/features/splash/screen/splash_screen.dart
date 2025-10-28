import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

  static Widget routeInstance() {
    return SplashScreen();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), navigateToNextScreen);
    super.initState();
  }

  void navigateToNextScreen() {
    final authState = context.read<AuthCubit>().state;

    authState.maybeWhen(
      authenticated: (jwtToken, isStudent, student) =>
          Get.offNamed(BudiLuhurRoutes.home),
      orElse: () => Get.offNamed(BudiLuhurRoutes.auth),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SizedBox(
            width: 250,
            height: 250,
            child: Animate(
              effects: [
                ScaleEffect(
                  delay: Duration(milliseconds: 200),
                  duration: Duration(seconds: 1),
                ),
              ],
              child: Image.asset("assets/images/bl_logo.png"),
            ),
          ),
        ),
      ),
    );
  }
}
