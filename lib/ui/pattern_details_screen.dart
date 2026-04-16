import 'package:flutter/material.dart';
import '../l10n/l10n_extension.dart';


class PatternDetailsScreen extends StatelessWidget {
  final String patternName;

  const PatternDetailsScreen({super.key, required this.patternName});

  @override
  Widget build(BuildContext context) {
    final info = _getPatternInfo(context, patternName);
    final localizedName = _getLocalizedPatternName(context, patternName);
    final isBullish = info['type'] == context.l10n.bullish;
    final color = isBullish
        ? Colors.green
        : (info['type'] == context.l10n.bearish ? Colors.red : Colors.grey);

    return Scaffold(
      appBar: AppBar(title: Text(localizedName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- Bildchen (Schematisch) ---
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(75),
                boxShadow: [
                  BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5)
                ],
              ),
              child: CustomPaint(
                painter: PatternPainter(patternName, color),
              ),
            ),
            const SizedBox(height: 32),

            // --- Titel & Typ ---
            Text(localizedName,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16)),
              child: Text(info['type']!,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 32),

            // --- Beschreibung ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.explanation,
                      style:
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(info['desc']!,
                      style: const TextStyle(fontSize: 16, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedPatternName(BuildContext context, String name) {
    switch (name) {
      case 'Bullish Divergenz': return context.l10n.patternBullishDivergence;
      case 'Bearish Divergenz': return context.l10n.patternBearishDivergence;
      case 'Doji': return context.l10n.patternDoji;
      case 'Long-Legged Doji': return context.l10n.patternLongLeggedDoji;
      case 'Spinning Top': return context.l10n.patternSpinningTop;
      case 'Marubozu Bullish': return context.l10n.patternMarubozuBullish;
      case 'Marubozu Bearish': return context.l10n.patternMarubozuBearish;
      case 'Hammer': return context.l10n.patternHammer;
      case 'Inverted Hammer': return context.l10n.patternInvertedHammer;
      case 'Shooting Star': return context.l10n.patternShootingStar;
      case 'Hanging Man': return context.l10n.patternHangingMan;
      case 'Bullish Engulfing': return context.l10n.patternBullishEngulfing;
      case 'Bearish Engulfing': return context.l10n.patternBearishEngulfing;
      case 'Piercing Line': return context.l10n.patternPiercingLine;
      case 'Dark Cloud Cover': return context.l10n.patternDarkCloudCover;
      case 'Bullish Harami': return context.l10n.patternBullishHarami;
      case 'Bearish Harami': return context.l10n.patternBearishHarami;
      case 'Tweezers Bottom': return context.l10n.patternTweezersBottom;
      case 'Tweezers Top': return context.l10n.patternTweezersTop;
      case 'Kicking Bullish': return context.l10n.patternKickingBullish;
      case 'Morning Star': return context.l10n.patternMorningStar;
      case 'Evening Star': return context.l10n.patternEveningStar;
      case '3 White Soldiers': return context.l10n.pattern3WhiteSoldiers;
      case '3 Black Crows': return context.l10n.pattern3BlackCrows;
      default: return name;
    }
  }

  Map<String, String> _getPatternInfo(BuildContext context, String name) {
    final l = context.l10n;
    String type = l.neutral;
    String desc = l.noData;

    if (name == 'Bullish Divergenz') {
      type = l.bullish;
      desc = l.patternBullishDivergenceDesc;
    } else if (name == 'Bearish Divergenz') {
      type = l.bearish;
      desc = l.patternBearishDivergenceDesc;
    } else if (name == 'Doji') {
      type = l.neutral;
      desc = l.patternDojiDesc;
    } else if (name == 'Long-Legged Doji') {
      type = l.neutral;
      desc = l.patternLongLeggedDojiDesc;
    } else if (name == 'Spinning Top') {
      type = l.neutral;
      desc = l.patternSpinningTopDesc;
    } else if (name == 'Marubozu Bullish') {
      type = l.bullish;
      desc = l.patternMarubozuBullishDesc;
    } else if (name == 'Marubozu Bearish') {
      type = l.bearish;
      desc = l.patternMarubozuBearishDesc;
    } else if (name == 'Hammer') {
      type = l.bullish;
      desc = l.patternHammerDesc;
    } else if (name == 'Inverted Hammer') {
      type = l.bullish;
      desc = l.patternInvertedHammerDesc;
    } else if (name == 'Shooting Star') {
      type = l.bearish;
      desc = l.patternShootingStarDesc;
    } else if (name == 'Hanging Man') {
      type = l.bearish;
      desc = l.patternHangingManDesc;
    } else if (name == 'Bullish Engulfing') {
      type = l.bullish;
      desc = l.patternBullishEngulfingDesc;
    } else if (name == 'Bearish Engulfing') {
      type = l.bearish;
      desc = l.patternBearishEngulfingDesc;
    } else if (name == 'Piercing Line') {
      type = l.bullish;
      desc = l.patternPiercingLineDesc;
    } else if (name == 'Dark Cloud Cover') {
      type = l.bearish;
      desc = l.patternDarkCloudCoverDesc;
    } else if (name == 'Bullish Harami') {
      type = l.bullish;
      desc = l.patternBullishHaramiDesc;
    } else if (name == 'Bearish Harami') {
      type = l.bearish;
      desc = l.patternBearishHaramiDesc;
    } else if (name == 'Tweezers Bottom') {
      type = l.bullish;
      desc = l.patternTweezersBottomDesc;
    } else if (name == 'Tweezers Top') {
      type = l.bearish;
      desc = l.patternTweezersTopDesc;
    } else if (name == 'Kicking Bullish') {
      type = l.bullish;
      desc = l.patternKickingBullishDesc;
    } else if (name == 'Morning Star') {
      type = l.bullish;
      desc = l.patternMorningStarDesc;
    } else if (name == 'Evening Star') {
      type = l.bearish;
      desc = l.patternEveningStarDesc;
    } else if (name == '3 White Soldiers') {
      type = l.bullish;
      desc = l.pattern3WhiteSoldiersDesc;
    } else if (name == '3 Black Crows') {
      type = l.bearish;
      desc = l.pattern3BlackCrowsDesc;
    }

    return {'type': type, 'desc': desc};
  }
}

class PatternPainter extends CustomPainter {
  final String pattern;
  final Color color;
  PatternPainter(this.pattern, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    // Zeichne eine schematische Kerze basierend auf dem Namen
    if (pattern.contains("Hammer")) {
      // Langer unterer Schatten, kleiner Körper oben
      canvas.drawRect(
          Rect.fromCenter(
              center: Offset(cx, h * 0.3), width: w * 0.3, height: h * 0.2),
          paint); // Body
      canvas.drawLine(Offset(cx, h * 0.4), Offset(cx, h * 0.9),
          paint..strokeWidth = 4); // Wick
    } else if (pattern.contains("Shooting")) {
      // Langer oberer Schatten, kleiner Körper unten
      canvas.drawRect(
          Rect.fromCenter(
              center: Offset(cx, h * 0.7), width: w * 0.3, height: h * 0.2),
          paint); // Body
      canvas.drawLine(Offset(cx, h * 0.6), Offset(cx, h * 0.1),
          paint..strokeWidth = 4); // Wick
    } else if (pattern.contains("Doji")) {
      // Kreuz
      canvas.drawLine(Offset(cx, h * 0.2), Offset(cx, h * 0.8),
          paint..strokeWidth = 4); // Vertikal
      canvas.drawLine(Offset(cx - w * 0.2, h * 0.5),
          Offset(cx + w * 0.2, h * 0.5), paint..strokeWidth = 6); // Horizontal
    } else if (pattern.contains("Divergenz")) {
      // Schematisch: Preis-Linie steigt, RSI-Linie fällt (bearish) oder umgekehrt
      final isBull = pattern.contains("Bullish");
      final paint2 = Paint()
        ..color = isBull ? Colors.green : Colors.red
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke;
      // Preis-Linie (geht nach oben für bearish div)
      canvas.drawLine(Offset(w * 0.1, isBull ? h * 0.8 : h * 0.4),
          Offset(w * 0.9, isBull ? h * 0.6 : h * 0.2), paint..strokeWidth = 3);
      // RSI-Linie (geht entgegengesetzt)
      canvas.drawLine(Offset(w * 0.1, isBull ? h * 0.6 : h * 0.2),
          Offset(w * 0.9, isBull ? h * 0.8 : h * 0.6), paint2);
      // Label
      canvas.drawLine(
          Offset(w * 0.85, h * 0.1),
          Offset(w * 0.85, h * 0.9),
          paint
            ..strokeWidth = 0.5
            ..color = Colors.grey);
    } else {
      // Standard Kerze
      canvas.drawRect(
          Rect.fromCenter(
              center: Offset(cx, h * 0.5), width: w * 0.3, height: h * 0.4),
          paint);
      canvas.drawLine(
          Offset(cx, h * 0.2), Offset(cx, h * 0.8), paint..strokeWidth = 4);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
