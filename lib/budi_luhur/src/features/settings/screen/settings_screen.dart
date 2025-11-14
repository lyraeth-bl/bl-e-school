import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static Widget routeInstance() {
    return SettingsScreen();
  }

  Widget _buildAppbar(BuildContext context) {
    return ScreenTopBackgroundContainer(
      padding: EdgeInsets.zero,
      heightPercentage: Utils.appBarSmallerHeightPercentage,
      child: Stack(
        children: [
          const CustomBackButton(
            alignmentDirectional: AlignmentDirectional.centerStart,
          ),
          Center(
            child: Text(
              Utils.getTranslatedLabel(settingsKey),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: Utils.screenTitleFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.only(
                bottom: Utils.getScrollViewBottomPadding(context),
                top:
                    Utils.getScrollViewTopPadding(
                      context: context,
                      appBarHeightPercentage:
                          Utils.appBarSmallerHeightPercentage,
                    ) -
                    10,
                end: 24,
                start: 24,
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      final bool isLoading = state.maybeWhen(
                        loading: () => true,
                        orElse: () => false,
                      );
                      final bool isEnabled = state.maybeWhen(
                        success: (biometricLogin) => biometricLogin,
                        orElse: () => false,
                      );

                      return GestureDetector(
                        onTap: () async {
                          final newValue = !isEnabled;
                          context.read<SettingsCubit>().toggleBiometricLogin(
                            enable: newValue,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12.5),
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x1a212121),
                                      offset: Offset(0, 10),
                                      blurRadius: 16,
                                    ),
                                  ],
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Icon(
                                  Icons.fingerprint,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * (0.05),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Utils.getTranslatedLabel(
                                        biometricLoginKey,
                                      ),
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Login cepat menggunakan biometric",
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isLoading) ...[
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ] else ...[
                                Switch(
                                  value: isEnabled,
                                  onChanged: (val) async {
                                    await context
                                        .read<SettingsCubit>()
                                        .toggleBiometricLogin(enable: val);
                                    final currentState = context
                                        .read<SettingsCubit>()
                                        .state;
                                    currentState.when(
                                      initial: () {},
                                      loading: () {},
                                      success: (biometricLogin) {
                                        final msg = biometricLogin
                                            ? "Biometric diaktifkan"
                                            : "Biometric dinonaktifkan";
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(content: Text(msg)),
                                        );
                                      },
                                      failure: (err) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text("Gagal: $err"),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          _buildAppbar(context),
        ],
      ),
    );
  }
}
