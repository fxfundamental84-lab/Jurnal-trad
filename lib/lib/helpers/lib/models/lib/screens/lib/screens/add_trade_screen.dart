import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';

class AddTradeScreen extends StatefulWidget {
  const AddTradeScreen({super.key});

  @override
  State<AddTradeScreen> createState() => _AddTradeScreenState();
}

class _AddTradeScreenState extends State<AddTradeScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _pairController = TextEditingController(text: 'XAUUSD');
  final TextEditingController _entryController = TextEditingController();
  final TextEditingController _slController = TextEditingController();
  final TextEditingController _tpController = TextEditingController();
  final TextEditingController _lotController = TextEditingController(text: '0.01');
  final TextEditingController _pnlController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  String _position = 'BUY';
  String _result = 'Profit';
  String _smcSetup = 'Order Block (OB)';
  String _emotion = 'Tenang / Disiplin';

  // Checklist SMC
  bool _chkMarketStructure = false;
  bool _chkBos = false;
  bool _chkChoch = false;
  bool _chkLiquiditySweep = false;
  bool _chkOrderBlock = false;
  bool _chkFvg = false;
  bool _chkPremiumDiscount = false;
  bool _chkKillZone = false;
  bool _chkConfirmation = false;
  bool _chkRiskManagement = false;

  bool _isPlanFollowed = 'Ya';
  bool _isSlFollowed = 'Ya';

  final List<String> _pairList = ['XAUUSD', 'EURUSD', 'GBPUSD', 'USDJPY', 'AUDUSD', 'USOIL', 'Crypto'];
  final List<String> _smcList = [
    'Order Block (OB)',
    'Fair Value Gap (FVG)',
    'Liquidity Sweep + OB',
    'Breaker Block',
    'Mitigation Block',
    'CHoCH + FVG'
  ];
  final List<String> _emotionList = ['Tenang / Disiplin', 'FOMO', 'Serakah (Greed)', 'Takut (Fear)', 'Balas Dendam (Revenge)'];

  @override
  void dispose() {
    _pairController.dispose();
    _entryController.dispose();
    _slController.dispose();
    _tpController.dispose();
    _lotController.dispose();
    _pnlController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _saveTrade() async {
    if (_formKey.currentState!.validate()) {
      final row = {
        'dateTime': DateTime.now().toIso8601String(),
        'pair': _pairController.text,
        'position': _position,
        'entryPrice': double.tryParse(_entryController.text) ?? 0.0,
        'stopLoss': double.tryParse(_slController.text) ?? 0.0,
        'takeProfit': double.tryParse(_tpController.text) ?? 0.0,
        'lot': double.tryParse(_lotController.text) ?? 0.0,
        'result': _result,
        'profitOrLoss': double.tryParse(_pnlController.text) ?? 0.0,
        'reason': _reasonController.text,
        'smcSetup': _smcSetup,
        'emotion': _emotion,
        'isPlanFollowed': _isPlanFollowed ? 'Ya' : 'Tidak',
        'isSlFollowed': _isSlFollowed ? 'Ya' : 'Tidak',
      };

      await DatabaseHelper.instance.insertTrade(row);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jurnal trading berhasil disimpan!'), backgroundColor: Colors.green),
      );

      // Reset form
      _entryController.clear();
      _slController.clear();
      _tpController.clear();
      _pnlController.clear();
      _reasonController.clear();
      setState(() {
        _chkMarketStructure = false;
        _chkBos = false;
        _chkChoch = false;
        _chkLiquiditySweep = false;
        _chkOrderBlock = false;
        _chkFvg = false;
        _chkPremiumDiscount = false;
        _chkKillZone = false;
        _chkConfirmation = false;
        _chkRiskManagement = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Jurnal Trading'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Pair & Posisi
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _pairController.text,
                    dropdownColor: const Color(0xFF1E1E1E),
                    decoration: const InputDecoration(labelText: 'Pair / Instrumen', border: OutlineInputBorder()),
                    items: _pairList.map((pair) => DropdownMenuItem(value: pair, child: Text(pair))).toList(),
                    onChanged: (val) => setState(() => _pairController.text = val!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _position,
                    dropdownColor: const Color(0xFF1E1E1E),
                    decoration: const InputDecoration(labelText: 'Posisi', border: OutlineInputBorder()),
                    items: ['BUY', 'SELL'].map((pos) => DropdownMenuItem(value: pos, child: Text(pos, style: TextStyle(color: pos == 'BUY' ? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.bold)))).toList(),
                    onChanged: (val) => setState(() => _position = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Harga Entry, SL, TP
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _entryController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Entry Price', border: OutlineInputBorder()),
                    validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _slController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Stop Loss (SL)', border: OutlineInputBorder()),
                    validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _tpController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Take Profit (TP)', border: OutlineInputBorder()),
                    validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Lot & Hasil & PnL
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _lotController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Lot Size', border: OutlineInputBorder()),
                    validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _result,
                    dropdownColor: const Color(0xFF1E1E1E),
                    decoration: const InputDecoration(labelText: 'Hasil', border: OutlineInputBorder()),
                    items: ['Profit', 'Loss', 'BEP'].map((res) => DropdownMenuItem(value: res, child: Text(res))).toList(),
                    onChanged: (val) => setState(() => _result = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pnlController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: const InputDecoration(labelText: 'Profit / Loss Nominal (\$contoh: 50 atau -20)', border: OutlineInputBorder()),
              validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 20),
            // Setup SMC & Emosi
            DropdownButtonFormField<String>(
              value: _smcSetup,
              dropdownColor: const Color(0xFF1E1E1E),
              decoration: const InputDecoration(labelText: 'Setup SMC', border: OutlineInputBorder()),
              items: _smcList.map((setup) => DropdownMenuItem(value: setup, child: Text(setup))).toList(),
              onChanged: (val) => setState(() => _smcSetup = val!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _emotion,
              dropdownColor: const Color(0xFF1E1E1E),
              decoration: const InputDecoration(labelText: 'Kondisi Emosi Saat Trading', border: OutlineInputBorder()),
              items: _emotionList.map((emo) => DropdownMenuItem(value: emo, child: Text(emo))).toList(),
              onChanged: (val) => setState(() => _emotion = val!),
            ),
            const SizedBox(height: 20),
            const Text('Checklist SMC Sebelum Entry', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  CheckboxListTile(title: const Text('Market Structure'), value: _chkMarketStructure, onChanged: (v) => setState(() => _chkMarketStructure = v!)),
                  CheckboxListTile(title: const Text('Break of Structure (BOS)'), value: _chkBos, onChanged: (v) => setState(() => _chkBos = v!)),
                  CheckboxListTile(title: const Text('Change of Character (CHoCH)'), value: _chkChoch, onChanged: (v) => setState(() => _chkChoch = v!)),
                  CheckboxListTile(title: const Text('Liquidity Sweep'), value: _chkLiquiditySweep, onChanged: (v) => setState(() => _chkLiquiditySweep = v!)),
                  CheckboxListTile(title: const Text('Order Block (OB)'), value: _chkOrderBlock, onChanged: (v) => setState(() => _chkOrderBlock = v!)),
                  CheckboxListTile(title: const Text('Fair Value Gap (FVG)'), value: _chkFvg, onChanged: (v) => setState(() => _chkFvg = v!)),
                  CheckboxListTile(title: const Text('Premium & Discount Area'), value: _chkPremiumDiscount, onChanged: (v) => setState(() => _chkPremiumDiscount = v!)),
                  CheckboxListTile(title: const Text('Kill Zone (Session)'), value: _chkKillZone, onChanged: (v) => setState(() => _chkKillZone = v!)),
                  CheckboxListTile(title: const Text('Konfirmasi Entry (Lower Timeframe)'), value: _chkConfirmation, onChanged: (v) => setState(() => _chkConfirmation = v!)),
                  CheckboxListTile(title: const Text('Risk Management Sesuai Aturan'), value: _chkRiskManagement, onChanged: (v) => setState(() => _chkRiskManagement = v!)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _reasonController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Alasan Entry / Catatan Analisis', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent, foregroundColor: Colors.black, padding: const EdgeInsets.all(16)),
              onPressed: _saveTrade,
              child: const Text('Simpan Jurnal Trading', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
