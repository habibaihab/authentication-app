import 'package:authentication/Pages/login.dart';
import 'package:authentication/Pages/signUp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Column(
        children: [
          Image.asset("assets/images/top.png",width: double.infinity,
            fit: BoxFit.cover,),
          SizedBox(height: 30,),
          Text("Welcome!",style: GoogleFonts.inter(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Color(0xff64C3BF)
          ),),
          Text("Find the things that you Love!",style: GoogleFonts.poppins(
          fontSize: 16,
              color: Color(0xff000000))),
          SizedBox(height: 70,),
          Image.asset("assets/images/welcome.png"),
          SizedBox(height: 40,),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen(),));
            },
            child: Container(
              width: 199.63,
              height: 38.21,
              decoration: BoxDecoration(
                color: Color(0xff64C3BF),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text("Sign Up",style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffffffff))),
              ),
            ),
          ),
          SizedBox(height: 15,),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
            },
            child: Container(
              width: 199.63,
              height: 38.21,
              decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xff64C3BF),width: 2)

              ),
              child: Center(
                child: Text("Login",style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff64C3BF))),
              ),
            ),
          )
        ],
      ),
    );
  }
}
