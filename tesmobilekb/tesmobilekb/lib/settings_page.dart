import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_mode_data.dart';
import 'login_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    // Mengambil data mode tema menggunakan Provider
    final themeModeData = Provider.of<ThemeModeData>(context);

    return Scaffold(
      appBar: AppBar(
        // Menampilkan judul halaman Settings
        title: Text('Settings'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan judul bagian Preferences
            Text(
              'Preferences',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800],
              ),
            ),
            // Menambahkan SizedBox untuk memberikan jarak
            SizedBox(height: 16),
            Container(
              // Membuat kartu pengaturan untuk Dark Mode
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _buildSettingCard(
                title: 'Dark Mode',
                icon: Icons.nightlight_round,
                trailing: Switch(
                  value: themeModeData.isDarkModeActive,
                  onChanged: (value) {
                    // Mengubah tema aplikasi berdasarkan switch
                    themeModeData.changeTheme(
                      value ? ThemeMode.dark : ThemeMode.light,
                    );
                  },
                  activeColor: Colors.orange,
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              // Membuat kartu pengaturan untuk Logout
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _buildSettingCard(
                title: 'Logout',
                icon: Icons.logout,
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () => _showLogoutDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membangun kartu pengaturan
  Widget _buildSettingCard({
    required String title,
    required IconData icon,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      // Menangani aksi ketika kartu ditekan
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            // Menambahkan efek bayangan pada kartu
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              // Membuat ikon pada kartu pengaturan
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange[100],
              ),
              child: Icon(icon, color: Colors.orange, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.black, 
                ),
              ),
            ),
            if (trailing != null) trailing, 
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi logout
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          // Menampilkan ikon dan teks pada judul dialog
          children: [
            Icon(Icons.warning, color: Colors.orange, size: 28),
            SizedBox(width: 8),
            Text(
              'Are you sure?',
              style: TextStyle(
                color: Colors.orange[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          // Pesan konfirmasi logout
          'Do you want to log out?',
          style: TextStyle(color: Colors.orange, fontSize: 15),
        ),
        actions: [
          TextButton(
            // Tombol untuk membatalkan logout
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.orange),
            ),
          ),
          ElevatedButton(
            // Tombol untuk melakukan logout
            onPressed: () {
              Navigator.pop(context); // Menutup dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
