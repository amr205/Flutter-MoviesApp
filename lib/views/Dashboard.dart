import 'package:flutter/material.dart';
import 'package:movies_app/views/Favorites.dart';
import 'package:movies_app/views/Popular.dart';
import 'package:movies_app/views/Search.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin{
  
  TabController controller;

  @override
  void initState() {
    super.initState();

    // Initialize the Tab Controller
    controller = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
      // Set the TabBar view as the body of the Scaffold
      body: new Container(
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: new TabBarView(
              // Add tabs as widgets
              children: <Widget>[new Popular(), new Search(), new Favorites()],
              // set the controller
              controller: controller,
            ),
            )
          ],
        ),
      ),
      // Set the bottom navigation bar
      bottomNavigationBar: new Material(
        shadowColor: Colors.white,
        elevation: 15.0,
        // set the color of the bottom navigation bar
        color: Color.fromRGBO(58, 66, 86, 1.0),
        // set the tab bar as the child of bottom navigation bar
        child: new TabBar(
          unselectedLabelColor: Colors.grey,
          indicatorColor: Color(0xff48d6b4),
          labelColor: Color(0xff45ccab),
          tabs: <Tab>[
            new Tab(
              // set icon to the tab
              icon: new Icon(Icons.movie),
            ),
            new Tab(
              icon: new Icon(Icons.search),
            ),
            new Tab(
              icon: new Icon(Icons.star),
            ),
          ],
          // setup the controller
          controller: controller,
        ),
      ),
    );
  }
  
}