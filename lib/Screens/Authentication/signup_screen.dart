import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_app/Globle/globle.dart';
import 'package:user_app/Screens/Authentication/Login_scren.dart';
import 'package:user_app/Screens/Main_Screen/Main_screen.dart';
import 'package:user_app/Screens/Splash_Screen.dart/Splash_screen.dart';
import 'package:user_app/Screens/widgets/progress_dialog.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  validateForm() {
    if (nameController.text.length < 3) {
      Fluttertoast.showToast(msg: 'name must be atleast 3 characters.');
    } else if (!emailController.text.contains('@')) {
      Fluttertoast.showToast(msg: 'Email address is not valid.');
    } else if (phoneController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Phone number is required.');
    } else if (passwordController.text.length < 6) {
      Fluttertoast.showToast(msg: 'password must be atleast 6 characters.');
    } else {
      saveDriveInfoNow();
    }
  }

  saveDriveInfoNow() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Basic email format validation
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      Fluttertoast.showToast(msg: "Invalid email format");
      return;
    }

    // Password length validation
    if (password.length < 6) {
      Fluttertoast.showToast(msg: "Password must be at least 6 characters.");
      return;
    }

    // Show progress dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) {
        return ProgressDialog(
          message: 'Progressing please wait....',
        );
      },
    );

    try {
      // Create the user with Firebase
      final User? firebaseUser = (await fAuth
              .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
              .catchError((error) {
        Navigator.pop(context); // Dismiss the dialog
        Fluttertoast.showToast(msg: "Error: $error");
        print("Error during account creation: $error");
        return null;
      }))
          .user;

      // If the user creation was successful
      if (firebaseUser != null) {
        print('Firebase User ID: ${firebaseUser.uid}');

        // Prepare data to save in the database
        Map userMap = {
          "id": firebaseUser.uid,
          "name": nameController.text.trim(),
          "email": email,
          "phone": phoneController.text.trim()
        };

        // Database reference
        DatabaseReference driverRef =
            FirebaseDatabase.instance.ref().child('users');
        print('Database reference: $driverRef');

        // Save the user data in Firebase Realtime Database
        await driverRef.child(firebaseUser.uid).set(userMap).then((_) {
          print('Driver data saved successfully in Realtime Database');
        }).catchError((error) {
          print("Error saving user data: $error");
          Fluttertoast.showToast(msg: "Error saving user data.");
        });

        currentFirebaseUser = firebaseUser;

        // Navigate to CarInfoScreen after successful registration
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => SplashScreen()),
        );
      } else {
        Navigator.pop(context); // Dismiss the dialog
        Fluttertoast.showToast(msg: "Account creation failed.");
      }
    } catch (error) {
      Navigator.pop(context); // Dismiss the dialog
      print("Error: $error");
      Fluttertoast.showToast(msg: "Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset('assets/logo.png'),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Register as a User',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.grey),
                decoration: const InputDecoration(
                    labelText: 'Name',
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 10)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: emailController,
                // keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.grey),
                decoration: const InputDecoration(
                    labelText: 'Email',
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 10)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: phoneController,
                // keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.grey),
                decoration: const InputDecoration(
                    labelText: 'Phone',
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 10)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                // keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.grey),
                decoration: const InputDecoration(
                    labelText: 'Password',
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 10)),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    validateForm();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreenAccent),
                  child: const Text(
                    'Create Accoun',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => const LoginScren()));
                  },
                  child: const Text(
                    'Already have an Account? Login here',
                    style: TextStyle(color: Colors.grey),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
