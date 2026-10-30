# Rule 06: UI & Responsive Design

1. **Responsiveness**:
   - Use `LayoutBuilder` and `AppConstants.mobileBreakpoint` (600.0) to dynamically adjust layouts between mobile and tablet/desktop.
   - Constrain content width on desktop using `ConstrainedBox` or `Container(constraints: ...)`.
2. **Standard Widgets**:
   - Always reuse core UI components from `lib/core/widgets/`:
     - `AppLoadingIndicator` for loading states.
     - `AppErrorView` for error states with retry actions.
     - `AppEmptyView` for empty lists or search results.
     - `AppButton` for standardized primary/secondary buttons.
     - `AppTextField` for text inputs.
3. **Design Tokens**:
   - Do not hardcode hex colors. Use `Theme.of(context).colorScheme` or `AppColors`.
   - Use typography styles from `Theme.of(context).textTheme` or `AppTypography`.
4. **Accessibility (a11y)**:
   - Interactive elements must maintain at least 48x48 tap targets.
   - Provide `Semantics` or `tooltip` for icon-only action buttons.

