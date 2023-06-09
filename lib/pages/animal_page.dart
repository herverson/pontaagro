import 'package:flutter/material.dart';
import 'package:pontaagro/routes/routes.dart';
import 'package:provider/provider.dart';

import '../entities/animal.dart';
import '../entities/farm.dart';
import '../repositories/animal_repository.dart';
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
    context.read<AnimalRepository>().farm = widget.farm;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getFilterAnimals(widget.farm);
      loading.value = false;
    });
  }

  getFilterAnimals(Farm farm) async {
    await context.read<AnimalRepository>().getAll();
  }

  openEditSheet(Animal animal) async {
    await showDialog(
      context: context,
      builder: (_) => EditAnimalPage(
        animal: animal,
      ),
    );
  }

  refresh(Farm farm) async {
    await getFilterAnimals(farm);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.farm.name),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Routes.to.pushNamed('/animals/add'),
        icon: const Icon(Icons.add),
        label: const Text('Adicionar Animais'),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 8,
            child: Consumer<AnimalRepository>(
              builder: (context, repository, child) {
                final animals = repository.animals;

                if (repository.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (animals.isEmpty) {
                  return const Center(
                    child: Text('A lista de animais está vazia :('),
                  );
                }
                return ListView.separated(
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
          ),
        ],
      ),
    );
  }
}
