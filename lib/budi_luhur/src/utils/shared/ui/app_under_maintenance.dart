import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppUnderMaintenanceContainer extends StatelessWidget {
  const AppUnderMaintenanceContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/images/maintenance.svg", fit: BoxFit.cover),
          SizedBox(height: MediaQuery.of(context).size.height * (0.0125)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              Utils.getTranslatedLabel(appUnderMaintenanceKey),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
