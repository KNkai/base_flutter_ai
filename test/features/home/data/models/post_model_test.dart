import 'package:flutter_test/flutter_test.dart';
import 'package:base_flutter_ai/features/home/data/models/post_model.dart';
import 'package:base_flutter_ai/features/home/domain/entities/post_entity.dart';

void main() {
  group('PostModel Tests', () {
    test('fromJson parses valid JSON with numeric values properly', () {
      final json = {
        'id': 1,
        'userId': 10,
        'title': 'Test Title',
        'body': 'Test Body',
        'views': 500,
        'rating': 4.5,
      };

      final model = PostModel.fromJson(json);

      expect(model.id, 1);
      expect(model.userId, 10);
      expect(model.title, 'Test Title');
      expect(model.body, 'Test Body');
      expect(model.views, 500);
      expect(model.rating, 4.5);
    });

    test(
      'fromJson safely parses stringified numeric values without crashing',
      () {
        final json = {
          'id': '42',
          'userId': '99',
          'title': 'Stringified Title',
          'body': 'Stringified Body',
          'views': '1250',
          'rating': '4.95',
        };

        final model = PostModel.fromJson(json);

        expect(model.id, 42);
        expect(model.userId, 99);
        expect(model.views, 1250);
        expect(model.rating, 4.95);
      },
    );

    test(
      'fromJson handles null values and missing keys with safe defaults',
      () {
        final json = <String, dynamic>{'id': null, 'userId': null};

        final model = PostModel.fromJson(json);

        expect(model.id, 0);
        expect(model.userId, 0);
        expect(model.title, '');
        expect(model.body, '');
        expect(model.views, 0);
        expect(model.rating, 0.0);
      },
    );

    test('toEntity converts PostModel to pure PostEntity', () {
      const model = PostModel(
        id: 7,
        userId: 3,
        title: 'Entity Test',
        body: 'Entity Body',
        views: 120,
        rating: 4.8,
      );

      final entity = model.toEntity();

      expect(entity, isA<PostEntity>());
      expect(entity.id, 7);
      expect(entity.userId, 3);
      expect(entity.title, 'Entity Test');
      expect(entity.body, 'Entity Body');
      expect(entity.views, 120);
      expect(entity.rating, 4.8);
    });

    test('fromEntity converts PostEntity to PostModel', () {
      const entity = PostEntity(
        id: 5,
        userId: 2,
        title: 'From Entity',
        body: 'From Body',
        views: 88,
        rating: 4.2,
      );

      final model = PostModel.fromEntity(entity);

      expect(model.id, 5);
      expect(model.userId, 2);
      expect(model.title, 'From Entity');
      expect(model.body, 'From Body');
      expect(model.views, 88);
      expect(model.rating, 4.2);
    });

    test('toJson serializes model back to Map', () {
      const model = PostModel(
        id: 1,
        userId: 2,
        title: 'Title',
        body: 'Body',
        views: 10,
        rating: 3.5,
      );

      final json = model.toJson();

      expect(json['id'], 1);
      expect(json['userId'], 2);
      expect(json['title'], 'Title');
      expect(json['body'], 'Body');
      expect(json['views'], 10);
      expect(json['rating'], 3.5);
    });
  });
}
