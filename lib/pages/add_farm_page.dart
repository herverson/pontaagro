import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../entities/farm.dart';
import '../stores/farm_store.dart';

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
  @override
  void initState() {
    super.initState();
    _name.text = widget.farm.name;
  }

  saveFarm() async {
    if (formKey.currentState!.validate()) {
      if (widget.farm.id == 0) {
        context.read<FarmStore>().save(widget.farm.name);
      } else {
        context.read<FarmStore>().update(widget.farm);
      }
      Navigator.of(context).pop();
    }
  }

  final TextEditingController _name = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isNew = widget.farm.id == 0;

    return AlertDialog(
      title: Text(isNew ? 'Criar Fazenda' : 'Editar Fazenda'),
      actions: [
        ElevatedButton(
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
      ],
      content: Form(
        key: formKey,
        child: TextFormField(
          autofocus: true,
          controller: _name,
          style: const TextStyle(fontSize: 18),
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32)),
            ),
            labelText: 'Nome',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Informe o nome da fazenda';
            }
            return null;
          },
          onChanged: (value) => widget.farm.name = value,
        ),
      ),
    );
  }
}
