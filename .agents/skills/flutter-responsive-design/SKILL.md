---
name: flutter-responsive-design
description: "Techniques for implementing multi-platform, adaptive, and responsive layouts across mobile, tablet, and desktop screens. Activate when designing layouts that adjust to different screen widths or orientations."
---

# Flutter Responsive Design Guide

This skill guides you through constructing adaptive Flutter layouts that provide an optimal user experience on phones, tablets, foldables, and desktops.

## When to Activate
- Creating views that require dynamic column counts or side panels.
- Adapting mobile navigation (bottom nav) to tablet/desktop navigation (navigation rail / drawer).
- Handling screen rotation or multi-window resizing.

## Breakpoint Standards
Defined in `lib/core/constants/app_constants.dart`:
- **Mobile**: `< 600.0` logical pixels
- **Tablet**: `600.0` to `1024.0` logical pixels
- **Desktop**: `> 1024.0` logical pixels

## Responsive Implementation Patterns

### Pattern A: `LayoutBuilder` Adaptive Grids
```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth >= AppConstants.mobileBreakpoint) {
      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => ItemCard(item: items[index]),
          childCount: items.length,
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ItemCard(item: items[index]),
        childCount: items.length,
      ),
    );
  },
)
```

### Pattern B: Constrained Max Width for Content
On wide screens, prevent readable text from stretching edge-to-edge:
```dart
Center(
  child: ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 960),
    child: content,
  ),
)
```

## Anti-Patterns
- Using fixed pixel widths (`width: 380`) without checking screen constraints.
- Hardcoding `MediaQuery.of(context).size.width` in nested children when `LayoutBuilder` provides local parent constraints.

## Verification Checklist
- [ ] Tested on mobile width (< 600px) and tablet width (> 600px).
- [ ] No `RenderFlex` overflow errors on screen rotation or narrow viewports.
- [ ] Text content is constrained and comfortably readable on desktop monitors.

