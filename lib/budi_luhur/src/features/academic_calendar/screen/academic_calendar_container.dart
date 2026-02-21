import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class AcademicCalendarContainer extends StatefulWidget {
  const AcademicCalendarContainer({super.key});

  @override
  State<AcademicCalendarContainer> createState() =>
      _AcademicCalendarContainerState();
}

class _AcademicCalendarContainerState extends State<AcademicCalendarContainer> {
  bool isApplicationItemAnimationOn = false;

  DateTime? _selectedDay;

  // Time now
  late DateTime _now = DateTime.now();

  late DateTime firstDay = DateTime(_now.year, _now.month, 1);
  late DateTime lastDay = DateTime(
    _now.year,
    _now.month + 1,
    1,
  ).subtract(const Duration(days: 1));

  late List<AcademicCalendar> listAcademicCalendar = [];
  PageController? _calendarPageController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _fetchAcademicCalendarThisMonth(),
    );
  }

  void _fetchAcademicCalendarThisMonth({bool forceRefresh = false}) {
    final studentDetails = context.read<AuthCubit>().getStudentDetails;
    context.read<AcademicCalendarCubit>().fetchCustomAcademicCalendar(
      year: _now.year,
      month: _now.month,
      unit: studentDetails.unit!,
      forceRefresh: forceRefresh,
    );

    final academicState = context.read<AcademicCalendarCubit>().state;
    academicState.maybeWhen(
      success: (apiList, year, month, lastUpdated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          updateMonthViceAcademicCalendar();
        });
      },
      orElse: () {},
    );
  }

  bool _disableChangeNextMonthButton() {
    final now = DateTime.now();

    return _now.year == now.year && _now.month == now.month;
  }

  void updateMonthViceAcademicCalendar() {
    final academicCalendarState = context.read<AcademicCalendarCubit>().state;

    final List<AcademicCalendar> dataAcademicCalendar = academicCalendarState
        .maybeWhen(
          success: (listAcademicCalendar, year, month, lastUpdated) =>
              listAcademicCalendar,
          orElse: () => [],
        );

    final List<AcademicCalendar> filtered = [];

    for (final academicCalendar in dataAcademicCalendar) {
      final dt = DateTime.tryParse(academicCalendar.tanggalMulai);
      if (dt != null && dt.month == _now.month && dt.year == _now.year) {
        filtered.add(academicCalendar);
      }
    }

    filtered.sort((first, second) {
      final a = DateTime.tryParse(first.tanggalMulai) ?? DateTime(0);
      final b = DateTime.tryParse(second.tanggalMulai) ?? DateTime(0);
      return a.compareTo(b);
    });

    setState(() {
      listAcademicCalendar = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      edgeOffset: Utils.getScrollViewTopPadding(
        context: context,
        appBarHeightPercentage: 0.19,
      ),
      onRefresh: () async {
        _fetchAcademicCalendarThisMonth(forceRefresh: true);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Stack(
          children: [
            _buildAppBar(),
            _buildHolidaysCalendar(),
            _buildPreviousNextButtonContainer(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHolidayDetailsList() {
    return Column(
      children: List.generate(
        listAcademicCalendar.length,
        (index) => Animate(
          key: isApplicationItemAnimationOn ? UniqueKey() : null,
          effects: listItemAppearanceEffects(
            itemIndex: index,
            totalLoadedItems: listAcademicCalendar.length,
          ),
          child: CustomContainer(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            width: MediaQuery.of(context).size.width * (0.85),
            child: LayoutBuilder(
              builder: (context, boxConstraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            listAcademicCalendar[index].judul,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        Text(
                          Utils.formatToDayMonthYear(
                            DateTime.tryParse(
                              listAcademicCalendar[index].tanggalMulai,
                            )!,
                          ),
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: listAcademicCalendar[index].keterangan.isEmpty
                          ? 0
                          : 2.5,
                    ),
                    listAcademicCalendar[index].keterangan.isEmpty
                        ? const SizedBox()
                        : Text(
                            listAcademicCalendar[index].keterangan,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 11.5,
                            ),
                          ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarContainer({
    required List<AcademicCalendar> listAcademicCalendar,
  }) {
    return CustomContainer(
      padding: const EdgeInsets.all(16),
      child: TableCalendar(
        headerVisible: false,
        daysOfWeekHeight: 40,
        onPageChanged: (DateTime dateTime) {
          setState(() {
            _now = dateTime;
            firstDay = DateTime(dateTime.year, dateTime.month, 1);
            lastDay = DateTime(
              dateTime.year,
              dateTime.month + 1,
              1,
            ).subtract(const Duration(days: 1));
          });
          updateMonthViceAcademicCalendar();
        },

        onCalendarCreated: (contoller) {
          _calendarPageController = contoller;
        },

        holidayPredicate: (dateTime) {
          try {
            return listAcademicCalendar.indexWhere((ev) {
                  final dt = DateTime.tryParse(ev.tanggalMulai);
                  return dt != null && isSameDay(dt, dateTime);
                }) !=
                -1;
          } catch (_) {
            return false;
          }
        },

        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            final hasEvent = listAcademicCalendar.any((ev) {
              final dt = DateTime.tryParse(ev.tanggalMulai);
              return dt != null && isSameDay(dt, date);
            });

            if (!hasEvent) return null;

            return Positioned(
              bottom: 6,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),

        onDaySelected: (selected, focused) {
          setState(() {
            _selectedDay = selected;
            _now = focused;
          });

          final eventsForSelectedDay = listAcademicCalendar.where((ev) {
            final dt = DateTime.tryParse(ev.tanggalMulai);
            return dt != null && isSameDay(dt, selected);
          }).toList();

          setState(() {
            isApplicationItemAnimationOn = !isApplicationItemAnimationOn;
          });

          _showAcademicBottomSheet(
            eventsForSelectedDay.isNotEmpty
                ? eventsForSelectedDay
                : [AcademicCalendar.empty(date: selected)],
          ).then((_) {
            setState(() {
              isApplicationItemAnimationOn = !isApplicationItemAnimationOn;
            });
          });
        },

        availableGestures: AvailableGestures.none,
        calendarStyle: CalendarStyle(
          weekendTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.error,
          ),
          defaultTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          todayDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          holidayDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            shape: BoxShape.circle,
          ),
          holidayTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),

        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
          weekendStyle: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontWeight: FontWeight.w700,
          ),
        ),
        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
        ),
        firstDay: firstDay,

        lastDay: lastDay,

        focusedDay: _now,
      ),
    );
  }

  Widget _buildHolidaysCalendar() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: Utils.getScrollViewBottomPadding(context),
        top: Utils.getScrollViewTopPadding(
          context: context,
          appBarHeightPercentage: 0.001,
        ),
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left:
                MediaQuery.of(context).size.width *
                Utils.screenContentHorizontalPaddingInPercentage,
            right:
                MediaQuery.of(context).size.width *
                Utils.screenContentHorizontalPaddingInPercentage,
            bottom: Utils.getScrollViewBottomPadding(context),
            top: Utils.getScrollViewTopPadding(
              context: context,
              appBarHeightPercentage: Utils.appBarMediumHeightPercentage,
            ),
          ),
          child: BlocConsumer<AcademicCalendarCubit, AcademicCalendarState>(
            listener: (context, state) {
              state.maybeWhen(
                success: (_, __, ___, ____) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    updateMonthViceAcademicCalendar();
                  });
                },
                orElse: () {},
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                success: (listAcademicCalendar, year, month, lastUpdated) {
                  return Column(
                    children: [
                      _buildCalendarContainer(
                        listAcademicCalendar: listAcademicCalendar,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * (0.025),
                      ),
                      _buildHolidayDetailsList(),
                    ],
                  );
                },
                failure: (errorMessage) => Center(
                  child: ErrorContainer(
                    errorMessageCode: errorMessage,
                    onTapRetry: () => updateMonthViceAcademicCalendar(),
                  ),
                ),
                orElse: () => Column(
                  children: [
                    const SizedBox(height: 20),
                    ShimmerLoadingContainer(
                      child: CustomShimmerContainer(
                        height: MediaQuery.of(context).size.height * (0.425),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return ScreenTopBackgroundContainer(
      heightPercentage: Utils.appBarMediumHeightPercentage,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              Utils.getTranslatedLabel(academicCalendarKey),
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

  Widget _buildPreviousNextButtonContainer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Utils.getScrollViewTopPadding(
          context: context,
          appBarHeightPercentage: 0.125,
        ),
        left: 24,
        right: 24,
      ),
      child: CustomContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ChangeCalendarMonthButton(
              onTap: () {
                final academicCalendarState = context
                    .read<AcademicCalendarCubit>()
                    .state;

                final isLoading = academicCalendarState.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                );

                if (isLoading) return;

                final previousMonth = DateTime(_now.year, _now.month - 1);

                setState(() {
                  _now = previousMonth;

                  firstDay = DateTime(
                    previousMonth.year,
                    previousMonth.month,
                    1,
                  );
                  lastDay = DateTime(
                    previousMonth.year,
                    previousMonth.month + 1,
                    1,
                  ).subtract(const Duration(days: 1));
                });

                _fetchAcademicCalendarThisMonth(forceRefresh: true);

                _calendarPageController?.previousPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
              isDisable: false,
              icon: Icons.keyboard_arrow_left,
            ),

            Text(
              Utils.formatToMonthYear(_now),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            ChangeCalendarMonthButton(
              onTap: () {
                if (_disableChangeNextMonthButton()) return;

                final academicCalendarState = context
                    .read<AcademicCalendarCubit>()
                    .state;

                final isLoading = academicCalendarState.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                );

                if (isLoading) return;

                final nextMonth = DateTime(_now.year, _now.month + 1);

                setState(() {
                  _now = nextMonth;

                  firstDay = DateTime(nextMonth.year, nextMonth.month, 1);
                  lastDay = DateTime(
                    nextMonth.year,
                    nextMonth.month + 1,
                    1,
                  ).subtract(const Duration(days: 1));
                });

                _fetchAcademicCalendarThisMonth(forceRefresh: true);

                _calendarPageController?.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
              isDisable: _disableChangeNextMonthButton(),
              icon: _disableChangeNextMonthButton()
                  ? Icons.close
                  : Icons.keyboard_arrow_right,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAcademicBottomSheet(
    List<AcademicCalendar> academicCalendarList,
  ) {
    if (academicCalendarList.isEmpty) return Future.value();

    final DateTime? firstStart = DateTime.tryParse(
      academicCalendarList.first.tanggalMulai,
    );
    final String dateHeader = firstStart != null
        ? Utils.formatDateTwo(firstStart)
        : "";

    return showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (c) {
        final maxHeight = MediaQuery.of(context).size.height * 0.75;

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Utils.getTranslatedLabel(detailsEventsKey),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),

                    CustomChipContainer(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      child: Text(
                        dateHeader,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Text(
                  "${academicCalendarList.length} ${Utils.getTranslatedLabel(eventKey)}",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: academicCalendarList.isEmpty
                      ? Center(
                          child: Text(
                            Utils.getTranslatedLabel(noEventKey),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: academicCalendarList.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final ev = academicCalendarList[index];

                            final start = DateTime.tryParse(ev.tanggalMulai);
                            final end = DateTime.tryParse(ev.tanggalSelesai);

                            final rangeText = (start != null && end != null)
                                ? "${Utils.formatDateTwo(start)} - ${Utils.formatDateTwo(end)}"
                                : (start != null
                                      ? Utils.formatDateTwo(start)
                                      : "");

                            return CustomContainer(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          ev.judul,
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                      if (rangeText.isNotEmpty)
                                        Text(
                                          rangeText,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurfaceVariant,
                                              ),
                                        ),
                                    ],
                                  ),
                                  if (ev.keterangan.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      ev.keterangan,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
