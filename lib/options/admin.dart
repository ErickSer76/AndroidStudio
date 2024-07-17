import 'package:flutter/material.dart';
import 'general_data.dart';
import 'calificaciones.dart';

class Homescreenadmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal.shade400,
              ),
              child: Image.asset(
                'assets/img/Logo.png',
              ),
            ),
            ListTile(
              title: Text('General'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EstudiantesScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Calificaciones'),
              onTap: (){
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CalificacionesEst()),
                );
              },
            )
            // Otros elementos del Drawer
          ],
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 140,
        backgroundColor: Colors.teal.shade400,
        title: Image.asset(
          'assets/img/Logo.png',
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.teal.shade400,
                  Colors.teal.shade300,
                  Colors.teal.shade200
                ],
                stops: const [0.3, 0.7, 0.9],
              ),
            ),
          ),
          Center(
            child: Container(
              width: 350,
              height: 550,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey,
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  'Admin',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}