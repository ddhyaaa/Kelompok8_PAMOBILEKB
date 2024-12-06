import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'home_page.dart'; 
import 'register_page.dart';

// Halaman login yang menggunakan StatefulWidget
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

// State untuk halaman login
class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController(); // Controller untuk input username
  final TextEditingController _passwordController = TextEditingController(); // Controller untuk input password
  final _formKey = GlobalKey<FormState>(); // Kunci global untuk form
  bool _isPasswordVisible = false; // Variabel untuk mengatur visibilitas password
  bool _rememberMe = false; // Variabel untuk mengatur apakah "remember me" dicentang

  final FirebaseAuth _auth = FirebaseAuth.instance; // Instance FirebaseAuth untuk autentikasi

  // Fungsi untuk memvalidasi format email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
    return emailRegex.hasMatch(email); 
  }

  // Fungsi untuk menambahkan @example.com ke username jika belum ada
  String _formatUsername(String username) {
    if (!username.contains('@') && !username.endsWith('@example.com')) {
       // Menambahkan domain email jika tidak ada
      return username + '@example.com';
    }
    return username; // Mengembalikan username jika sudah valid
  }

  // Fungsi untuk login
  Future<void> _login() async {
    String username = _usernameController.text.trim(); // Mengambil teks dari input username
    final password = _passwordController.text; // Mengambil teks dari input password

    // Format username agar menjadi email yang valid
    username = _formatUsername(username);

    // Validasi email
    if (!_isValidEmail(username)) {
      _showErrorDialog('Please enter a valid email address.'); 
      return;
    }

    // Validasi form
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Mencoba untuk login dengan email dan password
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: username,
          password: password,
        );

        // Jika login berhasil, arahkan ke HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(username: username)), 
        );
      } on FirebaseAuthException catch (e) {
        // Menampilkan pesan error jika login gagal
        _showErrorDialog(e.message ?? 'Login failed. Please try again.');
      }
    }
  }

  // Fungsi untuk menampilkan dialog error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Build method untuk membangun tampilan halaman login
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Mencegah pengguna kembali ke halaman sebelumnya menggunakan tombol back
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xffffffff),
        appBar: AppBar(
          backgroundColor: Colors.yellow[800],
          title: Text(
            "Login",
            style: GoogleFonts.pacifico(color: Colors.white, fontSize: 24),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false, // Menghilangkan panah kembali (default awal)
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  "Sign in to continue",
                  style: TextStyle(color: Color(0xFFD1470B), fontSize: 18),
                ),
                SizedBox(height: 20),
                _buildTextField("Email", _usernameController, false), 
                SizedBox(height: 20),
                _buildTextField("Password", _passwordController, true), 
                SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          // Mengatur status checkbox "remember me"
                          _rememberMe = value ?? false; 
                        });
                      },
                      activeColor: Color(0xFFD1470B),
                      checkColor: Colors.white,
                    ),
                    Text(
                      "Remember Me",
                      style: TextStyle(color: Color(0xFFD1470B)),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _login, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[800],
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text("Sign In", style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ",
                        style: TextStyle(color: Color(0xFFD1470B))),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage()),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Color(0xFFD1470B),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk membuat widget TextFormField dengan label dan controller
  Widget _buildTextField(String label, TextEditingController controller, bool isPassword) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible, 
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0xFFD1470B)),
        prefixIcon: Icon(
          isPassword ? Icons.lock_outline : Icons.email_outlined,
          color: Color(0xFFD1470B),
        ),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Color(0xFFD1470B),
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible; 
            });
          },
        )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Color(0xFFFFB703), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Color(0xFFD1470B), width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label'; 
        }
        return null;
      },
    );
  }
}
