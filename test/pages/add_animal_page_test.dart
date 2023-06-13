import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pontaagro/database/objectbox_database.dart';
import 'package:pontaagro/pages/add_animal_page.dart';
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

  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'Novo Animal',
      home: ChangeNotifierProvider(
        create: (_) => AnimalStore(mockFarmService),
        child: const AddAnimalPage(),
      ),
    );
  }

  testWidgets(
    "title is displayed",
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Novo Animal'), findsOneWidget);
    },
  );

  testWidgets(
    "input text correct is displayed",
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Salvar Animais'), findsOneWidget);
    },
  );
  testWidgets(
    "input text correct is displayed",
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Adicionar Animal'), findsOneWidget);
    },
  );
  testWidgets(
    "validate add animals",
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      const inputText = '';
      await tester.enterText(find.byKey(const Key('text-name')), inputText);
      await tester.tap(find.byKey(const Key('add-animal')));
      await tester.pumpAndSettle();

      expect(find.byType(AddAnimalPage), findsOneWidget);
      expect(find.byType(AnimalFormWidget), findsNWidgets(2));
    },
  );
  testWidgets(
    "validate save animals",
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      const inputText = '';
      await tester.enterText(find.byKey(const Key('text-name')), inputText);
      await tester.tap(find.byKey(const Key('save-animals')));
      await tester.pumpAndSettle();

      expect(find.byType(AddAnimalPage), findsNothing);
    },
  );
}
