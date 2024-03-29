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
      context.read<AnimalStore>().onClose();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: const Text('Novo Animal'),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: showFab
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton.extended(
                  key: const Key('add-animal'),
                  heroTag: 'addAnimal',
                  onPressed: () => context.read<AnimalStore>().onAdd(),
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar Animal'),
                ),
                const SizedBox(height: 10),
                FloatingActionButton.extended(
                  key: const Key('save-animals'),
                  heroTag: 'saveAnimals',
                  onPressed: saveAnimal,
                  icon: const Icon(Icons.check),
                  label: const Text('Salvar Animais'),
                )
              ],
            )
          : null,
      body: Consumer<AnimalStore>(
        builder: (context, repository, child) {
          final listForms = repository.listForms;
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 110),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: listForms[index],
              ),
            ),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: listForms.length,
          );
        },
      ),
    );
  }
}
