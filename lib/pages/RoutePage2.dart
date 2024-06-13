
import 'package:containsafe/pages/permission/viewPermissionScreen.dart';
import 'package:containsafe/pages/role/viewRoleScreen.dart';
import 'package:containsafe/pages/rolePermission/ViewRolePermissionScreen.dart';
import 'package:containsafe/pages/service/ViewServiceScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/authentication/logout/logout_bloc.dart';
import '../bloc/authentication/logout/logout_event.dart';
import '../bloc/authentication/logout/logout_state.dart';
import 'authentication/loginScreen.dart';
import 'config/viewConfigScreen.dart';
import 'node/viewNodesScreen.dart';

class DevOpsRoutePage extends StatefulWidget {
  const DevOpsRoutePage({Key? key}) : super(key: key);

  @override
  State<DevOpsRoutePage> createState() => _DevOpsRoutePageState();
}

class _DevOpsRoutePageState extends State<DevOpsRoutePage> {
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
                    _buildMenuItem(Icons.settings, 'Configuration', 1),
                    _buildMenuItem(Icons.settings, 'Permission', 2),
                    _buildMenuItem(Icons.settings, 'Role', 3),
                    _buildMenuItem(Icons.settings, 'Role Permission', 4),
                    _buildMenuItem(Icons.settings, 'Service', 5),
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
        return ViewConfigsScreen();
      case 2:
        return ViewPermissionsScreen();
      case 3:
        return ViewRolesScreen();
      case 4:
        return ViewRolePermissionsScreen();
      case 5:
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
