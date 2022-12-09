import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucky13capstone/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmationController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  void _authenticate() async {}

  void _register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (r) => false);
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        if (kDebugMode) {
          if (kDebugMode) {
            print('The password provided is too weak.');
          }
        }
      } else if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          print('The account already exists for that email.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Register")),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 370,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/lego.png'),
                          fit: BoxFit.fill)),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 300),
                    child: const Center(
                      child: Text(
                        "Register",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    ))
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  //login form
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10))
                      ]),
                  child: Form(
                    key: _key,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade100))),
                          child: TextFormField(
                            controller: emailController,
                            validator: validateEmail,
                            decoration: InputDecoration(
                                hintText: " Email",
                                prefixIcon: const Icon(Icons.email_outlined,
                                    color: Colors.redAccent),
                                hintStyle: TextStyle(color: Colors.grey[500])),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade100))),
                          child: TextFormField(
                            controller: phoneController,
                            validator: validatePhone,
                            decoration: InputDecoration(
                                hintText: "Phone",
                                prefixIcon: const Icon(Icons.phone,
                                    color: Colors.redAccent),
                                hintStyle: TextStyle(color: Colors.grey[500])),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade100))),
                          child: TextFormField(
                            controller: nameController,
                            validator: validateName,
                            decoration: InputDecoration(
                                hintText: "Full Name",
                                prefixIcon: const Icon(Icons.person,
                                    color: Colors.redAccent),
                                hintStyle: TextStyle(color: Colors.grey[500])),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade100))),
                          child: TextFormField(
                            controller: passwordController,
                            validator: validatePassword,
                            decoration: InputDecoration(
                                hintText: "Password",
                                prefixIcon: const Icon(Icons.lock,
                                    color: Colors.redAccent),
                                hintStyle: TextStyle(color: Colors.grey[500])),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade100))),
                          child: TextFormField(
                            controller: confirmationController,
                            validator: validateConfirmation,
                            decoration: InputDecoration(
                                hintText: "Confirm Password",
                                prefixIcon: const Icon(Icons.lock,
                                    color: Colors.redAccent),
                                hintStyle: TextStyle(color: Colors.grey[500])),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  //registration button
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(colors: [
                        Color.fromRGBO(16, 20, 251, 1),
                        Color.fromRGBO(16, 20, 251, .6),
                      ])),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        _register();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent),
                    child: const Center(
                      child: Text(
                        "Register",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return 'E-mail address is required.';
  }
  //other validations go here
  return null;
}

String? validatePhone(String? formPhone) {
  if (formPhone == null || formPhone.isEmpty) {
    return 'Phone number is required.';
  }
  //other validations go here
  return null;
}

String? validateName(String? formName) {
  if (formName == null || formName.isEmpty) {
    return 'Name is required.';
  }
  //other validations go here
  return null;
}

String? validatePassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty) {
    return 'Password is required.';
  }
  //other validations go here
  return null;
}

String? validateConfirmation(String? formConfirmation) {
  if (formConfirmation == null || formConfirmation.isEmpty) {
    return 'Please confirm your password';
  }
  //other validations go here
  return null;
}
