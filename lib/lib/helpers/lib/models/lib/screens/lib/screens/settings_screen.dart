import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _resetDatabase(BuildContext context) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('trades');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Semua data jurnal berhasil dibersihkan'), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan & Informasi'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Tentang Aplikasi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.greenAccent),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SMC Trading Journal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 4),
                Text('Versi 1.0.0+1', style: TextStyle(color: Colors.grey, fontSize: 13)),
                SizedBox(height: 12),
                Text(
                  'Aplikasi jurnal trading khusus untuk trader Forex dan Smart Money Concepts (SMC) agar disiplin mencatat setiap setup, emosi, dan evaluasi.',
                  style: TextStyle(color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Pengaturan Data',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
              title: const Text('Hapus Seluruh Data Jurnal', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Mengosongkan database aplikasi', style: TextStyle(color: Colors.grey, fontSize: 12)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: const Color(0xFF1E1E1E),
                    title: const Text('Peringatan!'),
                    content: const Text('Apakah Anda yakin ingin menghapus seluruh riwayat jurnal trading? Tindakan ini tidak dapat dibatalkan.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _resetDatabase(context);
                        },
                        child: const Text('Hapus Semua', style: TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
