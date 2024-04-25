import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_greenhouse/Widgets/Constants.dart';
import 'package:my_greenhouse/MainScreens/homepage.dart';
import 'package:my_greenhouse/MainScreens/homepage1.dart';
import 'package:my_greenhouse/MainScreens/signup.dart';
import 'package:my_greenhouse/Models/User.dart';
import 'package:my_greenhouse/Services/AuthService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
 

  // Contrôleurs pour les champs d'email et de mot de passe
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool showPassword = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  RegExp exp = RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    toastMsg(String msg) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        elevation: 15,
        backgroundColor: Colors.redAccent,
      ));
    }


    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          color: Colors.white,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  'assets/3.png',
                  width: size.width * 0.2,
                ),
              ),
              SingleChildScrollView(
                child: Material(
                  type: MaterialType.transparency,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "My Green House",
                          style: GoogleFonts.lato(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: const Color.fromARGB(240, 95, 140, 78),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Welcome !",
                          style: TextStyle(
                              fontSize: 20,
                              color: KBlackColor,
                              fontWeight: FontWeight.bold),
                        ),
                      
                        const SizedBox(
                          height: 30,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              //email field
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                    border: Border.all(color: KGreenColor),
                                    color: KWihteColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  controller: _emailController, // Utilisation du contrôleur
                                  validator: (value) {
                                    if (value == '') {
                                      return "Adesse e-mail est vide !";
                                    } else if (!exp.hasMatch(value!)) {
                                      return "Adesse e-mail incorrect !";
                                    }
                                  
                                  },
                                  decoration: const InputDecoration(
                                      hintText: "Adresse e-mail",
                                      icon: Icon(
                                        Icons.mail_outline,
                                        color: KBlackColor,
                                      ),
                                      border: InputBorder.none),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                              //space between
                              const SizedBox(
                                height: 30,
                              ),
                              //password field
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                    border: Border.all(color: KGreenColor),
                                    color: KWihteColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  controller: _passwordController, // Utilisation du contrôleur
                                  validator: (value) {
                                    if (value == '') {
                                      return "Mot de passe est vide !";
                                    } else if (value!.length < 6) {
                                      return "Mot de passe doit étre de 6 caracteres !";
                                    }
                                   
                                  },
                                  obscureText: showPassword,
                                  decoration: InputDecoration(
                                      hintText: "Mot de passe ",
                                      icon: const Icon(
                                        Icons.lock,
                                        color: KBlackColor,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          (showPassword)
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: KBlackColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            showPassword = !showPassword;
                                          });
                                        },
                                      ),
                                      border: InputBorder.none),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(164, 190, 123, 1),
                              textStyle: const TextStyle(
                                fontSize: 20,
                                color: KWihteColor,
                              )),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'LOGIN',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            submitLog(); // Appel de la fonction de connexion
                          },
                        ),
                         const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUp(),
                              ),
                            );
                          },
                          child: Text(
                            "Create an account",
                            style: TextStyle(
                              color: KBlackColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 void submitLog() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      try {
        // Fetch user document from Firestore based on email
        QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
            .collection('AppUsers')
            .where('email', isEqualTo: email)
            .get();

        if (snapshot.docs.isNotEmpty) {
          // User with provided email exists
          var userDoc = snapshot.docs.first;
          if (userDoc['password'] == password && userDoc['login'] == true  ) {
            // Password matches and login is true, navigate to home page
           if(userDoc.data()?['admin']== true){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MyHomePage( title: "my green house",),
              ),
            );
          }
          else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MyHomePage1(
                title: "My Green House",
              ),
            ),
            (route) => false,
          );
        }
      }
           else {
            // Invalid password or login is false
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Invalid email or password'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } else {
          // User with provided email does not exist
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User with email $email does not exist'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        print('Error signing in: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing in'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}