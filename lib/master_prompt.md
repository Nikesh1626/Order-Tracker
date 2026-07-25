# Order Tracker — Master Build Prompts (Flutter)

Paste **Step A** into your AI coding assistant (Claude Code, Cursor, etc.) first and let it fully generate + verify the app. Only once that's working, paste **Step B** into the same session/repo so it extends the existing code instead of starting over.

---

## STEP A — Build the Core App

```
You are a senior Flutter developer. Build a complete, runnable Flutter app
called "Order Tracker" that fulfills every requirement below exactly. Treat
this as an evaluated deliverable — do not skip any item.

OBJECTIVE
A 2-screen Flutter app: an Orders List screen and an Order Detail screen,
backed by a mock REST API that I will host separately (mockapi.io or a raw
JSON file on GitHub).

MOCK API SHAPE
Design the models and networking layer against this JSON shape, fetched from
a single GET endpoint (expose the base URL as a constant, e.g.
`const String kApiUrl = 'PASTE_MOCK_API_URL_HERE';`, so I can fill it in):

[
  {
    "id": "ORD-1001",
    "customer": "Aditi Rao",
    "items": ["Wireless Mouse", "USB-C Cable"],
    "amount": 1299.00,
    "status": "Placed",
    "placed_at": "2026-07-20T10:15:00Z",
    "status_history": [
      {"status": "Placed", "timestamp": "2026-07-20T10:15:00Z"},
      {"status": "Packed", "timestamp": "2026-07-20T14:00:00Z"},
      {"status": "Shipped", "timestamp": "2026-07-21T09:30:00Z"},
      {"status": "Delivered", "timestamp": "2026-07-22T16:45:00Z"}
    ]
  }
]

Note: `status_history` is added beyond the brief's minimum fields
(id, customer, items, amount, status, placed_at) because Screen 2 needs a
timeline — it's the data source for that. Generate at least 8 seed orders
spanning different statuses (Placed, Packed, Shipped, Out for Delivery,
Delivered, Cancelled) so every chip color and timeline state gets exercised.

SCREEN 1 — ORDERS LIST
- Fetch all orders from kApiUrl on load.
- Pull-to-refresh using RefreshIndicator.
- Each row shows: customer name, order id, amount, placed_at (human-readable),
  and a colored status chip (distinct color per status — e.g. Placed=grey,
  Packed=blue, Shipped=indigo, Out for Delivery=orange, Delivered=green,
  Cancelled=red).
- Tapping a row navigates to Screen 2 with that order's id.
- Implement three distinct UI states on this screen:
  - Loading: skeleton list or centered spinner during the first fetch.
  - Empty: friendly empty-state message if the API returns zero orders.
  - Error: if the fetch fails (bad network, non-200, timeout), show an error
    state with a retry button — never a blank screen or unhandled exception.

SCREEN 2 — ORDER DETAIL
- Opened by tapping an order on Screen 1 (pass id via route args).
- Shows customer, items, amount, placed_at.
- Vertical status timeline built from status_history: each node shows status
  label + timestamp, with completed steps visually distinct from
  upcoming/pending ones (e.g. filled vs hollow circle, connecting line).

TECH & ARCHITECTURE
- State management: Provider or Riverpod (your choice, stay consistent).
- Networking: http or dio.
- Clean separation: models/, services/ (API layer), providers/ or state/,
  screens/, widgets/.
- Null-safety throughout; no hardcoded magic strings for statuses (use an
  enum or constants).
- Handle JSON parsing failures gracefully — never crash on malformed data.

FOOTER REQUIREMENT (visible on both screens)
Add a visible credit line reading exactly: "Built for Digital Heroes
Training Task", styled as a tappable link that opens https://digitalheroesco.com
in the browser (use url_launcher).

DELIVERABLES CHECKLIST
- [ ] Public GitHub repo with full source + README (setup steps, screenshots)
- [ ] Mock API URL wired into the app (placeholder constant clearly marked)
- [ ] Buildable APK (flutter build apk)
- [ ] Footer credit line + link present on both screens

SCORING WEIGHTS TO BUILD AGAINST
- Functionality & state handling (loading/empty/error, correct data flow): 45%
- UI quality (chip colors, timeline clarity, layout polish): 30%
- Code structure (models/services/state separation, readability): 25%

Now generate the full project: pubspec.yaml, folder structure, and all
source files, followed by a short README with run instructions and a clearly
marked spot for me to paste my mock API URL.
```

---

## STEP B — Polish and Demo Prep

```
You are continuing work on the Flutter "Order Tracker" app built in Step A.
Extend the existing codebase — do not rebuild from scratch. Treat this as a
graded deliverable.

OBJECTIVE
Take the working Order Tracker and finish it like a real release: one
polished animation, full offline handling, and demo-readiness.

A) ANIMATION — pick exactly ONE and implement it well
- Screen transition: custom route transition (shared-axis or fade-through)
  between Orders List and Order Detail using PageRouteBuilder or the
  animations package.
- List entrance: staggered fade/slide-in for order rows as Screen 1 loads
  (flutter_staggered_animations or a custom AnimatedList).
- Timeline progression: animate the Screen 2 status timeline so completed
  steps draw in sequentially (AnimatedContainer per node with staggered
  delays, or TweenAnimationBuilder for the connecting line).
Keep it subtle and purposeful — "polished," not "flashy."

B) OFFLINE HANDLING
- Use connectivity_plus (or similar) to detect connection state.
- When offline: show a clear, non-intrusive indicator (e.g. a persistent
  banner — "You're offline — showing last loaded orders") instead of
  silently failing. If there's no cached data yet, fall back to the Step A
  error state.
- When connection returns: auto-detect reconnection and either auto-refresh
  or show a "Back online — tap to refresh" prompt. No full app restart
  required.
- Make sure this is easy to trigger for testing (e.g. toggling airplane mode
  should surface it within a few seconds).

C) DEMO PREP
- Ensure the Step A error state can be triggered on demand for recording
  (e.g. a debug toggle, or simply disabling Wi-Fi / pointing at a broken
  URL) — I will record a Loom showing: normal use → forced error state →
  offline → back online.
- Update the README with: (1) how to reproduce the error state on camera,
  (2) how to simulate offline/online for the demo.

FOOTER REQUIREMENT (unchanged — keep it present)
The footer credit line "Built for Digital Heroes Training Task" linking to
https://digitalheroesco.com must still be visible on both screens.

DELIVERABLES CHECKLIST
- [ ] Updated GitHub repo (same repo, new commits) + updated APK build
- [ ] Animation implemented and visibly working
- [ ] Offline banner + reconnect behavior implemented
- [ ] README updated with demo-recording instructions
- [ ] (my job, outside this prompt) Loom demo recorded showing normal flow,
      forced error state, offline state, and reconnect

SCORING WEIGHTS TO BUILD AGAINST
- Offline & edge-case handling: 40%
- Animation & detail/polish: 30%
- Demo quality (app must be demo-ready, even though this isn't code): 30%

Now implement all of the above on top of the existing Step A code, and list
exactly which files you changed.
```