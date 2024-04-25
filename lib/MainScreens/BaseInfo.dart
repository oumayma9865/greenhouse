import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:my_greenhouse/Services/GreenHouseMG.dart';
import 'package:my_greenhouse/Services/MqttDataHouseManager.dart';
import 'package:my_greenhouse/Services/newNotiffication.dart';
import 'package:my_greenhouse/Widgets/Constants.dart';

import '../Widgets/loading.dart';
import 'dart:async';
import 'dart:math';
class BaseInfo extends StatefulWidget {
  const BaseInfo({Key? key}) : super(key: key);

  @override
  State<BaseInfo> createState() => _BaseInfoState();
}

class _BaseInfoState extends State<BaseInfo> {
  late Timer _timer;
  final Random _random = Random();

  Map<String, dynamic> _generateRandomInfo() {
    return {
      "temp": (_random.nextDouble() * 10 + 18).toStringAsFixed(2),
      "hum": (_random.nextDouble() * 30 + 50).toStringAsFixed(2),
      "hums": (_random.nextDouble() * 30 + 50).toStringAsFixed(2),
      "water": _random.nextBool() ? "Active" : "Close",
      "vent": _random.nextBool() ? "Active" : "Close",
    };
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {}); // Appeler setState pour reconstruire le widget toutes les 10 secondes
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Annuler le timer à la fin pour éviter les fuites de mémoire
    super.dispose();
  }

   @override
  Widget build(BuildContext context) {
    final info = _generateRandomInfo(); // Générer des données aléatoires
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDataCard(icon: Icons.thermostat, label: 'Température', value: '${info["temp"]} °C'),
            _buildDataCard(icon: Icons.cloud_queue_sharp, label: 'Humidité', value: '${info["hum"]} %'),
          ],
        ),
         const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
             _buildDataCard(icon: Icons.opacity, label: 'Humidité du sol', value: '${info["hums"]} %'),
            _buildDataCard(icon: Icons.water_drop_outlined, label: 'Pompe à eau', value: info["water"]),
           
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
             _buildDataCard(icon: Icons.wind_power_sharp, label: 'Ventilateur', value: info["vent"]),
            _buildDataCard(icon: Icons.heat_pump_outlined, label: 'Chauffage', value: info["water"]),
           
          ],
        ),
         
      ],
    );
  }

  Widget _buildDataCard({required IconData icon, required String label, required String value}) {
     return Expanded(
      child: GestureDetector(
        onTap: () {}, // Vous pouvez ajouter une action au clic ici
        child: Card(
           elevation: 4,
          color: const Color.fromARGB(240, 164, 190, 123), // Couleur de fond par défaut
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 60,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Text(
                  label,
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  value,
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// class BaseInfo extends StatefulWidget {
//   const BaseInfo({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<BaseInfo> createState() => _BaseInfoState();
// }

// class _BaseInfoState extends State<BaseInfo> {
//   MqttDataHouseManager mqttClientManager = MqttDataHouseManager();
//   final String pubTopic = "ENSIT/2INFO/my_GreenHouse/sensors";
//   Future<void> setupMqttClient() async {
//     await mqttClientManager.connect();
//     mqttClientManager.subscribe(pubTopic);
//   }

//   @override
//   void dispose() {
//     mqttClientManager.disconnect();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     print("connecting to hive broker ");
//     setupMqttClient();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Map prevInfo = {"temp": 0, "hum": -1};
//     return StreamBuilder(
//       stream: mqttClientManager.getMessagesStream(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: Loading());
//         } else {
//           if (snapshot.hasData) {
//             var c = snapshot.data as List<MqttReceivedMessage<MqttMessage?>>;
//             final recMess = c[0].payload as MqttPublishMessage;
//             final pt = MqttPublishPayload.bytesToStringAsString(
//                 recMess.payload.message);
//             Map info = mqttClientManager.getsimpleInfo(pt);
//             if (info["temp"] != prevInfo["temp"] ||
//                 info["hum"] != prevInfo["hum"]) {
//               prevInfo = info;
//               String now = DateTime.now().toString().substring(0, 16);
//               //send data to firebase
//               GreenHouseMG().addNewInfo({now: info});
//             }
//             if (double.parse(info["temp"].toString()) > 24 ||
//                 double.parse(info["temp"].toString()) < 18) {
//               //send notification
//               Notif().getNotification("temperature problem",
//                   "critical condition in the green house\n Temperateur is ${info['temp']}");
//             }
//             if (double.parse(info["hum"].toString()) > 81 ||
//                 double.parse(info["hum"].toString()) < 79) {
//               //send notification

//               Notif().getNotification("humudity problem",
//                   "critical condition in the green house\n humudity is ${info['hum']}");
//             }
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.thermostat,
//                       size: 60,
//                       color: Kgray,
//                     ),
//                     Text(
//                       info['temp'] + "°C",
//                       style: GoogleFonts.lato(
//                           fontSize: 65,
//                           fontWeight: FontWeight.w300,
//                           color: Kgray),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Row(
//                   children: [
//                     const Icon(Icons.water_drop_outlined,
//                         size: 60, color: Kgray),
//                     Text(
//                       info['hum'] + " %",
//                       style: GoogleFonts.lato(
//                         fontSize: 65,
//                         fontWeight: FontWeight.w300,
//                         color: Kgray,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.light_rounded,
//                       size: 60,
//                       color: Kgray,
//                     ),
//                     Text(
//                       (info['light'].contains("true")) ? " Active" : " Close",
//                       style: GoogleFonts.lato(
//                         fontSize: 60,
//                         fontWeight: FontWeight.w300,
//                         color: Kgray,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           }
//         }
//         return Container();
//       },
//     );
//   }
// }
