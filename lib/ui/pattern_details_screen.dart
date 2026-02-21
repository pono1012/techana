import 'package:flutter/material.dart';

class PatternDetailsScreen extends StatelessWidget {
  final String patternName;

  const PatternDetailsScreen({super.key, required this.patternName});

  @override
  Widget build(BuildContext context) {
    final info = _getPatternInfo(patternName);
    final isBullish = info['type'] == 'Bullish';
    final color = isBullish
        ? Colors.green
        : (info['type'] == 'Bearish' ? Colors.red : Colors.grey);

    return Scaffold(
      appBar: AppBar(title: Text(patternName)),
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
            Text(patternName,
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
                  const Text("Erklärung",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

  Map<String, String> _getPatternInfo(String name) {
    // ---- Divergenzen ----
    if (name == 'Bullish Divergenz') {
      return {
        'type': 'Bullish',
        'desc':
            'Eine Bullish Divergenz tritt auf, wenn der Preis ein neues Tief macht, der RSI aber ein HÖHERES Tief bildet. Dies zeigt, dass der Verkaufsdruck nachlässt — obwohl der Kurs fällt, verliert die Abwärtsbewegung an Kraft. Oft ein starkes Warnsignal für eine bevorstehende Umkehr nach oben. Besonders zuverlässig in überverkauften Zonen (RSI < 30).'
      };
    }
    if (name == 'Bearish Divergenz') {
      return {
        'type': 'Bearish',
        'desc':
            'Eine Bearish Divergenz tritt auf, wenn der Preis ein neues Hoch macht, der RSI aber ein NIEDRIGERES Hoch bildet. Dies zeigt, dass der Kaufdruck nachlässt — die Rally verliert intern an Kraft, auch wenn der Kurs noch steigt. Ein Frühwarnsignal für eine mögliche Trendwende nach unten. Besonders zuverlässig in überkauften Zonen (RSI > 70).'
      };
    }
    // ---- Einzelne Kerzen ----
    if (name == 'Doji') {
      return {
        'type': 'Neutral',
        'desc':
            'Ein Doji hat fast den gleichen Eröffnungs- und Schlusskurs und sieht aus wie ein Kreuz. Er signalisiert Unentschlossenheit im Markt — weder Käufer noch Verkäufer hatten die Kontrolle. Oft ein Vorbote einer Trendumkehr, besonders nach einem starken Trend.'
      };
    }
    if (name == 'Long-Legged Doji') {
      return {
        'type': 'Neutral',
        'desc':
            'Ein Long-Legged Doji hat besonders lange obere und untere Schatten, fast kein Körper. Er zeigt extreme Unentschlossenheit — der Kurs schwankte stark in beide Richtungen, schloss aber fast unverändert. Ein starkes Signal für eine bevorstehende Richtungsentscheidung.'
      };
    }
    if (name == 'Spinning Top') {
      return {
        'type': 'Neutral',
        'desc':
            'Ein Spinning Top hat einen kleinen Körper in der Mitte und moderate Schatten auf beiden Seiten. Er zeigt Gleichgewicht zwischen Käufern und Verkäufern. Im Kontext eines bestehenden Trends kann er eine Erschöpfung und bevorstehende Korrektur ankündigen.'
      };
    }
    if (name == 'Marubozu Bullish') {
      return {
        'type': 'Bullish',
        'desc':
            'Ein Bullischer Marubozu ist eine große grüne Kerze ohne oder fast ohne Schatten. Der Kurs eröffnete auf dem Tief und schloss auf dem Hoch — absolutes Käufer-Dominanz durch die gesamte Periode. Ein sehr starkes Kaufsignal, besonders nach einem Rückgang.'
      };
    }
    if (name == 'Marubozu Bearish') {
      return {
        'type': 'Bearish',
        'desc':
            'Ein Bärischer Marubozu ist eine große rote Kerze ohne oder fast ohne Schatten. Der Kurs eröffnete auf dem Hoch und schloss auf dem Tief — absolute Verkäufer-Dominanz. Ein sehr starkes Verkaufssignal, besonders nach einem Aufwärtstrend.'
      };
    }
    if (name == 'Hammer') {
      return {
        'type': 'Bullish',
        'desc':
            'Ein Hammer tritt nach einem Abwärtstrend auf. Er hat einen kleinen Körper am oberen Ende und einen langen unteren Schatten (Lunte). Dies zeigt, dass Verkäufer den Preis stark drückten, aber Käufer ihn wieder hochkauften. Ein klassisches Umkehrsignal für eine mögliche Bodenbildung.'
      };
    }
    if (name == 'Inverted Hammer') {
      return {
        'type': 'Bullish',
        'desc':
            'Der Inverted Hammer (umgekehrter Hammer) hat einen kleinen Körper unten und einen langen oberen Schatten. Er erscheint nach einem Abwärtstrend und zeigt, dass Käufer versuchten, den Kurs hochzutreiben — auch wenn sie es nicht ganz schafften. Bestätigung durch die nächste Kerze wichtig.'
      };
    }
    if (name == 'Shooting Star') {
      return {
        'type': 'Bearish',
        'desc':
            'Der Shooting Star ist das Pendant zum Inverted Hammer, aber nach einem Aufwärtstrend. Er hat einen langen oberen Schatten und einen kleinen Körper unten. Käufer trieben den Kurs hoch, aber Verkäufer übernahmen die Kontrolle und drückten ihn wieder runter. Ein Warnsignal für eine bevorstehende Korrektur.'
      };
    }
    if (name == 'Hanging Man') {
      return {
        'type': 'Bearish',
        'desc':
            'Der Hanging Man sieht aus wie ein Hammer, erscheint aber nach einem Aufwärtstrend. Der lange untere Schatten zeigt, dass Verkäufer kurzfristig die Kontrolle hatten — ein Warnsignal, dass der Aufwärtstrend nachlassen könnte. Bestätigung durch eine rote Kerze am nächsten Tag verstärkt das Signal.'
      };
    }
    // ---- Zwei-Kerzen-Muster ----
    if (name == 'Bullish Engulfing') {
      return {
        'type': 'Bullish',
        'desc':
            'Eine große grüne Kerze umschließt die vorherige rote Kerze komplett. Dies zeigt massive Kaufkraftübernahme — Käufer haben alle Verluste des Vortages wettgemacht und mehr. Eines der zuverlässigsten bullishen Umkehrsignale.'
      };
    }
    if (name == 'Bearish Engulfing') {
      return {
        'type': 'Bearish',
        'desc':
            'Eine große rote Kerze umschließt die vorherige grüne Kerze komplett. Die Verkäufer haben alle Gewinne des Vortages vernichtet und treiben den Kurs tiefer. Eines der zuverlässigsten bärischen Umkehrsignale, besonders auf Widerstandsniveaus.'
      };
    }
    if (name == 'Piercing Line') {
      return {
        'type': 'Bullish',
        'desc':
            'Die Piercing Line ist ein 2-Kerzen-Umkehrmuster. Nach einer langen roten Kerze eröffnet die grüne Kerze tiefer (Gap Down), schließt aber über der Mitte der vorigen roten Kerze. Dies zeigt, dass Käufer die Kontrolle übernehmen. Ein bullishes Signal nach einem Abwärtstrend.'
      };
    }
    if (name == 'Dark Cloud Cover') {
      return {
        'type': 'Bearish',
        'desc':
            'Das Gegenteil der Piercing Line. Nach einer langen grünen Kerze eröffnet die rote Kerze höher (Gap Up), schließt aber unter der Mitte der vorigen grünen Kerze. Verkäufer übernehmen die Kontrolle. Ein bärisches Umkehrsignal nach einem Aufwärtstrend.'
      };
    }
    if (name == 'Bullish Harami') {
      return {
        'type': 'Bullish',
        'desc':
            'Beim Bullish Harami (japanisch: schwanger) wird eine kleine grüne Kerze komplett vom Körper der vorigen großen roten Kerze eingeschlossen. Dies signalisiert eine Verlangsamung des Abwärtsdrucks und eine mögliche Trendwende. Weniger stark als Engulfing, aber ein gutes Warnsignal.'
      };
    }
    if (name == 'Bearish Harami') {
      return {
        'type': 'Bearish',
        'desc':
            'Beim Bearish Harami wird eine kleine rote Kerze komplett vom Körper der vorigen großen grünen Kerze eingeschlossen. Dies signalisiert eine Verlangsamung des Aufwärtsdrucks. Der Markt verliert Momentum — ein erstes Warnsignal für eine mögliche Korrektur.'
      };
    }
    if (name == 'Tweezers Bottom') {
      return {
        'type': 'Bullish',
        'desc':
            'Tweezers Bottom (Pinzettenboden): Zwei Kerzen mit (fast) identischen Tiefs. Die erste ist rot (Abwärtsbewegung), die zweite grün (Erholung). Dies zeigt einen starken Unterstützungslevel — Käufer sind bereit, genau auf diesem Preisniveau zu kaufen. Ein bullishes Umkehrsignal.'
      };
    }
    if (name == 'Tweezers Top') {
      return {
        'type': 'Bearish',
        'desc':
            'Tweezers Top (Pinzettenspitze): Zwei Kerzen mit (fast) identischen Hochs. Die erste ist grün (Aufwärtsbewegung), die zweite rot (Abgabe). Dies zeigt einen starken Widerstandslevel — Verkäufer treten genau auf diesem Niveau auf. Ein bärisches Umkehrsignal.'
      };
    }
    if (name == 'Kicking Bullish') {
      return {
        'type': 'Bullish',
        'desc':
            'Das Kicking-Muster ist eines der stärksten Signale überhaupt. Eine bärische Marubozu-Kerze wird abrupt von einer bullischen Marubozu-Kerze gefolgt (Gap Up). Der komplette Richtungswechsel mit starkem Volumen zeigt einen massiven Stimmungsumschwung — von Panikverkauf zu starkem Kaufinteresse.'
      };
    }
    // ---- Drei-Kerzen-Muster ----
    if (name == 'Morning Star') {
      return {
        'type': 'Bullish',
        'desc':
            'Der Morning Star ist ein starkes 3-Kerzen-Umkehrmuster nach einem Abwärtstrend: 1) Große rote Kerze (starker Verkauf), 2) Kleine Kerze (Unentschlossenheit), 3) Große grüne Kerze die über die Mitte der ersten schließt. Einer der zuverlässigsten Bodenbildungs-Indikatoren.'
      };
    }
    if (name == 'Evening Star') {
      return {
        'type': 'Bearish',
        'desc':
            'Der Evening Star ist das Gegenstück zum Morning Star, nach einem Aufwärtstrend: 1) Große grüne Kerze (starker Kauf), 2) Kleine Kerze (Unentschlossenheit am Hoch), 3) Große rote Kerze die unter die Mitte der ersten schließt. Ein zuverlässiges Topping-Signal.'
      };
    }
    if (name == '3 White Soldiers') {
      return {
        'type': 'Bullish',
        'desc':
            'Drei aufeinanderfolgende grüne Kerzen mit höheren Hochs und höheren Schlusskursen. Jede Kerze eröffnet innerhalb oder knapp unter dem vorherigen Körper. Zeigt nachhaltiges Kaufinteresse und anhaltenden Aufwärtstrend — eines der stärksten Trendfortsetzungs- oder Umkehrsignale.'
      };
    }
    if (name == '3 Black Crows') {
      return {
        'type': 'Bearish',
        'desc':
            'Drei aufeinanderfolgende rote Kerzen mit tieferen Tiefs und tieferen Schlusskursen. Das Gegenstück zu den 3 White Soldiers. Zeigt nachhaltigen Verkaufsdruck — oft ein Signal für den Beginn eines stärkeren Abwärtstrends oder das Ende einer Aufwärtsbewegung.'
      };
    }
    return {
      'type': 'Neutral',
      'desc':
          'Kein spezifisches Muster erkannt oder das Muster ist weniger signifikant. Achte auf andere Indikatoren wie RSI, MACD und Volumen für die Marktrichtung.'
    };
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
