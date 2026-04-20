import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constant/constant.dart';
import '../../../utils/shared/ui/custom_container.dart';
import '../../../utils/utils.dart';
import '../../academic_calendar/presentation/screen/academic_calendar_container.dart';
import '../../academic_result/presentation/screen/widgets/academic_result_container.dart';
import '../../app_config/data/model/app_config/app_config.dart';
import '../../app_config/presentation/bloc/app_config_bloc.dart';
import '../../daily_attendance/presentation/bloc/today_attendance/today_attendance_bloc.dart';
import '../../daily_attendance/presentation/screen/attendance_container.dart';
import '../../discipline/presentation/screen/discipline_container.dart';
import '../../extracurricular/screen/extracurricular_container.dart';
import '../../guardian_details/screen/guardian_details_container.dart';
import '../../settings/screen/settings_screen.dart';
import '../../time_table/screen/student_time_table_container.dart';
import 'home_container.dart';
import 'widgets/bottom_nav_container.dart';
import 'widgets/bottom_nav_model.dart';
import 'widgets/home_container_top_profile_container.dart';
import 'widgets/home_screen_data_loading_container.dart';
import 'widgets/menu_model.dart';
import 'widgets/more_menu_bottom_sheet_container.dart';

class HomeScreen extends StatefulWidget {
  static GlobalKey<_HomeScreenState> homeScreenKey =
      GlobalKey<_HomeScreenState>();

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  static Widget routeInstance() {
    return HomeScreen(key: HomeScreen.homeScreenKey);
  }
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final args = Get.arguments;

  late final fromNotifications = (args is Map)
      ? args['fromNotifications']
      : false;

  /// Animations
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  late final Animation<double> _bottomNavAndTopProfileAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );

  late final List<AnimationController> _bottomNavItemTitlesAnimationController =
      [];

  late final AnimationController _moreMenuBottomSheetAnimationController =
      AnimationController(
        vsync: this,
        duration: homeMenuBottomSheetAnimationDuration,
      );

  late final Animation<Offset> _moreMenuBottomSheetAnimation =
      Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _moreMenuBottomSheetAnimationController,
          curve: Curves.easeInOut,
        ),
      );

  late final Animation<double> _moreMenuBackgroundContainerColorAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _moreMenuBottomSheetAnimationController,
          curve: Curves.easeInOut,
        ),
      );

  /// Variables
  var canPop = false;
  late int _currentSelectedBottomNavIndex = 0;
  late int _previousSelectedBottomNavIndex = -1;

  //index of opened homeBottomSheet menu
  late int _currentlyOpenMenuIndex = -1;

  late bool _isMoreMenuOpen = false;

  late List<BottomNavIconModel> _bottomNavItems = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _animationController.forward();

    updateBottomNavItems();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (fromNotifications) _fetchDailyAttendance();
    });
  }

  void fetchDailyAttendanceFromNotification() {
    _fetchDailyAttendance();
  }

  void _fetchDailyAttendance() {
    context.read<TodayAttendanceBloc>().add(
      TodayAttendanceEvent.started(forceRefresh: true),
    );
  }

  Future<bool> _checkVersion(AppConfig appConfig) async {
    return await Utils.compareAppVersion(appConfig);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentSelectedBottomNavIndex == 0 ? canPop : canPopScreen(),
      onPopInvokedWithResult: (didPop, _) {
        if (_currentSelectedBottomNavIndex == 0) {
          _onWillPop();
          return;
        }
        if (_isMoreMenuOpen) {
          _closeBottomMenu();
          return;
        }
        if (_currentSelectedBottomNavIndex != 0) {
          changeBottomNavItem(0);
          return;
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        body: context.read<AppConfigBloc>().isAppMaintenance
            ? const AppUnderMaintenanceContainer()
            : BlocConsumer<AppConfigBloc, AppConfigState>(
                listener: (context, state) {
                  state.maybeWhen(
                    success: (appConfiguration) async {
                      final isVersionOutdated = await _checkVersion(
                        appConfiguration,
                      );
                      final appLink = Platform.isIOS
                          ? appConfiguration.iosAppLink
                          : appConfiguration.androidAppLink;

                      if (isVersionOutdated) {
                        if (Get.isBottomSheetOpen != true) {
                          Get.bottomSheet(
                            AppUpdateBottomSheet(urlGithub: appLink ?? ""),
                            enableDrag: true,
                            isDismissible: true,
                            backgroundColor: Colors.white,
                          );
                        }
                      }
                    },
                    orElse: () {},
                  );
                },
                builder: (context, state) {
                  return state.maybeWhen(
                    success: (appConfiguration) {
                      return Stack(
                        children: [
                          IndexedStack(
                            index: _currentSelectedBottomNavIndex,
                            children: [
                              const HomeContainer(
                                isForBottomMenuBackground: false,
                              ),
                              _buildBottomSheetBackgroundContent(),
                            ],
                          ),

                          IgnorePointer(
                            ignoring: !_isMoreMenuOpen,
                            child: FadeTransition(
                              opacity:
                                  _moreMenuBackgroundContainerColorAnimation,
                              child: _buildMoreMenuBackgroundContainer(),
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SlideTransition(
                              position: _moreMenuBottomSheetAnimation,
                              child: MoreMenuBottomSheetContainer(
                                closeBottomMenu: _closeBottomMenu,
                                onTapMoreMenuItemContainer:
                                    _onTapMoreMenuItemContainer,
                              ),
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: _buildBottomNavigationContainer(),
                          ),
                        ],
                      );
                    },
                    loading: () => Column(
                      children: [
                        HomeContainerTopProfileContainer(),
                        Expanded(
                          child: HomeScreenDataLoadingContainer(
                            addTopPadding: false,
                          ),
                        ),
                      ],
                    ),
                    failure: (failure) {
                      return ErrorContainer(
                        errorMessageCode: failure.messageKey.translate(),
                      );
                    },
                    orElse: () => SizedBox.shrink(),
                  );
                },
              ),
      ),
    );
  }

  void updateBottomNavItems() {
    _bottomNavItems = [
      BottomNavIconModel(
        activeImageUrl: LucideIcons.house,
        disableImageUrl: LucideIcons.house,
        title: homeKey,
      ),
      BottomNavIconModel(
        activeImageUrl: LucideIcons.squareMenu,
        disableImageUrl: LucideIcons.menu,
        title: menuKey,
      ),
    ];

    initAnimations();

    setState(() {});
  }

  void initAnimations() {
    for (var i = 0; i < _bottomNavItems.length; i++) {
      _bottomNavItemTitlesAnimationController.add(
        AnimationController(
          value: i == _currentSelectedBottomNavIndex ? 0.0 : 1.0,
          vsync: this,
          duration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    for (var animationController in _bottomNavItemTitlesAnimationController) {
      animationController.dispose();
    }
    _moreMenuBottomSheetAnimationController.dispose();
    super.dispose();
  }

  bool canPopScreen() {
    if (_isMoreMenuOpen) {
      return false;
    }
    if (_currentSelectedBottomNavIndex != 0) {
      return false;
    }
    return true;
  }

  Future<void> changeBottomNavItem(int index) async {
    if (_moreMenuBottomSheetAnimationController.isAnimating) {
      return;
    }
    _bottomNavItemTitlesAnimationController[_currentSelectedBottomNavIndex]
        .forward();

    //need to assign previous selected bottom index only if menu is close
    if (!_isMoreMenuOpen && _currentlyOpenMenuIndex == -1) {
      _previousSelectedBottomNavIndex = _currentSelectedBottomNavIndex;
    }

    //change current selected bottom index
    setState(() {
      _currentSelectedBottomNavIndex = index;

      //if user taps on non-last bottom nav item then change _currentlyOpenMenuIndex
      if (_currentSelectedBottomNavIndex != _bottomNavItems.length - 1) {
        _currentlyOpenMenuIndex = -1;
      }
    });

    _bottomNavItemTitlesAnimationController[_currentSelectedBottomNavIndex]
        .reverse();

    //if bottom index is last means open/close the bottom sheet
    if (index == _bottomNavItems.length - 1) {
      if (_moreMenuBottomSheetAnimationController.isCompleted) {
        //close the menu
        await _moreMenuBottomSheetAnimationController.reverse();

        setState(() {
          _isMoreMenuOpen = !_isMoreMenuOpen;
        });

        //change bottom nav to previous selected index
        //only if there is not any opened menu item container
        if (_currentlyOpenMenuIndex == -1) {
          changeBottomNavItem(_previousSelectedBottomNavIndex);
        }
      } else {
        //open menu
        await _moreMenuBottomSheetAnimationController.forward();
        setState(() {
          _isMoreMenuOpen = !_isMoreMenuOpen;
        });
      }
    } else {
      //if current selected index is not last index(bottom nav item)
      //and menu is open then close the menu
      if (_moreMenuBottomSheetAnimationController.isCompleted) {
        await _moreMenuBottomSheetAnimationController.reverse();
        setState(() {
          _isMoreMenuOpen = !_isMoreMenuOpen;
        });
      }
    }
  }

  Future<void> _closeBottomMenu() async {
    if (_currentlyOpenMenuIndex == -1) {
      //close the menu and change bottom sheet
      changeBottomNavItem(_previousSelectedBottomNavIndex);
    } else {
      await _moreMenuBottomSheetAnimationController.reverse();
      setState(() {
        _isMoreMenuOpen = !_isMoreMenuOpen;
      });
    }
  }

  Future<void> _onTapMoreMenuItemContainer(int index) async {
    await _moreMenuBottomSheetAnimationController.reverse();
    _currentlyOpenMenuIndex = index;
    _isMoreMenuOpen = !_isMoreMenuOpen;
    setState(() {});
  }

  Widget _buildBottomNavigationContainer() {
    return FadeTransition(
      opacity: _bottomNavAndTopProfileAnimation,
      child: SlideTransition(
        position: _bottomNavAndTopProfileAnimation.drive(
          Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero),
        ),
        child: CustomContainer(
          enableShadow: false,
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: Utils.bottomNavigationBottomMargin),
          width: context.screenWidth * (0.85),
          height: context.screenHeight * Utils.bottomNavigationHeightPercentage,
          child: LayoutBuilder(
            builder: (context, boxConstraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _bottomNavItems.isEmpty
                    ? [const SizedBox()]
                    : _bottomNavItems.map((bottomNavItem) {
                        final int index = _bottomNavItems.indexWhere(
                          (e) => e.title == bottomNavItem.title,
                        );
                        return BottomNavContainer(
                          showCaseDescription: bottomNavItem.title,
                          onTap: changeBottomNavItem,
                          boxConstraints: boxConstraints,
                          currentIndex: _currentSelectedBottomNavIndex,
                          bottomNavItem: _bottomNavItems[index],
                          animationController:
                              _bottomNavItemTitlesAnimationController[index],
                          index: index,
                        );
                      }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMoreMenuBackgroundContainer() {
    return GestureDetector(
      onTap: () async {
        _closeBottomMenu();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.75),
      ),
    );
  }

  //To load the selected menu item
  //it _currentlyOpenMenuIndex is 0 then load the container based on homeBottomSheetMenu[_currentlyOpenMenuIndex]
  Widget _buildMenuItemContainer() {
    if (homeBottomSheetMenu[_currentlyOpenMenuIndex].title == attendanceKey) {
      return AttendanceContainer();
    }
    if (homeBottomSheetMenu[_currentlyOpenMenuIndex].title == timeTableKey) {
      return TimeTableContainer();
    }
    if (homeBottomSheetMenu[_currentlyOpenMenuIndex].title ==
        academicCalendarKey) {
      return AcademicCalendarContainer();
    }
    if (homeBottomSheetMenu[_currentlyOpenMenuIndex].title ==
        guardianDetailsKey) {
      return const GuardianDetailsContainer();
    }
    if (homeBottomSheetMenu[_currentlyOpenMenuIndex].title ==
        academicResultKey) {
      return const AcademicResultContainer();
    }
    if (homeBottomSheetMenu[_currentlyOpenMenuIndex].title ==
        meritAndDemeritKey) {
      return const DisciplineContainer();
    }
    if (homeBottomSheetMenu[_currentlyOpenMenuIndex].title ==
        extracurricularKey) {
      return const ExtracurricularContainer();
    }
    if (homeBottomSheetMenu[_currentlyOpenMenuIndex].title == settingsKey) {
      return SettingsScreen();
    }

    return const SizedBox();
  }

  Widget _buildBottomSheetBackgroundContent() {
    //
    //Based on previous selected index show background content
    if (_currentlyOpenMenuIndex != -1) {
      return _buildMenuItemContainer();
    } else {
      if (_previousSelectedBottomNavIndex == 0) {
        return const HomeContainer(isForBottomMenuBackground: true);
      }

      return const SizedBox();
    }
  }

  void _onWillPop() {
    setState(() {
      canPop = true;
    });
    AppToast.show(
      context,
      message: pressBackAgainToExitKey.translate(),
      type: ToastType.warning,
      forShowOnMenuScreen: true,
    );
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        canPop = false;
      });
    });
  }
}
