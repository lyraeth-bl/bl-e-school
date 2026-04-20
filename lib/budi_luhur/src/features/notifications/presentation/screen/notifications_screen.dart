import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../utils/shared/ui/custom_container.dart';
import '../../../../utils/utils.dart';
import '../../repository/notifications_repository.dart';
import '../cubit/notifications_cubit.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();

  static Widget routeInstance() {
    return BlocProvider<NotificationsCubit>(
      create: (_) => NotificationsCubit(NotificationsRepository()),
      child: NotificationsScreen(),
    );
  }
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsCubit>().fetchNotifications();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surfaceContainer,
      body: Stack(
        children: [
          BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (c, s) {
              return s.maybeWhen(
                success: (listNotifications) {
                  if (listNotifications.isEmpty) {
                    return Align(
                      alignment: Alignment.center,
                      child: NoDataContainer(titleKey: noNotificationsKey),
                    );
                  }

                  return Align(
                    alignment: Alignment.topCenter,
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<NotificationsCubit>().fetchNotifications();
                      },
                      edgeOffset: Utils.getScrollViewTopPadding(
                        context: context,
                        appBarHeightPercentage: 0.12,
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.only(
                          bottom: 25,
                          left:
                              context.screenWidth *
                              (Utils
                                  .screenContentHorizontalPaddingInPercentage),
                          right:
                              context.screenWidth *
                              (Utils
                                  .screenContentHorizontalPaddingInPercentage),
                          top: Utils.getScrollViewTopPadding(
                            context: context,
                            appBarHeightPercentage:
                                Utils.appBarSmallerHeightPercentage,
                          ),
                        ),
                        itemCount: listNotifications.length,
                        itemBuilder: (c, i) {
                          final notifications = listNotifications[i];
                          final hasAttachment =
                              notifications.attachmentUrl.isNotEmpty;

                          return CustomContainer(
                            margin: const EdgeInsets.only(bottom: 24),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Thumbnail or Notification Icon
                                hasAttachment
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl: notifications.attachmentUrl,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.surfaceContainerLow,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.notifications_active_rounded,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                          size: 28,
                                        ),
                                      ),

                                16.w,

                                // Text content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notifications.title,
                                        style: context.text.titleMedium
                                            ?.copyWith(
                                              color: context.colors.onSurface,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      8.h,
                                      Text(
                                        notifications.body,
                                        style: context.text.bodySmall?.copyWith(
                                          color:
                                              context.colors.onSurfaceVariant,
                                        ),
                                      ),
                                      16.h,
                                      Row(
                                        children: [
                                          if (notifications.type != "") ...[
                                            CustomChipContainer(
                                              backgroundColor: Theme.of(
                                                context,
                                              ).colorScheme.primaryContainer,
                                              child: Text(
                                                notifications.type,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimaryContainer,
                                                    ),
                                              ),
                                            ),
                                          ],
                                          Spacer(),
                                          Text(
                                            timeago.format(
                                              notifications.createdAt,
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
                failure: (errorMessage) => Center(
                  child: ErrorContainer(
                    errorMessageCode: errorMessage,
                    onTapRetry: () {
                      context.read<NotificationsCubit>().fetchNotifications();
                    },
                  ),
                ),
                orElse: () => Center(child: CircularProgressIndicator()),
              );
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(title: notificationsKey),
          ),
        ],
      ),
    );
  }
}
