const fs = require('fs');
const https = require('https');
const { execSync } = require('child_process');

module.exports = async ({ github, context, core }) => {
  // 1. Schalter prüfen (kommt aus Env Variable)
  const useAI = process.env.USE_AI === 'true';
  const geminiKey = process.env.GEMINI_API_KEY;

  // --- FALL 1: AI IST AUS ---
  if (!useAI) {
    console.log("🛑 AI ist deaktiviert. Nutze Standard-Texte.");
    core.setOutput("full_notes", "### 🔧 Wartungsupdate\n\nDies ist ein manuelles Update ohne detaillierte KI-Analyse.\nBitte Installationhinweise beachten.");
    core.setOutput("summary", "🔧 Wartungsupdate (Details folgen)");
    core.setOutput("run_status", "skipped"); // Signal für Workflow, dass wir nichts committen müssen
    return;
  }

  // --- FALL 2: AI IST AN ---
  console.log("🟢 AI ist aktiviert. Starte Analyse...");

  // Gedächtnis laden
  // Standard-Fallback ist immer der vorletzte Commit (HEAD~1), falls keine Historie existiert.
  let lastHash = "HEAD~1";
  const stateFile = '.github/ai_state.json';
  
  if (fs.existsSync(stateFile)) {
    try {
      const state = JSON.parse(fs.readFileSync(stateFile, 'utf8'));
      if (state.last_ai_commit && state.last_ai_commit !== "HEAD~1") {
        lastHash = state.last_ai_commit;
        console.log(`📜 Letzter AI-Stand war: ${lastHash}`);
      } else {
        console.log("ℹ️ State-File existiert, aber kein valider Hash. Nutze HEAD~1.");
      }
    } catch (e) {
      console.log("⚠️ Konnte State-File nicht lesen/parsen. Nutze Fallback HEAD~1.");
    }
  } else {
    console.log("ℹ️ Kein State-File gefunden. Nutze Fallback HEAD~1.");
  }

  // Diff holen (Von letztem AI-Stand bis HEUTE)
  let diff = "";
  try {
    // Checken, ob der alte Hash überhaupt noch existiert (Fetch-Depth Problem)
    // Wenn nicht, fallback auf HEAD~1
    try {
       // Versuch: Diff vom gespeicherten Hash bis heute
       execSync(`git cat-file -t ${lastHash}`);
       console.log(`🔍 Vergleiche ${lastHash} bis HEAD`);
       diff = execSync(`git diff ${lastHash} HEAD -- . ":(exclude)pubspec.lock" ":(exclude)*.png"`).toString();
    } catch (e) {
       console.log("⚠️ Alter Hash nicht gefunden (zu alt oder Git-History unvollständig?), vergleiche nur letzten Commit (HEAD~1).");
       diff = execSync(`git diff HEAD~1 HEAD -- . ":(exclude)pubspec.lock"`).toString();
    }
  } catch (error) {
    console.error("❌ Fehler beim Erstellen des Diffs:", error.message);
    diff = "Konnte keine Änderungen auslesen (Git Fehler).";
  }

  if (diff.length > 50000) diff = diff.substring(0, 50000) + "\n... (truncated)";

  // Prompt mit Anweisung zur Zusammenfassung (Initial Run Logic entfernt)
  const systemInstruction = `
  Du bist Release-Manager für "TechAna".
  
  SITUATION:
  Wir analysieren alle technischen Änderungen seit dem letzten KI-Bericht für ein Update.
  
  AUFGABE:
  Erstelle deutsche Release Notes basierend auf dem folgenden Code-Diff.
  
  FORMAT (WICHTIG! Nutze genau dieses Trennzeichen):
  
  TEIL 1 (Ausführlich für Release Page & Changelog):
  Überschrift: "## Update-Analyse"
  - Fasse zusammen, was in diesem Zeitraum passiert ist.
  - Wenn es viele Änderungen sind, gruppiere sie sinnvoll (Features, Fixes, Tech).
  - Erkläre den NUTZEN ("Was bringt das dem User/Dev?").
  
  ---SPLIT---
  
  TEIL 2 (Für die Front-README):
  - Max 3 Sätze. Knackig. Was ist das Highlight dieses Zeitraums?
  
  Hier ist der Code-Diff:
  `;

  const requestBody = JSON.stringify({
    contents: [{ parts: [{ text: systemInstruction + "\n" + diff }] }]
  });

  const options = {
    hostname: 'generativelanguage.googleapis.com',
    path: `/v1beta/models/gemini-2.5-flash:generateContent?key=${geminiKey}`,
    method: 'POST',
    headers: { 'Content-Type': 'application/json' }
  };

  await new Promise((resolve, reject) => {
    const req = https.request(options, (res) => {
      let body = '';
      res.on('data', c => body += c);
      res.on('end', () => {
        if (res.statusCode !== 200) return reject(`API Error: ${res.statusCode} ${body}`);
        
        try {
          const json = JSON.parse(body);
          const txt = json.candidates[0].content.parts[0].text;
          const parts = txt.split("---SPLIT---");
          
          const fullNotes = parts[0].trim();
          const summary = parts[1] ? parts[1].trim() : "Update verfügbar.";
          
          core.setOutput("full_notes", fullNotes);
          core.setOutput("summary", summary);
          core.setOutput("run_status", "success");
          
          // NEUEN STATE SPEICHERN (Nur im File, Commit macht der Workflow)
          // Wir speichern den aktuellen HEAD als neuen "letzten Stand"
          const currentHead = execSync('git rev-parse HEAD').toString().trim();
          fs.writeFileSync(stateFile, JSON.stringify({ last_ai_commit: currentHead }, null, 2));
          
          resolve();
        } catch (e) { reject(e); }
      });
    });
    req.write(requestBody);
    req.end();
  });
};
