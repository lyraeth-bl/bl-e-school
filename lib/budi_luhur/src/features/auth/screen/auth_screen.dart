import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();

  static Widget routeInstance() {
    return AuthScreen();
  }
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
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

  var canPop = false;

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
      errorMessage: pressBackAgainToExitKey.translate(),
      backgroundColor: context.colors.error,
    );
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
        backgroundColor: context.colors.primaryContainer,
        body: Stack(children: [_buildLogo(), _buildBottomMenu()]),
      ),
    );
  }

  Widget _buildLogo() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: context.screenWidth,
        margin: EdgeInsets.only(
          top: context.padding.top + context.screenHeight * (0.1),
        ),
        height: context.screenHeight * (0.25),
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
          return CustomContainer(
            borderRadius: 32.topRadiusCircular,
            width: context.screenWidth,
            height:
                context.screenHeight *
                    (0.525) *
                    _bottomMenuHeightUpAnimation.value -
                context.screenHeight *
                    (0.05) *
                    _bottomMenuHeightDownAnimation.value,
            enableShadow: false,
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
                            Text(
                              "Cerdas Berbudi Luhur",
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.titleMedium?.copyWith(
                                color: context.colors.onPrimaryContainer,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            CustomButtonContainer(
                              leadingIcon: LucideIcons.user,
                              backgroundColor: context.colors.primaryContainer,
                              onTap: () =>
                                  Get.toNamed(BudiLuhurRoutes.authStudent),
                              margin: 24.horizontal,
                              textKey:
                                  "${loginAsKey.translate()} ${studentKey.translate()}",
                            ),
                          ].separatedBy(24.h),
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
