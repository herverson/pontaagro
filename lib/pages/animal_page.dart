import 'package:flutter/material.dart';
import 'package:pontaagro/routes/routes.dart';
import 'package:provider/provider.dart';

import '../entities/animal.dart';
import '../entities/farm.dart';
import '../stores/animal_store.dart';
import '../stores/farm_store.dart';
import 'edit_animal_page.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();

class AnimalPage extends StatefulWidget {
  const AnimalPage({Key? key, required this.farm}) : super(key: key);

  final Farm farm;
  @override
  State<AnimalPage> createState() => _AnimalPageState();
}

class _AnimalPageState extends State<AnimalPage> {
  final loading = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    context.read<AnimalStore>().farm = widget.farm;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getFilterAnimals(widget.farm);
      loading.value = false;
    });
  }

  getFilterAnimals(Farm farm) async {
    await context.read<AnimalStore>().getAll();
  }

  openEditSheet(Animal animal) async {
    await showDialog(
      context: context,
      builder: (_) => EditAnimalPage(
        animal: animal,
      ),
    );
  }

  refresh() async {
    context.read<FarmStore>().getAll();
    context.read<AnimalStore>().onClose();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Consumer<AnimalStore>(
          builder: (context, repository, child) {
            return Text(repository.farm.name);
          },
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: refresh,
          ),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Routes.to.pushNamed('/animals/add'),
        icon: const Icon(Icons.add),
        label: const Text('Adicionar Animais'),
      ),
      body: Consumer<AnimalStore>(
        builder: (context, repository, child) {
          final animals = repository.animals;

          if (repository.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                key: Key('progress-indicator'),
              ),
            );
          }

          if (animals.isEmpty) {
            return const Center(
              child: Text('A lista de animais está vazia :('),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 80),
            itemBuilder: (context, index) => ListTile(
              title: Text(animals[index].tag),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                    onPressed: () => openEditSheet(animals[index]),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () => repository.remove(animals[index]),
                  ),
                ],
              ),
            ),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: repository.animals.length,
          );
        },
      ),
    );
  }
}
