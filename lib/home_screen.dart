import 'package:flutter/material.dart';
import 'package:veggies_app/veggies_basket/veggies_screen.dart';

import 'cart/cart_screen.dart';
import 'common_widget/side_drawer.dart';
import 'explore/explore_screen.dart';
import 'home/home_screen.dart';
import 'my_account/user_screen.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedPageIndex = 0;

  void _selectTab(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

   _getPage() {
    final List<Map<String, Object>> _pages = [
      {
        'page': HomeScreen(),
        'title': 'Home',
      },
      {
        'page': ExploreScreen(),
        'title': 'Explore',
      },
      {
        'page': VeggiesScreen(),
        'title': 'Veggies',
      },
      {
        'page': CartScreen(),
        'title': 'Cart',
      },
      {
        'page': UserScreen(),
        'title': 'My Profile',
      }
    ];

    return _pages[_selectedPageIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: SideDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          _getPage()['title'].toString(),
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectTab,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.black87,
        selectedItemColor: Colors.orange,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            icon: Icon(Icons.location_on),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            icon:const  Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            icon: Icon(Icons.shopping_basket),
            label: 'Veggies',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            icon: Icon(Icons.person),
            label: 'My Profile',
          ),
        ],
      ),
      body: VeggiesScreen(),
    );
  }
}
