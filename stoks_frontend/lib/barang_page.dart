import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BarangPage extends StatefulWidget {
  final String baseUrl;
  BarangPage({required this.baseUrl});

  @override
  _BarangPageState createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  List barang = [];
  final _namaController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _hargaController = TextEditingController();

  Future<void> fetchBarang() async {
    final response = await http.get(Uri.parse('${widget.baseUrl}/api/barang'));
    if (response.statusCode == 200) {
      setState(() {
        barang = json.decode(response.body);
      });
    }
  }

  Future<void> createBarang() async {
    final response = await http.post(
      Uri.parse('${widget.baseUrl}/api/barang'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama': _namaController.text,
        'jumlah': _jumlahController.text,
        'harga': _hargaController.text,
      }),
    );

    if (response.statusCode == 201) {
      fetchBarang();
      _namaController.clear();
      _jumlahController.clear();
      _hargaController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Barang berhasil ditambahkan')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan barang')),
      );
    }
  }

  Future<void> updateBarang(int id, String nama, String jumlah, String harga) async {
    final response = await http.put(
      Uri.parse('${widget.baseUrl}/api/barang/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nama': nama, 'jumlah': jumlah, 'harga': harga}),
    );

    if (response.statusCode == 200) {
      fetchBarang();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Barang berhasil diperbarui')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui barang')),
      );
    }
  }

  Future<void> deleteBarang(int id) async {
    final response = await http.delete(Uri.parse('${widget.baseUrl}/api/barang/$id'));
    if (response.statusCode == 200) {
      fetchBarang();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Barang berhasil dihapus')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus barang')),
      );
    }
  }

  void showEditDialog(Map barangData) {
    int jumlah = int.tryParse(barangData['jumlah'].toString()) ?? 0;
    final namaController = TextEditingController(text: barangData['nama']);
    final hargaController = TextEditingController(text: barangData['harga'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Edit Barang', style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: namaController, decoration: InputDecoration(labelText: 'Nama')),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          setStateDialog(() {
                            jumlah = jumlah > 0 ? jumlah - 1 : 0;
                          });
                        },
                      ),
                      Expanded(
                        child: Text('Jumlah: $jumlah', style: GoogleFonts.nunito()),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () {
                          setStateDialog(() {
                            jumlah++;
                          });
                        },
                      ),
                    ],
                  ),
                  TextField(controller: hargaController, decoration: InputDecoration(labelText: 'Harga')),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text('Batal')),
                ElevatedButton(
                  onPressed: () {
                    updateBarang(barangData['id'], namaController.text, jumlah.toString(), hargaController.text);
                    Navigator.pop(context);
                  },
                  child: Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchBarang();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('Daftar Barang')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 10),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _namaController,
                      decoration: InputDecoration(labelText: 'Nama', prefixIcon: Icon(Icons.label)),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _jumlahController,
                      decoration: InputDecoration(labelText: 'Jumlah', prefixIcon: Icon(Icons.confirmation_number)),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _hargaController,
                      decoration: InputDecoration(labelText: 'Harga', prefixIcon: Icon(Icons.attach_money)),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('Tambah Barang'),
                      onPressed: createBarang,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: barang.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: barang.length,
                      itemBuilder: (context, index) {
                        final item = barang[index];
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            title: Text(item['nama'], style: GoogleFonts.nunito(fontWeight: FontWeight.w600)),
                            subtitle: Text(
                              'Jumlah: ${item['jumlah']} | Harga: ${item['harga']}',
                              style: GoogleFonts.nunito(fontSize: 14),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.cyan[700]),
                                  onPressed: () => showEditDialog(item),
                                  tooltip: 'Edit Barang',
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () => deleteBarang(item['id']),
                                  tooltip: 'Hapus Barang',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
