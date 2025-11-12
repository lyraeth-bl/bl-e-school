import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class HomeContainerTopProfileContainer extends StatelessWidget {
  const HomeContainerTopProfileContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTopBackgroundContainer(
      padding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Stack(
            children: [
              // Bordered Circle
              PositionedDirectional(
                top: MediaQuery.of(context).size.width * (-0.15),
                start: MediaQuery.of(context).size.width * (-0.225),
                child: Container(
                  padding: const EdgeInsetsDirectional.only(
                    end: 20.0,
                    bottom: 20.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                    shape: BoxShape.circle,
                  ),
                  width: MediaQuery.of(context).size.width * (0.6),
                  height: MediaQuery.of(context).size.width * (0.6),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              // Bottom fill Circle
              PositionedDirectional(
                bottom: MediaQuery.of(context).size.width * (-0.15),
                end: MediaQuery.of(context).size.width * (-0.15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.outlineVariant.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  width: MediaQuery.of(context).size.width * (0.4),
                  height: MediaQuery.of(context).size.width * (0.4),
                ),
              ),

              // Content
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsetsDirectional.only(
                    end: boxConstraints.maxWidth * (0.065),
                    start: boxConstraints.maxWidth * (0.056),
                    bottom: boxConstraints.maxHeight * (0.2),
                  ),
                  child: Row(
                    children: [
                      BlocSelector<AuthCubit, AuthState, String?>(
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

                      SizedBox(width: boxConstraints.maxWidth * (0.03)),

                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context
                                      .read<AuthCubit>()
                                      .getStudentDetails
                                      .nama ??
                                  "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                            ),

                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    "${Utils.getTranslatedLabel(classKey)} : ${context.read<AuthCubit>().getStudentDetails.kelasSaatIni} - ${context.read<AuthCubit>().getStudentDetails.noKelasSaatIni}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          Get.toNamed(BudiLuhurRoutes.notifications);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.notifications_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
