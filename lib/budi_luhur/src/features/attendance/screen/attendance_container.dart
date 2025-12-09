import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceContainer extends StatefulWidget {
  const AttendanceContainer({super.key});

  @override
  State<AttendanceContainer> createState() => _AttendanceContainerState();
}

class _AttendanceContainerState extends State<AttendanceContainer> {
  // Selected Day
  DateTime? _selectedDay;

  // Temporary daily attendance data
  DailyAttendance? _selectedDailyAttendance;

  // Time now
  late DateTime _now = DateTime.now();

  // First day on month
  late DateTime firstDayOfMonth = DateTime(_now.year, _now.month, 1);

  // Last day on month
  late DateTime lastDayOfMonth = (_now.month < 12)
      ? DateTime(_now.year, _now.month + 1, 1).subtract(const Duration(days: 1))
      : DateTime(_now.year + 1, 1, 1).subtract(const Duration(days: 1));

  // Page Controller
  PageController? _calendarController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCurrentMonthDailyAttendanceData();
    });

    super.initState();
  }

  // Method

  // warna untuk tiap status
  Color _colorForStatus(String? status, BuildContext ctx) {
    final scheme = Theme.of(ctx).colorScheme;
    switch (status) {
      case 'Hadir':
        return scheme.primary;
      case 'Sakit':
        return Colors.orange;
      case 'Izin':
        return Colors.amber;
      case 'Alpha':
        return scheme.error;
      default:
        return scheme.onSurface.withValues(alpha: 0.25);
    }
  }

  void _fetchCurrentMonthDailyAttendanceData({bool forceRefresh = false}) {
    final authDetails = context.read<AuthCubit>().getStudentDetails;

    context.read<FetchDailyAttendanceCubit>().fetchCustomDailyAttendanceUser(
      nis: authDetails.nis,
      year: _now.year,
      month: _now.month,
      unit: authDetails.unit ?? "SMAKT",
      forceRefresh: forceRefresh,
    );
  }

  // Logic for disable next month button
  bool _disableChangeNextMonthButton() {
    final now = DateTime.now();

    return _now.year == now.year && _now.month == now.month;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      edgeOffset: Utils.getScrollViewTopPadding(
        context: context,
        appBarHeightPercentage: 0.19,
      ),
      onRefresh: () async {
        _fetchCurrentMonthDailyAttendanceData(forceRefresh: true);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Stack(
          children: [
            _buildAppBar(),
            _buildPreviousNextButtonContainer(context),
            _buildCalendarOnly(),
          ],
        ),
      ),
    );
  }

  // UI
  Widget _buildAppBar() {
    return ScreenTopBackgroundContainer(
      heightPercentage: Utils.appBarMediumHeightPercentage,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              Utils.getTranslatedLabel(attendanceKey),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: Utils.screenTitleFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          CustomBackButton(),
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
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ChangeCalendarMonthButton(
              isDisable: false,
              icon: Icons.keyboard_arrow_left,
              onTap: () {
                final previousMonth = DateTime(_now.year, _now.month - 1);

                setState(() {
                  _now = previousMonth;

                  firstDayOfMonth = DateTime(
                    previousMonth.year,
                    previousMonth.month,
                    1,
                  );
                  lastDayOfMonth = DateTime(
                    previousMonth.year,
                    previousMonth.month + 1,
                    1,
                  ).subtract(const Duration(days: 1));
                });

                // Fetch bulan sebelumnya
                _fetchCurrentMonthDailyAttendanceData();

                // Animasi jika controller ada
                _calendarController?.previousPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            ),

            Text(
              Utils.formatToMonthYear(_now),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            ChangeCalendarMonthButton(
              isDisable: _disableChangeNextMonthButton(),
              icon: _disableChangeNextMonthButton()
                  ? Icons.close
                  : Icons.keyboard_arrow_right,
              onTap: () {
                if (_disableChangeNextMonthButton()) return;

                final nextMonth = DateTime(_now.year, _now.month + 1);

                setState(() {
                  _now = nextMonth;

                  firstDayOfMonth = DateTime(
                    nextMonth.year,
                    nextMonth.month,
                    1,
                  );
                  lastDayOfMonth = DateTime(
                    nextMonth.year,
                    nextMonth.month + 1,
                    1,
                  ).subtract(const Duration(days: 1));
                });

                // Fetch bulan berikutnya
                _fetchCurrentMonthDailyAttendanceData();

                // Animasi jika controller ada
                _calendarController?.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarOnly() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: Utils.getScrollViewBottomPadding(context),
        top: Utils.getScrollViewTopPadding(
          context: context,
          appBarHeightPercentage: 0.19,
        ),
      ),
      child: BlocBuilder<FetchDailyAttendanceCubit, FetchDailyAttendanceState>(
        builder: (c, s) {
          return s.maybeWhen(
            failure: (errorMessage) => ErrorContainer(
              errorMessageCode: errorMessage,
              showErrorImage: false,
              onTapRetry: () => _fetchCurrentMonthDailyAttendanceData(),
            ),
            success: (dailyAttendanceList, _, _, lastUpdated) {
              final hadirCount = dailyAttendanceList
                  .where((d) => d.status == 'Hadir')
                  .length;
              final terlambatCount = dailyAttendanceList
                  .where((d) => d.status == 'Terlambat')
                  .length;
              final sakitCount = dailyAttendanceList
                  .where((d) => d.status == 'Sakit')
                  .length;
              final izinCount = dailyAttendanceList
                  .where((d) => d.status == 'Izin')
                  .length;
              final alphaCount = dailyAttendanceList
                  .where((d) => d.status == 'Alpha')
                  .length;

              final Map<String, double> pieData = {};
              if (hadirCount > 0) pieData['Hadir'] = hadirCount.toDouble();
              if (terlambatCount > 0) {
                pieData['Terlambat'] = terlambatCount.toDouble();
              }
              if (sakitCount > 0) pieData['Sakit'] = sakitCount.toDouble();
              if (izinCount > 0) pieData['Izin'] = izinCount.toDouble();
              if (alphaCount > 0) pieData['Alpha'] = alphaCount.toDouble();

              final order = ['Hadir', 'Terlambat', 'Sakit', 'Izin', 'Alpha'];

              final presentDays = dailyAttendanceList
                  .where(
                    (status) =>
                        status.status == "Hadir" ||
                        status.status == "Terlambat",
                  )
                  .toList();
              final absentDays = dailyAttendanceList
                  .where(
                    (status) =>
                        status.status == "Alpha" ||
                        status.status == "Sakit" ||
                        status.status == "Izin",
                  )
                  .toList();

              return Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Column(
                  children: [
                    _buildCalendarContainer(
                      dailyAttendanceList: dailyAttendanceList,
                      presentDays: presentDays,
                      absentDays: absentDays,
                    ),

                    _buildLastFetchData(timeUpdate: lastUpdated),

                    if (hadirCount != 0 ||
                        terlambatCount != 0 ||
                        alphaCount != 0 ||
                        sakitCount != 0 ||
                        izinCount != 0 && pieData.isNotEmpty)
                      AttendanceCharts(data: pieData, order: order),
                  ],
                ),
              );
            },
            orElse: () => AttendanceShimmer(),
          );
        },
      ),
    );
  }

  Widget _buildLastFetchData({required DateTime timeUpdate}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              "Last updated: ${Utils.formatDaysAndTime(timeUpdate, locale: "id_ID")}",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarContainer({
    required List<DailyAttendance> dailyAttendanceList,
    required List<DailyAttendance> presentDays,
    required List<DailyAttendance> absentDays,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TableCalendar(
        focusedDay: _now,
        firstDay: firstDayOfMonth,
        lastDay: lastDayOfMonth,
        headerVisible: false,
        daysOfWeekHeight: 24,
        onPageChanged: (DateTime dateTime) {
          setState(() {
            _now = dateTime;
            firstDayOfMonth = DateTime(dateTime.year, dateTime.month, 1);
            lastDayOfMonth = DateTime(
              dateTime.year,
              dateTime.month + 1,
              1,
            ).subtract(const Duration(days: 1));

            context
                .read<FetchDailyAttendanceCubit>()
                .fetchCustomDailyAttendanceUser(
                  nis: context.read<AuthCubit>().getStudentDetails.nis,
                  year: dateTime.year,
                  month: dateTime.month,
                  unit:
                      context.read<AuthCubit>().getStudentDetails.unit ??
                      "SMAKT",
                );
          });
        },
        onCalendarCreated: (controller) {
          _calendarController = controller;
        },
        selectedDayPredicate: (dateTime) {
          return absentDays.indexWhere(
                (date) =>
                    Utils.formatDate(dateTime) ==
                    Utils.formatDate(date.tanggal),
              ) !=
              -1;
        },
        holidayPredicate: (dateTime) {
          return presentDays.indexWhere(
                (date) =>
                    Utils.formatDate(dateTime) ==
                    Utils.formatDate(date.tanggal),
              ) !=
              -1;
        },
        availableGestures: AvailableGestures.none,
        onDaySelected: (selected, focused) {
          setState(() {
            _selectedDay = selected;
            _now = focused;

            _selectedDailyAttendance = dailyAttendanceList.firstWhere(
              (date) => isSameDay(date.tanggal.toLocal(), selected),
              orElse: () => DailyAttendance.fromJson({}),
            );
          });

          final selectedAttendance = dailyAttendanceList.firstWhere(
            (date) => isSameDay(date.tanggal.toLocal(), selected),
            orElse: () => DailyAttendance.fromJson({}),
          );

          _showAttendanceBottomSheet(selectedAttendance);
        },

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

        // custom markers: small dot with status color
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            // find attendance for this date
            final a = (dailyAttendanceList.where(
              (d) => Utils.formatDate(d.tanggal) == Utils.formatDate(date),
            )).toList();
            if (a.isEmpty) return null;

            // if multiple records, show up to 2 small dots
            final List<Widget> dots = a.take(2).map((d) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 1),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _colorForStatus(d.status, context),
                  shape: BoxShape.circle,
                ),
              );
            }).toList();

            return Positioned(bottom: 6, child: Row(children: dots));
          },
        ),
      ),
    );
  }

  void _showAttendanceBottomSheet(DailyAttendance dailyAttendance) {
    showModalBottomSheet(
      useSafeArea: true,
      showDragHandle: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (c) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Utils.formatDays(
                  _selectedDay ?? DateTime.now(),
                  locale: "id_ID",
                ),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),

              SizedBox(height: 24),

              // Divider(
              //   color: Theme.of(context).colorScheme.outlineVariant,
              //   height: 32,
              //   thickness: 1.5,
              //   radius: BorderRadius.circular(16),
              // ),
              if (dailyAttendance.status.isNotEmpty) ...[
                Text(
                  "Keterangan",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  dailyAttendance.alasan ?? dailyAttendance.status,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),

                SizedBox(height: 24),

                // Divider(
                //   color: Theme.of(context).colorScheme.outlineVariant,
                //   height: 32,
                //   thickness: 1.5,
                //   radius: BorderRadius.circular(16),
                // ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Jam Check-in",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            dailyAttendance.jamCheckIn != null
                                ? Utils.formatTime(
                                    dailyAttendance.jamCheckIn!.toLocal(),
                                  )
                                : "-",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jam Check-out',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dailyAttendance.jamCheckOut != null
                                ? Utils.formatTime(
                                    dailyAttendance.jamCheckOut!.toLocal(),
                                  )
                                : "-",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ] else
                Text(
                  "Tidak ada data kehadiran",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
            ],
          ),
        );
      },
    );
  }
}
