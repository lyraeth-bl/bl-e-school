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
    return BlocConsumer<DailyAttendanceCubit, DailyAttendanceState>(
      listener: (context, state) {
        state.maybeWhen(
          hasData:
              (
                DailyAttendance? dailyAttendance,
                bool hasPost,
                bool hasCheckIn,
                bool hasCheckOut,
                DateTime? lastUpdate,
              ) {
                if (dailyAttendance != null) {
                  context
                      .read<DailyAttendanceCubit>()
                      .updateDailyAttendanceData(dailyAttendance);
                }
              },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final checkInText = state.maybeWhen(
          hasData:
              (
                DailyAttendance? dailyAttendance,
                bool hasPost,
                bool hasCheckIn,
                bool hasCheckOut,
                DateTime? lastUpdate,
              ) {
                return formatOrDash(dailyAttendance?.jamCheckIn?.toLocal());
              },
          orElse: () => "-",
        );

        final checkOutText = state.maybeWhen(
          hasData:
              (
                DailyAttendance? dailyAttendance,
                bool hasPost,
                bool hasCheckIn,
                bool hasCheckOut,
                DateTime? lastUpdate,
              ) {
                return formatOrDash(dailyAttendance?.jamCheckOut?.toLocal());
              },
          orElse: () => "-",
        );

        return InkWell(
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
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
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

                const SizedBox(height: 8),

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
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  checkInText,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSecondaryContainer,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 4),
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
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  checkOutText,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSecondaryContainer,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 4),
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
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
