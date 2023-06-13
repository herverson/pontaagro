import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../entities/animal.dart';
import '../stores/animal_store.dart';

class EditAnimalPage extends StatefulWidget {
  const EditAnimalPage({
    Key? key,
    required this.animal,
  }) : super(key: key);

  @override
  State<EditAnimalPage> createState() => _EditAnimalPageState();
  final Animal animal;
}

class _EditAnimalPageState extends State<EditAnimalPage> {
  final TextEditingController _tag = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _tag.text = widget.animal.tag;
  }

  saveAnimal() async {
    if (formKey.currentState!.validate()) {
      context.read<AnimalStore>().update(widget.animal);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Animal'),
      actions: [
        ElevatedButton(
          onPressed: saveAnimal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.check),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Editar Animal',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ],
      content: Form(
        key: formKey,
        child: TextFormField(
          key: const Key('text-tag'),
          autofocus: true,
          controller: _tag,
          style: const TextStyle(fontSize: 18),
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32)),
            ),
            labelText: 'Tag',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Informe a Tag do animal';
            }
            return null;
          },
          onChanged: (value) => widget.animal.tag = value,
        ),
      ),
    );
  }
}
