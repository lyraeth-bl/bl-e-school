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

final List<MenuModel> homeBottomSheetMenu = [];
