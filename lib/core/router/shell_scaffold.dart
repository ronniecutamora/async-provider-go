import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Persistent shell that wraps every tab's navigator.
///
/// [NavigationBar] requires at least 2 destinations, so it is only
/// rendered when there are 2 or more branches. While the app has a
/// single tab, the body fills the full screen with no bottom bar.
class ShellScaffold extends StatelessWidget {
  const ShellScaffold({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  static const List<NavigationDestination> _destinations = [
    NavigationDestination(
      icon: Icon(Icons.article_outlined),
      selectedIcon: Icon(Icons.article),
      label: 'Posts',
    ),
    // ── Uncomment as new features/branches are added ──────────────────────
    // NavigationDestination(
    //   icon: Icon(Icons.person_outline),
    //   selectedIcon: Icon(Icons.person),
    //   label: 'Profile',
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    // NavigationBar crashes with fewer than 2 destinations.
    final bool showNav = _destinations.length >= 2;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: showNav
          ? NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _onTabTapped,
              destinations: _destinations,
            )
          : null,
    );
  }

  void _onTabTapped(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}