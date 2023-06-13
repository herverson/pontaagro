import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pontaagro/database/objectbox_database.dart';
import 'package:pontaagro/entities/animal.dart';
import 'package:pontaagro/pages/animal_form_widget.dart';
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

  final animal = Animal(tag: '');

  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'Novo Animal',
      home: Scaffold(
        body: ChangeNotifierProvider(
          create: (_) => AnimalStore(mockFarmService),
          child: AnimalFormWidget(
            animal: animal,
          ),
        ),
      ),
    );
  }

  testWidgets(
    "tag is displayed",
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Tag'), findsOneWidget);
    },
  );
  testWidgets(
    "input is displayed",
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      const inputText = '';
      await tester.enterText(find.byKey(const Key('text-name')), inputText);
      await tester.pumpAndSettle();
      expect(find.text(inputText), findsOneWidget);
    },
  );
}
