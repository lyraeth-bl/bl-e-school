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
            elevation: 3,
            color: Theme.of(context).colorScheme.surface,
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
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(
                            context,
                          ).colorScheme.tertiaryContainer,
                        ),
                        child: Text(
                          Utils.formatToDayMonthYear(
                            DateTime.now(),
                            locale: "id_ID",
                          ),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onTertiaryContainer,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.only(left: 16, right: 8),
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
                                        ).colorScheme.onSurface,
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
                                        ).colorScheme.onSurfaceVariant,
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
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.only(right: 16, left: 8),
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
                                        ).colorScheme.onSurface,
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
                                        ).colorScheme.onSurfaceVariant,
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
