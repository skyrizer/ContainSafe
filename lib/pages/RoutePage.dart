import 'package:containsafe/pages/permission/viewPermissionScreen.dart';
import 'package:containsafe/pages/role/viewRoleScreen.dart';
import 'package:flutter/material.dart';
import 'config/viewConfigScreen.dart';
import 'homeScreen.dart';
import 'httpResponse/viewHttpResponsesScreen.dart';
import 'node/viewNodesScreen.dart';


class RoutePage extends StatefulWidget {
  const RoutePage({Key? key}) : super(key: key);

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  bool _isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ContainSafe'),
        leading: IconButton(
          icon: Icon(
            _isMenuOpen ? Icons.close : Icons.menu,
            color: _isMenuOpen ? Colors.white : Colors.white, // Change the colors as desired
          ),          onPressed: () {
            setState(() {
              _isMenuOpen = !_isMenuOpen;
            });
          },
        ),
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
              width: MediaQuery.of(context).size.width * 0.8, // Adjust width as needed
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildMenuItem(Icons.home, 'Home', 0),
                  _buildMenuItem(Icons.list_alt, 'Node', 1),
                  _buildMenuItem(Icons.list, 'Log', 2),
                  _buildMenuItem(Icons.settings, 'Configuration', 3),
                  _buildMenuItem(Icons.settings, 'Permission', 4),
                  _buildMenuItem(Icons.settings, 'Role', 5),




                ],
              ),
            ),
        ],
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
        return HomeScreen();
      case 1:
        return ViewNodesScreen();
      case 2:
        return ViewHttpResponsesScreen();
      case 3:
        return ViewConfigsScreen();
      case 4:
        return ViewPermissionsScreen();
      case 5:
        return ViewRolesScreen();
      default:
        return HomeScreen(); // Default to HomeScreen if index is out of bounds
    }
  }

  void _navigateToPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  int _currentIndex = 0; // Default to HomeScreen when app starts
}
