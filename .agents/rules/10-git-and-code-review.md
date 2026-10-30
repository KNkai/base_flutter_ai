# Rule 10: Git Workflow & Code Review

1. **Commit Hygiene**:
   - Write clear, conventional commit messages: `feat(home): add search bar and empty state`, `fix(network): handle timeout exception gracefully`.
   - Never commit generated files if excluded by `.gitignore` (keep `*.g.dart` tracked if preferred, exclude build outputs).
2. **Pre-Commit Verification**:
   - Run `.\scripts\validate.ps1` before committing.
   - Ensure `dart format .` reports 0 changes needed.
   - Ensure `flutter analyze` reports 0 issues.
   - Ensure `flutter test` reports 0 failures.
3. **Review Gate**:
   - Every code change must be evaluated by `flutter-reviewer` or human peer review before merging.

