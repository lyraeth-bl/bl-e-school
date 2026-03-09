import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        final studentDetails = sI<SessionsBloc>().studentDetails;

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

            SizedBox(height: 24),

            // Attendance
            HomeAttendanceCard(),

            SizedBox(height: 24),

            // Feedback
            HomeFeedbackCard(),
          ],
        ),
      ),
    );
  }
}
