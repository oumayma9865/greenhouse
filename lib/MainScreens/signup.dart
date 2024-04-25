import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_greenhouse/MainScreens/login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signUp() async {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    try {
      // await FirebaseAuth.instance.createUserWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );

      await FirebaseFirestore.instance.collection('AppUsers').add({
        'name': name,
        'email': email,
        'password':password,
         'login': false,
         'admin':false,
      });
 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text('Inscription réussie ! En attente de l\'approbation de l\'administrateur'),
    duration: Duration(seconds: 2),
  ));
     Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const SignIn()),
                (route) => false);
    } catch (e) {
      print('Erreur lors de l\'inscription : $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de l\'inscription'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                        const SizedBox(height: 20),
                        const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Username field
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == '') {
                                      return "Nom d'utilisateur est vide !";
                                    }
                                    return null;
                                  },
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    hintText: "Nom d'utilisateur",
                                    icon: Icon(Icons.person, color: Colors.black),
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                              const SizedBox(height: 30),
                              // Email field
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == '') {
                                      return "Adresse e-mail est vide !";
                                    } else if (!RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$').hasMatch(value!)) {
                                      return "Adresse e-mail incorrecte !";
                                    }
                                    return null;
                                  },
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    hintText: "Adresse e-mail",
                                    icon: Icon(Icons.mail_outline, color: Colors.black),
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                              const SizedBox(height: 30),
                              // Password field
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == '') {
                                      return "Mot de passe est vide !";
                                    } else if (value!.length < 6) {
                                      return "Mot de passe doit être de 6 caractères ou plus !";
                                    }
                                    return null;
                                  },
                                  obscureText: true,
                                  controller: _passwordController,
                                  decoration: const InputDecoration(
                                    hintText: "Mot de passe",
                                    icon: Icon(Icons.lock, color: Colors.black),
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await _signUp();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(164, 190, 123, 1),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text('SIGN UP'),
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
}
