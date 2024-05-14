import 'package:containsafe/pages/httpResponse/SearchByCode.dart';
import 'package:containsafe/pages/node/viewNodesScreen.dart';
import 'package:flutter/material.dart';

class RoutePageLog extends StatefulWidget {
  const RoutePageLog({super.key});

  @override
  State<RoutePageLog> createState() => _RoutePageLogState();
}

class _RoutePageLogState extends State<RoutePageLog> {
  final List<Widget> _tablist = [
    SearchByCodeView(),
    ViewNodesScreen(),
    // ViewHttpResponsesScreen(),
    // ViewConfigsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tablist.length,
      initialIndex: 0, // Ensure the first tab is selected
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: Colors.brown[300], // You can set the background color for the TabBar here
              child: const TabBar(
                tabs: [
                  Tab(text: 'Status Code'),
                  Tab(text: 'DateTime'),
                  // Tab(icon: Icon(Icons.list), text: 'Log'),
                  // Tab(icon: Icon(Icons.settings), text: 'Post'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: _tablist,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
