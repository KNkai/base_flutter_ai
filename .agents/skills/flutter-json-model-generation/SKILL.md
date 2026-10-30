---
name: flutter-json-model-generation
description: "Creating resilient Flutter JSON data models using json_serializable, build_runner, and SafeParser. Activate when defining new data models, updating API serialization schemas, or fixing null-safety deserialization issues."
---

# Flutter JSON Model Generation & Safe Parsing

This skill details how to author data models that survive inconsistent or malformed API responses.

## When to Activate
- Creating new API model classes.
- Adding fields to existing models.
- Running `build_runner` code generation.
- Resolving type cast crashes (e.g. `String is not a subtype of double`).

## The SafeParser Rule
In real-world APIs, numbers are often returned inconsistently (e.g., `"12.5"` instead of `12.5`, `null` instead of `0`, or `10` instead of `10.0`).
Always use `SafeParser` when deserializing numbers and booleans.

## Model Template
```dart
import 'package:json_annotation/json_annotation.dart';
import 'package:base_flutter_ai/core/utils/safe_parser.dart';
import 'package:base_flutter_ai/features/my_feature/domain/entities/my_entity.dart';

part 'my_model.g.dart';

@JsonSerializable()
class MyModel {
  @JsonKey(readValue: _readId)
  final int id;

  @JsonKey(defaultValue: '')
  final String title;

  @JsonKey(readValue: _readPrice)
  final double price;

  const MyModel({
    required this.id,
    required this.title,
    this.price = 0.0,
  });

  static Object? _readId(Map<dynamic, dynamic> json, String key) =>
      SafeParser.toInt(json[key]);

  static Object? _readPrice(Map<dynamic, dynamic> json, String key) =>
      SafeParser.toDouble(json[key]);

  factory MyModel.fromJson(Map<String, dynamic> json) => _$MyModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyModelToJson(this);

  MyEntity toEntity() => MyEntity(id: id, title: title, price: price);
}
```

## Running Code Generation
```powershell
dart run build_runner build --delete-conflicting-outputs
```
Or use the validation script:
```powershell
.\scripts\validate.ps1
```

## Verification Checklist
- [ ] Model includes `part '<model_name>.g.dart';`.
- [ ] SafeParser used on numeric fields.
- [ ] `toEntity()` converter implemented.
- [ ] Code generation executed without syntax errors.

