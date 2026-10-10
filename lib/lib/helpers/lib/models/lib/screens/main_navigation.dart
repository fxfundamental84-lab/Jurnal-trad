import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/trade_model.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const PlaceholderScreen(title: 'Riwayat Jurnal Trading'),
    const AddTradeScreen(),
    const PlaceholderScreen(title: 'Evaluasi & Performa'),
    const PlaceholderScreen(title: 'Pengaturan & Backup'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Jurnal'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 32), label: 'Tambah'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Evaluasi'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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

  @override
  Widget build(BuildContext context) {
    int totalTrade = trades.length;
    double totalProfitLoss = trades.fold(0, (sum, item) => sum + item.profitOrLoss);
    int winCount = trades.where((element) => element.result == 'Profit').length;
    int lossCount = trades.where((element) => element.result == 'Loss').length;
    double winRate = totalTrade > 0 ? (winCount / totalTrade) * 100 : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard SMC Journal'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.greenAccent))
          : RefreshIndicator(
              onRefresh: _loadTrades,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Kartu Ringkasan PnL Utama
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: totalProfitLoss >= 0 ? Colors.greenAccent : Colors.redAccent,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Profit / Loss', style: TextStyle(color: Colors.grey, fontSize: 14)),
                        const SizedBox(height: 8),
                        Text(
                          '${totalProfitLoss >= 0 ? "+" : ""}\$${totalProfitLoss.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: totalProfitLoss >= 0 ? Colors.greenAccent : Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Grid Statistik Performa
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics,
                    childAspectRatio: 1.5,
                    children: [
                      _buildStatCard('Total Trade', '$totalTrade', Colors.white),
                      _buildStatCard('Win Rate', '${winRate.toStringAsFixed(1)}%', Colors.blueAccent),
                      _buildStatCard('Profit (Win)', '$winCount Trade', Colors.greenAccent),
                      _buildStatCard('Loss', '$lossCount Trade', Colors.redAccent),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(String title, String value, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
          ),
        ],
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, color: Colors.white70),
        ),
      ),
    );
  }
}
