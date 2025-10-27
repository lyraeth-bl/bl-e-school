import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();

  static Widget routeInstance() {
    return AuthScreen();
  }
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  /// Animations
  late final AnimationController _bottomMenuHeightAnimationController =
      AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );

  late final Animation<double> _bottomMenuHeightUpAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _bottomMenuHeightAnimationController,
          curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
        ),
      );
  late final Animation<double> _bottomMenuHeightDownAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _bottomMenuHeightAnimationController,
          curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
        ),
      );

  /// Variables
  var canPop = false;

  /// Methods
  Future<void> startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));

    _bottomMenuHeightAnimationController.forward();
  }

  void _onWillPop() {
    setState(() {
      canPop = true;
    });
    Utils.showCustomSnackBar(
      context: context,
      errorMessage: Utils.getTranslatedLabel(pressBackAgainToExitKey),
      backgroundColor: Theme.of(context).colorScheme.error,
    ); // Do not exit the app
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        canPop = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  @override
  void dispose() {
    _bottomMenuHeightAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;

        _onWillPop();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: Stack(children: [_buildLogo(), _buildBottomMenu()]),
      ),
    );
  }

  /// UI
  Widget _buildLogo() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
          top:
              MediaQuery.of(context).padding.top +
              MediaQuery.of(context).size.height * (0.05),
        ),
        height: MediaQuery.of(context).size.height * (0.4),
        child: Image.asset('assets/images/bl_logo.png'),
      ),
    );
  }

  Widget _buildBottomMenu() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedBuilder(
        animation: _bottomMenuHeightAnimationController,
        builder: (context, child) {
          final height =
              MediaQuery.of(context).size.height *
                  (0.525) *
                  _bottomMenuHeightUpAnimation.value -
              MediaQuery.of(context).size.height *
                  (0.05) *
                  _bottomMenuHeightDownAnimation.value;
          return Container(
            width: MediaQuery.of(context).size.width,
            height: height,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: AnimatedSwitcher(
              switchInCurve: Curves.easeInOut,
              duration: const Duration(milliseconds: 400),
              child: _bottomMenuHeightAnimationController.value != 1.0
                  ? const SizedBox()
                  : LayoutBuilder(
                      builder: (context, boxConstraints) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * (0.1),
                              ),
                              child: Text(
                                "Cerdas Berbudi Luhur",
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w300,
                                  color: Utils.getColorScheme(
                                    context,
                                  ).onSurface,
                                ),
                              ),
                            ),
                            SizedBox(height: boxConstraints.maxHeight * (0.05)),
                            CustomRoundedButton(
                              onTap: () {
                                Get.toNamed(BudiLuhurRoutes.authStudent);
                              },
                              widthPercentage: 0.8,
                              backgroundColor: Utils.getColorScheme(
                                context,
                              ).primary,
                              buttonTitle:
                                  "${Utils.getTranslatedLabel(loginAsKey)} ${Utils.getTranslatedLabel(studentKey)}",
                              showBorder: false,
                            ),
                          ],
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }
}
