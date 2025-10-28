import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AuthStudentScreen extends StatefulWidget {
  const AuthStudentScreen({super.key});

  @override
  State<AuthStudentScreen> createState() => _AuthStudentScreenState();

  static Widget routeInstance() {
    return BlocProvider<SignInCubit>(
      create: (_) => SignInCubit(AuthRepository()),
      child: const AuthStudentScreen(),
    );
  }
}

class _AuthStudentScreenState extends State<AuthStudentScreen>
    with TickerProviderStateMixin {
  /// Animations
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  late final Animation<double> _patterntAnimation =
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nisController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //to avoid the lower pattern from hiding login form when keyboard is open
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildLowerPattern(),
          _buildUpperPattern(),
          _buildLoginForm(),
        ],
      ),
    );
  }

  /// Methods
  void _signInStudent() {
    if (_nisController.text.trim().isEmpty) {
      Utils.showCustomSnackBar(
        context: context,
        errorMessage: Utils.getTranslatedLabel(pleaseEnterNisKey),
        backgroundColor: Utils.getColorScheme(context).error,
      );
      return;
    }

    if (_passwordController.text.trim().isEmpty) {
      Utils.showCustomSnackBar(
        context: context,
        errorMessage: Utils.getTranslatedLabel(pleaseEnterPasswordKey),
        backgroundColor: Utils.getColorScheme(context).error,
      );
      return;
    }

    context.read<SignInCubit>().signInUser(
      nis: _nisController.text.trim(),
      password: _passwordController.text.trim(),
      isStudentLogIn: true,
    );
  }

  /// UI
  Widget _buildUpperPattern() {
    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: FadeTransition(
        opacity: _patterntAnimation,
        child: SlideTransition(
          position: _patterntAnimation.drive(
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
        opacity: _patterntAnimation,
        child: SlideTransition(
          position: _patterntAnimation.drive(
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
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ), //to make UI scrollable when keyboard is opened
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: NotificationListener(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * (0.075),
                  right: MediaQuery.of(context).size.width * (0.075),
                  top: MediaQuery.of(context).size.height * (0.17),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getTranslatedLabel(letsSignInKey),
                      style: TextStyle(
                        fontSize: 34.0,
                        fontWeight: FontWeight.bold,
                        color: Utils.getColorScheme(context).onSurface,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      "${Utils.getTranslatedLabel(welcomeBackKey)}, \n${Utils.getTranslatedLabel(youHaveBeenMissedKey)}",
                      style: TextStyle(
                        fontSize: 24.0,
                        height: 1.5,
                        color: Utils.getColorScheme(context).onSurfaceVariant,
                      ),
                    ),

                    /// NIS field
                    const SizedBox(height: 30.0),
                    CustomTextFieldContainer(
                      hideText: false,
                      hintTextKey: Utils.getTranslatedLabel(nisKey),
                      bottomPadding: 0,
                      textEditingController: _nisController,
                    ),

                    /// Password field
                    const SizedBox(height: 30.0),
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
                      hintTextKey: passwordKey,
                      bottomPadding: 0,
                    ),
                    // _buildRequestResetPasswordContainer(),
                    const SizedBox(height: 30.0),
                    Center(
                      child: BlocConsumer<SignInCubit, SignInState>(
                        listener: (context, state) {
                          state.maybeWhen(
                            success: (jwtToken, isStudentLogIn, student) {
                              context.read<AuthCubit>().authenticateUser(
                                jwtToken: jwtToken,
                                isStudent: isStudentLogIn,
                                student: student,
                              );

                              Get.offNamedUntil(
                                BudiLuhurRoutes.studentOnboarding,
                                (Route<dynamic> route) => false,
                              );
                            },
                            failure: (errorMessage) {
                              Utils.showCustomSnackBar(
                                context: context,
                                errorMessage: Utils.getTranslatedLabel(
                                  errorMessage,
                                ),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.error,
                              );
                            },
                            orElse: () {},
                          );
                        },
                        builder: (context, state) {
                          final isLoading = state.maybeWhen(
                            loading: () => true,
                            orElse: () => false,
                          );

                          return CustomRoundedButton(
                            onTap: () {
                              if (isLoading) return;

                              FocusScope.of(context).unfocus();

                              _signInStudent();
                            },
                            widthPercentage: 0.8,
                            backgroundColor: Utils.getColorScheme(
                              context,
                            ).primary,
                            buttonTitle: Utils.getTranslatedLabel(signInKey),
                            titleColor: Theme.of(
                              context,
                            ).scaffoldBackgroundColor,
                            showBorder: false,
                            child: isLoading
                                ? CircularProgressIndicator()
                                : Text(Utils.getTranslatedLabel(signInKey)),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // const TermsAndConditionAndPrivacyPolicyContainer(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (0.025),
                    ),
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
