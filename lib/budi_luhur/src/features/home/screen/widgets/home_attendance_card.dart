import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class HomeAttendanceCard extends StatelessWidget {
  const HomeAttendanceCard({super.key});

  String formatOrDash(DateTime? time) {
    if (time == null) return "-";
    return Utils.formatTime(time);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DailyAttendanceCubit, DailyAttendanceState>(
      listener: (context, state) {
        state.maybeWhen(
          hasData:
              (dailyAttendance, hasPost, hasCheckIn, hasCheckOut, lastUpdate) =>
                  context
                      .read<DailyAttendanceCubit>()
                      .updateDailyAttendanceData(dailyAttendance),
          orElse: () {},
        );
      },
      child: InkWell(
        onTap: () {
          Get.toNamed(BudiLuhurRoutes.studentAttendance);
        },
        child: Card(
          color: Theme.of(context).colorScheme.secondaryContainer,
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Utils.getTranslatedLabel(attendanceKey),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Text(
                      Utils.formatDays(DateTime.now(), locale: "id_ID"),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(
                color: Theme.of(
                  context,
                ).colorScheme.outlineVariant.withValues(alpha: 0.5),
                indent: 16,
                endIndent: 16,
              ),

              SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.login,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSecondaryContainer,
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BlocBuilder<
                                DailyAttendanceCubit,
                                DailyAttendanceState
                              >(
                                builder: (context, state) {
                                  return state.maybeWhen(
                                    hasData:
                                        (
                                          dailyAttendance,
                                          hasPost,
                                          hasCheckIn,
                                          hasCheckOut,
                                          lastUpdate,
                                        ) {
                                          final checkIn = formatOrDash(
                                            dailyAttendance.jamCheckIn,
                                          );
                                          return Text(
                                            checkIn,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondaryContainer,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          );
                                        },
                                    orElse: () => Text(
                                      "-",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onPrimaryFixed,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 4),
                              Text(
                                Utils.getTranslatedLabel(checkInKey),
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryFixed,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  VerticalDivider(color: Theme.of(context).colorScheme.outline),

                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSecondaryContainer,
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BlocBuilder<
                                DailyAttendanceCubit,
                                DailyAttendanceState
                              >(
                                builder: (context, state) {
                                  return state.maybeWhen(
                                    hasData:
                                        (
                                          dailyAttendance,
                                          hasPost,
                                          hasCheckIn,
                                          hasCheckOut,
                                          lastUpdate,
                                        ) {
                                          final checkIn = formatOrDash(
                                            dailyAttendance.jamCheckOut,
                                          );
                                          return Text(
                                            checkIn,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondaryContainer,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          );
                                        },
                                    orElse: () => Text(
                                      "-",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onPrimaryFixed,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 4),
                              Text(
                                Utils.getTranslatedLabel(checkOutKey),
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryFixed,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
