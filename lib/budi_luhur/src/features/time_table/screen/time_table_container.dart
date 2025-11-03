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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchTimeTable());

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final cubit = context.read<TimeTableCubit>();
    final state = cubit.state;

    // Kalau udah scroll mendekati bawah
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        state.maybeWhen(
          success: (_, __, loadMore) => !loadMore && cubit.hasMore,
          orElse: () => false,
        )) {
      cubit.fetchMoreTimeTable();
    }
  }

  void _fetchTimeTable() {
    context.read<TimeTableCubit>().fetchTimeTable();
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
        "${context.read<AuthCubit>().getStudentDetails().kelasSaatIni} ${context.read<AuthCubit>().getStudentDetails().noKelasSaatIni}";

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
                color: Theme.of(context).scaffoldBackgroundColor,
                fontSize: Utils.screenTitleFontSize,
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
                  fontWeight: FontWeight.w600,
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

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.secondary.withValues(alpha: 0.075),
            offset: const Offset(4, 4),
            blurRadius: 10,
          ),
        ],
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      width: MediaQuery.of(context).size.width * (0.85),
      padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 10.0),
      child: Row(
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${Utils.formatTime(jamMulaiToDateTime!)} - ${Utils.formatTime(jamSelesaiToDateTime!)}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                      ),
                      child: Text(
                        timeTable.kelas,
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onTertiaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  timeTable.namaMataPelajaran,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                  ),
                ),
                Text(
                  timeTable.namaGuru,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        ],
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
          success: (timeTableResponse, timeTableList, loadMore) {
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
                  controller: _scrollController,
                  padding: EdgeInsets.only(
                    bottom: Utils.getScrollViewBottomPadding(context),
                  ),
                  itemCount: timetableSlots.length + (loadMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == timetableSlots.length) {
                      // loader di bawah
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      );
                    }

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
