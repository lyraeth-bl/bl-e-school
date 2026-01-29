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
  MenuModel(
    menuModuleId: timetableManagementModuleId.toString(),
    iconUrl: "assets/images/timetable_icon.svg",
    title: timeTableKey,
  ),
  MenuModel(
    menuModuleId: defaultModuleId.toString(),
    iconUrl: 'assets/images/parent_icon.svg',
    title: guardianDetailsKey,
  ),
  MenuModel(
    menuModuleId: academicsManagementModuleId.toString(),
    iconUrl: "assets/images/holiday_icon.svg",
    title: academicCalendarKey,
  ),
  MenuModel(
    menuModuleId: defaultModuleId.toString(),
    iconUrl: "assets/images/setting_icon.svg",
    title: settingsKey,
  ),
];
