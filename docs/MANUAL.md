# 📘 TechAna Benutzerhandbuch

Willkommen bei **TechAna**. Dieses Handbuch führt dich durch alle Funktionen der App, von der ersten Marktanalyse bis zum automatisierten Trading-Bot.

---

## 🧭 Navigation & Dashboard

Nach dem Start landest du auf dem **Dashboard** (`DashboardScreen`). Es ist deine Kommandozentrale.

### Hauptbereiche
1.  **Marktüberblick:** Oben siehst du eine Zusammenfassung der wichtigsten Indizes (z.B. BTC, ETH, S&P 500).
2.  **Top Movers:** Ein Swipe nach rechts bringt dich zu den Gewinnern und Verlierern des Tages (basiert auf 24h-Änderung).
3.  **Schnellzugriff:** Navigiere direkt zu:
    * 📰 **News:** Aktuelle Marktnachrichten.
    * 💼 **Portfolio:** Deine gehaltenen Assets.
    * 🤖 **Bot:** Automatisierter Handel.

> **Tipp:** Ziehe die Liste nach unten ("Pull-to-Refresh"), um die Kurse manuell zu aktualisieren.

---

## 📊 Detail-Analyse (Deep Dive)

Tippe auf ein beliebiges Asset (z.B. "Bitcoin"), um in den **Analyse-Modus** zu gelangen.

### 1. Chart & Interaktion
* **Zoom:** Nutze "Pinch-to-Zoom", um den Zeitrahmen der Candles zu ändern.
* **Fadenkreuz:** Tippe und halte auf den Chart, um genaue Preise (Open, High, Low, Close) zu sehen.

### 2. Technische Indikatoren (`AnalysisStatsScreen`)
TechAna berechnet Signale in Echtzeit. Hier lernst du, wie du sie liest:

* **RSI (Relative Strength Index):**
    * *Wert > 70:* Asset ist **überkauft** (Mögliche Korrektur nach unten).
    * *Wert < 30:* Asset ist **überverkauft** (Mögliche Chance zum Einstieg).
* **MACD (Moving Average Convergence Divergence):**
    * Achte auf Kreuzungen der Signallinie. Ein Kreuzen von unten nach oben ist oft ein **Bullish Signal**.
* **Bollinger Bands:**
    * Wenn der Preis das obere Band durchbricht, gilt das Asset oft als überdehnt.
* **TechAna Score (0-100):**
    * Unser KI-Score fasst alle Indikatoren zusammen.
    * 🟢 **80-100:** Strong Buy
    * 🔴 **0-20:** Strong Sell

### 3. Mustererkennung
Die App scannt Charts nach geometrischen Mustern.
* **Erkannte Muster:** Werden direkt im Chart markiert (z.B. ein Dreieck).
* **Zuverlässigkeit:** Jedes Muster hat einen "Confidence Score". Handle nur Muster mit hoher Wahrscheinlichkeit (> 70%).

---

## 🤖 Trading Bot (Beta)

Der Bot (`BotDashboardScreen`) kann basierend auf deinen Regeln automatisch handeln.

### Bot Konfigurieren (`BotSettingsScreen`)
Bevor du den Bot startest, musst du Strategien festlegen:
1.  **Indikator-Trigger:** Wähle z.B. *"Kaufe wenn RSI < 30"*.
2.  **Stop-Loss / Take-Profit:** Lege fest, bei wie viel % Verlust/Gewinn automatisch verkauft wird.
3.  **Asset-Allokation:** Bestimme, wie viel % deines Portfolios der Bot nutzen darf.

### 🧠 Kronos AI Engine Integration
TechAna bindet das leistungsstarke "Kronos" Foundation-Modell ein, um zukünftige Kerzen (Preisverläufe) zu prognostizieren:
* **Desktop (Windows/Mac/Linux):** Die App verwaltet das Kronos-Python-Backend für dich völlig automatisch. Lass in den Einstellungen unter *Daten -> Kronos Server URL* das Feld einfach leer.
* **Mobile (Android/iOS):** Smartphones haben nicht genug Leistung für das Backend. Trage in der mobilen App unter *Daten -> Kronos Server URL* die lokale IP-Adresse deines PCs ein (z.B. `http://192.168.178.139:8000`). Die App verbindet sich dann via WLAN mit dem laufenden Backend auf dem PC.
* Hast du Kronos aktiviert, scannt der Bot alle Paare und kombiniert seine finalen Entscheidungen mit der KI-Vorhersagekraft!

### Überwachung
* **Logs:** Im Tab "Logs" siehst du jede Entscheidung des Bots im Klartext (z.B. *"Bought BTC at 45.000 because RSI was 28"*).
* **Not-Aus:** Mit dem großen roten Button im Dashboard kannst du alle Bot-Aktivitäten sofort stoppen.

---

## 💼 Portfolio Management

Verfolge deine Performance im **Portfolio-Tab**.

* **Balance:** Dein Gesamtwert in USD/EUR.
* **Allocation:** Ein Tortendiagramm zeigt dir deine Risikoverteilung (z.B. 60% Krypto, 40% Aktien).
* **Transaktionshistorie:** Eine Liste aller vergangenen Trades (manuell oder durch Bot).

---

## 📰 News & Sentiment

TechAna aggregiert Nachrichten von verschiedenen Finanzquellen.
* **Sentiment-Analyse:** Neben jeder Schlagzeile siehst du einen Indikator:
    * 🟢 Positiv (Bullish News)
    * 🔴 Negativ (Bearish News)
* **Filter:** Filtere Nachrichten nach Krypto, Aktien oder Forex.

---

## ⚙️ Einstellungen & Daten

* **API-Keys:** Hinterlege hier deine Schlüssel für AlphaVantage oder Binance, um Live-Daten zu erhalten.
* **Theme:** Wechsle zwischen "Dark Mode" (empfohlen für Trader) und "Light Mode".
* **Updates:** Tippe auf "Nach Updates suchen", um via Shorebird die neueste Version zu laden.

---

**Haftungsausschluss:** *Trading birgt Risiken. Die Analysen von TechAna sind Hilfsmittel und keine Anlageberatung.*