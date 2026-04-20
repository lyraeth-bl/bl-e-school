import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/utils.dart';
import '../../app_config/presentation/bloc/app_config_bloc.dart';
import '../../daily_attendance/presentation/bloc/today_attendance/today_attendance_bloc.dart';
import '../../sessions/presentation/bloc/sessions_bloc.dart';
import '../../time_table/bloc/time_table_bloc.dart';
import 'widgets/home_attendance_card.dart';
import 'widgets/home_container_top_profile_container.dart';
import 'widgets/home_feedback_card.dart';
import 'widgets/home_schedule_card.dart';

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
        appBarHeightPercentage: Utils.appBarBiggerHeightPercentage - 0.025,
      ),
      onRefresh: () async {
        final studentDetails = context.read<SessionsBloc>().studentDetails;

        context.read<AppConfigBloc>().add(
          AppConfigEvent.appConfigRequested(forceRefresh: true),
        );

        context.read<TimeTableBloc>().add(
          TimeTableEvent.timeTableRequested(
            kelas:
                "${studentDetails!.kelasSaatIni!}${studentDetails.noKelasSaatIni}",
            forceRefresh: true,
          ),
        );

        context.read<TodayAttendanceBloc>().add(
          TodayAttendanceEvent.started(forceRefresh: true),
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

            // Attendance
            HomeAttendanceCard(),

            // Feedback
            HomeFeedbackCard(),
          ].separatedBy(24.h),
        ),
      ),
    );
  }
}
