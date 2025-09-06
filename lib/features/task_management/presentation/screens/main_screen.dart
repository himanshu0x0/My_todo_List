import 'package:flutter/material.dart';
import 'package:mytodoapp/features/authentication/presentation/screens/accounts_screen.dart';
import 'package:mytodoapp/features/task_management/presentation/screens/add_task_screen.dart';
import 'package:mytodoapp/features/task_management/presentation/screens/all_tasks_screen.dart';
import 'package:mytodoapp/features/task_management/presentation/screens/completed_tasks_screen.dart';
import 'package:mytodoapp/features/task_management/presentation/screens/incomplete_tasks_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin{

  late TabController _tabController;

  int currentIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController.index = currentIndex;
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: [
          AllTasksScreen(),
          IncompleteTasksScreen(),
          AddTaskScreen(),
          CompletedTasksScreen(),
          AccountsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        iconSize: 20.0,
        elevation: 5.0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            activeIcon: Icon(Icons.home),
      ),

       BottomNavigationBarItem(
            icon: Icon(Icons.dangerous_outlined),
            label: 'Incomplete',
            activeIcon: Icon(Icons.dangerous),
      ),

       BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
            activeIcon: Icon(Icons.add),
      ),

       BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outlined),
            label: 'Complete',
            activeIcon: Icon(Icons.check_box),
      ),

       BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Account',
            activeIcon: Icon(Icons.person),
      ),
        ],
      ),
    );
  }
}