import 'package:bl_e_school/budi_luhur/budi_luhur.dart';

class MenuModel {
  final String title;
  final String iconUrl;
  final String menuModuleId; //This is fixed

  MenuModel({
    required this.iconUrl,
    required this.title,
    required this.menuModuleId,
  });
}

final List<MenuModel> homeBottomSheetMenu = [
  MenuModel(
    menuModuleId: attendanceManagementModuleId.toString(),
    iconUrl: "assets/images/attendance_icon.svg",
    title: attendanceKey,
  ),
];
