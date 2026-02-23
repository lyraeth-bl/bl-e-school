import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MeritScreen extends StatefulWidget {
  const MeritScreen({super.key});

  @override
  State<MeritScreen> createState() => _MeritScreenState();
}

class _MeritScreenState extends State<MeritScreen> {
  String? _selectedSession;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DisciplineBloc, DisciplineState>(
      listener: (context, state) {
        state.whenOrNull(
          error: (message) {
            return ErrorContainer(errorMessageCode: message);
          },
        );
      },
      child: RefreshIndicator(
        onRefresh: () async {
          final nis = context.read<AuthCubit>().getStudentDetails.nis;

          context.read<DisciplineBloc>().add(DisciplineEvent.refresh(nis: nis));
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 24,
            top: 24,
            right: 24,
            bottom: Utils.getScrollViewBottomPadding(context),
          ),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer(
                padding: const EdgeInsets.all(16),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Utils.getTranslatedLabel(startingMeritPointsKey),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),

                            SizedBox(height: 24),

                            CircleNumberIndicator(
                              value: 0,
                              progress: 0,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              valueColor: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                      ),

                      VerticalDivider(
                        color: Theme.of(context).colorScheme.outline,
                        thickness: 0.1,
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              Utils.getTranslatedLabel(currentMeritPointsKey),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),

                            SizedBox(height: 24),

                            BlocSelector<DisciplineBloc, DisciplineState, int?>(
                              selector: (state) => state.maybeWhen(
                                loaded:
                                    (
                                      meritList,
                                      demeritList,
                                      totalMerit,
                                      totalDemerit,
                                    ) => totalMerit,
                                orElse: () => 0,
                              ),

                              builder: (context, totalMerit) =>
                                  CircleNumberIndicator(
                                    value: totalMerit!,
                                    progress: (totalMerit / totalMerit).clamp(
                                      0.0,
                                      1.0,
                                    ),
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                    valueColor: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    enableAnimation: true,
                                  ),
                            ),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              BlocBuilder<DisciplineBloc, DisciplineState>(
                builder: (context, state) {
                  final schoolSessionList = state.maybeWhen(
                    loaded: (meritList, _, _, _) => meritList
                        .map((merit) => merit.schoolSession)
                        .toSet()
                        .toList(),
                    orElse: () => [],
                  );

                  if (schoolSessionList.isEmpty) {
                    return const SizedBox();
                  }

                  _selectedSession ??= schoolSessionList.first;

                  return SizedBox(
                    height: 32,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemCount: schoolSessionList.length,
                      itemBuilder: (context, index) {
                        final session = schoolSessionList[index];
                        final isSelected = session == _selectedSession;

                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedSession = session);
                          },
                          child: CustomContainer(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            enableShadow: false,
                            backgroundColor: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : null,
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(
                                      context,
                                    ).colorScheme.outlineVariant,
                            ),
                            child: Text(
                              session.toString(),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: isSelected
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onPrimary
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              BlocBuilder<DisciplineBloc, DisciplineState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    loaded: (meritList, _, _, _) {
                      final filteredList = meritList.where((e) {
                        return e.schoolSession == _selectedSession;
                      }).toList();

                      if (filteredList.isEmpty) {
                        return NoDataContainer(titleKey: noDataFoundKey);
                      }

                      return CustomContainer(
                        padding: const EdgeInsets.all(16),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredList.length,
                          separatorBuilder: (_, __) => Divider(
                            color: Theme.of(context).colorScheme.outlineVariant,
                            indent: 56,
                            thickness: 0.5,
                          ),
                          itemBuilder: (context, index) {
                            final data = filteredList[index];
                            return _MeritHistoryItem(data: data);
                          },
                        ),
                      );
                    },
                    orElse: () => const SizedBox(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MeritHistoryItem extends StatelessWidget {
  final Merit data;

  const _MeritHistoryItem({required this.data});

  @override
  Widget build(BuildContext context) {
    final isPositive = data.point >= 0;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isPositive
                  ? Colors.green.withValues(alpha: 0.15)
                  : Colors.red.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPositive ? LucideIcons.trendingUp : LucideIcons.trendingDown,
              size: 18,
              color: isPositive ? Colors.green : Colors.red,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  data.teacherName.trim(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  Utils.formatToDayMonthYear(data.date),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          Text(
            "${isPositive ? '+' : ''}${data.point}",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: isPositive ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
