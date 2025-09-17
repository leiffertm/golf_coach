Golf Coach — Architecture & Developer Guide

Purpose: Mobile training aid to generate random golf shots, log attempts, and surface insights (miss patterns, opposite-shape rates) to improve decision‑making on the course.

⸻

TL;DR
	•	Layered architecture: UI → AppModel (state) → Domain (generator/scoring/insights) → Store (Drift/SQLite).
	•	Single source of truth: AppModel (a ChangeNotifier).
	•	Persistence: Drift (SQLite), tables ShotSpecs & ShotAttempts (FK: attempt → spec).
	•	Deterministic domain: Framework‑free Dart for easy tests.
	•	Build: flutter run; Drift codegen with dart run build_runner build.

⸻

App Tour
	•	Generate (Home): Produce a new target shot (club, carry, trajectory, curve shape/magnitude). Quick stats & top insights.
	•	Log Attempt: Record how you actually hit it; score is computed on save.
	•	Stats: Recent actionable patterns (avg right/short, opposite‑shape rate) with counts.
	•	Settings: Skill level, generator strictness, in‑bag clubs.

⸻

Folder Structure

lib/
  main.dart
  src/
    app_model.dart                # Single app state
    screens/
      home_screen.dart
      log_attempt_screen.dart
      stats_screen.dart
      settings_screen.dart
    widgets/
      segmented_enum.dart, empty_state.dart, spacer.dart, tiles.dart, kv.dart
    utils/
      format.dart, validators.dart
    domain/                       # Framework-free logic
      enums.dart                  # SkillLevel, Club, Trajectory, CurveShape, CurveMag, Units, ...
      models.dart                 # ShotSpec, ShotAttempt, UserPrefs, AttemptResult
      generator.dart              # ShotGenerator
      scoring.dart                # Scoring (0–100)
      insights.dart               # InsightEngine → PatternStats
      club_distance_table.dart
      util_id.dart
      store.dart                  # Store interface
      store_drift.dart            # Drift-backed Store implementation
    data/
      db.dart                     # Drift schema & opener (generates db.g.dart)


⸻

Architecture Overview

Layered design

flowchart LR
  UI[Flutter UI\nScreens & Widgets] -->|reads/writes| AM[AppModel\n(ChangeNotifier)]
  AM -->|orchestrates| SVC[PracticeService]
  SVC -->|pure calls| DOM[(Domain Logic\nGenerator / Scoring / Insights)]
  SVC --> STORE[[Store Interface]]
  STORE --> DSTORE[DriftStore\n(SQLite via Drift)]
  DSTORE --> DB[(ShotSpecs, ShotAttempts)]

	•	UI: Passive views; rebuild via AnimatedBuilder(animation: model, ...).
	•	AppModel: State + notifications. Exposes methods for generate/log/settings.
	•	PracticeService: Use cases; composes Generator/Scoring/Insights with storage.
	•	Domain: Pure Dart (deterministic, testable).
	•	Store: Repository boundary; swappable (InMemory → Drift → future remote sync).

Data flow (generate → display)

sequenceDiagram
  participant U as User
  participant UI as HomeScreen
  participant AM as AppModel
  participant S as PracticeService
  participant G as ShotGenerator
  participant ST as Store

  U->>UI: Tap "Generate Shot"
  UI->>AM: generate()
  AM->>S: generateSpec(prefs)
  S->>G: generate(inBag, skill, strictness)
  G-->>S: ShotSpec
  S->>ST: putSpec(spec)
  ST-->>S: ok
  S-->>AM: ShotSpec
  AM-->>UI: currentSpec set; notifyListeners()
  UI-->>U: New target shown

Data flow (log attempt → score → insights)

sequenceDiagram
  participant UI as LogAttemptScreen
  participant AM as AppModel
  participant S as PracticeService
  participant ST as Store
  participant SC as Scoring
  participant IN as InsightEngine

  UI->>AM: logAttempt(form values)
  AM->>S: logAttempt(...)
  S->>ST: putAttempt(attempt)
  ST-->>S: ok
  S->>SC: score(spec, attempt, skill)
  SC-->>S: ScoreResult
  S-->>AM: (attempt, score)
  AM->>S: computeInsights()
  S->>ST: allAttempts(); getSpec(specId)
  ST-->>S: lists
  S->>IN: compute(attempts, specsById)
  IN-->>S: List<PatternStats>
  S-->>AM: insights
  AM-->>UI: notifyListeners(); UI shows score & updated insights


⸻

Domain Logic

Generator
	•	Inputs: Set<Club> inBag, SkillLevel, GeneratorStrictness.
	•	Process:
	1.	Pick a club uniformly from in‑bag.
	2.	Look up distance band from ClubDistanceTable.range(club, skill).
	3.	Tighten band by strictness (0–30%) and sample carry.
	4.	Sample trajectory (Normal 60%, Low 20%, High 20%).
	5.	Sample curve shape (Draw 35%, Straight 30%, Fade 35%).
	6.	Sample curve magnitude (Small 50%, Medium 35%, Large 15%).
	•	Output: ShotSpec persisted via Store.

Note (generator.dart): Ensure _randInt is int-safe:

int _randInt(int a, int b) {
  final span = (b - a + 1);
  final max = span <= 0 ? 1 : span;
  return a + _rng.nextInt(max);
}

Scoring (0–100)

Weighted error model scaled by SkillLevel:

Term	Definition
eCarry	`
eHeight	adjacency cost: exact=0, adjacent=4, opposite=8
eCurveShape	same=0, straight vs curved=5, draw vs fade=10
eCurveMag	small/med/large distance in steps (0→0.0, 1→2.0, 2→4.0)
eSide	`

Weights scale with skill (beginner → lower penalty, plus → higher):

final base = (0.8, 1.0, 1.2, 0.7, 0.5);

Final:

score = clamp(100 - Σ wi*ei, 0..100).round();

Insights
	•	Group attempts by (trajectory, curveShape[, club]) and compute:
	•	avgRight (positive right, negative left)
	•	avgShort (negative short, positive long)
	•	oppositeShapeRate (% of attempts with actual draw↔fade opposite)
	•	Example wording:
“When given a High Fade with 7i, you tend to miss on average 17 yards right and 14 yards short.”

⸻

Persistence (Drift/SQLite)

Schema (Drift)

erDiagram
  ShotSpecs {
    text id PK
    int club
    int carryYards
    int trajectory
    int curveShape
    int curveMag
  }
  ShotAttempts {
    text id PK
    text specId FK
    int  timestampMillis
    int  carryYards
    int  height
    int  curveShape
    int  curveMag
    int  endSideYards
    int  endShortLongYards
    int  result
    text notes
  }
  ShotSpecs ||--o{ ShotAttempts : contains

	•	Enum storage: by index (compact, stable).
	•	FK: ShotAttempts.specId → ShotSpecs.id.
	•	Open: NativeDatabase.createInBackground(file) under app documents dir.

Mapping (domain ↔ DB)
	•	Keep domain models framework‑free; translate in DriftStore.
	•	Avoids name collisions via @DataClassName('ShotSpecRow'), @DataClassName('ShotAttemptRow') (see db.dart).

Codegen

# whenever schema changes
dart run build_runner build --delete-conflicting-outputs


⸻

State Management
	•	AppModel (ChangeNotifier) is the single source of truth.
	•	UI listens via AnimatedBuilder(animation: model, ...).
	•	Threading rules:
	•	After await, check the same BuildContext you’ll use:

if (!context.mounted) return; // not State.mounted



⸻

Build & Run

# from project root (contains pubspec.yaml)
flutter pub get
# generate Drift code (first time / after schema edits)
dart run build_runner build --delete-conflicting-outputs
# run on your chosen device
a. flutter run -d ios
b. flutter run -d android
c. flutter run -d macos
# or web for quick smoke test
d. flutter run -d chrome

Scripts (optional)
	•	Bootstrap: golf_coach_bootstrap.sh scaffolds MVP for a fresh repo.
	•	Drift add‑on: add_drift.sh wires dependencies, schema, store impls, and codegen.

⸻

Testing Strategy
	•	Unit (pure Dart): generator ranges, scoring weights, insights grouping.
	•	Widget: Home generates & displays spec; Settings toggles rebuild; Log saves & shows score dialog.
	•	Integration: Drift backed Store CRUD & simple queries.

Example seeds for deterministic generator tests:

final gen = ShotGenerator(42);
final spec = gen.generate(inBag: {Club.i7}, skill: SkillLevel.intermediate);
expect(spec.club, Club.i7);


⸻

Troubleshooting
	•	UI not refreshing after Generate: Ensure the screen is wrapped in AnimatedBuilder(animation: model, ...) and uses model.currentSpec inside the builder. Keep Flex layout consistent (Expanded on both branches).
	•	Linter: “Don’t use BuildContext across async gaps, guarded by an unrelated mounted check” → use if (!context.mounted) return;.
	•	Type error: nextInt expects int; avoid using num.clamp(...) directly; convert to int as shown in generator fix.
	•	Missing types: AttemptResult undefined → import ../domain/models.dart in log_attempt_screen.dart.
	•	Drift codegen: Run the build_runner command after schema edits.

⸻

Roadmap
	•	Filters & charts: Date ranges, per‑club breakdowns, dispersion plots.
	•	Sessions: Start/end sessions; per‑session insights.
	•	Cloud sync: Add remote store and conflict‑free merge.
	•	Coaching layer: Drill generator, tips tied to dominant patterns.

⸻

Privacy & Data
	•	Local‑only; no network I/O in MVP.
	•	Data stored under app documents dir as golf_coach.sqlite.

⸻

Contributing
	•	Keep domain logic pure & tested.
	•	Avoid UI business logic; delegate to AppModel/services.
	•	Maintain Store interface compatibility when adding persistence features.

⸻

Glossary
	•	Spec: The target shot the app asks you to hit.
	•	Attempt: Your recorded result (actual ball flight metrics & notes).
	•	Opposite‑shape: Actual curve is the inverse of the requested (draw↔fade).
	•	Strictness: How tight the generated carry band is.

⸻

License

TBD.