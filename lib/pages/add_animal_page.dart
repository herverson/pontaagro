import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../stores/animal_store.dart';

class AddAnimalPage extends StatefulWidget {
  const AddAnimalPage({Key? key}) : super(key: key);

  @override
  State<AddAnimalPage> createState() => _AddAnimalPageState();
}

class _AddAnimalPageState extends State<AddAnimalPage> {
  saveAnimal() async {
    final listForms = context.read<AnimalStore>().listForms;
    final isEmpty = listForms.any((element) => element.animal.tag.isEmpty);
    if (!isEmpty) {
      for (var element in listForms) {
        context
            .read<AnimalStore>()
            .save(element.animal.tag, context.read<AnimalStore>().farm);
      }
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: const Text('Novo Animal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Flexible(
              flex: 8,
              child: Consumer<AnimalStore>(
                builder: (context, repository, child) {
                  final listForms = repository.listForms;
                  return ListView.separated(
                    itemBuilder: (context, index) => ListTile(
                      title: listForms[index],
                    ),
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: listForms.length,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: ElevatedButton(
                onPressed: () => context.read<AnimalStore>().onAdd(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Adicionar Animal',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: ElevatedButton(
                onPressed: saveAnimal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.check),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Salvar Animais',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
