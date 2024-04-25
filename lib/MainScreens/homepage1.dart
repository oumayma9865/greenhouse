import 'package:flutter/material.dart';
import 'package:my_greenhouse/MainScreens/BaseInfo.dart';
import 'package:my_greenhouse/Widgets/SideMenu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_greenhouse/Widgets/InfoBulle.dart';
import 'package:my_greenhouse/MainScreens/statScreen.dart';
import 'package:my_greenhouse/MainScreens/notif.dart';
import '../Widgets/btnHistoStatistics.dart';

class MyHomePage1 extends StatefulWidget {
  const MyHomePage1({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage1> createState() => _MyHomePageState1();
 
}


class _MyHomePageState1 extends State<MyHomePage1> {
    bool light = false;
      void displayInfo(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: const Color.fromARGB(240, 185, 205, 152),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
            icon: const Icon(Icons.menu)),
        bottomOpacity: 0.8,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black38,
           actions: [
          Row(
            children: [
            //  Text(
            //   "Auto Control",
            //    style: GoogleFonts.lato(
            //                     fontSize: 20,
            //                     fontWeight: FontWeight.w500,
            //                     color: Color.fromARGB(240, 95, 140, 78),),
            //                     ), // Texte devant le bouton
              SizedBox(width: 8), // Espacement entre le texte et le bouton
              Switch(
                value: light, // Utilisation de la variable pour suivre l'état du bouton
                 activeColor:
                   const Color.fromARGB(240, 229, 217, 182),
                onChanged: (bool value) {
                  setState(() {
                    light = value; // Mettre à jour l'état du bouton
                    // Ajouter votre logique ici en fonction de l'état de light
                  });
                },
              ),
                IconButton(
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: Colors.grey[400],
                                  ),
                                  onPressed: () {
                                    displayInfo(
                                        "Open or Close the auto control in the green house");
                                  },
                                ),
            ],
          ),
           ]
            ),
      drawer: const SideMenu(),
      body: Stack(children: [
        // Image.asset(
        //   "assets/image4.jpeg",
        //   fit: BoxFit.cover,
        //   height: double.infinity,
        //   width: double.infinity,
        // ),
        Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Text(
                        "Green as always",
                        style: GoogleFonts.lato(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: const Color.fromARGB(240, 95, 140, 78),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                      child: Text(
                        "Time spent amongst trees is never wasted time.",
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: const Color.fromARGB(240, 164, 190, 123),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const BaseInfo(),
                    // const SizedBox(
                    //   height: 60,
                    // ),
                    // const BtnHistoStatistics()
                 
                    
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}