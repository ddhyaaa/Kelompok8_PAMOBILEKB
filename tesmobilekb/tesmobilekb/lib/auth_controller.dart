import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController with ChangeNotifier {
  // Deklarasi variabel FirebaseAuth untuk autentikasi
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Deklarasi variabel Firestore untuk database
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Deklarasi variabel ImagePicker untuk memilih gambar
  final ImagePicker _picker = ImagePicker();

  // Deklarasi variabel untuk user saat ini
  User? _user;
  User? get user => _user;

  // Fungsi untuk login dengan username dan password
  Future<void> login(String username, String password, BuildContext context) async {
    try {
      // Memeriksa keberadaan username di Firestore
      final snapshot = await _firestore.collection('users')
          .doc(username) // Menggunakan username sebagai ID dokumen
          .get();

      if (!snapshot.exists) {
        _showErrorDialog(context, "Username not found");
        return;
      }

      // Mendapatkan email yang terkait dengan username
      final email = snapshot['email'];

      // Melakukan login Firebase menggunakan email yang ditemukan
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Menyimpan user ke variabel jika berhasil login
      if (userCredential.user != null) {
        _user = userCredential.user;
        notifyListeners();
      }
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  // Fungsi untuk sign-up dengan username dan password
  Future<void> signUp(String username, String password, BuildContext context) async {
    try {
      // Validasi input username
      if (username.isEmpty || username.length < 3) {
        _showErrorDialog(context, "Username must be at least 3 characters long");
        return;
      }

      if (!RegExp(r"^[a-zA-Z0-9_.-]+$").hasMatch(username)) {
        _showErrorDialog(context, "Username can only contain letters, numbers, underscores, or dots.");
        return;
      }

      // Validasi input password
      if (password.isEmpty || password.length < 6) {
        _showErrorDialog(context, "Password must be at least 6 characters long");
        return;
      }

      // Memeriksa apakah username sudah ada
      final snapshot = await _firestore.collection('users')
          .doc(username) // Menggunakan username sebagai ID dokumen
          .get();

      if (snapshot.exists) {
        _showErrorDialog(context, "Username already exists");
        return;
      }

      // Membuat email berdasarkan username
      final email = "$username@example.com";

      // Membuat akun di FirebaseAuth
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Menyimpan username dan email ke Firestore
      await _firestore.collection('users').doc(username).set({
        'username': username,
        'email': email, // Email yang dibuat
        'createdAt': FieldValue.serverTimestamp(), // Waktu pendaftaran
      });

      // Memperbarui variabel user jika berhasil
      if (userCredential.user != null) {
        _user = userCredential.user;
        notifyListeners();

        // Menampilkan pesan sukses (opsional)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful!')),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      // Penanganan error spesifik dari FirebaseAuth
      if (e.code == 'email-already-in-use') {
        errorMessage = "An account with this email already exists.";
      } else if (e.code == 'weak-password') {
        errorMessage = "The password is too weak.";
      } else {
        errorMessage = "Registration failed: ${e.message}";
      }

      _showErrorDialog(context, errorMessage);
    } catch (e) {
      // Penanganan error umum
      _showErrorDialog(context, "An unexpected error occurred: ${e.toString()}");
    }
  }

  // Fungsi untuk menampilkan dialog error
  void _showErrorDialog(BuildContext context, String message) {
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

  // Fungsi untuk log out
  Future<void> logOut(BuildContext context) async {
    await _firebaseAuth.signOut();
    _user = null;
    notifyListeners();
  }

  // Fungsi untuk memilih gambar dari galeri dan mengunggahnya
  Future<Map<String, dynamic>> pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return {'success': false, 'message': 'No image selected'};
    }

    File file = File(image.path);
    return await _uploadImage(file);
  }

  // Fungsi untuk mengambil foto dari kamera dan mengunggahnya
  Future<Map<String, dynamic>> takePhotoAndUpload() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo == null) {
      return {'success': false, 'message': 'No photo taken'};
    }

    File file = File(photo.path);
    return await _uploadImage(file);
  }

  // Fungsi pembantu untuk mengunggah gambar dan mendapatkan prediksi
  Future<Map<String, dynamic>> _uploadImage(File file) async {
    var uri = Uri.parse(
        'https://detect.roboflow.com/banana-machine-learning/2?api_key=WmYk1uRxzClzxCtDYCO9');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var decodedResponse = json.decode(responseData);

        if (decodedResponse.containsKey('predictions')) {
          return {'success': true, 'image': file, 'predictions': decodedResponse['predictions']};
        } else {
          return {'success': false, 'message': 'No predictions found'};
        }
      } else {
        return {'success': false, 'message': 'Error: ${response.statusCode}'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
