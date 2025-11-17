import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:bl_e_school/budi_luhur/src/utils/shared/ui/class_period.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeContainer extends StatefulWidget {
  // Need this flag in order to show the homeContainer
  // in background when bottom menu is open
  // If it is just for background showing purpose then it will not reactive or not making any api call
  final bool isForBottomMenuBackground;

  const HomeContainer({super.key, required this.isForBottomMenuBackground});

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  DateTime? _now;
  String _periodLabel = '';

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _periodLabel = getPeriodFromTime(_now!);
  }

  void _handleTick(DateTime now) {
    final newLabel = getPeriodFromTime(now);
    if (newLabel != _periodLabel) {
      setState(() {
        _now = now;
        _periodLabel = newLabel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [_buildAppBarHome(), _buildHomeContent()]);
  }

  Widget _buildAppBarHome() {
    return Align(
      alignment: Alignment.topCenter,
      child: HomeContainerTopProfileContainer(),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
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
          Card(
            elevation: 4,
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.getTranslatedLabel(scheduleKey),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.tertiaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              _periodLabel,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onTertiaryContainer,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            Utils.getTranslatedLabel(timeKey),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          SizedBox(height: 8),
                          RealTimeClock(onTick: _handleTick),
                        ],
                      ),
                    ],
                  ),
                ),

                Divider(),

                BlocBuilder<TimeTableCubit, TimeTableState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      success: (timeTableList) {
                        final now = DateTime.now();

                        final rawPeriod = _periodLabel.isNotEmpty
                            ? _periodLabel.substring(0, 1)
                            : '';
                        final isNumericPeriod = RegExp(
                          r'^\d+$',
                        ).hasMatch(rawPeriod);

                        final todayStr = Utils.formatNumberDaysToStringDays(
                          now.weekday,
                        ).toLowerCase();

                        final currentMatches = isNumericPeriod
                            ? timeTableList
                                  .where(
                                    (e) =>
                                        e.jamKe == rawPeriod &&
                                        e.hari.toLowerCase() == todayStr,
                                  )
                                  .toList()
                            : <dynamic>[];

                        if (currentMatches.isNotEmpty) {
                          final timeTimeTable = currentMatches.first;
                          return ListTile(
                            title: Row(
                              children: [
                                Icon(Icons.timer, size: 16, color: Colors.red),
                                SizedBox(width: 4),
                                Text(
                                  "${Utils.formatTime(Utils.timeStringToToday(timeTimeTable.jamMulai)!)} - ${Utils.formatTime(Utils.timeStringToToday(timeTimeTable.jamSelesai)!)}",
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.book,
                                      size: 16,
                                      color: Colors.green,
                                    ),
                                    SizedBox(width: 4),
                                    Text(timeTimeTable.namaMataPelajaran),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 16,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 4),
                                    Text(timeTimeTable.namaGuru),
                                  ],
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          );
                        }

                        final upcoming = timeTableList
                            .where(
                              (e) =>
                                  e.hari.toLowerCase() == todayStr &&
                                  (() {
                                    final jamMulaiDt = Utils.timeStringToToday(
                                      e.jamMulai,
                                    );
                                    return jamMulaiDt != null &&
                                        jamMulaiDt.isAfter(now);
                                  })(),
                            )
                            .toList();

                        if (upcoming.isNotEmpty) {
                          upcoming.sort((a, b) {
                            final aDt = Utils.timeStringToToday(a.jamMulai)!;
                            final bDt = Utils.timeStringToToday(b.jamMulai)!;
                            return aDt.compareTo(bDt);
                          });
                          final next = upcoming.first;
                          return ListTile(
                            title: Row(
                              children: [
                                Icon(
                                  Icons.coffee,
                                  size: 16,
                                  color: Colors.orange,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "${Utils.getTranslatedLabel(breakKey)} - ${Utils.getTranslatedLabel(nextClassKey)} : ${next.namaMataPelajaran}",
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      size: 16,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "${Utils.formatTime(Utils.timeStringToToday(next.jamMulai)!)} - ${Utils.formatTime(Utils.timeStringToToday(next.jamSelesai)!)}",
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 16,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 4),
                                    Text(next.namaGuru),
                                  ],
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          );
                        }

                        // Tidak ada jadwal lagi hari ini
                        return ListTile(
                          title: Row(
                            children: [
                              Icon(
                                Icons.free_breakfast,
                                size: 16,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Istirahat / Tidak ada jadwal",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                          subtitle: SizedBox.shrink(),
                        );
                      },
                      orElse: () => Center(child: Text("Tidak ada jadwal")),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
