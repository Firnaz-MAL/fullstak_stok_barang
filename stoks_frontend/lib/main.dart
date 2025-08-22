import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoks_barang/barang_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color baseColor = Color(0xFFB3E5FC); // Soft Sky Blue
  final Color accentMint = Color(0xFFB2DFDB); // Mint

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ✅ ini yang ngilangin tulisan DEBUG
      title: 'Stok Barang',
      theme: ThemeData(
        scaffoldBackgroundColor: baseColor,
        textTheme: GoogleFonts.nunitoTextTheme(),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.cyan).copyWith(secondary: accentMint),
        appBarTheme: AppBarTheme(
          backgroundColor: accentMint,
          foregroundColor: Colors.black,
          titleTextStyle: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentMint,
            foregroundColor: Colors.black,
            textStyle: GoogleFonts.nunito(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final String baseUrl = 'http://192.168.1.130:5000';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('Stok Barang')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory_2, size: 80, color: Colors.cyan[700]),
              SizedBox(height: 20),
              Text(
                'Kelola Stok Barangmu',
                style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                icon: Icon(Icons.list_alt),
                label: Text('Lihat Barang'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BarangPage(baseUrl: baseUrl)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
