import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisciplineContainer extends StatefulWidget {
  const DisciplineContainer({super.key});

  @override
  State<DisciplineContainer> createState() => _DisciplineContainerState();
}

class _DisciplineContainerState extends State<DisciplineContainer> {
  final List<Widget> _screens = [MeritScreen(), DemeritScreen()];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchMeritAndDemerit();
    });

    super.initState();
  }

  Future<void> _fetchMeritAndDemerit() async {
    final nis = context.read<AuthCubit>().getStudentDetails.nis;

    context.read<DisciplineBloc>().add(DisciplineEvent.load(nis: nis));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 80,
          title: Text(
            Utils.getTranslatedLabel(meritAndDemeritKey),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  Utils.getTranslatedLabel(meritKey),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  Utils.getTranslatedLabel(demeritKey),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
            splashBorderRadius: BorderRadius.circular(8),
            dividerColor: Colors.transparent,
          ),
        ),
        body: TabBarView(children: _screens),
      ),
    );
  }
}
