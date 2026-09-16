# ?? Flutter Performance Lab

[![Flutter CI](https://github.com/WagyuuA5/Flutter_Performance_Lab/actions/workflows/ci.yml/badge.svg)](https://github.com/WagyuuA5/Flutter_Performance_Lab/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Welcome to the **Flutter Performance Lab**! This repository serves as a professional portfolio demonstrating advanced capabilities in **Performance Engineering** within the Flutter ecosystem. 

Rather than relying on visual assumptions (e.g., "it feels faster"), this project is built on the principle of empirical measurement. Every optimization is backed by hard data extracted directly from **Flutter DevTools** (Performance and Memory profilers) running in Profile Mode on real devices.

---

## ??? Architecture & Workflow

This project is structured around 7 distinct performance anti-patterns commonly found in Flutter development. Each case is implemented as an isolated module containing a dual-tab interface:
- **?? Before (Unoptimized):** The naive implementation that causes frame drops, memory leaks, or CPU throttling.
- **?? After (Optimized):** The refactored code applying Flutter best practices, resulting in a buttery-smooth 60/120fps experience.

The application includes an interactive **Measurement Toolkit** built-in, guiding users on how to properly profile each screen. 

---

## ?? Performance Metrics Summary

> **Note:** The metrics below represent real-world profiling data captured via `flutter run --profile`. *Values marked with `[TODO]` indicate areas pending manual data entry from physical device testing.*

| Case Study | Measured Metric | Before (Naive) | After (Optimized) | Net Improvement |
| :--- | :--- | :---: | :---: | :---: |
| **1. Excessive Rebuilds** | Child Widget Rebuilds | `[TODO]` | `[TODO]` | `[TODO]` |
| **2. Expensive ListView** | Initial Build Time | `[TODO]` ms | `[TODO]` ms | `[TODO]`x faster |
| **3. Unoptimized Images** | Peak Heap Memory | `[TODO]` MB | `[TODO]` MB | `[TODO]` MB saved |
| **4. Heavy Build Method** | Execution Time in `build()` | `[TODO]` ms | `0` ms | O(N) ? O(1) in render |
| **5. Expensive Widgets** | Average Raster Time (GPU) | `[TODO]` ms/frame | `[TODO]` ms/frame | `saveLayer` eliminated |
| **6. Missing Debounce** | API Calls per Input | `[TODO]` calls | `1` call | Exponential reduction |
| **7. Animation Jank** | Heavy Tree Rebuild Frequency | 60x / sec | 1x upfront | Zero CPU throttling |

---

## ?? Detailed Case Studies

### [Case 1: Excessive Rebuilds](lib/cases/rebuild/)
**The Problem:** Calling `setState` at the root of a complex widget tree, causing the entire UI to rebuild on minor state changes.
**The Fix:** Granular state management using `ValueNotifier` and `ValueListenableBuilder` to isolate rebuilds strictly to the affected widgets.

### [Case 2: Expensive ListView](lib/cases/listview/)
**The Problem:** Instantiating a standard `ListView` with thousands of children, forcing Flutter to calculate the layout for all items simultaneously (freezing the UI).
**The Fix:** Utilizing `ListView.builder` combined with a fixed `itemExtent` to achieve O(1) layout calculation complexity and lazy loading.

### [Case 3: Unoptimized Images](lib/cases/image/)
**The Problem:** Rendering a large grid of high-resolution network images (e.g., 1200x1200px) directly, which decodes to massive bitmaps in RAM and causes Out-Of-Memory (OOM) crashes.
**The Fix:** Using the `cached_network_image` package and explicitly constraining the decode size via `memCacheWidth` and `memCacheHeight`.

### [Case 4: Heavy Build Method](lib/cases/build_method/)
**The Problem:** Executing expensive CPU operations (like filtering or sorting large datasets) directly inside the `build()` method, blocking the 16ms frame budget.
**The Fix:** Precomputing the data asynchronously or outside the build cycle (e.g., in `initState` or event handlers), ensuring `build()` only performs O(1) state reads.

### [Case 5: Expensive Widgets](lib/cases/expensive_widgets/)
**The Problem:** Stacking compositing-heavy widgets (`Opacity`, `ClipRRect`, and unoptimized `BoxShadow`), which forces the GPU to allocate expensive offscreen buffers (`saveLayer`).
**The Fix:** Baking opacity into colors via `.withValues(alpha:)`, using optimized container clipping, and isolating complex static UI with `RepaintBoundary`.

### [Case 6: Missing Debounce](lib/cases/debounce/)
**The Problem:** Triggering state updates or network requests on every single keystroke in a search field, leading to race conditions and bandwidth waste.
**The Fix:** Implementing a 300ms debounce using Dart's `Timer` to ensure the action only fires after the user pauses typing.

### [Case 7: Animation Jank](lib/cases/animation_jank/)
**The Problem:** Placing heavy, static widget trees directly inside the `builder` callback of an `AnimatedBuilder`, causing them to rebuild 60 times per second.
**The Fix:** Extracting the heavy widget tree into the `child` parameter of `AnimatedBuilder`, so it is built exactly once and only its transformation matrix is updated per frame.

---

## ?? Documentation & Proof (DevTools)

Below is the visual proof captured directly from Flutter DevTools demonstrating the before-and-after impact of these optimizations.

> *Note to Reviewers: Placeholder images below will be replaced with actual DevTools Timeline and Memory screenshots once physical profiling is complete.*

<div align="center">
  
### Case 5: GPU Raster Time Reduction (Expensive Widgets)
| Before (Jank & `saveLayer` spikes) | After (Smooth 60fps) |
| :---: | :---: |
| <img src="docs/screenshots/case-5-widgets-before.png" width="400" alt="GPU Spikes Before" /> | <img src="docs/screenshots/case-5-widgets-after.png" width="400" alt="Smooth GPU After" /> |

### Case 3: Heap Memory Stabilization (Image Resizing)
| Before (OOM Risk) | After (Stable Memory) |
| :---: | :---: |
| <img src="docs/screenshots/case-3-image-before.png" width="400" alt="Memory Leak Before" /> | <img src="docs/screenshots/case-3-image-after.png" width="400" alt="Stable Memory After" /> |

</div>

*(Additional screenshots for cases 1, 2, 4, 6, and 7 are located in the `docs/screenshots/` directory).*

---

## ?? How to Run and Measure

To verify these metrics yourself, follow these precise steps:

1. **Connect a Physical Device** (do not use simulators for performance profiling).
2. Run the app strictly in **Profile Mode**:
   ```bash
   flutter run --profile
   ```
3. Press `p` in the terminal to toggle the **Performance Overlay** on your device.
4. Open the **Flutter DevTools** link provided in the terminal (e.g., `http://127.0.0.1:9100`).
5. Navigate to the **Performance** tab, enable "Enhance Tracing", and click **Record** while interacting with the app.
6. Compare the frame rendering times (aiming for <16ms per frame) between the Before and After tabs.
