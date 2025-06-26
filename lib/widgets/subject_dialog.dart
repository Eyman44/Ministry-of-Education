import 'package:flutter/material.dart';
import 'package:flutter_application_eyman/models/education_model.dart';

class SubjectDialog extends StatefulWidget {
  final Subject? subject;
  const SubjectDialog({super.key, this.subject});

  @override
  State<SubjectDialog> createState() => _SubjectDialogState();
}

class _SubjectDialogState extends State<SubjectDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _markController;
  late TextEditingController _markMinController;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subject?.name ?? "");
    _markController =
        TextEditingController(text: widget.subject?.maxMark.toString() ?? "");
    _markMinController =
        TextEditingController(text: widget.subject?.maxMark.toString() ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.subject == null ? "Add Subject" : "Edit Subject"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Subject Name",
              ),
              validator: (val) =>
                  val == null || val.isEmpty ? "Required" : null,
            ),
            TextFormField(
              controller: _markController,
              decoration: const InputDecoration(labelText: "Max Mark"),
              keyboardType: TextInputType.number,
              validator: (val) {
                if (val == null || val.isEmpty) return "Required";
                if (int.tryParse(val) == null) return "Enter a valid number";
                return null;
              },
            ),
            TextFormField(
              controller: _markMinController,
              decoration: const InputDecoration(labelText: "Min Mark"),
              keyboardType: TextInputType.number,
              validator: (val) {
                if (val == null || val.isEmpty) return "Required";
                if (int.tryParse(val) == null) return "Enter a valid number";
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newSubject = Subject(
                id: widget.subject?.id ?? 0,
                minMark: int.parse(_markMinController.text),
                name: _nameController.text,
                maxMark: int.parse(_markController.text),
              );
              Navigator.pop(context, newSubject);
            }
          },
          child: const Text("Save"),
        )
      ],
    );
  }
}
