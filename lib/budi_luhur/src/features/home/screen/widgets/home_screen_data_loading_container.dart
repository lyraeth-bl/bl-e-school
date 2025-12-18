import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';

class HomeScreenDataLoadingContainer extends StatelessWidget {
  final bool addTopPadding;

  const HomeScreenDataLoadingContainer({
    super.key,
    required this.addTopPadding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(
        top: addTopPadding
            ? Utils.getScrollViewTopPadding(
                context: context,
                appBarHeightPercentage: Utils.appBarBiggerHeightPercentage,
              )
            : 25,
      ),
      children: [
        ShimmerLoadingContainer(
          child: CustomShimmerContainer(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * (0.075),
            ),
            width: MediaQuery.of(context).size.width,
            borderRadius: 25,
            height:
                MediaQuery.of(context).size.height *
                Utils.appBarBiggerHeightPercentage * (1.15)
          ),
        ),

        SizedBox(height: MediaQuery.of(context).size.height * (0.025)),

        ShimmerLoadingContainer(
          child: CustomShimmerContainer(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * (0.075),
            ),
            width: MediaQuery.of(context).size.width,
            borderRadius: 25,
            height:
                MediaQuery.of(context).size.height *
                Utils.appBarBiggerHeightPercentage *
                (0.7),
          ),
        ),

        SizedBox(height: MediaQuery.of(context).size.height * (0.025)),

        ShimmerLoadingContainer(
          child: CustomShimmerContainer(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * (0.075),
            ),
            width: MediaQuery.of(context).size.width,
            borderRadius: 25,
            height:
                MediaQuery.of(context).size.height *
                Utils.appBarBiggerHeightPercentage *
                (0.4),
          ),
        ),
      ],
    );
  }
}
