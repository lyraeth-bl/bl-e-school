import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExtracurricularContainer extends StatefulWidget {
  const ExtracurricularContainer({super.key});

  @override
  State<ExtracurricularContainer> createState() =>
      _ExtracurricularContainerState();
}

class _ExtracurricularContainerState extends State<ExtracurricularContainer> {
  final Map<String, bool> _expandedSession = {};

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _fetchExtracurricular(),
    );
    super.initState();
  }

  void _fetchExtracurricular() async {
    final nis = context.read<AuthCubit>().getStudentDetails.nis;

    context.read<ExtracurricularBloc>().add(
      ExtracurricularEvent.fetchExtracurricular(nis: nis),
    );
  }

  void _refreshData() async {
    final nis = context.read<AuthCubit>().getStudentDetails.nis;

    context.read<ExtracurricularBloc>().add(
      ExtracurricularEvent.refresh(nis: nis),
    );
  }

  Color colorForGrades(BuildContext context, String grades) {
    final grade = grades.toUpperCase();

    switch (grade) {
      case "A":
        return const Color(0xFF2E7D32).withValues(alpha: 0.2);
      case "B":
        return const Color(0xFF1565C0).withValues(alpha: 0.2);
      case "C":
        return const Color(0xFFF9A825).withValues(alpha: 0.2);
      case "D":
      case "E":
        return const Color(0xFFC62828).withValues(alpha: 0.2);
      default:
        return const Color(0xFF9E9E9E).withValues(alpha: 0.2);
    }
  }

  Map<String, List<Extracurricular>> groupBySession(
    List<Extracurricular> list,
  ) {
    final Map<String, List<Extracurricular>> grouped = {};

    for (final item in list) {
      grouped.putIfAbsent(item.tajaran, () => []);
      grouped[item.tajaran]!.add(item);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 80,
        title: Text(
          Utils.getTranslatedLabel(extracurricularKey),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      body: BlocListener<ExtracurricularBloc, ExtracurricularState>(
        listener: (context, state) {
          state.maybeWhen(
            failure: (errorMessage) =>
                ErrorContainer(errorMessageCode: errorMessage),
            orElse: () {},
          );
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: RefreshIndicator(
            onRefresh: () async => _refreshData(),
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
                  BlocBuilder<ExtracurricularBloc, ExtracurricularState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        success: (extracurricularList) {
                          final groupedData = groupBySession(
                            extracurricularList,
                          );

                          final sortedKeys = groupedData.keys.toList()
                            ..sort((a, b) => b.compareTo(a));

                          for (final key in sortedKeys) {
                            _expandedSession.putIfAbsent(
                              key,
                              () => key == sortedKeys.first,
                            );
                          }

                          return Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: groupedData.entries.map((entry) {
                                final tajaran = entry.key;
                                final items = entry.value;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () {
                                        setState(() {
                                          _expandedSession[tajaran] =
                                              !(_expandedSession[tajaran] ??
                                                  true);
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 8,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${Utils.getTranslatedLabel(yearKey)} $tajaran",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                            AnimatedRotation(
                                              turns:
                                                  (_expandedSession[tajaran] ??
                                                      true)
                                                  ? 0.5
                                                  : 0,
                                              duration: const Duration(
                                                milliseconds: 200,
                                              ),
                                              child: const Icon(
                                                Icons.expand_more,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    AnimatedCrossFade(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      crossFadeState:
                                          (_expandedSession[tajaran] ?? true)
                                          ? CrossFadeState.showFirst
                                          : CrossFadeState.showSecond,
                                      firstChild: Column(
                                        children: items
                                            .map(
                                              (extra) => ListTile(
                                                leading: CircleAvatar(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .tertiaryContainer,
                                                  child: Icon(
                                                    Utils.iconForExtracurricular(
                                                      extra.namaKegiatan,
                                                    ),
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onTertiaryContainer,
                                                  ),
                                                ),
                                                title: Text(
                                                  extra.namaKegiatan,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.onSurface,
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${Utils.getTranslatedLabel(classKey)}: ${extra.kelas} ${extra.nomorKelas}",
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      "${Utils.getTranslatedLabel(yearKey)}: ${extra.tajaran} (${extra.semester})",
                                                    ),
                                                  ],
                                                ),
                                                trailing: CircleAvatar(
                                                  backgroundColor:
                                                      colorForGrades(
                                                        context,
                                                        extra.nilai,
                                                      ),
                                                  child: Text(extra.nilai),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                      secondChild: const SizedBox.shrink(),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          );
                        },
                        loading: () =>
                            Center(child: CircularProgressIndicator()),
                        orElse: () => const SizedBox.shrink(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
