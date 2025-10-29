import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class StudentOnBoardingScreen extends StatefulWidget {
  const StudentOnBoardingScreen({super.key});

  @override
  State<StudentOnBoardingScreen> createState() =>
      _StudentOnBoardingScreenState();

  static Widget routeInstance() {
    return StudentOnBoardingScreen();
  }
}

class _StudentOnBoardingScreenState extends State<StudentOnBoardingScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DeviceTokenCubit>().postDeviceToken(
        nis: context.read<AuthCubit>().getStudentDetails().nis,
      );
    });

    _checkFirstTimeUser();
  }

  Future<void> _checkFirstTimeUser() async {
    var box = await Hive.openBox(studentBoxKey);
    bool isFirstTime = box.get('isFirstTimeStudent', defaultValue: true);
    if (isFirstTime) {
      await box.put('isFirstTimeStudent', false);

      Future.delayed(Duration(seconds: 5), () {
        Get.offNamedUntil(
          BudiLuhurRoutes.home,
          (Route<dynamic> route) => false,
        );
      });
    } else {
      Get.offNamedUntil(BudiLuhurRoutes.home, (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/bl_logo.png",
              height: context.height * 0.17,
              width: context.width * 0.4,
              fit: BoxFit.fill,
            ),

            SizedBox(height: context.height * 0.03),

            Text(
              'Budi Luhur',
              style: TextStyle(
                fontSize: Utils.screenOnboardingTitleFontSize,
                fontWeight: FontWeight.bold,
                color: Color(0xff22577a),
              ),
            ),

            /// Uncomment this if photos ready
            // GridView.builder(
            //   padding: EdgeInsets.only(top: context.height * 0.03),
            //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,
            //     mainAxisSpacing: 10,
            //     crossAxisSpacing: 8,
            //     mainAxisExtent: context.height * 0.22,
            //   ),
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   itemCount: 4,
            //   itemBuilder: (context, index) {
            //     String? imageUrl = (state.schoolDetails.schoolImages !=
            //         null &&
            //         state.schoolDetails.schoolImages!.length > index)
            //         ? state.schoolDetails.schoolImages![index]
            //         : '';
            //
            //     return ClipRRect(
            //       borderRadius: BorderRadius.circular(10),
            //       child: imageUrl.isNotEmpty
            //           ? NetworkImageHandler(
            //         imageUrl: imageUrl,
            //         fit: BoxFit.fill,
            //         height: context.height * 0.22,
            //         placeholder: Center(
            //           child: CircularProgressIndicator(),
            //         ),
            //         errorWidget: SvgPicture.asset(
            //           Utils.getImagePath("appLogo.svg"),
            //           fit: BoxFit.fill,
            //         ),
            //       )
            //           : SvgPicture.asset(
            //         Utils.getImagePath("appLogo.svg"),
            //         fit: BoxFit.fill,
            //       ),
            //     );
            //   },
            // ),
            SizedBox(height: context.height * 0.03),

            Text(
              'Cerdas Berbudi Luhur',
              style: TextStyle(
                fontSize: Utils.screenOnboardingTitleFontSize,
                fontWeight: FontWeight.bold,
                color: Color(0xff22577a),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
