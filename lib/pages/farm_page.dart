import 'package:flutter/material.dart';
import 'package:pontaagro/pages/animal_page.dart';
import 'package:provider/provider.dart';

import '../entities/farm.dart';
import '../stores/farm_store.dart';
import 'add_farm_page.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();

class FarmPage extends StatefulWidget {
  const FarmPage({Key? key}) : super(key: key);

  @override
  State<FarmPage> createState() => _FarmPageState();
}

class _FarmPageState extends State<FarmPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getFilterFarms();
    });
  }

  getFilterFarms() async {
    await context.read<FarmStore>().getAll();
  }

  openAddSheet(Farm farm) async {
    await showDialog(
      context: context,
      builder: (_) => AddFarmPage(
        farm: farm,
      ),
    );
  }

  refresh() async {
    await getFilterFarms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text('Pontaagro'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openAddSheet(Farm(name: '')),
        icon: const Icon(Icons.add),
        label: const Text('Adicionar Fazenda'),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 8,
            child: Consumer<FarmStore>(
              builder: (context, repository, child) {
                final farms = repository.farms;

                if (repository.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      key: Key('progress-indicator'),
                    ),
                  );
                }

                if (farms.isEmpty) {
                  return const Center(
                    child: Text('A lista de fazendas está vazia :('),
                  );
                }
                return ListView.separated(
                  itemBuilder: (context, index) => ListTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AnimalPage(farm: farms[index]),
                      ),
                    ),
                    leading: Text('${repository.farms[index].animals.length}'),
                    title: Text(farms[index].name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () => openAddSheet(farms[index]),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () => repository.remove(farms[index]),
                        ),
                      ],
                    ),
                  ),
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: repository.farms.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
