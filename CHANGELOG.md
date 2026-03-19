### 2026-03-19 - Update

#### Wichtige Neuerungen und Verbesserungen in TechAna

Dieses Update bringt bedeutende Erweiterungen in der analytischen Tiefe und der Automatisierung unserer Handelsstrategien, insbesondere durch die Einführung einer Monte-Carlo-Simulationsengine und die Integration von fundamentalen Marktdaten. Unser Ziel ist es, Ihnen noch präzisere und risikobewusstere Entscheidungen zu ermöglichen und die Robustheit Ihrer automatisierten Handelsprozesse zu steigern.

#### 🚀 Features

*   **Integration der Monte-Carlo-Simulation für verbesserte Prognosen:**
    *   **Nutzen:** TechAna verfügt nun über eine hochmoderne Monte-Carlo-Simulationsengine. Diese neue Funktionalität ermöglicht die probabilistische Vorhersage von zukünftigen Kursentwicklungen und bewertet die Wahrscheinlichkeit, dass ein Trade Take-Profit- oder Stop-Loss-Niveaus innerhalb eines definierten Zeitraums erreicht.
    *   **Für User/Devs:** Sowohl in der manuellen Analyse als auch in den automatisierten Bots wird die Qualität der Handelssignale durch eine zukunftsgerichtete, risikobasierte Bewertung erheblich gesteigert. Der Kern-Score von TechAna berücksichtigt diese neuen probabilistischen Einblicke für fundiertere Entscheidungen. Entwickler können die Simulation direkt nutzen, um eigene Strategien zu verfeinern.

*   **Erweiterte Fundamentalanalyse-Integration (FMP Classic Data):**
    *   **Nutzen:** TechAna kann nun eine Vielzahl zusätzlicher fundamentaler Daten von Financial Modeling Prep (FMP) abrufen, darunter bevorstehende Earnings-Termine, Analysten-Kursziele und jüngste Insider-Handelsaktivitäten.
    *   **Für User/Devs:** Diese Daten sind direkt in die Analyse integrierbar und ermöglichen eine ganzheitlichere Bewertung von Assets. Entwickler können auf diese erweiterten Datenpunkte für komplexere Algorithmen und Filter zugreifen.

*   **Intelligentere Bot-Handelsstrategien:**
    *   **Nutzen:** Die Automatisierungsfunktionen des Bots wurden signifikant aufgewertet, um die neuen Analysefähigkeiten zu nutzen:
        *   **Earnings-Blocker:** Der Bot vermeidet jetzt automatisch Trades kurz vor wichtigen Unternehmens-Earnings (innerhalb von 3 Tagen), um volatile Marktbewegungen und damit verbundene Risiken zu umgehen.
        *   **Analysten-Kursziel-Boost:** Bei Kaufsignalen erhalten Assets einen Score-Bonus von 10 Punkten, wenn Analysten ein signifikantes Kurspotenzial (>15% über dem aktuellen Kurs) prognostizieren.
        *   **Insider-Kauf-Boost:** Wenn vermehrt Insider-Käufe festgestellt werden (mindestens 3 in der jüngsten Vergangenheit), erhalten Kaufsignale ebenfalls einen Score-Bonus von 10 Punkten.
        *   **Monte-Carlo-Strict-Mode:** Eine neue Bot-Einstellung erlaubt es, Trades abzulehnen, wenn die Monte-Carlo-Simulation eine höhere Wahrscheinlichkeit für das Erreichen des Stop-Loss als des Take-Profit-Ziels prognostiziert.
    *   **Für User:** Ihre automatisierten Strategien werden durch diese fundamentalen Filter und probabilistischen Risikobewertungen deutlich intelligenter, was potenziell zu sichereren und profitableren Trades führt.

*   **Konfigurierbare Monte-Carlo-Simulationen:**
    *   **Nutzen:** Sie können jetzt die Anzahl der Monte-Carlo-Simulationen in den App-Einstellungen (für die manuelle Analyse) und in den Bot-Einstellungen (für automatisierte Strategien) anpassen. Die Standardeinstellung beträgt 200 Simulationen.
    *   **Für User:** Mehr Kontrolle über die Rechenintensität und Präzision der Monte-Carlo-Analyse, passend zu Ihren Präferenzen und der Performance Ihres Systems.

*   **Erweiterte Timeframe-Randomisierung im Bot:**
    *   **Nutzen:** Der Bot wählt bei der Strategie-Randomisierung nun aus einem breiteren Spektrum aller verfügbaren Timeframes aus (von 15m bis 1w).
    *   **Für User:** Ermöglicht dem Bot, über eine größere Vielfalt von Marktzyklen und Trading-Stilen hinweg zu optimieren und potenziell bessere Strategien zu entdecken.

#### 🩹 Fixes

*   **Korrektur der Stop-Loss-Anpassung nach Teilgewinnmitnahme (TP1):**
    *   **Nutzen:** Ein kritischer Fehler wurde behoben, der dazu führte, dass die Stop-Loss-Anpassung nach einer ersten Teilgewinnmitnahme (TP1) nicht korrekt funktionierte oder die konfigurierte Verkaufsfraktion nicht beachtet wurde.
    *   **Für User:** Verbesserte Zuverlässigkeit und Präzision in der automatisierten Verlustbegrenzung nach Teilausstiegen, was die Risikomanagement-Strategien des Bots schützt und unbeabsichtigte Verluste verhindert.

#### ⚙️ Verbesserungen & Interne Änderungen

*   **Code-Refactoring des Bot-Dashboards:**
    *   **Nutzen:** Das Bot-Dashboard wurde intern überarbeitet, um die Code-Basis modularer und leichter wartbar zu machen. Dadurch können zukünftige Entwicklungen und Erweiterungen des Dashboards effizienter umgesetzt werden.
    *   **Für Devs:** Vereinfacht die Pflege und Erweiterung des UI-Codes und verbessert die Stabilität der Anwendung.
*   **Bereinigungen von ungenutztem Code und Imports:**
    *   **Nutzen:** Entfernung von veraltetem oder ungenutztem Code sowie von unnötigen Importen.
    *   **Für Devs:** Saubere, schlankere und effizientere Code-Basis, die die Performance verbessern kann.

### 📂 Geänderte Dateien
- `flutter_analyze.txt`
- `lib/models/models.dart`
- `lib/models/trade_record.dart`
- `lib/providers/app_provider.dart`
- `lib/services/bot_settings_service.dart`
- `lib/services/data_service.dart`
- `lib/services/monte_carlo_service.dart`
- `lib/services/trade_execution_service.dart`
- `lib/services/update_service.dart`
- `lib/ui/analysis_stats_screen.dart`
- `lib/ui/bot_dashboard_screen.dart`
- `lib/ui/bot_dashboard_widgets.dart`
- `lib/ui/bot_settings_screen.dart`
- `lib/ui/dashboard_screen.dart`
- `lib/ui/fundamental_analysis_screen.dart`
- `lib/ui/monte_carlo_screen.dart`
- `lib/ui/settings_screen.dart`
- `lib/ui/top_movers_screen.dart`
- `pubspec.yaml`

---

### 2026-02-22 - Update

TechAna Release Notes - Update vom 21. Februar 2026

#### Highlights dieses Updates

Wir freuen uns, ein umfassendes Update für TechAna vorzustellen, das nicht nur die Stabilität und Zuverlässigkeit Ihrer automatisierten Handelsausführung signifikant verbessert, sondern auch die Intelligenz unseres Analyse-Kerns auf ein neues Niveau hebt. Dieses Release behebt kritische Fehler in der Orderverarbeitung, erweitert die strategischen Möglichkeiten durch tiefere Marktanalysen und neue Konfigurationsoptionen für Ihren Trading-Bot und macht die Analyse-Entscheidungen der KI transparenter.

#### Fehlerbehebungen und Stabilitätsverbesserungen

*   **Behebung kritischer Fehler in der Handelsausführung:** Ein gravierender Fehler im Kern der Handelsausführung wurde behoben. Dieser Fehler konnte dazu führen, dass wichtige Order-Typen wie Stop-Loss, Take-Profit und Pending-Orders unter bestimmten Bedingungen nicht korrekt oder gar nicht ausgelöst wurden. Die betroffenen Bereiche umfassten sowohl die Datenverarbeitung als auch die Service-Schichten und die Benutzeroberfläche der Bot-Steuerung.
    *   **Ihr Nutzen:** Diese Korrektur stellt sicher, dass Ihre Schutzmechanismen und Gewinnmitnahmen stets zuverlässig funktionieren. Sie können nun mit erhöhtem Vertrauen handeln, da Ihre automatisierten Strategien und manuellen Schutzbefehle präzise und zeitgerecht ausgeführt werden. Dies minimiert das Risiko unerwarteter Verluste und maximiert die Wahrscheinlichkeit, Ihre Gewinnziele zu erreichen, was zu einem insgesamt sichereren und kontrollierteren Handelserlebnis führt.

#### Neue Funktionen und Analyse-Upgrades

*   **Erweiterter KI-Analyse-Kern mit neuen Indikatoren:** Der Smart Analysis Core wurde erheblich erweitert und integriert nun eine Vielzahl neuer technischer Indikatoren aus der `ta_extended`-Bibliothek, darunter CCI, PSAR, CMF, MFI, Awesome Oscillator (AO), Bollinger Band %B sowie Vortex und Chop Index. Zudem wurde der Ichimoku Cloud Indikator hinzugefügt.
    *   **Ihr Nutzen:** TechAna kann Marktbewegungen nun mit weitaus größerer Präzision und Tiefe analysieren. Dies führt zu relevanteren und zeitnahen Handelssignalen, die eine breitere Palette von Marktbedingungen berücksichtigen. Ihre Handelsentscheidungen werden durch ein umfassenderes Verständnis des Marktes untermauert.
*   **Verbessertes Scoring-System:** Das bisherige Scoring-Modell wurde durch ein differenziertes, kategoriebasiertes Budget-Scoring-System ersetzt. Dieses berücksichtigt separate Bewertungen für Trend, Momentum, Volumen, Chartmuster und Volatilität, um eine robustere und nuanciertere Bewertung der Marktlage zu ermöglichen.
    *   **Ihr Nutzen:** Die Qualität der generierten Handelssignale wird deutlich gesteigert. Das neue System minimiert Fehlinterpretationen und bietet eine transparentere Grundlage für die Kauf-/Verkaufsempfehlungen, was zu potenziell profitableren und sichereren Trades führt.
*   **Erkennung von Candlestick-Mustern und Divergenzen:** Der Analyse-Kern erkennt nun automatisch gängige Candlestick-Muster und identifiziert bullische/bearische Divergenzen auf Basis von Preis und RSI.
    *   **Ihr Nutzen:** Sie erhalten frühzeitig Hinweise auf potenzielle Trendwenden oder Fortsetzungen. Dies ermöglicht es Ihnen, proaktiver zu agieren und von Mustern zu profitieren, die historisch gesehen eine hohe Vorhersagekraft haben.
*   **Erweiterte Optionen für Stop-Loss und Take-Profit Strategien:** Neue Methoden für Stop-Loss (Swing) und Take-Profit (Pivot) wurden in den Bot-Einstellungen eingeführt, ergänzt durch einen einstellbaren `swingLookback`-Parameter.
    *   **Ihr Nutzen:** Mehr Flexibilität und Präzision bei der Definition Ihrer Risikomanagement- und Gewinnmitnahme-Strategien. Passen Sie den Bot noch genauer an Ihren Handelsstil und Ihre Marktanalyse an, um optimierte Ausstiegsstrategien zu nutzen.
*   **Neue Funktion: Automatische Strategie-Randomisierung:** Der Bot kann nun so konfiguriert werden, dass er für jeden Scan eine zufällige Kombination von Entry-, Stop-Loss-, Take-Profit-Methoden und Timeframes auswählt.
    *   **Ihr Nutzen:** Ideal für fortgeschrittene Nutzer und Forscher, um die Robustheit von Strategien unter verschiedenen Marktbedingungen zu testen oder neue, unkonventionelle Setups zu entdecken. Dies bietet eine leistungsstarke Möglichkeit zur Optimierung und Anpassung an dynamische Märkte.
*   **Neue Funktion: Interaktive Score-Aufschlüsselung:** Die detaillierte Score-Ansicht ermöglicht es nun, auf jede Kategorie (Trend, Momentum, Volumen, Muster, Volatilität) zu tippen, um eine modale Ansicht mit spezifischen Erklärungen der zugrunde liegenden Indikatoren zu öffnen.
    *   **Ihr Nutzen:** Erhöhte Transparenz und Verständnis für die Entscheidungsfindung der KI. Sie können schnell nachvollziehen, welche Indikatoren zu einer bestimmten Bewertung beitragen, was das Vertrauen in die generierten Handelssignale stärkt und die Lernkurve verbessert.
*   **Verbesserte Bot-Konfiguration und Zeitrahmen-Auswahl:** Die Auswahl des Analyse-Zeitrahmens für den Bot wurde in die dedizierten Bot-Einstellungen verschoben.
    *   **Ihr Nutzen:** Zentralisiert alle wichtigen Bot-Parameter an einem Ort, was die Konfiguration übersichtlicher und effizienter macht.

#### Architektonische Verbesserungen und Refactoring

*   **Modularisierung der Bot- und Portfolio-Services:** Die Funktionalitäten für Bot-Einstellungen, Watchlist-Management und Handelsausführung wurden aus dem `PortfolioService` in dedizierte, neue Services (`BotSettingsService`, `WatchlistService`, `TradeExecutionService`) ausgelagert und als separate `ChangeNotifierProvider`s in die Anwendung integriert.
    *   **Ihr Nutzen:** Diese strukturelle Verbesserung führt zu einem saubereren, wartbareren und erweiterbaren Code. Für Sie bedeutet das eine stabilere Anwendung und die Grundlage für zukünftige, schnellere Feature-Entwicklungen. Die neue Architektur ermöglicht zudem dedizierte Einstellungsbereiche für Ihren Bot.

#### Dokumentation und Interne Updates

*   **Aktualisierter CHANGELOG und README:** Der `CHANGELOG.md` wurde um die detaillierten Release Notes für dieses Update erweitert und ersetzt die temporären `current_patch_notes.md`, die nun entfernt wurden. Die `README.md` wurde ebenfalls aktualisiert, um die neuesten Highlights und verbesserte Installationsanweisungen widerzuspiegeln.
    *   **Ihr Nutzen:** Verbesserte Transparenz über die Änderungen und eine klarere Kommunikation der Vorteile. Die aktualisierten Installationsanleitungen erleichtern den Einstieg und die Wartung der Anwendung.
*   **Anwendungsversion `1.0.0+3`:** Die interne Version von TechAna wurde entsprechend der vorgenommenen Änderungen aktualisiert.
*   **KI-Statusaktualisierung:** Der interne Status des KI-Berichtssystems (`last_ai_commit`) wurde aktualisiert, um sicherzustellen, dass nachfolgende KI-Analysen und Berichte stets die neuesten Codeänderungen und Systemzustände korrekt reflektieren.

### 📂 Geänderte Dateien
- `lib/main.dart`
- `lib/models/models.dart`
- `lib/providers/app_provider.dart`
- `lib/services/bot_settings_service.dart`
- `lib/services/portfolio_service.dart`
- `lib/services/ta_extended.dart`
- `lib/services/trade_execution_service.dart`
- `lib/services/watchlist_service.dart`
- `lib/ui/bot_dashboard_screen.dart`
- `lib/ui/bot_settings_screen.dart`
- `lib/ui/dashboard_screen.dart`
- `lib/ui/pattern_details_screen.dart`
- `lib/ui/score_details_screen.dart`
- `lib/ui/settings_screen.dart`
- `lib/ui/top_movers_history_screen.dart`
- `lib/ui/top_movers_screen.dart`
- `lib/ui/trade_details_screen.dart`
- `pubspec.yaml`

### 📂 Geänderte Dateien
- `analyze_score.txt`
- `analyze_trade.txt`
- `flutter_analyze.txt`
- `lib/services/bot_settings_service.dart`
- `lib/services/trade_execution_service.dart`
- `lib/ui/bot_dashboard_screen.dart`
- `lib/ui/bot_settings_screen.dart`
- `lib/ui/score_details_screen.dart`
- `lib/ui/trade_details_screen.dart`
- `pubspec.yaml`

---

### 2026-02-21 - Update

**TechAna Release Notes - Update vom 13. Februar 2026**

#### Highlights dieses Updates

Wir freuen uns, ein umfassendes Update für TechAna vorzustellen, das nicht nur die Stabilität und Zuverlässigkeit Ihrer automatisierten Handelsausführung signifikant verbessert, sondern auch die Intelligenz unseres Analyse-Kerns auf ein neues Niveau hebt. Dieses Release behebt kritische Fehler in der Orderverarbeitung und erweitert die strategischen Möglichkeiten durch tiefere Marktanalysen und neue Konfigurationsoptionen für Ihren Trading-Bot.

#### Fehlerbehebungen und Stabilitätsverbesserungen

*   **Behebung kritischer Fehler in der Handelsausführung:** Ein gravierender Fehler im Kern der Handelsausführung wurde behoben. Dieser Fehler konnte dazu führen, dass wichtige Order-Typen wie Stop-Loss, Take-Profit und Pending-Orders unter bestimmten Bedingungen nicht korrekt oder gar nicht ausgelöst wurden. Die betroffenen Bereiche umfassten sowohl die Datenverarbeitung als auch die Service-Schichten und die Benutzeroberfläche der Bot-Steuerung.
    *   **Ihr Nutzen:** Diese Korrektur stellt sicher, dass Ihre Schutzmechanismen und Gewinnmitnahmen stets zuverlässig funktionieren. Sie können nun mit erhöhtem Vertrauen handeln, da Ihre automatisierten Strategien und manuellen Schutzbefehle präzise und zeitgerecht ausgeführt werden. Dies minimiert das Risiko unerwarteter Verluste und maximiert die Wahrscheinlichkeit, Ihre Gewinnziele zu erreichen, was zu einem insgesamt sichereren und kontrollierteren Handelserlebnis führt.

#### Neue Funktionen und Analyse-Upgrades

*   **Erweiterter KI-Analyse-Kern mit neuen Indikatoren:** Der Smart Analysis Core wurde erheblich erweitert und integriert nun eine Vielzahl neuer technischer Indikatoren aus der `ta_extended`-Bibliothek, darunter CCI, PSAR, CMF, MFI, Awesome Oscillator (AO), Bollinger Band %B sowie Vortex und Chop Index. Zudem wurde der Ichimoku Cloud Indikator hinzugefügt.
    *   **Ihr Nutzen:** TechAna kann Marktbewegungen nun mit weitaus größerer Präzision und Tiefe analysieren. Dies führt zu relevanteren und zeitnahen Handelssignalen, die eine breitere Palette von Marktbedingungen berücksichtigen. Ihre Handelsentscheidungen werden durch ein umfassenderes Verständnis des Marktes untermauert.
*   **Verbessertes Scoring-System:** Das bisherige Scoring-Modell wurde durch ein differenziertes, kategoriebasiertes Budget-Scoring-System ersetzt. Dieses berücksichtigt separate Bewertungen für Trend, Momentum, Volumen, Chartmuster und Volatilität, um eine robustere und nuanciertere Bewertung der Marktlage zu ermöglichen.
    *   **Ihr Nutzen:** Die Qualität der generierten Handelssignale wird deutlich gesteigert. Das neue System minimiert Fehlinterpretationen und bietet eine transparentere Grundlage für die Kauf-/Verkaufsempfehlungen, was zu potenziell profitableren und sichereren Trades führt.
*   **Erkennung von Candlestick-Mustern und Divergenzen:** Der Analyse-Kern erkennt nun automatisch gängige Candlestick-Muster und identifiziert bullische/bearische Divergenzen auf Basis von Preis und RSI.
    *   **Ihr Nutzen:** Sie erhalten frühzeitig Hinweise auf potenzielle Trendwenden oder Fortsetzungen. Dies ermöglicht es Ihnen, proaktiver zu agieren und von Mustern zu profitieren, die historisch gesehen eine hohe Vorhersagekraft haben.
*   **Erweiterte Optionen für Stop-Loss und Take-Profit Strategien:** Neue Methoden für Stop-Loss (Swing) und Take-Profit (Pivot) wurden in den Bot-Einstellungen eingeführt, ergänzt durch einen einstellbaren `swingLookback`-Parameter.
    *   **Ihr Nutzen:** Mehr Flexibilität und Präzision bei der Definition Ihrer Risikomanagement- und Gewinnmitnahme-Strategien. Passen Sie den Bot noch genauer an Ihren Handelsstil und Ihre Marktanalyse an, um optimierte Ausstiegsstrategien zu nutzen.

#### Architektonische Verbesserungen und Refactoring

*   **Modularisierung der Bot- und Portfolio-Services:** Die Funktionalitäten für Bot-Einstellungen, Watchlist-Management und Handelsausführung wurden aus dem `PortfolioService` in dedizierte, neue Services (`BotSettingsService`, `WatchlistService`, `TradeExecutionService`) ausgelagert und als separate `ChangeNotifierProvider`s in die Anwendung integriert.
    *   **Ihr Nutzen:** Diese strukturelle Verbesserung führt zu einem saubereren, wartbareren und erweiterbaren Code. Für Sie bedeutet das eine stabilere Anwendung und die Grundlage für zukünftige, schnellere Feature-Entwicklungen. Die neue Architektur ermöglicht zudem dedizierte Einstellungsbereiche für Ihren Bot.

#### Dokumentation und Interne Updates

*   **Aktualisierter CHANGELOG und README:** Der `CHANGELOG.md` wurde um die detaillierten Release Notes für dieses Update erweitert und ersetzt die temporären `current_patch_notes.md`, die nun entfernt wurden. Die `README.md` wurde ebenfalls aktualisiert, um die neuesten Highlights und verbesserte Installationsanweisungen widerzuspiegeln.
    *   **Ihr Nutzen:** Verbesserte Transparenz über die Änderungen und eine klarere Kommunikation der Vorteile. Die aktualisierten Installationsanleitungen erleichtern den Einstieg und die Wartung der Anwendung.
*   **Anwendungsversion `1.0.0+3`:** Die interne Version von TechAna wurde entsprechend der vorgenommenen Änderungen aktualisiert.
*   **KI-Statusaktualisierung:** Der interne Status des KI-Berichtssystems (`last_ai_commit`) wurde aktualisiert, um sicherzustellen, dass nachfolgende KI-Analysen und Berichte stets die neuesten Codeänderungen und Systemzustände korrekt reflektieren.

### 📂 Geänderte Dateien
- `lib/main.dart`
- `lib/models/models.dart`
- `lib/providers/app_provider.dart`
- `lib/services/bot_settings_service.dart`
- `lib/services/portfolio_service.dart`
- `lib/services/ta_extended.dart`
- `lib/services/trade_execution_service.dart`
- `lib/services/watchlist_service.dart`
- `lib/ui/bot_dashboard_screen.dart`
- `lib/ui/bot_settings_screen.dart`
- `lib/ui/dashboard_screen.dart`
- `lib/ui/pattern_details_screen.dart`
- `lib/ui/score_details_screen.dart`
- `lib/ui/settings_screen.dart`
- `lib/ui/top_movers_history_screen.dart`
- `lib/ui/top_movers_screen.dart`
- `lib/ui/trade_details_screen.dart`
- `pubspec.yaml`

---

### 2026-02-13 - Update

#### Highlights dieses Updates

Wir freuen uns, ein wichtiges Stabilitätsupdate für TechAna bereitzustellen, das die Zuverlässigkeit und Präzision Ihrer automatisierten Handelsausführung signifikant verbessert. Dieses Release behebt kritische Fehler in der Orderverarbeitung und stellt sicher, dass Ihre Handelsstrategien exakt wie beabsichtigt umgesetzt werden.

#### Fehlerbehebungen und Stabilitätsverbesserungen

*   **Behebung kritischer Fehler in der Handelsausführung:** Ein gravierender Fehler im Kern der Handelsausführung wurde behoben. Dieser Fehler konnte dazu führen, dass wichtige Order-Typen wie Stop-Loss, Take-Profit und Pending-Orders unter bestimmten Bedingungen nicht korrekt oder gar nicht ausgelöst wurden. Die betroffenen Bereiche umfassten sowohl die Datenverarbeitung als auch die Service-Schichten und die Benutzeroberfläche der Bot-Steuerung.
    *   **Ihr Nutzen:** Diese Korrektur stellt sicher, dass Ihre Schutzmechanismen und Gewinnmitnahmen stets zuverlässig funktionieren. Sie können nun mit erhöhtem Vertrauen handeln, da Ihre automatisierten Strategien und manuellen Schutzbefehle präzise und zeitgerecht ausgeführt werden. Dies minimiert das Risiko unerwarteter Verluste und maximiert die Wahrscheinlichkeit, Ihre Gewinnziele zu erreichen, was zu einem insgesamt sichereren und kontrollierteren Handelserlebnis führt.

#### Technische und interne Updates

*   **Anwendungsversion:** Die Version von TechAna wurde auf `1.0.0+3` aktualisiert. Diese inkrementelle Versionierung unterstreicht unsere fortlaufenden Bemühungen, die Stabilität und Wartbarkeit der Anwendung zu gewährleisten.
*   **Interne KI-Statusaktualisierung:** Der interne Status des KI-Berichtssystems (`last_ai_commit`) wurde aktualisiert. Dies ist eine technische Anpassung, die sicherstellt, dass die nachfolgenden KI-Analysen und Berichte stets die neuesten Codeänderungen und Systemzustände korrekt reflektieren, was die Genauigkeit und Relevanz der KI-generierten Erkenntnisse aufrechterhält.

### 📂 Geänderte Dateien
- `pubspec.yaml`

---

### 2026-02-09 - Update

Hier sind die professionellen Release Notes für "TechAna":

#### Überblick über das aktuelle Update

Wir haben ein entscheidendes Update für TechAna veröffentlicht, das sich auf die Verbesserung unserer Kernanalysefähigkeiten und die Optimierung der Benutzerkommunikation konzentriert. Diese Version bringt signifikante Verbesserungen in der Reaktionsfähigkeit unserer KI auf Marktbewegungen und stellt sicher, dass unsere Nutzer stets die agilsten und präzisesten Einblicke erhalten.

#### Core AI & Performance-Verbesserungen

*   **Agiler Smart Analysis Core:** Der Kern unserer KI-gestützten Analyse wurde umfassend aktualisiert. Diese Neuerung ermöglicht es TechAna, wesentlich agiler und präziser auf dynamische Marktbedingungen zu reagieren.
    *   **Nutzen:** Für Anwender bedeutet dies relevantere und zeitnahe Daten, die eine fundiertere und strategischere Entscheidungsfindung im Handel ermöglichen. Entwickler profitieren von einer robusteren und performanteren Basis für zukünftige KI-Modul-Erweiterungen. Die Aktualisierung des `ai_state.json` spiegelt diese tiefgreifende Änderung wider und sichert die Konsistenz unserer KI-Berechnungen.

#### Benutzererfahrung & Dokumentations-Optimierungen

*   **Verbesserte Sichtbarkeit des neuesten Updates:** Wir haben eine neue, dedizierte Sektion im `README.md` eingeführt, die die wichtigsten Änderungen und Vorteile dieses Updates prominent hervorhebt. Dies stellt sicher, dass Nutzer sofort die neuesten Verbesserungen erkennen und deren Mehrwert verstehen.
    *   **Nutzen:** Erhöhte Transparenz und verbesserte Kommunikation über neue Funktionen und deren Auswirkungen für alle Benutzer.
*   **Optimierte Darstellung:** Die `README.md` wurde um zusätzliche Trennlinien erweitert und der Bildpfad für unser Banner wurde korrigiert.
    *   **Nutzen:** Dies führt zu einer übersichtlicheren und professionelleren Darstellung der Projektinformationen und einer korrekten Anzeige visueller Elemente.

---

### 2026-02-09 - Update

Willkommen zum neuesten Update von TechAna! Dieses Release vom 09. Februar 2026 bringt eine Fülle von Verbesserungen, die sowohl unter der Haube als auch in der Benutzererfahrung spürbar sind. Unser Fokus lag darauf, die Effizienz zu steigern und Ihnen den Zugang zu den mächtigen Analysewerkzeugen von TechAna noch einfacher und intuitiver zu gestalten. Wir freuen uns, ein signifikantes Update für TechAna bekannt zu geben, das sowohl unter der Haube als auch in der öffentlichen Darstellung wesentliche Verbesserungen mit sich bringt. Dieses Release spiegelt unsere kontinuierliche Weiterentwicklung unseres **Smart Analysis Core** wider und stellt sicher, dass TechAna noch agiler und effizienter auf die dynamischen Marktbedingungen reagieren kann.

#### ⚡ Leistungsoptimierung & Systemstabilität
Das interne Update-System von TechAna wurde grundlegend optimiert und überarbeitet. Diese entscheidende Verbesserung gewährleistet eine **schnellere und reibungslosere Bereitstellung** zukünftiger Bugfixes, Sicherheitsupdates und Feature-Erweiterungen. Für Sie als Nutzer bedeutet dies, dass Sie stets von der neuesten und stabilsten Version von TechAna profitieren, da wichtige Verbesserungen und Problembehebungen ohne lange Wartezeiten verfügbar gemacht werden können. Die Aktualisierung unserer internen AI-Status-Dateien (`ai_state.json`) spiegelt zudem die erfolgreiche Weiterentwicklung unseres **Smart Analysis Core** wider, der nun noch agiler auf dynamische Marktbedingungen reagiert und dessen Analyseprozesse weiter verfeinert wurden. Die Vereinheitlichung unserer Release-Informationen in einem zentralen Changelog (`CHANGELOG.md`) führt zu einer klareren und konsistenteren Kommunikation über alle Updates.

#### ✨ Umfassende Dokumentations- und Funktionsübersicht
Die gesamte öffentliche Dokumentation, insbesondere die **`README.md` auf unserer Projektseite**, wurde komplett überarbeitet und stark erweitert. Diese Neugestaltung transformiert unsere Projektseite in eine zentrale und visuell ansprechende Informationsquelle, die nun eine tiefere Einsicht in die Fähigkeiten von TechAna bietet und sowohl neuen Anwendern als auch potenziellen Entwicklern einen klaren Weg aufzeigt.

*   **Verbesserte Sichtbarkeit der Kernfunktionen**: Der `README` stellt nun die Leistungsfähigkeit des **KI-gestützten Smart Analysis Core** noch detaillierter dar. Anwender erhalten spezifische Informationen zu den von TechAna erkannten Reversal- und Continuation-Patterns sowie zur erweiterten Fundamentalanalyse (Kennzahlen wie KGV, Umsatzwachstum, Dividendenrendite).
    *   **Nutzen:** Dies ermöglicht Tradern, fundiertere und datenbasierte Handelsentscheidungen zu treffen, indem sie ein umfassenderes Bild der Marktdynamik erhalten.

*   **Einführung von Algo-Trading & Backtesting (Beta)**: Ein dedizierter Abschnitt beleuchtet nun die Möglichkeit, **konfigurierbare Trading-Bots** zu nutzen und Strategien mittels **Backtesting** mit historischen Daten zu simulieren.
    *   **Nutzen:** Dies ist ein entscheidender Vorteil, da Trader ihre Ansätze risikofrei verfeinern und optimieren können, bevor sie diese im Live-Handel einsetzen, und so ihre Strategien effektiv automatisieren und validieren.

*   **Erweiterte Indikatoren und Sentiment-Analyse**: Die Liste der verfügbaren technischen Indikatoren wurde erheblich ergänzt und detailliert dargestellt (z.B. Ichimoku Cloud, Keltner Channels, MFI). Darüber hinaus wird die **Sentiment-Analyse** als integraler Bestandteil des News-Aggregators hervorgehoben, der Nutzern hilft, die Marktstimmung (Bullish/Bearish) schnell zu erfassen.
    *   **Nutzen:** Diese umfassendere Werkzeugpalette ermöglicht eine präzisere und tiefere Marktbewertung, indem sie vielfältige Perspektiven und Stimmungen berücksichtigt.

*   **Professionelle Präsentation & App-Einblicke**: Durch die Integration von **aktuellen App-Screenshots** und einem neuen visuellen Banner erhalten Interessenten einen ersten, ansprechenden Einblick in das User Interface und die intuitive Funktionsweise von TechAna, noch bevor sie die Anwendung installieren.
    *   **Nutzen:** Dies schafft Transparenz, baut Vertrauen auf und erleichtert die Kaufentscheidung, indem es eine Vorschau auf die Benutzererfahrung bietet.

*   **Optimiertes Onboarding für Entwickler und Anwender**: Detaillierte Installationsanweisungen, eine klare Übersicht über alle unterstützten Plattformen (iOS, Android, macOS, Windows, Linux, Web) und die neu eingeführten **Contributing-Richtlinien** (bald verfügbar) erleichtern den Einstieg für jeden, der TechAna nutzen oder zur Weiterentwicklung beitragen möchte. Die verbesserte API-Dokumentation ist zudem eine Bereicherung für Integrationspartner und ermöglicht eine effizientere Anbindung externer Datenquellen.
    *   **Nutzen:** Ein schnellerer und einfacherer Einstieg für alle Nutzer und Entwickler, kombiniert mit effizienteren Integrationsmöglichkeiten für externe Systeme.

---

### 2026-02-09 - Update

Wir freuen uns, ein signifikantes Update für TechAna bekannt zu geben, das sowohl unter der Haube als auch in der öffentlichen Darstellung wesentliche Verbesserungen mit sich bringt. Dieses Release spiegelt unsere kontinuierliche Weiterentwicklung unseres **Smart Analysis Core** wider und stellt sicher, dass TechAna noch agiler und effizienter auf die dynamischen Marktbedingungen reagieren kann. Unser Fokus lag auf der Steigerung der operativen Effizienz sowie der Bereitstellung einer noch klareren und umfassenderen Dokumentation, um Ihnen den Einstieg und die Nutzung von TechAna zu erleichtern.

#### ⚡ Performance & Stabilität (Release vom 09. Februar 2026)
Das interne Update-System von TechAna wurde grundlegend optimiert. Diese entscheidende Verbesserung gewährleistet eine **schnellere und reibungslosere Bereitstellung** zukünftiger Bugfixes, Sicherheitsupdates und Feature-Erweiterungen. Für Sie als Nutzer bedeutet dies, dass Sie stets von der neuesten und stabilsten Version von TechAna profitieren, da wichtige Verbesserungen und Problembehebungen ohne lange Wartezeiten verfügbar gemacht werden können.

#### ✨ Umfassende Dokumentations- und Funktionsübersicht
Die gesamte öffentliche Dokumentation, insbesondere die **`README.md` auf unserer Projektseite**, wurde komplett überarbeitet und stark erweitert. Diese Neugestaltung transformiert unsere Projektseite in eine zentrale und visuell ansprechende Informationsquelle, die nun eine tiefere Einsicht in die Fähigkeiten von TechAna bietet und sowohl neuen Anwendern als auch potenziellen Entwicklern einen klaren Weg aufzeigt.

*   **Verbesserte Sichtbarkeit der Kernfunktionen**: Der `README` stellt nun die Leistungsfähigkeit des **KI-gestützten Smart Analysis Core** noch detaillierter dar. Anwender erhalten spezifische Informationen zu den von TechAna erkannten Reversal- und Continuation-Patterns sowie zur erweiterten Fundamentalanalyse (Kennzahlen wie KGV, Umsatzwachstum, Dividendenrendite). Dies ermöglicht es Tradern, fundiertere und datenbasierte Handelsentscheidungen zu treffen.

*   **Einführung von Algo-Trading & Backtesting (Beta)**: Ein dedizierter Abschnitt beleuchtet nun die Möglichkeit, **konfigurierbare Trading-Bots** zu nutzen und Strategien mittels **Backtesting** mit historischen Daten zu simulieren. Dies ist ein entscheidender Vorteil, da Trader ihre Ansätze risikofrei verfeinern können, bevor sie diese im Live-Handel einsetzen, und so ihre Strategien effektiv automatisieren.

*   **Erweiterte Indikatoren und Sentiment-Analyse**: Die Liste der verfügbaren technischen Indikatoren wurde erheblich ergänzt und detailliert dargestellt (z.B. Ichimoku Cloud, Keltner Channels, MFI). Darüber hinaus wird die **Sentiment-Analyse** als integraler Bestandteil des News-Aggregators hervorgehoben, der Nutzern hilft, die Marktstimmung (Bullish/Bearish) schnell zu erfassen. Diese umfassendere Werkzeugpalette ermöglicht eine präzisere und tiefere Marktbewertung.

*   **Professionelle Präsentation & App-Einblicke**: Durch die Integration von **aktuellen App-Screenshots** und einem neuen visuellen Banner erhalten Interessenten einen ersten, ansprechenden Einblick in das User Interface und die intuitive Funktionsweise von TechAna, noch bevor sie die Anwendung installieren. Dies schafft Transparenz und erleichtert die Kaufentscheidung.

*   **Optimiertes Onboarding für Entwickler und Anwender**: Detaillierte Installationsanweisungen, eine klare Übersicht über alle unterstützten Plattformen (iOS, Android, macOS, Windows, Linux, Web) und die neu eingeführten **Contributing-Richtlinien** (bald verfügbar) erleichtern den Einstieg für jeden, der TechAna nutzen oder zur Weiterentwicklung beitragen möchte. Die verbesserte API-Dokumentation ist zudem eine Bereicherung für Integrationspartner und ermöglicht eine effizientere Anbindung externer Datenquellen.

---

### 2026-02-08 - Update

TEIL 1 (Ausführlich für Release Page & Changelog):

#### ✨ TechAna v1.0.0 – Offizieller Start & Funktionserweiterungen

Wir freuen uns, den offiziellen Start von TechAna mit Version 1.0.0 bekannt zu geben! Dieses Release legt nicht nur ein robustes Fundament für intelligentes Trading und Marktanalyse, sondern führt auch wesentliche Verbesserungen ein, die Effizienz und Benutzerfreundlichkeit in den Vordergrund stellen. Parallel dazu haben wir unsere internen Prozesse für Release-Management und Bugfixing massiv optimiert.

**Neue Funktionen & UI-Verbesserungen:**
*   **Interaktive Trade-Filter im Bot-Dashboard:** Nutzer können Trades nun schnell und intuitiv nach ihrem Status (Offen, Pending, Geschlossen) oder ihrer Performance (Plus, Minus) filtern.
    *   **Nutzen:** Erhöht die Übersichtlichkeit und ermöglicht eine deutlich schnellere und zielgerichtete Analyse der Handelsaktivitäten sowie der Portfolio-Performance.
*   **Erweitertes Watchlist-Management durch Kategorien:** Neue Watchlist-Kategorien erlauben es, alle Symbole innerhalb einer Kategorie gleichzeitig zu aktivieren oder zu deaktivieren.
    *   **Nutzen:** Vereinfacht die Konfiguration des Bots erheblich und spart wertvolle Zeit beim Anpassen oder Erstellen individueller Watchlists.
*   **Verbessertes Bot-Scan-Feedback mit Ladebalken:** Der Bot-Scan-Prozess visualisiert nun seinen Fortschritt detailliert, inklusive eines dynamischen Ladebalkens.
    *   **Nutzen:** Bietet den Benutzern eine bessere Transparenz über den aktuellen Status und die voraussichtliche Dauer von Bot-Scans, was die Wartezeit subjektiv verkürzt.
*   **Detaillierte PnL-Anzeige für Trades:** Für geschlossene Trades wird die prozentuale Performance angezeigt. Bei offenen Trades wird ein eventuell bereits realisierter Teilgewinn separat ausgewiesen.
    *   **Nutzen:** Liefert tiefere und präzisere Einblicke in die Effizienz einzelner Trades und des Gesamtportfolios.

**Verbesserungen der Kernstabilität & Performance:**
*   **Intelligente Bot-Scan-Optimierung:** Der Bot wurde dahingehend optimiert, dass er das erneute Laden historischer Daten überspringt, wenn ein Symbol kürzlich gescannt wurde, und stattdessen nur den aktuellen Live-Preis abruft.
    *   **Nutzen:** Reduziert die Anzahl der API-Anfragen drastisch, beschleunigt die Bot-Routine erheblich und schont wertvolle Systemressourcen.
*   **Robusterer Yahoo Finance Datenabruf:** Der Abruf von Live-Preisen wurde auf die zuverlässigere Yahoo Finance `v8/chart` API umgestellt und mit automatischer Session-Reset- sowie Wiederholungslogik versehen.
    *   **Nutzen:** Steigert die Zuverlässigkeit und Genauigkeit der extern bezogenen Daten, was für präzise Bot-Entscheidungen und eine korrekte Portfolio-Anzeige unerlässlich ist.
*   **Verbesserte Stop-Loss-Sicherheit:** Zusätzliche Sicherheitsprüfungen gewährleisten, dass der Stop-Loss stets korrekt platziert wird, auch unter volatilen Marktbedingungen.
    *   **Nutzen:** Minimiert unvorhergesehene Risiken durch fehlerhafte SL-Platzierungen und schützt das Kapital des Benutzers effektiver.
*   **Preis-Fallback für offene Positionen:** Kann kein Live-Preis abgerufen werden, greift das System auf den letzten bekannten Schlusskurs zurück.
    *   **Nutzen:** Verhindert eine "0.00"-Anzeige im PnL bei temporären Datenproblemen und bietet weiterhin eine sinnvolle Näherung des aktuellen Zustands.

#### 🛠️ Umfassende Optimierung des Release- und Patch-Management-Prozesses

Dieses Update bringt auch eine revolutionäre Verbesserung unserer internen Release-Prozesse, um zukünftige Updates und Bugfixes schneller und präziser an Sie auszuliefern.

*   **Intelligente Patch-Erkennung und -Bereitstellung:**
    *   Unser System kann jetzt automatisch erkennen, ob eine Änderung ein "Shorebird Patch" (Hotfix) oder ein vollständiges "Release" ist. Dies wird durch die Analyse von Codeänderungen in plattformspezifischen Verzeichnissen (`android/`, `ios/` etc.) oder der `pubspec.yaml` ermöglicht.
    *   **Nutzen:** Ermöglicht die Bereitstellung kleinerer Fehlerbehebungen und Performance-Verbesserungen als schnelle Patches, ohne dass ein vollständiger App-Store-Upload erforderlich ist. Dies reduziert die Wartezeit für Nutzer auf wichtige Fixes erheblich.
*   **Dynamische Aktualisierung von GitHub Releases:**
    *   Bei Patch-Updates wird der Body des *letzten stabilen Releases* auf GitHub automatisch mit den neuen Patch-Informationen angereichert. Frühere Patches bleiben dabei erhalten.
    *   **Nutzen:** Hält die Release-Notes stets aktuell und übersichtlich, ohne dass für jeden kleinen Fix ein neues vollständiges Release erstellt werden muss.
*   **Verbessertes Changelog-Management:**
    *   Patch-Notizen werden nun dediziert in einer internen Datei (`.github/current_patch_notes.md`) gesammelt und in den globalen `CHANGELOG.md` integriert. Bei einem neuen Vollrelease wird diese Datei geleert, um einen sauberen Start für den nächsten Patch-Zyklus zu gewährleisten.
    *   **Nutzen:** Sorgt für eine konsistente und vollständige Dokumentation aller Änderungen, sei es ein großer Release oder ein kleiner Fix.
*   **Automatische Auflistung geänderter Dateien:**
    *   Release Notes beinhalten nun automatisch eine Liste der geänderten Dateien für mehr Transparenz.
    *   **Nutzen:** Bietet Entwicklern und technisch interessierten Nutzern einen schnellen Überblick über die betroffenen Codebereiche.
*   **Robustere KI-Analyse für Release Notes:**
    *   Die Logik zur Erstellung dieser Release Notes wurde vereinfacht und robuster gestaltet. Das System fällt nun konsistent auf den vorletzten Commit (`HEAD~1`) zurück, sollte der letzte AI-Stand nicht mehr verfügbar oder zu alt sein.
    *   **Nutzen:** Garantiert konsistentere und zuverlässigere Release Notes in der Zukunft, unabhängig von der Projekthistorie oder möglichen Fehlern in der Git-History.
*   **Optimiertes README-Update:**
    *   Das Projekt-README wird nun nur noch bei vollwertigen Releases aktualisiert, nicht bei jedem Patch.
    *   **Nutzen:** Hält die Hauptseite des Projekts stabiler und relevanter, da dort nur die Highlights der größeren Updates präsentiert werden.
*   **Konfigurierbares Release-Ziel:**
    *   Es wurden Umgebungsvariablen (`RELEASE_OWNER`, `RELEASE_REPO`) eingeführt, um Releases optional in einem anderen GitHub-Repository zu erstellen.
    *   **Nutzen:** Ermöglicht mehr Flexibilität für die Deployment-Strategie von TechAna.

**Ausblick:** Mit v1.0.0 haben wir den Grundstein für eine innovative Ära der intelligenten Marktanalyse gelegt. Diese fortgeschrittenen internen Prozesse stellen sicher, dass wir TechAna kontinuierlich und effizient weiterentwickeln können, um Ihren Anforderungen stets gerecht zu werden. Wir sind gespannt auf Ihr Feedback und freuen uns auf die gemeinsame Reise!

### 📂 Geänderte Dateien
- `.github/scripts/generate_notes.js`
- `.github/workflows/dart.yml`
- `README.md`
- `android/build/reports/problems/problems-report.html`
- `lib/ui/bot_settings_screen.dart`

---

### 2026-02-07 - Update

TEIL 1 (Ausführlich für Release Page & Changelog):
## Update-Analyse

Dieser Update-Zyklus ist ein wichtiger Meilenstein für TechAna, denn er beinhaltet nicht nur den offiziellen Launch unserer Plattform mit Version 1.0.0, sondern auch bedeutende interne Verbesserungen, die unsere zukünftige Entwicklung und Kommunikation optimieren.

**Zusammenfassung der Änderungen:**

### ✨ TechAna v1.0.0 – Die Basis ist gelegt!
Mit diesem Release fällt der Startschuss für TechAna! Version 1.0.0 bietet ein robustes Fundament für intelligentes Trading und Marktanalyse, mit einem klaren Fokus auf Effizienz, Präzision und Automatisierung.

*   **Neue Funktionen & UI-Verbesserungen:**
    *   **Interaktive Trade-Filter:** Im Bot-Dashboard können Trades nun nach Status (Offen, Pending, Geschlossen) oder Performance (Plus, Minus) gefiltert werden.
        *   **Nutzen:** Ermöglicht eine schnellere und übersichtlichere Analyse der Handelsaktivitäten und Portfolio-Performance.
    *   **Erweitertes Watchlist-Management:** Watchlist-Kategorien bieten die Möglichkeit, alle Symbole einer Kategorie gleichzeitig zu aktivieren oder zu deaktivieren.
        *   **Nutzen:** Vereinfacht die Konfiguration des Bots und spart Zeit beim Aufbau individueller Watchlists.
    *   **Verbessertes Bot-Scan-Feedback:** Der Bot-Scan-Prozess zeigt nun einen detaillierten Fortschritt inklusive eines Ladebalkens an.
        *   **Nutzen:** Benutzer erhalten eine bessere Übersicht über den aktuellen Status und die verbleibende Dauer von Bot-Scans.
    *   **Detaillierte PnL-Anzeige:** Für geschlossene Trades wird die prozentuale Performance angezeigt; bei offenen Trades wird ein eventuell bereits realisierter Teilgewinn separat ausgewiesen.
        *   **Nutzen:** Bietet tiefere Einblicke in die Effizienz einzelner Trades und des Gesamtportfolios.

*   **Verbesserungen & Stabilität (des Kernsystems):**
    *   **Intelligente Bot-Scan-Optimierung:** Der Bot überspringt nun das Laden historischer Daten, wenn ein Symbol kürzlich gescannt wurde, und ruft nur den aktuellen Live-Preis ab.
        *   **Nutzen:** Reduziert API-Anfragen, beschleunigt die Bot-Routine erheblich und schont Ressourcen.
    *   **Robusterer Yahoo Finance Datenabruf:** Der Abruf von Live-Preisen wurde auf die zuverlässigere Yahoo Finance `v8/chart` API umgestellt, inklusive automatischer Session-Reset- und Wiederholungslogik.
        *   **Nutzen:** Steigert die Zuverlässigkeit und Genauigkeit der von Yahoo Finance bezogenen Daten, entscheidend für Bot-Entscheidungen und Portfolio-Anzeige.
    *   **Verbesserte Stop-Loss-Sicherheit:** Zusätzliche Sicherheitsprüfungen stellen sicher, dass der Stop-Loss stets korrekt platziert wird.
        *   **Nutzen:** Minimiert unvorhergesehene Risiken durch fehlerhafte SL-Platzierungen und schützt das Kapital des Benutzers.
    *   **Preis-Fallback für offene Positionen:** Wenn kein Live-Preis abgerufen werden kann, greift das System auf den letzten Schlusskurs zurück.
        *   **Nutzen:** Vermeidet eine "0.00"-Anzeige im PnL bei temporären Datenproblemen und bietet weiterhin eine Näherung des aktuellen Zustands.

### 🛠️ Interne Verbesserungen & Release-Prozess
*   **Aktualisiertes AI-Status-Tracking:** Der interne AI-Status (der letzte AI-generierte Commit) wurde aktualisiert.
    *   **Nutzen:** Dient internen Prozessen zur besseren Nachvollziehbarkeit und Automatisierung von Releases.
*   **Optimierung der Release-Notizen-Generierung:** Die Logik zur Erstellung dieser Release Notes wurde vereinfacht und robuster gestaltet. Die vorherige spezielle Behandlung für einen "Initial Run" wurde entfernt. Das System fällt nun konsistent auf den vorletzten Commit zurück (`HEAD~1`), sollte der letzte AI-Stand nicht mehr verfügbar oder zu alt sein.
    *   **Nutzen:** Sorgt für konsistentere, zuverlässigere und automatisierte Release Notes in der Zukunft, unabhängig von der Projekthistorie.
*   **Allgemeine Code-Refaktorierungen:** Zahlreiche interne Logging-Meldungen wurden präzisiert und mit Emojis versehen, um die Entwicklung und Fehlersuche zu erleichtern, und der Code wurde zur Verbesserung der Wartbarkeit und Lesbarkeit überarbeitet.

**Ausblick:** Mit v1.0.0 haben wir den Grundstein gelegt. Dies ist nur der Anfang. Wir werden kontinuierlich an der Verbesserung und Erweiterung von TechAna arbeiten, basierend auf eurem Feedback und den Anforderungen des Marktes. Wir freuen uns darauf, diese Reise gemeinsam mit euch zu gestalten!

---

### 2026-02-05 - Update

TEIL 1 (Ausführlich für Release Page & Changelog):
## Update-Analyse

Willkommen zum allerersten öffentlichen Release von TechAna – Version 1.0.0!

Dieser initiale Launch markiert einen bedeutenden Meilenstein und bildet das Fundament für eine neue Ära im Bereich des intelligenten Tradings und der Marktanalyse. Nach intensiver Entwicklungsarbeit präsentieren wir euch heute ein robustes Basis-Release, das darauf ausgelegt ist, sowohl erfahrenen Tradern als auch Neueinsteigern ein mächtiges und intuitives Werkzeug an die Hand zu geben.

**Was ist passiert?**
In diesem Zeitraum wurde das gesamte Kernsystem von TechAna von Grund auf konzipiert, entwickelt und stabilisiert. Wir haben uns darauf konzentriert, eine solide Architektur zu schaffen, die nicht nur die aktuellen Anforderungen erfüllt, sondern auch zukünftige Erweiterungen und Integrationen problemlos ermöglicht. Das Ergebnis ist eine Plattform, die Effizienz, Präzision und Automatisierung in den Vordergrund stellt.

Neben der grundsätzlichen Bereitstellung der Plattform wurden zahlreiche Verbesserungen in den Bereichen Bot-Logik, Datenzuverlässigkeit und Benutzerfreundlichkeit umgesetzt:

### ✨ Neue Funktionen & UI-Verbesserungen

*   **Interaktive Trade-Filter**: Im Bot-Dashboard können Trades nun nach Status (Offen, Pending, Geschlossen) oder Performance (Plus, Minus) gefiltert werden.
    *   **Nutzen**: Ermöglicht eine schnellere und übersichtlichere Analyse der eigenen Handelsaktivitäten und Portfolio-Performance.
*   **Erweitertes Watchlist-Management**: Watchlist-Kategorien (z.B. "Germany (DAX & MDAX)") bieten nun die Möglichkeit, alle Symbole einer Kategorie gleichzeitig zu aktivieren oder zu deaktivieren.
    *   **Nutzen**: Vereinfacht die Konfiguration des Bots und spart Zeit beim Aufbau einer individuellen Watchlist.
*   **Verbessertes Bot-Scan-Feedback**: Der Bot-Scan-Prozess zeigt nun einen detaillierten Fortschritt (z.B. "Analysiere Symbol X (Y/Z)") inklusive eines Ladebalkens an.
    *   **Nutzen**: Benutzer erhalten eine bessere Übersicht über den aktuellen Status und die verbleibende Dauer von Bot-Scans.
*   **Detaillierte PnL-Anzeige**: Für geschlossene Trades wird im Dashboard neben dem realisierten Gewinn/Verlust nun auch die prozentuale Performance angezeigt. Bei offenen Trades wird ein eventuell bereits realisierter Teilgewinn separat ausgewiesen.
    *   **Nutzen**: Bietet tiefere Einblicke in die Effizienz einzelner Trades und des Gesamtportfolios.

### ⚙️ Verbesserungen & Stabilität

*   **Intelligente Bot-Scan-Optimierung**:
    *   Der Bot überspringt nun das Laden historischer Daten (von Stooq), wenn ein Symbol innerhalb der letzten 48 Stunden bereits erfolgreich gescannt wurde. Stattdessen wird nur der aktuelle Live-Preis abgerufen.
    *   Ein Symbol wird komplett vom Scan ausgeschlossen, wenn es innerhalb des vordefinierten Scan-Intervalls (`_autoIntervalMinutes`) bereits analysiert wurde.
    *   **Nutzen**: Reduziert API-Anfragen, beschleunigt die Bot-Routine erheblich und schont Ressourcen.
*   **Robusterer Yahoo Finance Datenabruf**:
    *   Der Abruf von Live-Preisen wurde auf die zuverlässigere Yahoo Finance `v8/chart` API umgestellt.
    *   Es wurde eine automatische Session-Reset- und Wiederholungslogik für Yahoo API-Anfragen (insbesondere bei `401 Unauthorized` Fehlern) implementiert.
    *   **Nutzen**: Steigert die Zuverlässigkeit und Genauigkeit der von Yahoo Finance bezogenen Daten (Live-Preise, Chart-Daten), was für die Entscheidungsfindung des Bots und die Portfolio-Anzeige entscheidend ist.
*   **Verbesserte Stop-Loss-Sicherheit**:
    *   Bei der Erstellung und Ausführung von Trades wurden zusätzliche Sicherheitsprüfungen für den Stop-Loss (SL) implementiert. Diese stellen sicher, dass der SL auch bei Gaps oder Rechenungenauigkeiten stets auf der korrekten Seite des Einstiegspreises liegt.
    *   **Nutzen**: Minimiert unvorhergesehene Risiken durch fehlerhafte SL-Platzierungen und schützt das Kapital des Benutzers.
*   **Preis-Fallback für offene Positionen**: Wenn kein Live-Preis abgerufen werden kann, greift das System auf den letzten Schlusskurs der historischen Daten zurück, um eine PnL-Anzeige zu gewährleisten.
    *   **Nutzen**: Vermeidet eine "0.00"-Anzeige im PnL bei temporären Datenproblemen und bietet weiterhin eine Näherung des aktuellen Zustands.
*   **Verbesserte Debug-Protokollierung**: Zahlreiche interne Logging-Meldungen wurden präzisiert und mit Emojis versehen, um die Entwicklung und Fehlersuche zu erleichtern.

### 🛠️ Technische Verbesserungen

*   **Interne AI-Status-Verfolgung**: Ein neuer Mechanismus zur Verfolgung des letzten AI-generierten Commits wurde eingeführt.
    *   **Nutzen**: Dient internen Prozessen zur besseren Nachvollziehbarkeit und Automatisierung von Releases (wie dieser hier!).
*   Allgemeine Code-Refaktorierungen zur Verbesserung der Wartbarkeit und Lesbarkeit.

**Ausblick:**
Mit v1.0.0 haben wir den Grundstein gelegt. Dies ist nur der Anfang. Wir werden kontinuierlich an der Verbesserung und Erweiterung von TechAna arbeiten, basierend auf eurem Feedback und den Anforderungen des Marktes. Wir freuen uns darauf, diese Reise gemeinsam mit euch zu gestalten!

---

### 2026-02-05 - Update

Hallo liebe TechAna-Community,

wir freuen uns riesig, euch heute den offiziellen Start von TechAna, Version 1.0.0, bekannt geben zu dürfen! Dies ist ein historischer Moment für unser Projekt und wir sind unglaublich stolz, euch unsere Arbeit der letzten Monate präsentieren zu können.

---

TEIL 1 (Ausführlich für Release Page & Changelog):
## Update-Analyse

Willkommen zum allerersten öffentlichen Release von TechAna – Version 1.0.0!

Dieser initiale Launch markiert einen bedeutenden Meilenstein und bildet das Fundament für eine neue Ära im Bereich des intelligenten Tradings und der Marktanalyse. Nach intensiver Entwicklungsarbeit präsentieren wir euch heute ein robustes Basis-Release, das darauf ausgelegt ist, sowohl erfahrenen Tradern als auch Neueinsteigern ein mächtiges und intuitives Werkzeug an die Hand zu geben.

**Was ist passiert?**
In diesem Zeitraum wurde das gesamte Kernsystem von TechAna von Grund auf konzipiert, entwickelt und stabilisiert. Wir haben uns darauf konzentriert, eine solide Architektur zu schaffen, die nicht nur die aktuellen Anforderungen erfüllt, sondern auch zukünftige Erweiterungen und Integrationen problemlos ermöglicht. Das Ergebnis ist eine Plattform, die Effizienz, Präzision und Automatisierung in den Vordergrund stellt.

**Kern-Features dieses Basis Releases:**

*   **[Feature] Umfassende Trading-Plattform:**
    *   **Beschreibung:** Eine intuitive Benutzeroberfläche ermöglicht den direkten Handel mit verschiedenen Assets. Dazu gehören Funktionen für Orderplatzierung, Positionsverwaltung und Echtzeit-Kursüberwachung.
    *   **Nutzen:** Ermöglicht Benutzern einen einfachen und direkten Zugang zu den Märkten, um Handelsentscheidungen schnell und effizient umzusetzen, ohne zwischen verschiedenen Tools wechseln zu müssen.

*   **[Feature] Tiefgehende Analyse-Tools:**
    *   **Beschreibung:** TechAna bietet eine Reihe von Tools zur technischen und fundamentalen Marktanalyse. Dazu gehören interaktive Charts mit vielfältigen Indikatoren, historische Datenvisualisierung und Anpassungsmöglichkeiten für individuelle Analysen.
    *   **Nutzen:** User können fundierte Handelsentscheidungen auf Basis umfassender Daten und Visualisierungen treffen, Muster erkennen und Marktstimmungen besser einschätzen.

*   **[Feature] Intelligente Bot-Integration:**
    *   **Beschreibung:** Die Plattform ermöglicht die Konfiguration und den Einsatz von automatisierten Trading-Bots. Diese können vorgegebene Strategien 24/7 ausführen, basierend auf vordefinierten Parametern und Signalen.
    *   **Nutzen:** Sparrt den Benutzern Zeit, eliminiert emotionale Handelsfehler und ermöglicht die Ausführung komplexer Strategien rund um die Uhr, selbst wenn sie offline sind. Dies steigert die Effizienz und potenzielle Profitabilität.

**Ausblick:**
Mit v1.0.0 haben wir den Grundstein gelegt. Dies ist nur der Anfang. Wir werden kontinuierlich an der Verbesserung und Erweiterung von TechAna arbeiten, basierend auf eurem Feedback und den Anforderungen des Marktes. Wir freuen uns darauf, diese Reise gemeinsam mit euch zu gestalten!

---

# Update Historie
* ⚡ Performance: Optimierung des Update-Systems für schnellere Bereitstellung zukünftiger Bugfixes und Verbesserungen.

* ⚡ Performance: Der Smart Analysis Core wurde aktualisiert und reagiert nun agiler auf dynamische Marktbedingungen.

* ⚡ Performance: Der Smart Analysis Core wurde aktualisiert und reagiert nun agiler und präziser auf dynamische Marktbedingungen.

* ⚡ Performance: Der Smart Analysis Core wurde aktualisiert und reagiert nun agiler und präziser auf dynamische Marktbedingungen.

* 🐛 Fix: Behebung kritischer Fehler in der Handelsausführung, die zu verpassten Stop-Loss-, Take-Profit- und Pending-Order-Triggern führen konnten.

* 🐛 Fix: Korrektur der Stop-Loss-Anpassung nach Teilgewinnmitnahme (TP1) und Sicherstellung der Verwendung der konfigurierten Verkaufsfraktion.
