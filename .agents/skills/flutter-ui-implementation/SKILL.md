---
name: flutter-ui-implementation
description: "Guidelines for implementing composable, accessible, and performant Flutter UI components and views. Activate when building screens, creating reusable widgets, or applying design tokens."
---

# Flutter UI Implementation Guide

This skill governs the construction of Flutter presentation widgets and screens.

## When to Activate
- Developing screen views or sub-widgets.
- Creating reusable components in `lib/core/widgets/`.
- Styling elements with colors, typography, and Material 3 design tokens.

## Widget Composition Standards
1. **Prefer `StatelessWidget` / `GetView`**:
   - Presentation logic lives in controllers.
   - Avoid `StatefulWidget` unless managing local animation controllers or scroll listener ticker controllers.
2. **Optimize Widget Rebuilds**:
   - Mark constructors `const` whenever possible.
   - Extract complex subtrees into private or standalone `const` classes rather than large helper methods (`Widget _buildCard()`).
3. **Use Core Standard Widgets**:
   - `AppLoadingIndicator`: Standardized loader.
   - `AppErrorView`: Standardized error view with retry callback.
   - `AppEmptyView`: Standardized empty state.
   - `AppButton`: Unified button with built-in loading indicator support.
   - `AppTextField`: Standardized input field with validation.

## Theme & Color Tokens
Never hardcode hex colors in widget trees. Always reference:
- `Theme.of(context).colorScheme.primary`
- `AppColors.primary`, `AppColors.surfaceLight`, etc.
- `Theme.of(context).textTheme` or `AppTypography`

## Verification Checklist
- [ ] No hardcoded colors (use `Theme` or `AppColors`).
- [ ] Widget constructors marked `const`.
- [ ] Business logic calls delegate to `controller.action()`.
- [ ] Reusable states (loading/error/empty) handled.

