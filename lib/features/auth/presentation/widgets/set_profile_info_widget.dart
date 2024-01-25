import 'package:flutter/material.dart';
import 'package:lokalio/core/util/create_route.dart';
import 'package:lokalio/features/auth/presentation/widgets/validate_phone_widget.dart';

class SetProfileInfoWidget extends StatelessWidget {
  final String? name;
  final String? phone;

  const SetProfileInfoWidget({
    super.key,
    required this.name,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController nameController =
        TextEditingController(text: name);
    final TextEditingController phoneController =
        TextEditingController(text: phone);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const Text('Uzupełnij dane profilowe'),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textCapitalization: TextCapitalization.words,
                autocorrect: false,
                autofillHints: const [AutofillHints.name],
                maxLines: 1,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Imię i nazwisko'),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autocorrect: false,
                autofillHints: const [AutofillHints.telephoneNumber],
                maxLines: 1,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: 'Numer telefonu'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.of(context).push(createRoute(
                      ValidatePhoneWidget(
                        name: nameController.text,
                        phone: phoneController.text,
                      ),
                    ));
                  }
                },
                child: const Text('Zapisz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
