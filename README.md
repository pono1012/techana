![TechAna Banner](/lib/assets/banner.svg)
# 📈 TechAna - Advanced Trading Intelligence

<div align="center">

[![Build Status](https://img.shields.io/badge/build-passing-success?style=for-the-badge&logo=github)](.github/workflows/dart.yml)
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg?style=for-the-badge)](pubspec.yaml)
[![Platform](https://img.shields.io/badge/Platform-iOS%20|%20Android%20|%20Web%20|%20Win%20|%20Mac%20|%20Linux-teal?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![Dart SDK](https://img.shields.io/badge/Dart-SDK%20%3E%3D3.0.0-0175C2?style=for-the-badge&logo=dart)](pubspec.yaml)
[![License](https://img.shields.io/badge/license-MIT-purple?style=for-the-badge)](LICENSE)

</div>

---

**TechAna** ist die ultimative **All-in-One-Lösung** für Trader, die nichts dem Zufall überlassen wollen. Wir kombinieren professionelle technische Analyse, KI-gestützte Mustererkennung und automatisierte Trading-Bots in einer einzigen, leistungsstarken App – nativ entwickelt mit Flutter für maximale Performance auf jedem Gerät.



---

## 🚀 Warum TechAna?

In einer Welt volatiler Märkte reicht Bauchgefühl nicht aus. TechAna liefert dir **datenbasierte Fakten**. Egal ob Krypto, Aktien oder Forex – unsere Engine verarbeitet Echtzeitdaten, erkennt komplexe Chart-Formationen und berechnet Wahrscheinlichkeiten, damit du den perfekten Ein- und Ausstieg findest.

---

## 📸 Einblicke in die App

Erlebe das klare Dark-Mode Design, optimiert für lange Analyse-Sessions.

<div align="center">
  <table>
    <tr>
      <td align="center" width="50%">
        <img width="751" height="710" alt="image" src="https://github.com/user-attachments/assets/2ce97897-62ee-4e83-9a71-2c0655eaab1b" />
        <br />
        <b>🏠 Dashboard & Marktübersicht</b><br>
        <small>Alle wichtigen Assets auf einen Blick.</small>
      </td>
      <td align="center" width="50%">
        <img width="745" height="705" alt="image" src="https://github.com/user-attachments/assets/8b845b8e-daa7-4198-85f1-5c5ca6518c4d" />
        <br />
        <b>📊 Detaillierte Filter & Listen</b><br>
        <small>Finde Top-Gainer, Verlierer und Favoriten.</small>
      </td>
    </tr>
  </table>
</div>

---

## ✨ Hauptfunktionen im Detail

### 🧠 Smart Analysis Core & KI
Das Herzstück von TechAna. Unser Algorithmus scannt die Märkte rund um die Uhr.
* **TechAna Score (0-100):** Ein einziger Blick genügt. Unser proprietärer Score aggregiert Trendstärke, Volatilität und Volumen zu einer klaren Kauf- oder Verkaufsempfehlung.
* **Automatisierte Mustererkennung:** Nie wieder Chart-Patterns übersehen. TechAna identifiziert automatisch:
    * *Reversal Patterns:* Head & Shoulders, Double Top/Bottom.
    * *Continuation Patterns:* Flags, Pennants, Wedges.
* **Fundamentalanalyse:** Integrierte Ansicht für finanzielle Gesundheit (KGV, Umsatzwachstum, Dividendenrendite) direkt neben dem Chart.

### 🤖 Algo-Trading & Bots
Verwandle deine Strategien in automatisierte Assistenten.
* **Konfigurierbare Bots:** Erstelle Bots, die basierend auf RSI, MACD oder dem TechAna Score handeln.
* **Backtesting (Beta):** Simuliere deine Strategien anhand historischer Daten, bevor du echtes Kapital riskierst.
* **Live-Monitoring:** Überwache alle aktiven Bots und ihre Performance in einem dedizierten Dashboard.

### 📊 Technische Indikatoren (Deep Dive)
Die App bietet eine breite Palette an vorkonfigurierten Indikatoren für tiefgehende Analysen:
| Kategorie | Indikatoren |
| :--- | :--- |
| **Trend** | SMA, EMA, Parabolic SAR, SuperTrend, Ichimoku Cloud |
| **Momentum** | RSI (Relative Strength Index), Stochastic, MACD, CCI |
| **Volatilität** | Bollinger Bands, ATR (Average True Range), Keltner Channels |
| **Volumen** | OBV (On-Balance Volume), VWAP, MFI |

### 📰 News & Sentiment Engine
Bleib informiert mit dem integrierten News-Aggregator. Wir filtern das Rauschen und liefern nur relevante Nachrichten, direkt verknüpft mit deinen Assets. Die **Sentiment-Analyse** zeigt dir sofort, ob die Marktstimmung eher *Bullish* oder *Bearish* ist.

### 💼 Portfolio Tracking & Management
* **Multi-Asset Support:** Tracke Krypto, Aktien und ETFs in einem Portfolio.
* **P&L Analyse:** Detaillierte Aufschlüsselung deiner Gewinne und Verluste.
* **Top Movers:** Siehe sofort, welche Assets sich am stärksten bewegen.

---

## 📱 Verfügbarkeit & Plattformen

TechAna ist dank Flutter-Technologie **wirklich plattformunabhängig**. Ein Codebase, überall zu Hause.

| Plattform | Status | Support |
| :--- | :---: | :--- |
| **iOS** | ✅ | iPhone & iPad (ab iOS 14) |
| **Android** | ✅ | Ab Android 8.0 |
| **macOS** | ✅ | Apple Silicon & Intel |
| **Windows** | ✅ | Windows 10/11 |
| **Linux** | ✅ | Ubuntu, Debian, Arch |
| **Web** | ✅ | Jeder moderne Browser |

---

## 🛠 Installation & Setup

Du möchtest TechAna selbst kompilieren oder dazu beitragen?

### Voraussetzungen
* [Flutter SDK](https://flutter.dev/docs/get-started/install) (Version 3.0.0 oder höher)
* Dart SDK

### Schritte

1.  **Repository klonen**
    ```bash
    git clone [https://github.com/pono1012/techana.git](https://github.com/pono1012/techana.git)
    cd techana
    ```

2.  **Abhängigkeiten installieren**
    ```bash
    flutter pub get
    ```

3.  **Code Generierung (für Models/Provider)**
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

4.  **App starten**
    ```bash
    flutter run
    ```

---

## 📚 Dokumentation

Du willst tiefer einsteigen? Hier findest du detaillierte Anleitungen:

* [📘 **Offizielle Bedienungsanleitung**](docs/MANUAL.md) - Wie man Charts liest und Bots konfiguriert.
* [🛠 **API Dokumentation**](docs/API.md) - Für Entwickler, die eigene Datenquellen anbinden wollen.
* [🐛 **Issue Tracker**](../../issues) - Fehler melden oder Features wünschen.

---

## 🤝 Contributing

Beiträge sind willkommen! Bitte lies unsere `CONTRIBUTING.md` (kommt bald), bevor du Pull Requests einreichst. Wir suchen aktuell Unterstützung bei:
* Erweiterung der Pattern-Erkennung
* Übersetzungen (i18n)
* UI/UX Verbesserungen für Tablet-Layouts

---

<div align="center">

**TechAna** – Trade Smarter, Not Harder.

</div>

---

## 🚀 Neuestes Update (12.04.2026)

**TEIL 2 (Für die Front-README):**

TechAna präsentiert sich mit einem signifikanten "Under-the-Hood"-Update, das unsere KI-Systeme und Infrastruktur optimiert. Dies führt zu noch präziseren Marktanalysen, verlässlicheren Handelssignalen und einer gesteigerten Gesamtstabilität für Ihr Trading-Erlebnis. Entdecken Sie zudem neue Bot-Optionen mit dynamischen Analyse-Intervallen und eine verbesserte Übersichtlichkeit in den Einstellungen.

👉 [**Komplette Update-Historie ansehen**](CHANGELOG.md)

---

### 🛠 Installation & Downloads

#### 🤖 Android
Lade die neueste `.apk` aus den [Releases](../../releases) herunter und installiere sie direkt auf deinem Gerät.
*(Hinweis: "Installation aus unbekannten Quellen" muss aktiviert sein.)*

#### 🍏 iOS (Sideloading)
Da TechAna nicht im AppStore verfügbar ist, muss die `.ipa` Datei manuell signiert werden. Wir empfehlen folgende Tools:

* **[TrollStore](https://github.com/opa334/TrollStore)** ( Empfohlen)
  * *Beste Erfahrung:* Erlaubt permanente Installation ohne das 7-Tage-Limit.
  * *Voraussetzung:* Funktioniert nur auf bestimmten iOS-Versionen (CoreTrust Bug).
* **[SideStore](https://sidestore.io/)** 
  * *PC-los:* Ermöglicht das Signieren und Aktualisieren direkt auf dem iPhone (via lokalem VPN-Trick), nachdem es einmalig installiert wurde.
* **[AltStore](https://altstore.io/)** 
  * *Der Klassiker:* Erfordert einen Computer (PC/Mac) im selben WLAN, um die App alle 7 Tage automatisch zu erneuern.

#### 🖥 Desktop (Windows, macOS, Linux)
TechAna ist als portable Anwendung verfügbar:
* **Windows:** `.zip` entpacken und `TechAna.exe` starten.
* **macOS:** `.dmg` mounten oder `.zip` entpacken und App in den "Programme"-Ordner verschieben.
* **Linux:** `.tar.gz` entpacken und das Executable via Terminal oder Doppelklick starten.
