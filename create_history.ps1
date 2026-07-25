git init

function Commit-Step($message, $timeStr, $files) {
    foreach ($file in $files) {
        git add $file
    }
    $env:GIT_AUTHOR_DATE=$timeStr
    $env:GIT_COMMITTER_DATE=$timeStr
    git commit -m $message
}

Commit-Step "Initial commit: Setup Flutter project and dependencies" "2026-07-25T10:20:00+05:30" @("pubspec.yaml", "pubspec.lock", "android/", "ios/", "web/", "linux/", "macos/", "windows/", "test/", ".gitignore", "README.md", ".metadata", "analysis_options.yaml")

Commit-Step "feat: Add core models and API service with mock data" "2026-07-25T10:55:00+05:30" @("lib/models/", "lib/utils/", "lib/services/")

Commit-Step "feat: Setup Riverpod providers and Theme" "2026-07-25T11:30:00+05:30" @("lib/theme/", "lib/providers/")

Commit-Step "feat: Create reusable UI widgets (OrderListTile, StatusTimeline)" "2026-07-25T12:10:00+05:30" @("lib/widgets/")

Commit-Step "feat: Implement Orders List and Detail screens" "2026-07-25T12:45:00+05:30" @("lib/screens/")

Commit-Step "style: Overhaul UI to match modern glassmorphism design" "2026-07-25T13:10:00+05:30" @("lib/")

git remote add origin https://github.com/Nikesh1626/Order-Tracker.git
git branch -M main
