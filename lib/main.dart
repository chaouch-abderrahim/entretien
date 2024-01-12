import 'package:flutter/material.dart';
import 'Ecran1.dart';
import 'Ecran2.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carte des Capitales'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Ecran 1'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Ecran1()),
                );
              },
            ),
            ListTile(
              title: Text('Ecran 2'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Ecran2()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Bienvenue sur l\'écran d\'accueil'),
      ),
    );
  }
}
