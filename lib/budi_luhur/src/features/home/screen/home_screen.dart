import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomeScreen extends StatefulWidget {
  static GlobalKey<_HomeScreenState> homeScreenKey =
      GlobalKey<_HomeScreenState>();

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  static Widget routeInstance() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FetchDailyAttendanceCubit>(
          create: (_) => FetchDailyAttendanceCubit(AttendanceRepository()),
        ),
        BlocProvider<AcademicCalendarCubit>(
          create: (_) => AcademicCalendarCubit(AcademicCalendarRepository()),
        ),
        BlocProvider<DisciplineBloc>(
          create: (_) => DisciplineBloc(DisciplineRepository()),
        ),
      ],
      child: HomeScreen(key: HomeScreen.homeScreenKey),
    );
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (fromNotifications) _fetchDailyAttendance();
      loadTemporarilyStoredNotifications();
      _fetchAppConfiguration();
      _fetchDailyAttendance();
      NotificationsUtility.setUpNotificationService();
    });
  }

  void _fetchAppConfiguration() =>
      context.read<AppConfigurationCubit>().fetchAppConfiguration();

  void fetchDailyAttendanceFromNotification() {
    _fetchDailyAttendance();
  }

  void _fetchDailyAttendance() {
    final detailsUser = context.read<AuthCubit>().getStudentDetails;
    context.read<DailyAttendanceCubit>().fetchTodayDailyAttendance(
      nis: detailsUser.nis,
    );
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
        body: context.read<AppConfigurationCubit>().getAppMaintenance
            ? const AppUnderMaintenanceContainer()
            : BlocConsumer<AppConfigurationCubit, AppConfigurationState>(
                listener: (context, state) {
                  state.maybeWhen(
                    failure: (errorMessage) => updateBottomNavItems(),
                    success: (appConfiguration) => updateBottomNavItems(),
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
                    orElse: () => Column(
                      children: [
                        HomeContainerTopProfileContainer(),
                        Expanded(
                          child: HomeScreenDataLoadingContainer(
                            addTopPadding: false,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  /// Methods

  void loadTemporarilyStoredNotifications() {
    NotificationsRepository.getTemporarilyStoredNotifications().then((
      notifications,
    ) {
      //
      for (var notificationData in notifications) {
        NotificationsRepository.addNotification(
          notificationDetails: NotificationsDetails.fromJson(
            Map.from(notificationData),
          ),
        );
      }
      //
      if (notifications.isNotEmpty) {
        NotificationsRepository.clearTemporarilyNotification();
      }

      //
    });
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

    //Update the animations controller based on assignment module enable
    initAnimations();

    setState(() {});
  }

  /// TODO : Uncomment after Assignment ready
  // void navigateToAssignmentContainer() {
  //   Get.until((route) => route.isFirst);
  //   changeBottomNavItem(1);
  // }

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      loadTemporarilyStoredNotifications();
    }
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
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: Utils.bottomNavigationBottomMargin),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Utils.getColorScheme(
                  context,
                ).shadow.withValues(alpha: 0.15),
                offset: const Offset(2.5, 2.5),
                blurRadius: 20,
              ),
            ],
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10.0),
          ),
          width: MediaQuery.of(context).size.width * (0.85),
          height:
              MediaQuery.of(context).size.height *
              Utils.bottomNavigationHeightPercentage,
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
        meritAndDemeritKey) {
      return const DisciplineContainer();
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
    Utils.showCustomSnackBar(
      context: context,
      errorMessage: Utils.getTranslatedLabel(pressBackAgainToExitKey),
      backgroundColor: Theme.of(context).colorScheme.error,
    ); // Do not exit the app
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        canPop = false;
      });
    });
  }
}
