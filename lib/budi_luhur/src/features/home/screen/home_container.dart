import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class HomeContainer extends StatelessWidget {
  // Need this flag in order to show the homeContainer
  // in background when bottom menu is open
  // If it is just for background showing purpose then it will not reactive or not making any api call
  final bool isForBottomMenuBackground;

  const HomeContainer({super.key, required this.isForBottomMenuBackground});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [_buildHomeContent(context), _buildAppBarHome()]);
  }

  Widget _buildAppBarHome() {
    return Align(
      alignment: Alignment.topCenter,
      child: HomeContainerTopProfileContainer(),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    return RefreshIndicator(
      edgeOffset: Utils.getScrollViewTopPadding(
        context: context,
        appBarHeightPercentage: Utils.appBarBiggerHeightPercentage,
      ),
      onRefresh: () async {
        context.read<DailyAttendanceCubit>().fetchTodayDailyAttendance(
          nis: context.read<AuthCubit>().getStudentDetails.nis,
        );
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.only(
          bottom: Utils.getScrollViewBottomPadding(context),
          top: Utils.getScrollViewTopPadding(
            context: context,
            appBarHeightPercentage: Utils.appBarBiggerHeightPercentage,
          ),
          start: 24,
          end: 24,
        ),
        child: Column(
          children: [
            // Schedule
            HomeScheduleCard(),

            SizedBox(height: 8),

            // Attendance
            HomeAttendanceCard(),

            SizedBox(height: 8),

            // Feedback
            InkWell(
              onTap: () => Get.toNamed(BudiLuhurRoutes.feedback),
              child: Card(
                color: Theme.of(context).colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.getTranslatedLabel(feedbackKey),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Ayoooo! Berikan saranmu untuk aplikasi ini",
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),

                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
