import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';
import 'dart:io';
//import 'login_page.dart';
//import 'about_us_page.dart';
import 'package:provider/provider.dart';
import 'auth_controller.dart';

// Halaman Dashboard utama
class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

// State untuk DashboardPage
class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  // Deklarasi variabel yang digunakan untuk pengambilan gambar dan prediksi
  final ImagePicker _picker = ImagePicker();
  String _predictionResult = '';
  File? _imageFile;
  List<Map<String, dynamic>> _predictions = [];
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    // Inisialisasi state awal halaman Dashboard
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _expandAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selamat datang di Dashboard!')),
      );
    });
  }

  // Fungsi untuk memilih gambar dari galeri dan mengunggahnya
  Future<void> _pickAndUploadImage() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    var result = await authController.pickAndUploadImage();

    if (result['success']) {
      setState(() {
        // Setel gambar yang dipilih
        _imageFile = File(result['image'].path); 
        _predictions = (result['predictions'] as List)
            .map<Map<String, dynamic>>((prediction) {
          return {
            "class": prediction['class'],
            "confidence": (prediction['confidence'] * 100).toStringAsFixed(2),
          };
        }).toList();

        _predictionResult = _predictions.map((prediction) {
          return '${prediction["class"]} (Confidence: ${prediction["confidence"]}%)';
        }).join('\n');
      });
    } else {
      setState(() {
        _predictionResult = result['message'];
        _predictions = [];
        // Reset gambar jika gagal
        _imageFile = null; 
      });
    }
  }

  // Fungsi untuk mengambil foto menggunakan kamera dan mengunggahnya
  Future<void> _takePhotoAndUpload() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    var result = await authController.takePhotoAndUpload();

    if (result['success']) {
      setState(() {
         // Setel gambar yang diambil
        _imageFile = File(result['image'].path); 
        _predictions = (result['predictions'] as List)
            .map<Map<String, dynamic>>((prediction) {
          return {
            "class": prediction['class'],
            "confidence": (prediction['confidence'] * 100).toStringAsFixed(2),
          };
        }).toList();

        _predictionResult = _predictions.map((prediction) {
          return '${prediction["class"]} (Confidence: ${prediction["confidence"]}%)';
        }).join('\n');
      });
    } else {
      setState(() {
        _predictionResult = result['message'];
        _predictions = [];
        // Reset gambar jika gagal
        _imageFile = null; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Widget utama yang membangun UI Dashboard
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Dashboard", style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              SizedBox(height: 24.0),

              // Menampilkan gambar dengan border
              _imageFile != null
                  ? Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange, width: 5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _imageFile!,
                              height: 200.0,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                      ],
                    )
                  : Container(),

              // Menampilkan hasil prediksi dalam kartu
              Text(
                'Hasil Prediksi:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0),

              Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.symmetric(vertical: 10.0),
                color: Colors.orange,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.0),
                      _predictionResult.isEmpty
                          ? Text(
                              'Belum ada hasil.',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _predictions.map((prediction) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Text(
                                    '${prediction["class"]} (Confidence: ${prediction["confidence"]}%)',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                );
                              }).toList(),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Tombol untuk mengambil foto atau memilih gambar
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                  _isExpanded
                      ? _animationController.forward()
                      : _animationController.reverse();
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    _isExpanded ? Icons.close : Icons.camera_alt,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          if (_isExpanded)
            Positioned(
              bottom: 100.0,
              right: 20.0,
              child: FadeTransition(
                opacity: _expandAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton(
                      onPressed: _pickAndUploadImage,
                      backgroundColor: Colors.yellow,
                      child: Icon(Icons.photo),
                    ),
                    SizedBox(height: 10),
                    FloatingActionButton(
                      onPressed: _takePhotoAndUpload,
                      backgroundColor: Color.fromARGB(255, 255, 215, 17),
                      child: Icon(Icons.camera),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
