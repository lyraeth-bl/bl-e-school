import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../utils/shared/extensions/media_query_extension.dart';
import '../../../utils/shared/extensions/radius_extension.dart';
import '../../../utils/shared/extensions/space_extension.dart';
import '../../../utils/shared/extensions/theme_extension.dart';
import '../../../utils/shared/extensions/translate_extension.dart';
import '../../../utils/shared/label_keys/label_keys.dart';
import '../../../utils/shared/ui/app_toast.dart';
import '../../../utils/shared/ui/custom_container.dart';
import '../../../utils/shared/ui/custom_text_field_container.dart';
import '../../../utils/shared/ui/password_hide_show_button.dart';
import '../../sessions/presentation/bloc/sessions_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../data/model/login_request/login_request.dart';

class AuthStudentScreen extends StatefulWidget {
  const AuthStudentScreen({super.key});

  @override
  State<AuthStudentScreen> createState() => _AuthStudentScreenState();

  static Widget routeInstance() {
    return AuthStudentScreen();
  }
}

class _AuthStudentScreenState extends State<AuthStudentScreen>
    with TickerProviderStateMixin {
  /// Animations
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  late final Animation<double> _patternAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
        ),
      );

  late final Animation<double> _formAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
        ),
      );

  /// Variables
  final TextEditingController _nisController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  void initState() {
    super.initState();
    _animationController.forward();

    final args = Get.arguments as Map<String, dynamic>?;

    final wantBiometric = args?['biometricState'] == "true";
    final fromSessionBottomSheet = args?['fromSessionBottomSheet'] == "true";

    if (wantBiometric && fromSessionBottomSheet) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // biometricLogin();
      });
    }
  }

  // void biometricLogin() async {
  //   final ok = await context.read<AuthCubit>().biometricRefreshToken();
  //
  //   if (ok && mounted) {
  //     final dailyAttendanceCubit = context.read<DailyAttendanceCubit>();
  //     final dailyAttendanceData = dailyAttendanceCubit.getDailyAttendance;
  //
  //     if (dailyAttendanceData?.tanggal.day != _now.day) {
  //       dailyAttendanceCubit.clearAllData();
  //     }
  //
  //     Get.offNamed(BudiLuhurRoutes.home);
  //   } else {}
  // }

  @override
  void dispose() {
    _animationController.dispose();
    _nisController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.whenOrNull(
          successLogin: (accessToken, expiresAt) {
            context.read<SessionsBloc>().add(
              SessionsEvent.loggedIn(token: accessToken),
            );
          },
          failure: (failure) {
            AppToast.show(
              context,
              message: failure.errorMessage!,
              type: ToastType.error,
            );
          },
        );
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            _buildLowerPattern(),
            _buildUpperPattern(),
            _buildLoginForm(),
          ],
        ),
      ),
    );
  }

  /// Methods
  void _signInStudent() {
    if (_nisController.text.trim().isEmpty) {
      AppToast.show(
        context,
        message: pleaseEnterNisKey.translate(),
        type: ToastType.warning,
      );
      return;
    }

    if (_passwordController.text.trim().isEmpty) {
      AppToast.show(
        context,
        message: pleaseEnterPasswordKey.translate(),
        type: ToastType.warning,
      );
      return;
    }

    final loginParams = LoginRequest(
      nis: _nisController.text.trim(),
      password: _passwordController.text.trim(),
    );

    context.read<AuthBloc>().add(
      AuthEvent.loginRequested(loginRequest: loginParams),
    );
  }

  /// UI
  Widget _buildUpperPattern() {
    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: FadeTransition(
        opacity: _patternAnimation,
        child: SlideTransition(
          position: _patternAnimation.drive(
            Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero),
          ),
          child: SvgPicture.asset("assets/images/upper_pattern.svg"),
        ),
      ),
    );
  }

  Widget _buildLowerPattern() {
    return Align(
      alignment: AlignmentDirectional.bottomStart,
      child: FadeTransition(
        opacity: _patternAnimation,
        child: SlideTransition(
          position: _patternAnimation.drive(
            Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero),
          ),
          child: SvgPicture.asset("assets/images/lower_pattern.svg"),
        ),
      ),
    );
  }

  /// Uncomment onTap if Request Password has been active
  // Widget _buildRequestResetPasswordContainer() {
  //   return Align(
  //     alignment: AlignmentDirectional.centerEnd,
  //     child: Padding(
  //       padding: const EdgeInsets.only(top: 8),
  //       child: GestureDetector(
  //         onTap: () {
  //           Utils.showBottomSheet(
  //             child: BlocProvider(
  //               create: (_) => RequestResetPasswordCubit(AuthRepository()),
  //               child: const RequestResetPasswordBottomsheet(),
  //             ),
  //             context: context,
  //           ).then((value) {
  //             if (value != null && !value['error']) {
  //               Utils.showCustomSnackBar(
  //                 context: context,
  //                 errorMessage: Utils.getTranslatedLabel(
  //                   passwordResetRequestKey,
  //                 ),
  //                 backgroundColor: Theme.of(context).colorScheme.onPrimary,
  //               );
  //             }
  //           });
  //         },
  //         child: Text(
  //           "${Utils.getTranslatedLabel(resetPasswordKey)}?",
  //           style: TextStyle(color: Theme.of(context).colorScheme.primary),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildLoginForm() {
    return Align(
      alignment: Alignment.topCenter,
      child: FadeTransition(
        opacity: _formAnimation,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: context.viewInsets.bottom,
          ), //to make UI scrollable when keyboard is opened
          child: SizedBox(
            height: context.screenHeight,
            child: NotificationListener(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.only(
                  left: context.screenWidth * (0.075),
                  right: context.screenWidth * (0.075),
                  top: context.screenHeight * (0.17),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      letsSignInKey.translate(),
                      style: context.text.headlineLarge?.copyWith(
                        color: context.colors.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    16.h,

                    Text(
                      "${welcomeBackKey.translate()}, \n${youHaveBeenMissedKey.translate()}",
                      style: context.text.headlineSmall?.copyWith(
                        height: 1.5,
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),

                    /// NIS field
                    24.h,

                    CustomTextFieldContainer(
                      hideText: false,
                      hintTextKey: nisKey.translate(),
                      bottomPadding: 0,
                      textEditingController: _nisController,
                    ),

                    /// Password field
                    24.h,

                    CustomTextFieldContainer(
                      textEditingController: _passwordController,
                      suffixWidget: PasswordHideShowButton(
                        hidePassword: _hidePassword,
                        onTap: () {
                          setState(() {
                            _hidePassword = !_hidePassword;
                          });
                        },
                      ),
                      hideText: _hidePassword,
                      hintTextKey: passwordKey.translate(),
                      bottomPadding: 0,
                    ),

                    // _buildRequestResetPasswordContainer(),
                    48.h,

                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final isLoading = state.maybeWhen(
                          loading: () => true,
                          orElse: () => false,
                        );

                        return CustomContainer(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    CustomRadiusExtension.customContainerRadius,
                              ),
                            ),
                            onPressed: () {
                              if (isLoading) return;

                              FocusScope.of(context).unfocus();

                              _signInStudent();
                            },
                            child: isLoading
                                ? SizedBox(
                                    height: 20,
                                    child: Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                context.colors.onPrimary,
                                              ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Text(
                                    signInKey.translate(),
                                    style: context.text.bodyMedium?.copyWith(
                                      color: context.colors.onPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),

                    // 20.h,

                    // const TermsAndConditionAndPrivacyPolicyContainer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
