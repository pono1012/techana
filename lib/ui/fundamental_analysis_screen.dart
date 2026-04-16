import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/data_service.dart';
import '../models/models.dart';
import '../l10n/l10n_extension.dart';
import 'package:intl/intl.dart';

class FundamentalAnalysisScreen extends StatefulWidget {
  final String symbol;
  final String apiKey;

  const FundamentalAnalysisScreen(
      {super.key, required this.symbol, required this.apiKey});

  @override
  State<FundamentalAnalysisScreen> createState() =>
      _FundamentalAnalysisScreenState();
}

class _FundamentalAnalysisScreenState extends State<FundamentalAnalysisScreen> {
  bool _isLoading = true;
  FmpData? _data;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.apiKey.isEmpty) {
      setState(() {
        _error = context.l10n.noFmpKeyError;
        _isLoading = false;
      });
      return;
    }

    final ds = DataService();
    final data = await ds.fetchFmpData(widget.symbol, widget.apiKey);

    if (mounted) {
      setState(() {
        _data = data;
        _isLoading = false;
        if (data == null)
          _error = context.l10n.loadFmpDataError(widget.symbol);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.fundamentalAnalysis(widget.symbol))),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child:
                      Text(_error!, style: const TextStyle(color: Colors.red)))
              : _buildContent(context, _data!),
    );
  }

  Widget _buildContent(BuildContext context, FmpData d) {
    final l = context.l10n;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                if (d.image != null)
                  Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                          image: NetworkImage(d.image!), fit: BoxFit.contain),
                    ),
                  )
                else
                  Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12)),
                    alignment: Alignment.center,
                    child: Text(d.symbol.substring(0, 1),
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent)),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d.companyName,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("${d.exchange ?? ''} : ${d.symbol}",
                          style: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                              "${d.price.toStringAsFixed(2)} ${d.currency ?? 'USD'}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 12),
                          if (d.changes != null)
                            Text(
                                "${d.changes! >= 0 ? '+' : ''}${d.changes!.toStringAsFixed(2)} (${d.changesPercentage?.toStringAsFixed(2)}%)",
                                style: TextStyle(
                                    color: (d.changes ?? 0) >= 0
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- Company Profile ---
          Text(l.companyProfile,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(d.description,
              style: const TextStyle(color: Colors.grey, height: 1.4)),
          const SizedBox(height: 16),
          _buildInfoGrid([
            _buildInfoItem(l.ceo, d.ceo),
            _buildInfoItem(l.sector, d.sector),
            _buildInfoItem(l.industry, d.industry),
            _buildInfoItem(l.country, d.country),
            _buildInfoItem(l.employees, d.fullTimeEmployees),
            _buildInfoItem(l.ipoDate, d.ipoDate),
            _buildInfoItem(l.website, d.website, isLink: true),
          ]),
          const SizedBox(height: 24),

          // --- Market Data ---
          Text(l.marketData,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildInfoGrid([
            _buildInfoItem(l.marketCap, _formatLarge(context, d.marketCap)),
            _buildInfoItem(l.volAvg, _formatLarge(context, d.volAvg ?? 0)),
            _buildInfoItem(l.beta, d.beta.toStringAsFixed(2)),
            _buildInfoItem(l.fiftyTwoWeekRange, d.range),
            _buildInfoItem(l.lastDiv, d.lastDiv?.toStringAsFixed(2)),
            _buildInfoItem(l.isEtf, d.isEtf ? l.yes : l.no),
          ]),
          const SizedBox(height: 24),

          // --- Analyst Targets ---
          if (d.analystTarget != null) ...[
            Text(l.analystTargets,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildInfoGrid([
              _buildInfoItem(l.targetConsensus,
                  "\$${d.analystTarget!.targetConsensus.toStringAsFixed(2)}"),
              _buildInfoItem(
                  l.targetHigh, "\$${d.analystTarget!.targetHigh.toStringAsFixed(2)}",
                  color: Colors.green),
              _buildInfoItem(
                  l.targetLow, "\$${d.analystTarget!.targetLow.toStringAsFixed(2)}",
                  color: Colors.red),
            ]),
            const SizedBox(height: 24),
          ],

          // --- Earnings ---
          if (d.nextEarnings != null) ...[
            Text(l.nextEarningsDate,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    color: Colors.blueAccent, size: 20),
                const SizedBox(width: 8),
                Text(
                    DateFormat.yMd(Localizations.localeOf(context).languageCode).format(d.nextEarnings!.date),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(4)),
                  child: Text(d.nextEarnings!.time.toUpperCase(),
                      style: const TextStyle(fontSize: 10)),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],

          // --- Insider Trades ---
          if (d.insiderTrades != null && d.insiderTrades!.isNotEmpty) ...[
            Text(l.recentInsiderTrades,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...d.insiderTrades!.take(5).map((t) {
              bool isBuy =
                  t.transactionType.toUpperCase().contains("P-PURCHASE") ||
                      t.transactionType.toUpperCase() == "P";
              return ListTile(
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                leading: Icon(isBuy ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isBuy ? Colors.green : Colors.red),
                title: Text(t.reportingName,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: Text(
                    "${t.typeOfOwner} • ${t.transactionDate.day}.${t.transactionDate.month}.${t.transactionDate.year}",
                    style: const TextStyle(fontSize: 11)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                        "${isBuy ? '+' : '-'}${_formatLarge(context, t.securitiesTransacted)} ${l.shares}",
                        style: TextStyle(
                            color: isBuy ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                    Text("@ \$${t.price.toStringAsFixed(2)}",
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 24),
          ],

          // Link zu Aktien.guide
          Center(
            child: ElevatedButton.icon(
              onPressed: () async {
                // Symbol bereinigen: Endungen wie .DE oder .DEF entfernen für die Suche
                String searchSym = d.symbol;
                if (searchSym.endsWith(".DE")) {
                  searchSym = searchSym.substring(0, searchSym.length - 3);
                } else if (searchSym.endsWith(".DEF")) {
                  searchSym = searchSym.substring(0, searchSym.length - 4);
                }

                final url =
                    Uri.parse('https://aktien.guide/search?q=$searchSym');
                if (!await launchUrl(url,
                    mode: LaunchMode.externalApplication)) {
                  debugPrint("Konnte $url nicht öffnen");
                }
              },
              icon: const Icon(Icons.open_in_new),
              label: Text(l.moreInfoOnAktienGuide),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
              child: Text(l.dataProvidedByFmp,
                  style: const TextStyle(fontSize: 10, color: Colors.grey))),
        ],
      ),
    );
  }

  Widget _buildInfoGrid(List<Widget> children) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: children,
    );
  }

  Widget _buildInfoItem(String label, String? val,
      {bool isLink = false, Color? color}) {
    if (val == null || val.isEmpty) return const SizedBox.shrink();
    return Container(
      width: 150, // Fixed width for grid look
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(val,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isLink ? Colors.blueAccent : color)),
        ],
      ),
    );
  }

  String _formatLarge(BuildContext context, double val) {
    final l = context.l10n;
    if (val > 1e12) return "${(val / 1e12).toStringAsFixed(2)} ${l.thousandBillionShort}";
    if (val > 1e9) return "${(val / 1e9).toStringAsFixed(2)} ${l.billionShort}";
    if (val > 1e6) return "${(val / 1e6).toStringAsFixed(2)} ${l.millionShort}";
    return val.toStringAsFixed(0);
  }
}
