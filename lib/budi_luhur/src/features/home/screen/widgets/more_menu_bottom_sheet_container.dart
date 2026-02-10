import 'dart:math';

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class MoreMenuBottomSheetContainer extends StatelessWidget {
  final Function onTapMoreMenuItemContainer;
  final Function closeBottomMenu;

  const MoreMenuBottomSheetContainer({
    super.key,
    required this.onTapMoreMenuItemContainer,
    required this.closeBottomMenu,
  });

  Widget _buildMoreMenuContainer({
    required BuildContext context,
    required BoxConstraints boxConstraints,
    required MenuModel menu,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () {
          onTapMoreMenuItemContainer(
            homeBottomSheetMenu.indexWhere(
              (element) => element.title == menu.title,
            ),
          );
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 0.2,
                ),
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(16.0),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: boxConstraints.maxWidth * (0.065),
              ),
              width: boxConstraints.maxWidth * (0.2),
              height: boxConstraints.maxWidth * (0.2),
              child: Icon(
                menu.icon,
                size: 32,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: boxConstraints.maxWidth * (0.3),
              child: Text(
                Utils.getTranslatedLabel(menu.title),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * (0.85),
      ),
      padding: const EdgeInsets.only(top: 25.0, right: 25.0, left: 25.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    height: boxConstraints.maxWidth * (0.22),
                    width: boxConstraints.maxWidth * (0.22),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(
                        boxConstraints.maxWidth * (0.11),
                      ),
                    ),
                    child: BlocSelector<AuthCubit, AuthState, String?>(
                      selector: (state) => state.maybeWhen(
                        authenticated: (isStudent, student, time) =>
                            student.profileImageUrl,
                        orElse: () => "",
                      ),
                      builder: (context, profileImageUrl) =>
                          CustomUserProfileImageWidget(
                            profileUrl: profileImageUrl ?? "",
                            color: Colors.black,
                          ),
                    ),
                  ),

                  SizedBox(width: boxConstraints.maxWidth * (0.075)),

                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.read<AuthCubit>().getStudentDetails.nama ??
                              "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                        ),
                        SizedBox(height: 4),
                        Flexible(
                          child: Text(
                            "${Utils.getTranslatedLabel(classKey)} : ${context.read<AuthCubit>().getStudentDetails.kelasSaatIni} - ${context.read<AuthCubit>().getStudentDetails.noKelasSaatIni}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      closeBottomMenu();

                      Get.toNamed(BudiLuhurRoutes.studentProfile);
                    },
                    icon: Transform.rotate(
                      angle: pi,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),

              Divider(
                color: Theme.of(context).colorScheme.outlineVariant,
                height: 50,
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: homeBottomSheetMenu
                        .map(
                          (e) => _buildMoreMenuContainer(
                            context: context,
                            boxConstraints: boxConstraints,
                            menu: e,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),

              SizedBox(height: Utils.getScrollViewBottomPadding(context)),
            ],
          );
        },
      ),
    );
  }
}
