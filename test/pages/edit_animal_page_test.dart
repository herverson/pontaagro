import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pontaagro/database/objectbox_database.dart';
import 'package:pontaagro/entities/animal.dart';
import 'package:pontaagro/pages/edit_animal_page.dart';
import 'package:pontaagro/services/animal_service.dart';
import 'package:pontaagro/stores/animal_store.dart';
import 'package:provider/provider.dart';

class MockObjectBoxDatabase extends Mock implements ObjectBoxDatabase {}

class MockAnimalService extends Mock implements AnimalService {}

void main() {
  late MockAnimalService mockFarmService;

  setUp(() {
    mockFarmService = MockAnimalService();
  });

  final animal = Animal(tag: 'Test Tag');

  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'Test Tag',
      home: ChangeNotifierProvider(
        create: (_) => AnimalStore(mockFarmService),
        child: EditAnimalPage(
          animal: animal,
        ),
      ),
    );
  }

  testWidgets(
    "title is displayed",
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Editar Animal'), findsNWidgets(2));
    },
  );

  testWidgets(
    "input text correct is displayed",
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text(animal.tag), findsOneWidget);
    },
  );

  testWidgets(
    "validate",
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      const inputText = '';
      await tester.enterText(find.byKey(const Key('text-tag')), inputText);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(EditAnimalPage), findsOneWidget);
      expect(find.text('Informe a Tag do animal'), findsOneWidget);
    },
  );
}
