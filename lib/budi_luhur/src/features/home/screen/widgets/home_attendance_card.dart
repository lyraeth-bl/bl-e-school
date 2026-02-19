import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
          child: CustomContainer(
            shadowsOffset: Offset(5, 5),
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
                      CustomChipContainer(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.secondaryContainer,
                        child: Text(
                          Utils.formatToDayMonthYear(
                            DateTime.now(),
                            locale: "id_ID",
                          ),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondaryContainer,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  children: [
                    CustomAttendanceContainer(
                      icon: LucideIcons.logIn,
                      textKey: checkInKey,
                      value: checkInText,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      foregroundColor: Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer,
                    ),

                    CustomAttendanceContainer(
                      isCheckOut: true,
                      icon: LucideIcons.logOut,
                      textKey: checkOutKey,
                      value: checkOutText,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.errorContainer,
                      foregroundColor: Theme.of(
                        context,
                      ).colorScheme.onErrorContainer,
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

class CustomAttendanceContainer extends StatelessWidget {
  const CustomAttendanceContainer({
    super.key,
    this.backgroundColor,
    required this.icon,
    this.foregroundColor,
    required this.textKey,
    required this.value,
    this.isCheckOut = false,
  }) : assert(
         !(backgroundColor != null &&
             foregroundColor != null &&
             backgroundColor == foregroundColor),
         "You cannot use same color on backgroundColor and foregroundColor, use onBackgroundColor on foregroundColor",
       );

  final Color? backgroundColor;

  final IconData icon;

  final Color? foregroundColor;

  final String textKey;

  final String value;

  final bool isCheckOut;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        margin: isCheckOut
            ? const EdgeInsets.only(right: 16, left: 8)
            : const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            Icon(icon, color: foregroundColor),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: foregroundColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  Utils.getTranslatedLabel(textKey),
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(color: foregroundColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
