import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';

class BottomNavContainer extends StatefulWidget {
  final BoxConstraints boxConstraints;
  final int index;
  final int currentIndex;
  final AnimationController animationController;
  final BottomNavIconModel bottomNavItem;
  final Function onTap;
  final String showCaseDescription;

  const BottomNavContainer({
    super.key,
    required this.boxConstraints,
    required this.currentIndex,
    required this.showCaseDescription,
    required this.bottomNavItem,
    required this.animationController,
    required this.onTap,
    required this.index,
  });

  @override
  State<BottomNavContainer> createState() => _BottomNavContainerState();
}

class _BottomNavContainerState extends State<BottomNavContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        widget.onTap(widget.index);
      },
      child: SizedBox(
        width: widget.boxConstraints.maxWidth * (0.25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.0, 0.05),
                    end: const Offset(0.0, 0.35),
                  ).animate(
                    CurvedAnimation(
                      parent: widget.animationController,
                      curve: Curves.easeInOut,
                    ),
                  ),
              child: Container(
                padding: widget.index == widget.currentIndex
                    ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                    : null,
                decoration: BoxDecoration(
                  color: widget.index == widget.currentIndex
                      ? Theme.of(
                          context,
                        ).colorScheme.secondaryContainer.withValues(alpha: 0.8)
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  widget.index == widget.currentIndex
                      ? widget.bottomNavItem.activeImageUrl
                      : widget.bottomNavItem.disableImageUrl,
                  color: widget.index == widget.currentIndex
                      ? Theme.of(context).colorScheme.onSecondaryContainer
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            SizedBox(height: widget.boxConstraints.maxHeight * (0.051)),
            FadeTransition(
              opacity: Tween<double>(
                begin: 1.0,
                end: 0.0,
              ).animate(widget.animationController),
              child: SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(0.0, 0.0),
                      end: const Offset(0.0, 0.5),
                    ).animate(
                      CurvedAnimation(
                        parent: widget.animationController,
                        curve: Curves.easeInOut,
                      ),
                    ),
                child: Text(
                  Utils.getTranslatedLabel(widget.bottomNavItem.title),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
