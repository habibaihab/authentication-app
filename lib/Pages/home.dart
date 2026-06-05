import 'package:authentication/Pages/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> getUserData() async {
    try {
      setState(() => isLoading = true);

      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        setState(() => isLoading = false);
        return;
      }

      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (!userData.exists) {
        setState(() => isLoading = false);
        return;
      }

      final data = userData.data() as Map<String, dynamic>;

      firstNameController.text = data["firstName"] ?? "";
      lastNameController.text = data["lastName"] ?? "";
      phoneController.text = data["phone"] ?? "";
      emailController.text = data["email"] ?? "";

      if (!mounted) return;
      setState(() => isLoading = false);

    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            (route) => false,
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logout failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Container(
            width: double.infinity,
            height: 330,
            decoration: const BoxDecoration(
              color: Color(0xff64C3BF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.arrow_back_ios_new_outlined,
                          color: Colors.white),
                      Text(
                        "Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Icon(Icons.settings, color: Colors.white),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                const CircleAvatar(
                  radius: 55,
                  backgroundImage:
                  AssetImage("assets/images/profile.jpeg"),
                ),

                const SizedBox(height: 10),

                Text(
                  "${firstNameController.text} ${lastNameController.text}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  emailController.text,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: firstNameController,
                  readOnly: true,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff827E7E),
                  ),
                  decoration: const InputDecoration(
                    labelText: "First Name",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                ),

                TextField(
                  controller: lastNameController,
                  readOnly: true,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff827E7E),
                  ),
                  decoration: const InputDecoration(
                    labelText: "Last Name",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                ),

                TextField(
                  controller: phoneController,
                  readOnly: true,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff827E7E),
                  ),
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                ),

                TextField(
                  controller: emailController,
                  readOnly: true,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff827E7E),
                  ),
                  decoration: const InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          InkWell(
            onTap: logout,
            child: Container(
              width: 199,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xff64C3BF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "LOG OUT",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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