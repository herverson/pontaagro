import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repositories/animal_repository.dart';

class AddAnimalPage extends StatefulWidget {
  const AddAnimalPage({Key? key}) : super(key: key);

  @override
  State<AddAnimalPage> createState() => _AddAnimalPageState();
}

class _AddAnimalPageState extends State<AddAnimalPage> {
  saveAnimal() async {
    final listForms = context.read<AnimalRepository>().listForms;
    final isEmpty = listForms.any((element) => element.animal.tag.isEmpty);
    if (!isEmpty) {
      for (var element in listForms) {
        context.read<AnimalRepository>().save(element.animal.tag);
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
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              context.read<AnimalRepository>().onClose();
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Flexible(
              flex: 8,
              child: Consumer<AnimalRepository>(
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
                onPressed: () => context.read<AnimalRepository>().onAdd(),
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
