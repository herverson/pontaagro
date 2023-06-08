import 'package:flutter/material.dart';
import 'package:pontaagro/pages/farm_form_widget.dart';
import 'package:provider/provider.dart';

import '../entities/farm.dart';
import '../repositories/farm_repository.dart';

class AddFarmPage extends StatefulWidget {
  const AddFarmPage({
    Key? key,
    required this.farm,
  }) : super(key: key);

  @override
  State<AddFarmPage> createState() => _AddFarmPageState();
  final Farm farm;
}

class _AddFarmPageState extends State<AddFarmPage> {
  saveFarm() async {
    if (widget.farm.id == 0) {
      context.read<FarmRepository>().save(widget.farm.name);
    } else {
      context.read<FarmRepository>().update(widget.farm);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.farm.id == 0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          title: Text(isNew ? 'Criar Fazenda' : 'Editar Fazenda'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              FarmFormWidget(farm: widget.farm),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: ElevatedButton(
                  onPressed: saveFarm,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          isNew ? 'Salvar Fazenda' : 'Editar Fazenda',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
