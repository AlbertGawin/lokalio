import 'package:flutter/material.dart';

class CreateNoticeWidget extends StatelessWidget {
  const CreateNoticeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autocorrect: false,
                maxLines: 1,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Title'),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autocorrect: false,
                maxLines: 5,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Description'),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
