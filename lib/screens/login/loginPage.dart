import 'dart:math';

import 'package:capstone_web/providers/authentication/authProvider.dart';
import 'package:capstone_web/providers/authentication/firebaseAuthMethods.dart';
import 'package:capstone_web/screens/homepage/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = useState(false);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final animationController = useAnimationController(
      duration: const Duration(seconds: 5),
    );

    animationController.repeat();

    void handleLogin(BuildContext context) async {
      isLoading.value = true; // Start loading

      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        showSnackBar(context, 'Please enter email and password');
        isLoading.value = false; // End loading if failed
        return;
      }

      String email =
          emailController.text.trim(); // Trim any leading/trailing spaces

      print("Email: $email"); // Check if the email is correct

      final authMethods = ref.read(firebaseAuthMethodsProvider);
      final userDetails = ref.read(userDetailsProvider);

      // Log in with Firebase first
      UserCredential? userCredential;
      String? firebaseErrorMessage;
      try {
        userCredential = await authMethods.loginWithEmail(
          email: emailController.text,
          password: passwordController.text,
        );
      } catch (e) {
        print('Firebase Login Error: $e');
        firebaseErrorMessage = e.toString(); // Capture the error message
      }

      // If Firebase login was unsuccessful, show the error message
      if (userCredential == null) {
        showSnackBar(
            context, firebaseErrorMessage ?? 'Failed to log in with Firebase');
        isLoading.value = false; // End loading if failed
        return;
      }

      // If Firebase login was successful, log in with your API
      String? apiErrorMessage = await userDetails.loginWithEmailAPI(
        email: userCredential.user?.email ?? '',
        password: passwordController.text,
      );

      isLoading.value = false; // End loading

      if (apiErrorMessage == null) {
        // User details have been updated in the UserDetailsProvider
        // Continue with your navigation or other logic here
        if (userDetails.username != null) {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
        } else {
          showSnackBar(context, 'Failed to fetch user details');
        }
      } else {
        showSnackBar(context, apiErrorMessage);
      }
    }

    return Scaffold(
      backgroundColor: Color(0xFFEBE3D5), // Background color
      body: Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center content vertically
            children: [
              // Left part with the image
              Container(
                width: width * 0.45, // Adjust the width as needed
                height: height,
                child: Image.asset('assets/bg.jpg', fit: BoxFit.fill),
              ),
              SizedBox(
                  width:
                      20.0), // Add some spacing between the image and the login form
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Login',
                            style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)), // Text color
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      // Rest of your login form widgets here

                      // Example:
                      TextField(
                        controller: emailController, // Use your controller
                        decoration: InputDecoration(
                          hintText: 'Email',
                          suffixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        controller: passwordController, // Use your controller
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: Icon(Icons.visibility_off),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Forget password?',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black, // Text color
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => handleLogin(context),
                              style: ElevatedButton.styleFrom(
                                primary:
                                    Color(0xB0A695), // Button background color
                              ),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.black, // Text color
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () {
                          // Navigate to registration screen or use your desired logic
                        },
                        child: Text.rich(
                          TextSpan(
                            text: 'Don\'t have an account? ',
                            children: [
                              TextSpan(
                                text: 'Signup',
                                style: TextStyle(
                                  color: Color(0xffEE7B23),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Show Lottie animation when isLoading is true
      floatingActionButton: isLoading.value
          ? FloatingActionButton(
              backgroundColor: Colors.transparent,
              onPressed: null,
              child: Lottie.network(
                'https://lottie.host/32413dad-2e67-4020-8063-5ccaaa63fcc5/9UVqKYdixL.json',
                width: 100,
                height: 100,
              ),
            )
          : null,
    );
  }
}

class WavyPainter extends CustomPainter {
  final double animation;

  WavyPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.fill;

    // Calculating the phase shift using animation value for each wave
    final phaseShift = animation * 2 * pi;

    // Top wave
    final pathTop = Path()
      ..moveTo(0, 10 * sin(phaseShift))
      ..quadraticBezierTo(size.width / 4, 10 * sin(phaseShift + pi / 2),
          size.width / 2, 10 * sin(phaseShift))
      ..quadraticBezierTo(size.width * 3 / 4, 10 * sin(phaseShift - pi / 2),
          size.width, 10 * sin(phaseShift))
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(pathTop, paint);

    // Bottom wave (mirroring the top wave)
    final pathBottom = Path()
      ..moveTo(0, size.height - 10 * sin(phaseShift))
      ..quadraticBezierTo(
          size.width / 4,
          size.height - 10 * sin(phaseShift + pi / 2),
          size.width / 2,
          size.height - 10 * sin(phaseShift))
      ..quadraticBezierTo(
          size.width * 3 / 4,
          size.height - 10 * sin(phaseShift - pi / 2),
          size.width,
          size.height - 10 * sin(phaseShift))
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(pathBottom, paint);

    // Left wave
    final pathLeft = Path()
      ..moveTo(10 * sin(phaseShift), 0)
      ..quadraticBezierTo(10 * sin(phaseShift + pi / 2), size.height / 4,
          10 * sin(phaseShift), size.height / 2)
      ..quadraticBezierTo(10 * sin(phaseShift - pi / 2), size.height * 3 / 4,
          10 * sin(phaseShift), size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(pathLeft, paint);

    // Right wave (mirroring the left wave)
    final pathRight = Path()
      ..moveTo(size.width - 10 * sin(phaseShift), 0)
      ..quadraticBezierTo(size.width - 10 * sin(phaseShift + pi / 2),
          size.height / 4, size.width - 10 * sin(phaseShift), size.height / 2)
      ..quadraticBezierTo(size.width - 10 * sin(phaseShift - pi / 2),
          size.height * 3 / 4, size.width - 10 * sin(phaseShift), size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(pathRight, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Next Screen')),
      body: const Center(child: Text('Welcome to the next screen!')),
    );
  }
}
