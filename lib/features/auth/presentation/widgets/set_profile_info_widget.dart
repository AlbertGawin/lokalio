import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lokalio/core/util/create_route.dart';
import 'package:lokalio/features/auth/presentation/widgets/validate_phone_widget.dart';

class SetProfileInfoWidget extends StatelessWidget {
  const SetProfileInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController nameController =
        TextEditingController(text: user.displayName);
    final TextEditingController phoneController =
        TextEditingController(text: user.phoneNumber);

    final FocusNode nameFocusNode = FocusNode();
    final FocusNode phoneFocusNode = FocusNode();

    return GestureDetector(
      onTap: () {
        nameFocusNode.unfocus();
        phoneFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: Center(
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
                    focusNode: nameFocusNode,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.words,
                    autocorrect: false,
                    autofillHints: const [AutofillHints.name],
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    decoration:
                        const InputDecoration(labelText: 'Imię i nazwisko'),
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
                    focusNode: phoneFocusNode,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    autocorrect: false,
                    autofillHints: const [AutofillHints.telephoneNumber],
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    decoration:
                        const InputDecoration(labelText: 'Numer telefonu'),
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
        ),
      ),
    );
  }
}
