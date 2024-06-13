import 'package:containsafe/pages/permission/viewPermissionScreen.dart';
import 'package:containsafe/pages/role/viewRoleScreen.dart';
import 'package:containsafe/pages/rolePermission/ViewRolePermissionScreen.dart';
import 'package:containsafe/pages/service/ViewServiceScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/authentication/logout/logout_bloc.dart';
import '../bloc/authentication/logout/logout_event.dart';
import '../bloc/authentication/logout/logout_state.dart';
import 'RoutePageLog.dart';
import 'authentication/loginScreen.dart';
import 'config/viewConfigScreen.dart';
import 'node/viewNodesScreen.dart';

// Define role IDs
const int adminRole = 1;
const int devOpsRole = 2;
const int managementRole = 3;

// Example role-based menu configuration
final Map<int, List<MenuItem>> roleBasedMenus = {
  adminRole: [
    MenuItem(icon: Icons.home, label: 'Home', pageIndex: 0),
    MenuItem(icon: Icons.list, label: 'Log', pageIndex: 1),
    MenuItem(icon: Icons.settings, label: 'Configuration', pageIndex: 2),
    MenuItem(icon: Icons.settings, label: 'Permission', pageIndex: 3),
    MenuItem(icon: Icons.settings, label: 'Role', pageIndex: 4),
    MenuItem(icon: Icons.settings, label: 'Role Permission', pageIndex: 5),
    MenuItem(icon: Icons.settings, label: 'Service', pageIndex: 6),
  ],
  devOpsRole: [
    MenuItem(icon: Icons.home, label: 'Home', pageIndex: 0),
    MenuItem(icon: Icons.settings, label: 'Configuration', pageIndex: 2),
    MenuItem(icon: Icons.settings, label: 'Permission', pageIndex: 3),
    MenuItem(icon: Icons.settings, label: 'Role', pageIndex: 4),
    MenuItem(icon: Icons.settings, label: 'Role Permission', pageIndex: 5),
    MenuItem(icon: Icons.settings, label: 'Service', pageIndex: 6),
  ],
  managementRole: [
    MenuItem(icon: Icons.home, label: 'Home', pageIndex: 0),
  ],
};

class MenuItem {
  final IconData icon;
  final String label;
  final int pageIndex;

  MenuItem({
    required this.icon,
    required this.label,
    required this.pageIndex,
  });
}

class RoutePage extends StatefulWidget {
  const RoutePage({Key? key}) : super(key: key);

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  bool _isMenuOpen = false;
  late LogoutBloc logoutbloc;
  int userRole = managementRole; // Default role, fetch actual role from auth
  int _currentIndex = 0; // Default to HomeScreen when app starts

  @override
  void initState() {
    logoutbloc = BlocProvider.of<LogoutBloc>(context);
    _loadUserRole();
    super.initState();
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getInt('roleId') ?? managementRole; // Fetch user role or default to managementRole
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutBloc, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccessState) {
          // If logout is successful, navigate to login screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('ContainSafe'),
          leading: IconButton(
            icon: Icon(
              _isMenuOpen ? Icons.close : Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isMenuOpen = !_isMenuOpen;
              });
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                // Trigger logout action here
                logoutbloc.add(LogoutButtonPressed());
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            // Main content of each page
            Container(
              color: Colors.white,
              child: _getCurrentPage(),
            ),
            // Side navigation menu
            if (_isMenuOpen)
              Container(
                color: Colors.white.withOpacity(1.0),
                width: MediaQuery.of(context).size.width * 0.6,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: _buildMenuItems(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMenuItems() {
    return roleBasedMenus[userRole]!.map((menuItem) {
      return ListTile(
        leading: Icon(menuItem.icon),
        title: Text(menuItem.label),
        onTap: () {
          setState(() {
            _isMenuOpen = false; // Close the menu after selecting an item
            _currentIndex = menuItem.pageIndex; // Navigate to the selected page
          });
        },
      );
    }).toList();
  }

  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return ViewNodesScreen();
      case 1:
        return RoutePageLog();
      case 2:
        return ViewConfigsScreen();
      case 3:
        return ViewPermissionsScreen();
      case 4:
        return ViewRolesScreen();
      case 5:
        return ViewRolePermissionsScreen();
      case 6:
        return ViewServicesScreen();
      default:
        return ViewNodesScreen(); // Default to HomeScreen if index is out of bounds
    }
  }

}
