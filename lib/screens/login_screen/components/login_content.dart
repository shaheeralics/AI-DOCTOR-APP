import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:login_screen/utils/helper_functions.dart';

import '../../../utils/constants.dart';
import '../../doctor_selection_screen/doctor_selection_screen.dart'; // Import doctor selection screen
import '../animations/change_screen_animation.dart';
import 'bottom_text.dart';
import 'top_text.dart';

enum Screens {
  createAccount,
  welcomeBack,
}

class LoginContent extends StatefulWidget {
  const LoginContent({Key? key}) : super(key: key);

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent>
    with TickerProviderStateMixin {
  late final List<Widget> createAccountContent;
  late final List<Widget> loginContent;
  
  // Form controllers for authentication
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    ChangeScreenAnimation.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // Input field
  Widget inputField(String hint, IconData iconData, {TextEditingController? controller, bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: SizedBox(
        height: 50,
        child: Material(
          elevation: 8,
          shadowColor: kMedicalBlue.withOpacity(0.2),
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword,
            textAlignVertical: TextAlignVertical.bottom,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              if (hint == 'Email' && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: kCardBackground,
              hintText: hint,
              hintStyle: TextStyle(
                color: kTextSecondary,
                fontFamily: 'Montserrat',
              ),
              prefixIcon: Icon(
                iconData,
                color: kMedicalBlue,
              ),
            ),
            style: const TextStyle(
              fontFamily: 'Montserrat',
              color: kTextPrimary,
            ),
          ),
        ),
      ),
    );
  }

  // Authentication methods
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      // TODO: Replace with your actual authentication logic
      await _authenticateUser(_emailController.text, _passwordController.text);
      
      // Navigate to doctor selection screen on success
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DoctorSelectionScreen(),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      // TODO: Replace with your actual registration logic
      await _registerUser(_nameController.text, _emailController.text, _passwordController.text);
      
      // Navigate to doctor selection screen on success
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DoctorSelectionScreen(),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // TODO: Implement your authentication logic here
  Future<void> _authenticateUser(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Replace this with your actual authentication logic:
    // - Firebase Auth: FirebaseAuth.instance.signInWithEmailAndPassword()
    // - Custom API: http.post() to your backend
    // - Local storage: SQLite query
    
    // For now, accept any email/password combination
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Invalid credentials');
    }
  }

  Future<void> _registerUser(String name, String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Replace this with your actual registration logic:
    // - Firebase Auth: FirebaseAuth.instance.createUserWithEmailAndPassword()
    // - Custom API: http.post() to your backend
    // - Local storage: SQLite insert
    
    // For now, accept any valid data
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      throw Exception('All fields are required');
    }
  }

  Widget loginButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
      child: ElevatedButton(
        onPressed: _isLoading ? null : () async {
          if (title == 'Sign Up') {
            await _handleSignUp();
          } else {
            await _handleLogin();
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const StadiumBorder(),
          backgroundColor: kMedicalBlue,
          elevation: 8,
          shadowColor: kMedicalBlue.withOpacity(0.4),
        ),
        child: _isLoading 
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Montserrat',
          ),
        ),
      ),
    );
  }

  Widget orDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 8),
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: 1,
              color: kPrimaryColor,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'or',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: Container(
              height: 1,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget logos() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/facebook.png'),
          const SizedBox(width: 24),
          Image.asset('assets/images/google.png'),
        ],
      ),
    );
  }

  Widget forgotPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 110),
      child: TextButton(
        onPressed: () {},
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: kSecondaryColor,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    createAccountContent = [
      inputField('Name', Ionicons.person_outline),
      inputField('Email', Ionicons.mail_outline),
      inputField('Password', Ionicons.lock_closed_outline),
      loginButton('Sign Up'),
      orDivider(),
      logos(),
    ];

    loginContent = [
      inputField('Email', Ionicons.mail_outline),
      inputField('Password', Ionicons.lock_closed_outline),
      loginButton('Log In'),
      forgotPassword(),
      orDivider(),
      logos(),
    ];

    ChangeScreenAnimation.initialize(
      vsync: this,
      createAccountItems: createAccountContent.length,
      loginItems: loginContent.length,
    );

    for (var i = 0; i < createAccountContent.length; i++) {
      createAccountContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.createAccountAnimations[i],
        child: createAccountContent[i],
      );
    }

    for (var i = 0; i < loginContent.length; i++) {
      loginContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.loginAnimations[i],
        child: loginContent[i],
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          top: 80,
          left: 0, // Changed from 24 to 0
          right: 0, // Added right: 0 to make it take full width for centering
          child: TopText(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: createAccountContent,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: loginContent,
              ),
            ],
          ),
        ),
        
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: BottomText(),
          ),
        ),
      ],
    );
  }
}
