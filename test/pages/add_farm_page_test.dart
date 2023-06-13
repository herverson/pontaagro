import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pontaagro/database/objectbox_database.dart';
import 'package:pontaagro/entities/farm.dart';
import 'package:pontaagro/pages/add_farm_page.dart';
import 'package:pontaagro/services/farm_service.dart';
import 'package:pontaagro/stores/farm_store.dart';
import 'package:provider/provider.dart';

class MockObjectBoxDatabase extends Mock implements ObjectBoxDatabase {}

class MockFarmService extends Mock implements FarmService {}

void main() {
  late MockFarmService mockFarmService;

  setUp(() {
    mockFarmService = MockFarmService();
  });

  final farm = Farm(name: '');

  Widget createWidgetUnderTest(Farm farm) {
    return MaterialApp(
      title: 'Pontaagro',
      home: ChangeNotifierProvider(
        create: (_) => FarmStore(mockFarmService),
        child: AddFarmPage(
          farm: farm,
        ),
      ),
    );
  }

  group('Save farm', () {
    testWidgets(
      "title is displayed",
      (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest(farm));
        expect(find.text('Criar Fazenda'), findsOneWidget);
      },
    );
    testWidgets(
      "title button is displayed",
      (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest(farm));
        expect(find.text('Salvar Fazenda'), findsOneWidget);
      },
    );

    testWidgets(
      "validate input text farm name",
      (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest(farm));
        const inputText = '';
        await tester.enterText(find.byKey(const Key('text-name')), inputText);
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byType(AddFarmPage), findsOneWidget);
        expect(find.text('Informe o nome da fazenda'), findsOneWidget);
      },
    );
  });
  group('Edit farm', () {
    testWidgets(
      "title button is displayed",
      (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest(farm..id = 1));
        expect(find.text('Editar Fazenda'), findsNWidgets(2));
      },
    );
    testWidgets(
      "input text correct is displayed",
      (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest(farm..id = 1));
        expect(find.text(farm.name), findsOneWidget);
      },
    );
    testWidgets(
      "validate input text farm name",
      (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest(farm..id = 1));
        const inputText = '';
        await tester.enterText(find.byKey(const Key('text-name')), inputText);
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byType(AddFarmPage), findsOneWidget);
        expect(find.text('Informe o nome da fazenda'), findsOneWidget);
      },
    );
  });
}
