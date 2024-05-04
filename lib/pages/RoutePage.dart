
import 'package:containsafe/pages/node/viewNodesScreen.dart';
import 'package:flutter/material.dart';
import 'homeScreen.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  int _currentIndex = 0;

  final List<Widget> _tablist = [
     HomeScreen(),
    // SearchUserView(),
    // NewPost(),
     ViewNodesScreen(),
    // ProfileView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tablist,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index){
          setState((){
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.brown,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Node',
            backgroundColor: Colors.brown,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
            backgroundColor: Colors.brown,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Post',
            backgroundColor: Colors.brown,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.brown,
          ),
        ],
      ),
    );
  }
}