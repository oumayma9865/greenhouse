import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:my_greenhouse/Widgets/InfoBulle.dart';
import 'package:my_greenhouse/Services/MqttDataHouseManager.dart';
import 'package:my_greenhouse/Widgets/SideMenu.dart';
import 'package:my_greenhouse/main.dart';
import 'dart:async';
import 'dart:math';

class HouseControl extends StatefulWidget {
  const HouseControl({Key? key}) : super(key: key);

  @override
  State<HouseControl> createState() => _HouseControlState();
}

class _HouseControlState extends State<HouseControl> {
  bool vent = true;
  bool water = true;
   bool heat = true;

  // Fonctions de simulation pour générer des données fictives
  double temperature = 25.0;
  double humiditesol = 60.0;

  // Fonction de mise à jour des données simulées
  void updateData() {
    setState(() {
      // Générer des valeurs aléatoires pour la température et l'humidité
      temperature = Random().nextInt(30).toDouble();
      humiditesol = Random().nextInt(100).toDouble();
    });
  }

  @override
  void initState() {
    // Appeler la fonction de mise à jour des données à intervalles réguliers
    Timer.periodic(Duration(seconds: 10), (timer) {
      updateData();
    });
    super.initState();
  }

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
          icon: const Icon(Icons.menu),
        ),
        bottomOpacity: 0.8,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black38,
      ),
      drawer: const SideMenu(),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Current informations",
                    style: GoogleFonts.lato(
                      fontSize: 35,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(240, 95, 140, 78),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 10,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InfoBulle(
                      myIcon: Icons.thermostat,
                      textInfo: '$temperature °C',
                    ),
                    InfoBulle(
                      myIcon: Icons.opacity,
                      textInfo: '$humiditesol %',
                    ),
                    InfoBulle(
                      myIcon: Icons.wind_power_sharp,
                      textInfo: vent ? 'Active' : 'Close',
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 60,
                indent: 25,
                endIndent: 25,
                thickness: 1,
                color: Color.fromARGB(240, 164, 190, 123),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(240, 242, 242, 242),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              offset: const Offset(0, 10),
                              blurRadius: 7,
                              spreadRadius: -5)
                        ],
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.1),
                            width: 1.0,
                            style: BorderStyle.solid),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Open / Close water pump ",
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Switch(
                                  // This bool value toggles the switch.
                                  value: water,
                                  activeColor:
                                      const Color.fromARGB(240, 229, 217, 182),
                                  onChanged: (bool value) {
                                    setState(() {
                                      water = value;
                                      // mqttClientManager.publishMessage(
                                      //     publishTopic, "$water|$light");
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
                                        "Open or Close the water pump in the green house");
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(240, 242, 242, 242),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              offset: const Offset(0, 10),
                              blurRadius: 7,
                              spreadRadius: -5)
                        ],
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.1),
                            width: 1.0,
                            style: BorderStyle.solid),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Turn on the fan ",
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Switch(
                                  // This bool value toggles the switch.
                                  value: vent,
                                  activeColor:
                                      const Color.fromARGB(240, 229, 217, 182),
                                  onChanged: (bool value) {
                                    setState(() {
                                      vent = value;
                                      // mqttClientManager.publishMessage(
                                      //     publishTopic, "$water|$light");
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
                                        "Open or close the fan in the green house");
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                          Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(240, 242, 242, 242),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              offset: const Offset(0, 10),
                              blurRadius: 7,
                              spreadRadius: -5)
                        ],
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.1),
                            width: 1.0,
                            style: BorderStyle.solid),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Turn on the heat ",
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Switch(
                                  // This bool value toggles the switch.
                                  value: heat,
                                  activeColor:
                                      const Color.fromARGB(240, 229, 217, 182),
                                  onChanged: (bool value) {
                                    setState(() {
                                      heat = value;
                                      // mqttClientManager.publishMessage(
                                      //     publishTopic, "$water|$light");
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
                                        "Open or close the Ultra Violet light in the green house");
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(240, 242, 242, 242),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              offset: const Offset(0, 10),
                              blurRadius: 7,
                              spreadRadius: -5)
                        ],
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.1),
                            width: 1.0,
                            style: BorderStyle.solid),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Call responsible ",
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.call_sharp,
                                    size: 35,
                                    color: Color.fromARGB(240, 95, 140, 78),
                                  ),
                                  onPressed: () {
                                    FlutterPhoneDirectCaller.callNumber(
                                        "+21622845764");
                                    displayInfo(
                                        "making a call to +216 ** *** ***");
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: Colors.grey[400],
                                  ),
                                  onPressed: () {
                                    displayInfo(
                                        "Make a call to the responsible / Gard of the green house");
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
