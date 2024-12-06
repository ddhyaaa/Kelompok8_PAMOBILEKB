import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; 
import 'auth_controller.dart'; 
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  // Konstruktor untuk membuat state pada RegisterPage
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Deklarasi TextEditingController untuk username
  final TextEditingController _usernameController = TextEditingController();
  // Deklarasi TextEditingController untuk password
  final TextEditingController _passwordController = TextEditingController();
  // Deklarasi GlobalKey untuk form state
  final _formKey = GlobalKey<FormState>();
  // Variabel untuk menyimpan status apakah password terlihat atau tidak
  bool _isPasswordVisible = false;
  // Variabel untuk menyimpan status apakah terms and conditions diterima
  bool _isTermsAccepted = false;

  // Fungsi untuk melakukan registrasi
  Future<void> _register() async {
    // Jika terms and conditions tidak diterima, makaa akan menampilkan pesan error
    if (!_isTermsAccepted) {
      _showErrorDialog('You must agree to the Terms and Conditions to register.');
      return;
    }

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    // Jika username atau password kosong, tampilkan pesan error
    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog('Username and password cannot be empty.');
      return;
    }

    // Gunakan AuthController untuk melakukan registrasi
    await context.read<AuthController>().signUp(username, password, context);
  }

  // Fungsi untuk menampilkan dialog sukses
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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

  // Fungsi untuk membangun tampilan form
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Cegah tombol back untuk kembali ke halaman sebelumnya
        return false; // Mengembalikan false untuk mencegah navigasi kembali
      },
      child: Scaffold(
        backgroundColor: Color(0xffffffff),
        appBar: AppBar(
          backgroundColor: Colors.yellow[800],
          title: Text(
            "Create Account",
            style: GoogleFonts.pacifico(color: Colors.white, fontSize: 24),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false, // Menghilangkan tombol back default
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  "Let's create your account",
                  style: TextStyle(color: Color(0xFFD1470B), fontSize: 18),
                ),
                SizedBox(height: 20),
                // Panggil fungsi _buildTextField untuk input username
                _buildTextField("Email or Username", _usernameController, false),
                SizedBox(height: 20),
                // Panggil fungsi _buildTextField untuk input password
                _buildTextField("Password", _passwordController, true),
                SizedBox(height: 20),
                Row(
                  children: [
                    // Checkbox untuk menerima syarat dan ketentuan
                    Checkbox(
                      value: _isTermsAccepted,
                      onChanged: (value) {
                        // Update status terms diterima
                        setState(() {
                          _isTermsAccepted = value ?? false;
                        });
                      },
                      activeColor: Color(0xFFD1470B),
                      checkColor: Colors.white,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Ubah status penerimaan terms ketika teks diklik
                          setState(() {
                            _isTermsAccepted = !_isTermsAccepted;
                          });
                        },
                        child: Text(
                          "I agree to the Terms and Conditions",
                          style: TextStyle(
                            color: Color(0xFFD1470B),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                ElevatedButton(
                   // Panggil fungsi _register ketika tombol ditekan
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[800],
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text("Sign Up", style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ",
                        style: TextStyle(color: Color(0xFFD1470B))),
                    GestureDetector(
                      onTap: () {
                        // Arahkan pengguna ke halaman Login
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        "Sign In",
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

  // Fungsi untuk membangun text field yang menerima input
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
            // Toggle status visibility password ketika icon diklik
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
        // Validasi untuk memastikan input tidak kosong
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }
}
