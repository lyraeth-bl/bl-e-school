import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MenuModel {
  final String title;
  final IconData icon;
  final String menuModuleId;

  MenuModel({
    required this.icon,
    required this.title,
    required this.menuModuleId,
  });
}

final List<MenuModel> homeBottomSheetMenu = [
  MenuModel(
    menuModuleId: attendanceManagementModuleId.toString(),
    icon: LucideIcons.calendar1,
    title: attendanceKey,
  ),
  MenuModel(
    menuModuleId: timetableManagementModuleId.toString(),
    icon: LucideIcons.clock,
    title: timeTableKey,
  ),
  MenuModel(
    menuModuleId: defaultModuleId.toString(),
    icon: LucideIcons.userStar,
    title: guardianDetailsKey,
  ),
  MenuModel(
    menuModuleId: defaultModuleId.toString(),
    icon: LucideIcons.shieldUser,
    title: meritAndDemeritKey,
  ),
  MenuModel(
    menuModuleId: academicsManagementModuleId.toString(),
    icon: LucideIcons.calendars,
    title: academicCalendarKey,
  ),
  MenuModel(
    menuModuleId: defaultModuleId.toString(),
    icon: LucideIcons.music,
    title: extracurricularKey,
  ),
  MenuModel(
    menuModuleId: defaultModuleId.toString(),
    icon: LucideIcons.settings,
    title: settingsKey,
  ),
];
