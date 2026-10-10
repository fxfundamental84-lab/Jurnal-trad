import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/trade_model.dart';
import 'package:intl/intl.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  List<TradeModel> trades = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrades();
  }

  Future<void> _loadTrades() async {
    setState(() => isLoading = true);
    final data = await DatabaseHelper.instance.queryAllTrades();
    setState(() {
      trades = data.map((e) => TradeModel.fromMap(e)).toList();
      isLoading = false;
    });
  }

  Future<void> _deleteTrade(int id) async {
    await DatabaseHelper.instance.deleteTrade(id);
    _loadTrades();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Catatan trade berhasil dihapus'), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Jurnal Trading'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.greenAccent))
          : trades.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada jurnal trading.\nSilakan tambah di menu Tambah.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadTrades,
                  child: ListView.builder(
                    itemCount: trades.length,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      final trade = trades[index];
                      final isProfit = trade.profitOrLoss >= 0;
                      final formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(trade.dateTime));

                      return Card(
                        color: const Color(0xFF1E1E1E),
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        trade.pair,
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: trade.position == 'BUY' ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          trade.position,
                                          style: TextStyle(
                                            color: trade.position == 'BUY' ? Colors.greenAccent : Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${isProfit ? "+" : ""}\$${trade.profitOrLoss.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isProfit ? Colors.greenAccent : Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(formattedDate, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              const Divider(height: 16, color: Colors.grey),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Entry: ${trade.entryPrice} | SL: ${trade.stopLoss}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                    onPressed: () {
                                      showDialog(
                                        context: dialogContext = context,
                                        builder: (ctx) => AlertDialog(
                                          backgroundColor: const Color(0xFF1E1E1E),
                                          title: const Text('Hapus Catatan?'),
                                          content: const Text('Apakah Anda yakin ingin menghapus jurnal trade ini?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(ctx),
                                              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(ctx);
                                                _deleteTrade(trade.id!);
                                              },
                                              child: const Text('Hapus', style: TextStyle(color: Colors.redAccent)),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              if (trade.smcSetup != null && trade.smcSetup!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text('Setup: ${trade.smcSetup}', style: const TextStyle(color: Colors.blueAccent, fontSize: 12)),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  // Variabel bantu untuk dialog
  late BuildContext dialogContext;
}
