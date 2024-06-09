import 'package:containsafe/pages/ViewPerformanceWS.dart';
import 'package:containsafe/pages/httpResponse/SearchByCode.dart';
import 'package:containsafe/pages/permission/viewPermissionScreen.dart';
import 'package:containsafe/pages/role/viewRoleScreen.dart';
import 'package:containsafe/pages/rolePermission/ViewRolePermissionScreen.dart';
import 'package:containsafe/pages/service/ViewServiceScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/authentication/logout/logout_bloc.dart';
import '../bloc/authentication/logout/logout_event.dart';
import '../bloc/authentication/logout/logout_state.dart';
import 'RoutePageLog.dart';
import 'authentication/loginScreen.dart';
import 'config/viewConfigScreen.dart';
import 'ContainerPerformanceScreen.dart';
import 'httpResponse/viewHttpResponsesScreen.dart';
import 'node/viewNodesScreen.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({Key? key}) : super(key: key);

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  bool _isMenuOpen = false;
  late LogoutBloc logoutbloc;

  @override
  void initState() {
    logoutbloc = BlocProvider.of<LogoutBloc>(context);
    super.initState();
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
              color: _isMenuOpen
                  ? Colors.white
                  : Colors.white, // Change the colors as desired
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
                color: Colors.white?.withOpacity(1.0),
                width: MediaQuery.of(context).size.width *
                    0.6, // Adjust width as needed
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildMenuItem(Icons.home, 'Home', 0),
                    _buildMenuItem(Icons.list, 'Log', 1),
                    _buildMenuItem(Icons.settings, 'Configuration', 2),
                    _buildMenuItem(Icons.settings, 'Permission', 3),
                    _buildMenuItem(Icons.settings, 'Role', 4),
                    _buildMenuItem(Icons.settings, 'Role Permission', 5),
                    _buildMenuItem(Icons.settings, 'Service', 6),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, int index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {
        setState(() {
          _isMenuOpen = false; // Close the menu after selecting an item
        });
        _navigateToPage(index); // Navigate to the selected page
      },
    );
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

  void _navigateToPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  int _currentIndex = 0; // Default to HomeScreen when app starts
}
