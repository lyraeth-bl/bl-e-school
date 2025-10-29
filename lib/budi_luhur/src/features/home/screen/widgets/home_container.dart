import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: Utils.getScrollViewTopPadding(
        context: context,
        appBarHeightPercentage: Utils.appBarBiggerHeightPercentage,
      ),
      onRefresh: () async {},
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          top: Utils.getScrollViewTopPadding(
            context: context,
            appBarHeightPercentage: Utils.appBarBiggerHeightPercentage,
          ),
          bottom: Utils.getScrollViewBottomPadding(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildAdvertisementSliders(),
            SizedBox(height: MediaQuery.of(context).size.height * (0.025)),

            // StudentSubjectsContainer(
            //   subjects: subjects,
            //   subjectsTitleKey: mySubjectsKey,
            //   animate: !widget.isForBottomMenuBackground,
            // ),
            // HomeScreenDataLoadingContainer(addTopPadding: true),
          ],
        ),
      ),
    );
  }
}
