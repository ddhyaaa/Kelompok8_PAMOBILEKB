import 'dart:ui';
import 'package:flutter/material.dart';
import 'about_us_page.dart';
import 'dashboard_page.dart';
import 'settings_page.dart';

// Deklarasi class HomePage sebagai StatelessWidget
class HomePage extends StatelessWidget {
  // Deklarasi variabel username dengan parameter required
  final String username;
  // konstruktor
  HomePage({required this.username});

  // Fungsi untuk memformat username agar hanya menampilkan bagian sebelum '@'
  String getFormattedUsername() {
    return username.split('@')[0];
  }

  // Deklarasi list produk untuk ditampilkan pada halaman
  final List<Map<String, dynamic>> products = [
    {
      "image": "assets/IMG_8988.PNG",
      "name": "   Segar",
      "description":
      "Pisang Segar, biasanya dapat dilihat dari warna buah pisang yang berwarna kuning cerah.",
    },
    {
      "image": "assets/IMG_9001.PNG",
      "name": "   Busuk",
      "description":
      "Pisang Busuk, biasanya dapat di lihat dari perubahan warna pada buah pisang yang mulai menggelap.",
    },
    {
      "image": "assets/IMG_9087.PNG",
      "name": "Tata Cara",
      "description":
      "• Tekan Logo Kamera\n• Pilih Sumber Gambar: Kamera HP atau Album Foto\n• Ambil Foto (Jika Pilih Kamera).\n• Pilih Gambar (Jika Pilih Album) \n• Hasil ditampilkan"
    }
  ];

  // Fungsi untuk menangani navigasi berdasarkan item BottomNavigationBar yang diklik
  void _onBottomNavTap(BuildContext context, int index) {
    // Percabangan untuk menentukan halaman yang dituju berdasarkan indeks
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AboutUsPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsPage()),
      );
    }
  }

  // Override fungsi build untuk membangun UI halaman
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Deklarasi AppBar pada Scaffold
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.yellow[900],
        title: Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          // Tombol ikon kamera di AppBar
          IconButton(
            icon: Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
            onPressed: () {
              // Navigasi ke DashboardPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardPage()),
              );
            },
          ),
        ],
      ),
      // Bagian utama konten halaman
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text(
                'Hello',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                  height: 0.1,
                ),
              ),
              Text(
                getFormattedUsername() + " !",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w900,
                  fontSize: 35,
                ),
              ),
              SizedBox(height: 16),
              // Bagian untuk menampilkan card secara horizontal
              SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return HorizontalProductCard(
                      productName: product["name"],
                      image: product["image"],
                      description: product["description"],
                    );
                  },
                ),
              ),
              // Bagian untuk menampilkan metrik dataset
              SizedBox(height: 20),
              DatasetMetrics(),
            ],
          ),
        ),
      ),
      // Deklarasi BottomNavigationBar
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.orange,
          type: BottomNavigationBarType.fixed,
          elevation: 10,
          onTap: (index) => _onBottomNavTap(context, index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.orange,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline),
              label: 'About Us',
              backgroundColor: Colors.orange,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}

// Deklarasi class HorizontalProductCard sebagai StatelessWidget
class HorizontalProductCard extends StatelessWidget {
  // Deklarasi atribut untuk gambar, nama produk, dan deskripsi
  final String image;
  final String productName;
  final String description;

  const HorizontalProductCard({
    required this.image,
    required this.productName,
    required this.description,
  });

  // Override fungsi build untuk membangun tampilan kartu produk
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: EdgeInsets.only(right: 16),
      child: Stack(
        children: [
          // Bagian latar belakang kartu
          Positioned.fill(
            left: 40,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Tombol untuk menampilkan detail produk
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return Stack(
                                children: [
                                  // Konten modal bottom sheet
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 10.0,
                                          sigmaY: 10.0,
                                        ),
                                        child: Container(
                                          color: Colors.orange.withOpacity(0.6),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  productName,
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  description,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text("Read More"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bagian nama produk di posisi atas kartu
          Positioned(
            left: 80,
            top: 10,
            child: Text(
              productName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          // Bagian gambar produk
          Positioned(
            left: -5,
            top: 50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DatasetMetrics extends StatelessWidget {
  // Fungsi utama untuk membangun widget DatasetMetrics
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Menampilkan judul informasi dataset
          Text(
            'Dataset Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.orange[900],
            ),
          ),
          SizedBox(height: 12),

          // Memanggil kartu metrik untuk jumlah dataset
          _buildMetricCard(
            'Number of Datasets',
            '200',
            Icons.dataset,
            Colors.orange[700],
          ),
          SizedBox(height: 16),

          // Menampilkan label "Metrics:"
          Text(
            'Metrics:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange[800],
            ),
          ),
          SizedBox(height: 10),

          // Membuat kolom untuk beberapa metrik
          Column(
            children: [
              _buildMetricCard(
                  'mAP', '88.9%', Icons.assessment, Colors.green[700]),
              SizedBox(height: 12),
              _buildMetricCard(
                  'Precision', '80.6%', Icons.check_circle, Colors.blue[700]),
              SizedBox(height: 12),
              _buildMetricCard(
                  'Recall', '83.6%', Icons.replay, Colors.purple[700]),
            ],
          ),
          SizedBox(height: 20),

          // Garis pembagi untuk memisahkan bagian
          Divider(thickness: 1.5, color: Colors.orange[300]),
          SizedBox(height: 20),

          // Bagian informasi tentang YOLOv8
          Text(
            'About YOLOv8',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.orange[900],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'YOLOv8 adalah versi terbaru dari algoritma You Only Look Once (YOLO), yang dirancang untuk deteksi objek secara real-time. YOLOv8 memiliki keunggulan dalam akurasi yang lebih tinggi, kecepatan pemrosesan yang lebih baik, dan optimasi arsitektur model dibandingkan dengan versi sebelumnya. Teknologi ini sangat cocok untuk aplikasi yang membutuhkan identifikasi objek secara cepat dan tepat.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),

          // Menampilkan gambar arsitektur YOLOv8
          Center(
            child: Image.asset(
              'assets/arsitektur.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20),

          // Menampilkan kegunaan YOLOv8
          Text(
            'Kegunaan YOLOv8 dalam Deteksi Pisang Segar dan Busuk:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange[900],
            ),
          ),
          SizedBox(height: 12),

          // Kartu metrik untuk setiap kegunaan YOLOv8
          _buildMetricCard(
            'Klasifikasi Otomatis',
            'Mendeteksi dan mengklasifikasikan pisang segar dan busuk secara otomatis.',
            Icons.category,
            Colors.green[700],
          ),
          SizedBox(height: 12),
          _buildMetricCard(
            'Peningkatan Efisiensi',
            'Meningkatkan efisiensi dalam memilah pisang berdasarkan kondisi.',
            Icons.speed,
            Colors.blue[700],
          ),
          SizedBox(height: 12),
          _buildMetricCard(
            'Pengendalian Kualitas',
            'Memastikan pisang berkualitas baik dikirim ke pasar.',
            Icons.verified,
            Colors.orange[700],
          ),
          SizedBox(height: 12),
          _buildMetricCard(
            'Dukungan Pertanian Cerdas',
            'Membantu proses otomatisasi dalam pengelolaan kualitas hasil panen.',
            Icons.agriculture,
            Colors.purple[700],
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membangun widget card metrik
  Widget _buildMetricCard(
      String title,
      String description,
      IconData icon,
      Color? iconColor,
      ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ikon metrik
          Icon(icon, color: iconColor, size: 30),
          SizedBox(width: 16),
          // Menampilkan informasi metrik
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
