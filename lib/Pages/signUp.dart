import 'package:authentication/Pages/home.dart';
import 'package:authentication/Pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TextEditingController firstName;
  late final TextEditingController lastName;
  late final TextEditingController email;
  late final TextEditingController phoneNumber;
  late final TextEditingController password;
  late final TextEditingController confirm;

  final formKey = GlobalKey<FormState>();

  bool showPassword = true;
  bool showConfirmPassword = true;
  bool isLoading = false;

  final border = const OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xff64C3BF),
      width: 3,
    ),
  );

  @override
  void initState() {
    super.initState();

    firstName = TextEditingController();
    lastName = TextEditingController();
    email = TextEditingController();
    phoneNumber = TextEditingController();
    password = TextEditingController();
    confirm = TextEditingController();
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    phoneNumber.dispose();
    password.dispose();
    confirm.dispose();
    super.dispose();
  }

  String? validateEmpty(String? value, String msg) {
    if (value == null || value.trim().isEmpty) {
      return msg;
    }
    return null;
  }

  Future<void> signUp() async {
    try {
      setState(() => isLoading = true);

      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.user!.uid)
          .set({
        "firstName": firstName.text.trim(),
        "lastName": lastName.text.trim(),
        "email": email.text.trim(),
        "phone": phoneNumber.text.trim(),
        "createdAt": DateTime.now(),
      });

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Authentication error")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/top.png",
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 30),

            Text(
              "Create Account",
              style: GoogleFonts.inter(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: const Color(0xff64C3BF),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: firstName,
                      decoration: InputDecoration(
                        hintText: "First Name",
                        enabledBorder: border,
                        focusedBorder: border,
                      ),
                      validator: (value) =>
                          validateEmpty(value, "First Name is Required"),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: lastName,
                      decoration: InputDecoration(
                        hintText: "Last Name",
                        enabledBorder: border,
                        focusedBorder: border,
                      ),
                      validator: (value) =>
                          validateEmpty(value, "Last Name is Required"),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: phoneNumber,
                      decoration: InputDecoration(
                        hintText: "Phone Number",
                        enabledBorder: border,
                        focusedBorder: border,
                      ),
                      validator: (value) =>
                          validateEmpty(value, "Phone Number is Required"),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        hintText: "Email",
                        enabledBorder: border,
                        focusedBorder: border,
                      ),
                      validator: (value) {
                        if (validateEmpty(value, "Email Required") != null) {
                          return "Email Required";
                        }
                        if (!value!.contains("@")) {
                          return "Enter valid email";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: password,
                      obscureText: showPassword,
                      decoration: InputDecoration(
                        hintText: "Password",
                        enabledBorder: border,
                        focusedBorder: border,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          icon: Icon(
                            showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (validateEmpty(value, "Password Required") != null) {
                          return "Password Required";
                        }
                        if (value!.length < 6) {
                          return "Minimum 6 characters";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: confirm,
                      obscureText: showConfirmPassword,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        enabledBorder: border,
                        focusedBorder: border,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showConfirmPassword = !showConfirmPassword;
                            });
                          },
                          icon: Icon(
                            showConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (validateEmpty(value, "Required") != null) {
                          return "Required";
                        }
                        if (value != password.text) {
                          return "Passwords don't match";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            InkWell(
              onTap: isLoading
                  ? null
                  : () async {
                if (formKey.currentState!.validate()) {
                  await signUp();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                }
              },
              child: Container(
                width: 199,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xff64C3BF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Sign Up",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Color(0xff64C3BF)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
