import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/trade_model.dart';

class EvaluationScreen extends StatefulWidget {
  const EvaluationScreen({super.key});

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  List<TradeModel> trades = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    final data = await DatabaseHelper.instance.queryAllTrades();
    setState(() {
      trades = data.map((e) => TradeModel.fromMap(e)).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalTrade = trades.length;
    int planFollowedCount = trades.where((e) => e.isPlanFollowed == 'Ya').length;
    int slFollowedCount = trades.where((e) => e.isSlFollowed == 'Ya').length;
    
    double planCompliance = totalTrade > 0 ? (planFollowedCount / totalTrade) * 100 : 0;
    double slCompliance = totalTrade > 0 ? (slFollowedCount / totalTrade) * 100 : 0;

    // Analisis emosi terbanyak yang sering muncul saat loss
    Map<String, int> emotionLossCount = {};
    for (var trade in trades) {
      if (trade.result == 'Loss' && trade.emotion != null) {
        emotionLossCount[trade.emotion!] = (emotionLossCount[trade.emotion!] ?? 0) + 1;
      }
    }

    String topEmotionError = 'Belum ada data';
    if (emotionLossCount.isNotEmpty) {
      var sortedEmotions = emotionLossCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      topEmotionError = '${sortedEmotions.first.key} (${sortedEmotions.first.value}x kejadian)';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluasi & Performa Trading'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.greenAccent))
          : totalTrade == 0
              ? const Center(
                  child: Text(
                    'Belum ada data untuk dievaluasi.\nSilakan isi jurnal trading terlebih dahulu.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const Text(
                        'Ringkasan Evaluasi Otomatis',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Kepatuhan Rencana Trading (Plan)', style: TextStyle(color: Colors.grey, fontSize: 13)),
                            const SizedBox(height: 4),
                            Text('${planCompliance.toStringAsFixed(1)}% ($planFollowedCount dari $totalTrade trade)',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            const SizedBox(height: 16),
                            const Text('Kepatuhan Stop Loss (SL)', style: TextStyle(color: Colors.grey, fontSize: 13)),
                            const SizedBox(height: 4),
                            Text('${slCompliance.toStringAsFixed(1)}% ($slFollowedCount dari $totalTrade trade)',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            const SizedBox(height: 16),
                            const Text('Emosi Dominan Saat Mengalami Loss', style: TextStyle(color: Colors.grey, fontSize: 13)),
                            const SizedBox(height: 4),
                            Text(topEmotionError,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Tips Perbaikan SMC:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                        ),
                        child: const Text(
                          '• Pastikan selalu menunggu konfirmasi Break of Structure (BOS) dan Change of Character (CHoCH) sebelum entry di area Order Block atau FVG.\n\n'
                          '• Jangan memindahkan Stop Loss ketika harga mendekati area SL Anda. Pertahankan manajemen risiko yang disiplin.',
                          style: TextStyle(color: Colors.white70, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
