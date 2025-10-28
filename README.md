# 📚 Learning Journey  
*A simple, beautiful SwiftUI app to track your daily learning goals.*


## 🧠 Overview

**Learning Journey** is an elegant, interactive iOS app built entirely with **SwiftUI**.  
It helps users stay consistent with their learning habits by setting a subject and duration goal — then tracking their progress day by day.

You can:
- Log daily learning progress
- Freeze missed days (limited per duration)
- Review your full learning history by month
- Update or reset goals anytime

---

## ✨ Features

### 🎯 Set Your Learning Goal
- Choose *what* you want to learn (e.g. Swift, Korean, Guitar...).
- Pick a goal duration: **Week**, **Month**, or **Year**.

### 📅 Track Your Progress
- Tap the main button to mark the day as **Learned**.
- Optionally mark a day as **Freezed** (limited usage).
- Automatically prevents re-logging for locked days.
- Progress visually displayed by week.

### 🧊 Freeze System
- Freeze up to:
  - 2 days for a **Week**
  - 8 days for a **Month**
  - 96 days for a **Year**
- Perfect for rest days or emergencies.

### 🏆 Completion Rewards
- Celebrate with an animation and encouragement once your goal is done.
- Option to start fresh or continue with the same goal.

### 📊 View All History
- Full monthly view in **Task 5** showing all learned/freezed days.
- Stored persistently using `@AppStorage` and JSON encoding.

### ⚙️ Goal Updates
- Easily change your subject or duration in **Task 4**.
- Confirmation popup before resetting progress.

---

## 🏗️ App Structure

| File | Description |
|------|--------------|
| **`task1.swift`** | Landing screen — choose subject and duration. |
| **`task2.swift`** | Main activity tracker with calendar and logging buttons. |
| **`task4.swift`** | Goal editor — allows user to update subject/duration. |
| **`task5.swift`** | History view showing monthly activity overview. |
| **`ActivityStatus` enum** | Defines 3 states: `.defaultState`, `.learned`, `.freezed`. |
| **`CircleButton` / `SummaryPill`** | Custom reusable SwiftUI components. |

---

## 🧩 Technologies Used

- **SwiftUI** — declarative UI framework.
- **@AppStorage** — lightweight data persistence.
- **Calendar & DateFormatter** — for smart date handling.
- **Custom Modifiers** (e.g. `glassEffect`) for a polished design.
- **Adaptive UI** for light/dark modes.

---

## 🚀 How to Run

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/LearningJourney.git
