import 'package:flutter/material.dart';
import 'package:pontaagro/pages/animal_form_widget.dart';
import 'package:provider/provider.dart';

import '../entities/animal.dart';
import '../repositories/animal_repository.dart';

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
  saveAnimal() async {
    context.read<AnimalRepository>().update(widget.animal);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          title: const Text('Editar Animal'),
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
              AnimalFormWidget(animal: widget.animal),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: ElevatedButton(
                  onPressed: saveAnimal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Salvar Animal',
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
