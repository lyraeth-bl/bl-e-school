import 'dart:async';

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeTableContainer extends StatefulWidget {
  const TimeTableContainer({super.key});

  @override
  State<TimeTableContainer> createState() => _TimeTableContainerState();
}

class _TimeTableContainerState extends State<TimeTableContainer>
    with SingleTickerProviderStateMixin {
  late int _currentSelectedDayIndex = DateTime.now().weekday - 1;

  void _fetchTimeTable() {
    final detailsStudent = context.read<AuthCubit>().getStudentDetails;
    final classStudent =
        "${detailsStudent.kelasSaatIni}${detailsStudent.noKelasSaatIni}";
    context.read<TimeTableCubit>().fetchTimeTable(
      kelas: classStudent,
      forceRefresh: true,
    );
  }

  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: Utils.getScrollViewBottomPadding(context),
              top: Utils.getScrollViewTopPadding(
                context: context,
                appBarHeightPercentage: Utils.appBarMediumHeightPercentage,
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * (0.025)),
                _buildDays(),
                SizedBox(height: MediaQuery.of(context).size.height * (0.025)),
                _buildTimeTable(),
              ],
            ),
          ),
        ),
        Align(alignment: Alignment.topCenter, child: _buildAppBar()),
      ],
    );
  }

  List<TimeTable> _buildTimeTableSlots(List<TimeTable> timeTableSlot) {
    final dayWiseTimeTableSlots = timeTableSlot
        .where(
          (element) =>
              element.hari ==
              Utils.weekDaysFullFormTranslated[_currentSelectedDayIndex]
                  .toLowerCase(),
        )
        .toList();
    return dayWiseTimeTableSlots;
  }

  Widget _buildTimeTableShimmerLoadingContainer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
        horizontal:
            Utils.screenContentHorizontalPaddingInPercentage *
            MediaQuery.of(context).size.width,
      ),
      child: ShimmerLoadingContainer(
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            return Row(
              children: [
                CustomShimmerContainer(
                  height: 60,
                  width: boxConstraints.maxWidth * (0.25),
                ),
                SizedBox(width: boxConstraints.maxWidth * (0.05)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomShimmerContainer(
                      height: 9,
                      width: boxConstraints.maxWidth * (0.6),
                    ),
                    const SizedBox(height: 10),
                    CustomShimmerContainer(
                      height: 8,
                      width: boxConstraints.maxWidth * (0.5),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimeTableLoading() {
    return ShimmerLoadingContainer(
      child: Column(
        children: List.generate(
          5,
          (index) => index,
        ).map((e) => _buildTimeTableShimmerLoadingContainer()).toList(),
      ),
    );
  }

  Widget _buildAppBar() {
    String getStudentClassDetails = "";
    getStudentClassDetails =
        "${context.read<AuthCubit>().getStudentDetails.kelasSaatIni}";

    return ScreenTopBackgroundContainer(
      heightPercentage: Utils.appBarMediumHeightPercentage,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const CustomBackButton(),

          Align(
            alignment: Alignment.topCenter,
            child: Text(
              Utils.getTranslatedLabel(timeTableKey),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: Utils.screenTitleFontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Positioned(
            bottom: -20,
            left: MediaQuery.of(context).size.width * (0.075),
            child: Container(
              alignment: Alignment.center,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withValues(alpha: 0.075),
                    offset: const Offset(2.5, 2.5),
                    blurRadius: 5,
                  ),
                ],
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              width: MediaQuery.of(context).size.width * (0.85),
              child: Text(
                "${Utils.getTranslatedLabel(classKey)} - $getStudentClassDetails",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayContainer(int index) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        setState(() {
          _currentSelectedDayIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: index == _currentSelectedDayIndex
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
        ),
        margin: EdgeInsetsDirectional.only(end: 6.25, start: 6.25),
        padding: const EdgeInsets.all(7.5),
        child: Text(
          Utils.getTranslatedLabel(Utils.weekDays[index]),
          style: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w600,
            color: index == _currentSelectedDayIndex
                ? Theme.of(context).scaffoldBackgroundColor
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildDays() {
    final List<Widget> children = [];

    for (var i = 0; i < Utils.weekDays.length; i++) {
      children.add(_buildDayContainer(i));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: MediaQuery.of(context).size.width * (0.075),
      ),
      child: Row(children: children),
    );
  }

  Widget _buildTimeTableSlotDetailsContainer({required TimeTable timeTable}) {
    final jamMulaiToDateTime = Utils.timeStringToToday(timeTable.jamMulai);
    final jamSelesaiToDateTime = Utils.timeStringToToday(timeTable.jamSelesai);

    final now = DateTime.now();

    final isSameDay =
        timeTable.hari.toLowerCase() ==
        Utils.formatNumberDaysToStringDays(now.weekday);

    final isNow =
        isSameDay &&
        now.isAfter(jamMulaiToDateTime!) &&
        now.isBefore(jamSelesaiToDateTime!);

    final isWeekend =
        ((DateTime.now().weekday != (DateTime.saturday)) &&
        (DateTime.now().weekday != (DateTime.sunday)));

    final lessonDay =
        Utils.weekDaysFullFormTranslated
            .map((e) => e.toLowerCase())
            .toList()
            .indexOf(timeTable.hari.toLowerCase()) +
        1;

    final isPastDay = lessonDay < now.weekday;
    final isFutureDay = lessonDay > now.weekday;

    final isBeforeLesson = isSameDay && now.isBefore(jamMulaiToDateTime!);
    final isAfterLesson = isSameDay && now.isAfter(jamSelesaiToDateTime!);

    final progress = Utils.calculateLessonProgress(
      start: jamMulaiToDateTime!,
      end: jamSelesaiToDateTime!,
      now: now,
    );

    double progressValue;

    if (lessonDay == 0) {
      progressValue = 0;
    }

    if (isPastDay) {
      // pelajaran hari kemarin
      progressValue = 1;
    } else if (isFutureDay) {
      // pelajaran besok
      progressValue = 0;
    } else if (isSameDay && isBeforeLesson) {
      // hari ini tapi belum mulai
      progressValue = 0;
    } else if (isSameDay && isAfterLesson) {
      // hari ini tapi sudah selesai
      progressValue = 1;
    } else if (isNow) {
      // sedang berlangsung
      progressValue = progress;
    } else {
      progressValue = 0;
    }

    return Card(
      margin: isNow ? const EdgeInsets.symmetric(vertical: 10) : null,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    timeTable.namaMataPelajaran,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                  ),
                ),

                if (isNow && isWeekend) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      Utils.getTranslatedLabel(nowKey),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            SizedBox(height: 4),

            Text(
              timeTable.namaGuru,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      timeTable.jamMulai,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHigh,
                      ),
                    ),
                  ],
                ),

                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 6,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: LinearProgressIndicator(
                      value: progressValue,
                      minHeight: 6,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHigh,
                      valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).colorScheme.primaryFixedDim,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      timeTable.jamSelesai,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeTable() {
    return BlocBuilder<TimeTableCubit, TimeTableState>(
      builder: (context, state) {
        return state.maybeWhen(
          failure: (errorMessage) => ErrorContainer(
            key: isApplicationItemAnimationOn ? UniqueKey() : null,
            errorMessageCode: errorMessage,
            onTapRetry: _fetchTimeTable,
          ),
          success: (timeTableList) {
            final timetableSlots = _buildTimeTableSlots(timeTableList);

            if (timetableSlots.isEmpty) {
              return NoDataContainer(
                key: isApplicationItemAnimationOn ? UniqueKey() : null,
                titleKey: noLecturesKey,
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  padding: EdgeInsets.only(
                    bottom: Utils.getScrollViewBottomPadding(context),
                  ),
                  itemCount: timetableSlots.length,
                  itemBuilder: (context, index) {
                    final timeTable = timetableSlots[index];
                    return _buildTimeTableSlotDetailsContainer(
                      timeTable: timeTable,
                    );
                  },
                ),
              ),
            );
          },
          orElse: () => _buildTimeTableLoading(),
        );
      },
    );
  }
}
