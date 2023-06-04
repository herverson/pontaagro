import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repositories/animal_repository.dart';

class AddAnimalPage extends StatefulWidget {
  const AddAnimalPage({Key? key}) : super(key: key);

  @override
  State<AddAnimalPage> createState() => _AddAnimalPageState();
}

class _AddAnimalPageState extends State<AddAnimalPage> {
  final _form = GlobalKey<FormState>();
  final _tag = TextEditingController();

  salvar() async {
    if (_form.currentState!.validate()) {
      context.read<AnimalRepository>().save(_tag.text);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black87,
          title: const Text('Novo Animal'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Form(
                key: _form,
                child: TextFormField(
                  maxLength: 15,
                  controller: _tag,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                    ),
                    labelText: 'Título',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe o título do animal';
                    }
                    return null;
                  },
                  onChanged: (value) {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: ElevatedButton(
                  onPressed: salvar,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check),
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
            ],
          ),
        ),
      ),
    );
  }
}
