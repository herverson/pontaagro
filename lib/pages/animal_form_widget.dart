import 'package:flutter/material.dart';

import '../entities/animal.dart';

class AnimalFormWidget extends StatefulWidget {
  const AnimalFormWidget({
    key,
    required this.animal,
  }) : super(key: key);
  final Animal animal;
  @override
  State<AnimalFormWidget> createState() => _AnimalFormWidgetState();
}

class _AnimalFormWidgetState extends State<AnimalFormWidget> {
  final TextEditingController _tag = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tag.text = widget.animal.tag;
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
        key: const Key('text-name'),
        maxLength: 15,
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
            return 'Informe a tag do animal';
          }
          return null;
        },
        onChanged: (value) => widget.animal.tag = value,
      ),
    );
  }
}
