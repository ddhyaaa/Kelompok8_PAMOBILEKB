import 'package:flutter/material.dart';

// Kelas utama aplikasi AboutUs
class AboutUsApp extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {
    // Membangun MaterialApp dengan tema yang ditentukan
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menyembunyikan banner debug
      theme: ThemeData(
        primarySwatch: Colors.orange, // Warna utama aplikasi
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange, // Warna latar belakang AppBar
          foregroundColor: Colors.orange, // Warna teks pada AppBar
        ),
        cardColor: Colors.orange.shade100, // Warna latar belakang kartu
      ),
      home: AboutUsPage(), // Menampilkan AboutUsPage di home
    );
  }
}

// Kelas halaman yang menampilkan informasi tim
class AboutUsPage extends StatelessWidget { 
  // Daftar anggota tim beserta informasi terkait
  final List<Map<String, String>> teamMembers = [
    {
      'name': 'Muhammad Arianda Saputra',
      'role': 'Frontend Developer   2209106027',
      'image': 'assets/ari.jpg'
    },
    {
      'name': 'Raudhya Azzahra',
      'role': 'Frontend Developer   2209106034',
      'image': 'assets/diah.jpg'
    },
    {
      'name': 'Ricky Anggari',
      'role': 'Backend Developer   2209106037',
      'image': 'assets/riki.jpg'
    },
    {
      'name': 'Nadifa Salasabila Purnomo',
      'role': 'Frontend Developer   2209106044',
      'image': 'assets/nana.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Membangun halaman dengan AppBar dan daftar anggota tim
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Team'), 
        centerTitle: true, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), 
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          // Menentukan jumlah item dalam daftar
          itemCount: teamMembers.length, 
          itemBuilder: (context, index) {
             // Mendapatkan data anggota tim berdasarkan indeks
            final member = teamMembers[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), 
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Gambar anggota tim dalam bentuk lingkaran
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(member['image']!), 
                    ),
                    const SizedBox(width: 16), 
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, 
                        children: [
                          // Nama anggota tim
                          Text(
                            member['name']!,
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold, 
                              color: Colors.orange.shade900,
                            ),
                          ),
                          const SizedBox(height: 8), 
                          // Peran anggota tim
                          Text(
                            member['role']!,
                            style: TextStyle(
                              fontSize: 16, 
                              color: Colors.orange.shade700, 
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
