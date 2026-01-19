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
    return const SplashScreen();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  final DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    // After a 2-second delay, trigger the navigation logic.
    Future.delayed(const Duration(seconds: 2), navigateToNextScreen);
  }

  /// Determines and navigates to the next screen based on authentication state
  /// and session validity.
  ///
  /// This method checks the `AuthCubit` state:
  /// - If `authenticated`, it verifies if the session is still valid (less than 50 minutes).
  ///   - If valid, it navigates to the home screen.
  ///   - If expired, it checks if biometric login is enabled.
  ///     - If biometrics are enabled, it prompts for re-authentication.
  /// - If `unauthenticated` (or any other state), it navigates to the main auth screen.
  void navigateToNextScreen() {
    final authState = context.read<AuthCubit>().state;

    authState.maybeWhen(
      authenticated: (isStudent, student, time) async {
        final authCubit = context.read<AuthCubit>();
        final settingsCubit = context.read<SettingsCubit>();

        // Get the time the user originally logged in.
        final timeSession = authCubit.getTimeLogin;

        // A session is considered expired after 50 minutes.
        final sessionExpiryTime = timeSession.add(const Duration(minutes: 50));

        // Check if the current time is after the session expiry time.
        if (_now.isAfter(sessionExpiryTime)) {
          // If the session has expired, check if biometric login is enabled.
          final isBiometricStatusActive = settingsCubit.getBiometricLoginStatus;

          if (isBiometricStatusActive) {
            // Navigate to the auth screen to prompt for biometric re-authentication.
            Get.offNamed(
              BudiLuhurRoutes.authStudent,
              arguments: {'biometricState': "true"},
            );
          } else {
            // If biometrics are not active, navigate to the standard auth flow.
            Get.offNamed(BudiLuhurRoutes.authStudent);
          }
        } else {
          // If the session is still valid, navigate to the home screen.
          Get.offNamed(BudiLuhurRoutes.home);
        }
      },
      // If the user is not authenticated, navigate to the auth screen.
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
            // Animate the logo with a scaling effect.
            child: Animate(
              effects: const [
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
