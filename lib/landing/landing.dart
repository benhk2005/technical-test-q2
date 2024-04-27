import 'package:flutter/material.dart';
import 'package:moovup_flutter/listing/people_list.dart';
import 'package:moovup_flutter/map/map_view.dart';

class LandingWidget extends StatefulWidget {
  const LandingWidget({super.key});

  @override
  State<StatefulWidget> createState() => _LandingWidgetState();
}

class _LandingWidgetState extends State<LandingWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      animationDuration: Duration.zero,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: const [
          PeopleList(),
          MapView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabController.index,
        onTap: (index) {
          setState(() {
            _tabController.index = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: "List",
            icon: Icon(
              Icons.list,
            ),
          ),
          BottomNavigationBarItem(
            label: "Map",
            icon: Icon(
              Icons.map,
            ),
          ),
        ],
      ),
    );
  }
}
