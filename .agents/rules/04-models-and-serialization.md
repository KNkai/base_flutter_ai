# Rule 04: Models & Resilient Serialization

1. **Serialization Approach**:
   - Use `json_serializable` with `part '<name>.g.dart';` for complex models.
   - Explicit factory `fromJson` and `toJson` methods are encouraged for simple models.
2. **Safe Parsing Requirement**:
   - **Mandatory**: For all nullable numeric fields (int, double, num) or booleans received from APIs, use `SafeParser`:
     - `SafeParser.toDouble(json['amount'])`
     - `SafeParser.toInt(json['count'])`
     - `SafeParser.toBool(json['is_active'])`
   - Never use direct cast `json['rate'] as double` because backend APIs frequently return integers or strings for float fields.
3. **Entity Conversion**:
   - Every API model must implement `toEntity()` returning its corresponding pure domain entity.
   - Do not pass raw API models into UI widgets.

