import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repositories/animal_repository.dart';
import 'add_animal_page.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();

class AnimalPage extends StatefulWidget {
  const AnimalPage({Key? key}) : super(key: key);

  @override
  State<AnimalPage> createState() => _AnimalPageState();
}

class _AnimalPageState extends State<AnimalPage> {
  final loading = ValueNotifier(true);
  final showAnimalsNotDone = ValueNotifier(false);
  final showFilter = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getFilterAnimals();
      loading.value = false;
    });
    showAnimalsNotDone.addListener(getFilterAnimals);
  }

  @override
  void dispose() {
    showAnimalsNotDone.removeListener(getFilterAnimals);
    super.dispose();
  }

  getFilterAnimals() async {
    await context.read<AnimalRepository>().getAll();
  }

  openAddSheet() async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => const AddAnimalPage(),
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.35,
      ),
    );
  }

  refresh() async {
    await getFilterAnimals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text('Animal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: openAddSheet,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => refresh(),
        child: Column(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: showFilter,
              builder: (context, show, _) => !show
                  ? const SizedBox.shrink()
                  : Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Card(
                          color: Colors.grey[200],
                          child: ListTile(
                            title: const Text('Mostrar Apenas não Finalizados'),
                            trailing: ValueListenableBuilder(
                              valueListenable: showAnimalsNotDone,
                              builder: (context, _, __) => Switch(
                                value: showAnimalsNotDone.value,
                                onChanged: (val) =>
                                    showAnimalsNotDone.value = val,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
            Flexible(
              flex: 8,
              child: ValueListenableBuilder<bool>(
                valueListenable: loading,
                builder: (context, load, _) => Consumer<AnimalRepository>(
                  builder: (context, repository, child) {
                    final animals = repository.animals;

                    if (load) {
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
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => repository.remove(animals[index]),
                        ),
                      ),
                      separatorBuilder: (_, __) => const Divider(),
                      itemCount: repository.animals.length,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
