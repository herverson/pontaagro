import 'package:flutter/material.dart';

import '../entities/farm.dart';

class FarmFormWidget extends StatefulWidget {
  const FarmFormWidget({
    key,
    required this.farm,
  }) : super(key: key);
  final Farm farm;
  @override
  State<FarmFormWidget> createState() => _FarmFormWidgetState();
}

class _FarmFormWidgetState extends State<FarmFormWidget> {
  final TextEditingController _name = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name.text = widget.farm.name;
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
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
    );
  }
}
