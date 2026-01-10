import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  static Widget routeInstance() {
    return StudentProfileScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          Utils.getTranslatedLabel(profileKey),
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().signOut(reason: LogoutReason.manual);

              Get.offNamed(BudiLuhurRoutes.auth);
            },
            icon: Icon(LucideIcons.logOut),
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildProfileDetailsContainer(
            context,
            studentDetails: context.read<AuthCubit>().getStudentDetails,
          ),
        ],
      ),
    );
  }

  /// UI
  Widget _buildProfileDetailsTile(
    BuildContext context, {
    required String label,
    required String value,
    required String iconUrl,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SvgPicture.asset(
              iconUrl,
              theme: SvgTheme(
                currentColor:
                    iconColor ??
                    Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              colorFilter: iconColor == null
                  ? null
                  : ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * (0.05)),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value.isEmpty ? "-" : value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetailsContainer(
    BuildContext context, {
    required Student studentDetails,
  }) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 24),
            Container(
              width: MediaQuery.of(context).size.width * (0.25),
              height: MediaQuery.of(context).size.width * (0.25),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              child: BlocSelector<AuthCubit, AuthState, String?>(
                selector: (state) => state.maybeWhen(
                  authenticated: (isStudent, student, time) =>
                      student.profileImageUrl,
                  orElse: () => "",
                ),
                builder: (context, profileImageUrl) =>
                    BorderedProfilePictureContainer(
                      imageUrl: profileImageUrl ?? "",
                      heightAndWidth: 60,
                    ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              studentDetails.nama ?? "-",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              studentDetails.email ?? "",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 16.0),

            Divider(color: Theme.of(context).colorScheme.outlineVariant),

            const SizedBox(height: 16.0),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * (0.075),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Utils.getTranslatedLabel(personalDetailsKey),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                        ),

                        InkWell(
                          onTap: () => Get.toNamed(
                            BudiLuhurRoutes.studentDetailsProfile,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  Utils.getTranslatedLabel(detailsProfileKey),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimaryContainer,
                                      ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 8),

                  _buildProfileDetailsTile(
                    context,
                    label: Utils.getTranslatedLabel(schoolKey),
                    value: Utils.formatEmptyValue(
                      ("${studentDetails.unit?.substring(0, 3)} Budi Luhur"),
                    ),
                    iconUrl: "assets/images/school.svg",
                    iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  _buildProfileDetailsTile(
                    context,
                    label: Utils.getTranslatedLabel(nisKey),
                    value: Utils.formatEmptyValue(studentDetails.nis),
                    iconUrl: "assets/images/user_pro_roll_no_icon.svg",
                    iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  _buildProfileDetailsTile(
                    context,
                    label: Utils.getTranslatedLabel(nisnKey),
                    value: Utils.formatEmptyValue(studentDetails.nisn ?? ""),
                    iconUrl: "assets/images/user_pro_roll_no_icon.svg",
                    iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  _buildProfileDetailsTile(
                    context,
                    label: Utils.getTranslatedLabel(classKey),
                    value: Utils.formatEmptyValue(
                      "${studentDetails.kelasSaatIni} ${studentDetails.noKelasSaatIni}",
                    ),
                    iconUrl: "assets/images/user_pro_class_icon.svg",
                    iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  _buildProfileDetailsTile(
                    context,
                    label: Utils.getTranslatedLabel(dateOfBirthKey),
                    value: Utils.formatEmptyValue(
                      DateTime.tryParse(
                                studentDetails.tanggalLahir
                                        ?.toIso8601String() ??
                                    "",
                              ) ==
                              null
                          ? "-"
                          : Utils.formatDays(
                              DateTime.tryParse(
                                studentDetails.tanggalLahir!.toIso8601String(),
                              )!,
                              locale: "id_ID",
                            ),
                    ),
                    iconUrl: "assets/images/user_pro_dob_icon.svg",
                    iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  _buildProfileDetailsTile(
                    context,
                    label: Utils.getTranslatedLabel(currentAddressKey),
                    value: Utils.formatEmptyValue(studentDetails.alamat ?? ""),
                    iconUrl: "assets/images/user_pro_address_icon.svg",
                    iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * (0.05)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentDetailsValueShimmerLoading(
    BoxConstraints boxConstraints,
  ) {
    return Column(
      children: [
        const SizedBox(height: 20),
        ShimmerLoadingContainer(
          child: CustomShimmerContainer(
            margin: EdgeInsetsDirectional.only(
              end: boxConstraints.maxWidth * (0.7),
            ),
            height: 8,
          ),
        ),
        const SizedBox(height: 10),
        ShimmerLoadingContainer(
          child: CustomShimmerContainer(
            margin: EdgeInsetsDirectional.only(
              end: boxConstraints.maxWidth * (0.5),
            ),
            height: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildStudentDetailsShimmerLoading(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Utils.getScrollViewTopPadding(
          context: context,
          appBarHeightPercentage: Utils.appBarSmallerHeightPercentage,
        ),
      ),
      child: Center(
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            return Column(
              children: [
                ShimmerLoadingContainer(
                  child: Container(
                    width: MediaQuery.of(context).size.width * (0.25),
                    height: MediaQuery.of(context).size.width * (0.25),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShimmerLoadingContainer(
                        child: Divider(
                          color: Colors.white.withValues(alpha: 0.85),
                          height: 2,
                        ),
                      ),
                      _buildStudentDetailsValueShimmerLoading(boxConstraints),
                      const SizedBox(height: 20),
                      _buildStudentDetailsValueShimmerLoading(boxConstraints),
                      const SizedBox(height: 20),
                      _buildStudentDetailsValueShimmerLoading(boxConstraints),
                      const SizedBox(height: 20),
                      _buildStudentDetailsValueShimmerLoading(boxConstraints),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
