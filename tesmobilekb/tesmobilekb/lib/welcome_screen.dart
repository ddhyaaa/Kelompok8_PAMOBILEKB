import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';  // Impor package google_fonts
import 'login_page.dart';  // Mengimpor halaman Login

class WelcomeScreen extends StatelessWidget {
  @override
  // Fungsi build untuk membuat tampilan halaman utama
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          // Container untuk latar belakang dengan gambar
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg2.jpg"), // Gambar latar belakang
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Penempatan logo di pojok kanan atas
          Positioned(
            top: 40,
            right: 10,
            child: Row(
              children: [
                // Logo pertama
                Container(
                  decoration: BoxDecoration(
                    // Latar belakang oranye dengan opacity
                    color: Colors.orange.withOpacity(0.6), 
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Image.asset(
                    "assets/unmul.png",
                    width: 50,
                    height: 50,
                  ),
                ),
                SizedBox(width: 10),
                // Logo kedua
                Container(
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.6), // Latar belakang oranye dengan opacity
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Image.asset(
                    "assets/informatika.png",
                    width: 50,
                    height: 50,
                  ),
                ),
              ],
            ),
          ),

          // Menambahkan SizedBox untuk space diatas
          Positioned(
            top: 40,  
            left: 20,  
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                children: [
                  // Baris Pertama
                  TextSpan(
                    text: "Aplikasi Deteksi\n",
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, 
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black.withOpacity(0.7), 
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                  ),
                  // Baris kedua 
                  TextSpan(
                    text: "Buah Pisang Segar\n",
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, 
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black.withOpacity(0.7), 
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                  ),
                  // Baris ketiga
                  TextSpan(
                    text: "Dan Pisang Busuk\n",
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, 
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black.withOpacity(0.7), 
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // Tombol Get Start di bagian bawah tengah -> ke register
          Positioned(
            bottom: 40,
            left: 0,
            right: 20,
            child: Center(
              child: Material(
                color: Colors.orange,  
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: () {
                    // mengarah ke halaman Login atau Register
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(), 
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                    child: Text(
                      "Get Started",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black.withOpacity(0.5), 
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
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
