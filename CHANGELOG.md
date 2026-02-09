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
