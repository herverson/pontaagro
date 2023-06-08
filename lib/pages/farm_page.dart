import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../entities/farm.dart';
import '../repositories/farm_repository.dart';
import 'add_farm_page.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();

class FarmPage extends StatefulWidget {
  const FarmPage({Key? key}) : super(key: key);

  @override
  State<FarmPage> createState() => _FarmPageState();
}

class _FarmPageState extends State<FarmPage> {
  final loading = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getFilterFarms();
      loading.value = false;
    });
  }

  getFilterFarms() async {
    await context.read<FarmRepository>().getAll();
  }

  openAddSheet(Farm farm) async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => AddFarmPage(
        farm: farm,
      ),
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.40,
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
      body: RefreshIndicator(
        onRefresh: () => refresh(),
        child: Column(
          children: [
            Flexible(
              flex: 8,
              child: ValueListenableBuilder<bool>(
                valueListenable: loading,
                builder: (context, load, _) => Consumer<FarmRepository>(
                  builder: (context, repository, child) {
                    final farms = repository.farms;

                    if (load) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (farms.isEmpty) {
                      return const Center(
                        child: Text('A lista de fazendas está vazia :('),
                      );
                    }
                    return ListView.separated(
                      itemBuilder: (context, index) => ListTile(
                        leading: Text(farms[index].id.toString()),
                        title: Text(farms[index].name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => openAddSheet(farms[index]),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
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
            ),
          ],
        ),
      ),
    );
  }
}
