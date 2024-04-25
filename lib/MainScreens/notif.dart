import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';


class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
   late List<String> users = [];// Liste des noms des utilisateurs

  @override
  void initState() {
    super.initState();
    // Charger les utilisateurs depuis Firestore lorsque la page est initialisée
    loadUsers();
  }

 Future<void> loadUsers() async {
  try {
    // Récupérer tous les documents de la collection AppUsers depuis Firestore
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('AppUsers').get();
    
    setState(() {
      // Extraction des noms des utilisateurs dont le champ 'admin' est false
      users = snapshot.docs
          .where((doc) => doc['admin'] == false) // Filtrer les utilisateurs avec 'admin' égal à false
          .map<String>((doc) => doc['name'] as String)
          .toList();
    });
  } catch (e) {
    // Gérer les erreurs éventuelles
    print('Erreur lors du chargement des utilisateurs: $e');
  }
}

  Future<void> acceptUser(String userName) async {
  try {
    // Récupérer les informations de l'utilisateur depuis Firestore
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('AppUsers')
        .where('name', isEqualTo: userName)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Récupérer l'ID du document de l'utilisateur
      String userId = snapshot.docs.first.id;

      // Mettre à jour le champ "login" à true dans le document de l'utilisateur
      await FirebaseFirestore.instance.collection('AppUsers').doc(userId).update({
        'login': true,
      });

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Utilisateur $userName a désormais accès à l\'application.'),
        duration: Duration(seconds: 2),
      ));
    }
  } catch (e) {
    // Afficher un message d'erreur en cas d'échec
    print('Erreur lors de la mise à jour de l\'utilisateur : $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erreur lors de la mise à jour de l\'utilisateur.'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

  Future<void> rejectUser(String userName) async {
  try {
    // Récupérer les informations de l'utilisateur depuis Firestore
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('AppUsers')
        .where('name', isEqualTo: userName)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Récupérer l'ID du document de l'utilisateur
      String userId = snapshot.docs.first.id;

      // Supprimer le document de l'utilisateur
      await FirebaseFirestore.instance.collection('AppUsers').doc(userId).delete();

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Utilisateur $userName supprimé avec succès.'),
          duration: Duration(seconds: 2),
        ),
      );
         await loadUsers();
    }
  } catch (e) {
    // Afficher un message d'erreur en cas d'échec
    print('Erreur lors de la suppression de l\'utilisateur : $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erreur lors de la suppression de l\'utilisateur.'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Notifications',
        style: GoogleFonts.lato(
          fontSize: 25,
          fontWeight: FontWeight.w600,
          color: const Color.fromARGB(240, 95, 140, 78),
        ),
      ),
    ),
      
    body:
     ListView.separated(
      itemCount: users.length,
      separatorBuilder: (BuildContext context, int index) => SizedBox(height: 20), // Ajoute de l'espace entre chaque notification
      itemBuilder: (BuildContext context, int index) {
        String userName = users[index];
        return Container(
          height: 60,
          decoration: BoxDecoration(
            color: const Color.fromARGB(250, 242, 242, 242),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            title: Text(userName),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    acceptUser(userName); // Authentifier l'utilisateur
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return Colors.green; // Couleur de fond verte pour le bouton "Accepter"
                      },
                    ),
                  ),
                  child: Text('Accepter'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Gérer le rejet de l'utilisateur si nécessaire
                    rejectUser(userName);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return Colors.red; // Couleur de fond rouge pour le bouton "Rejeter"
                      },
                    ),
                  ),
                  child: Text('Rejeter'),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
}