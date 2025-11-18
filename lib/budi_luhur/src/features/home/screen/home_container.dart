import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';

class HomeContainer extends StatelessWidget {
  // Need this flag in order to show the homeContainer
  // in background when bottom menu is open
  // If it is just for background showing purpose then it will not reactive or not making any api call
  final bool isForBottomMenuBackground;

  const HomeContainer({super.key, required this.isForBottomMenuBackground});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [_buildHomeContent(context), _buildAppBarHome()]);
  }

  Widget _buildAppBarHome() {
    return Align(
      alignment: Alignment.topCenter,
      child: HomeContainerTopProfileContainer(),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
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
          HomeScheduleCard(),
        ],
      ),
    );
  }
}
