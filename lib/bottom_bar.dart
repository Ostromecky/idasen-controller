import 'dart:io';

import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final List<Widget> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final _padding = 8.0;
  final _heightBaseline = 48.0;
  final _lineHeight = 17;

  get _height =>
      items.where((item) => item is NavItem && item.label != null).isNotEmpty
          ? (_heightBaseline + _padding * 2) + _lineHeight
          : _heightBaseline + _padding * 2;

  BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      margin: EdgeInsets.only(
        left: 0,
        right: 0,
        bottom: Platform.isAndroid ? 16 : 0,
      ),
      child: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        color: Theme.of(context).primaryColor,
        elevation: 0.0,
        height: _height,
        notchMargin: 5,
        shape: const CircularNotchedRectangle(),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = selectedIndex == index;
              return item is NavItem
                  ? Expanded(
                      child: InkWell(
                        // radius: 100,
                        customBorder: const CircleBorder(),
                        onTap: () => onTap(index),
                        child: Padding(
                          padding: EdgeInsets.all(_padding),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                item.icon,
                                size: 24,
                                color: isSelected
                                    ? Theme.of(context).primaryColorLight
                                    : Colors.white,
                              ),
                              if (item.label != null)
                                Text(
                                  item.label!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected
                                        ? Theme.of(context).primaryColorLight
                                        : Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : item;
            })),
      ),
    );
  }
}

class NavItem extends Widget {
  final IconData icon;
  String? label;

  NavItem({
    required this.icon,
    this.label,
  });

  @override
  Element createElement() {
    // TODO: implement createElement
    throw UnimplementedError();
  }
}
