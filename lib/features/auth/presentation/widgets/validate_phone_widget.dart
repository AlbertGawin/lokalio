import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lokalio/injection_container.dart';

class ValidatePhoneWidget extends StatelessWidget {
  final String name;
  final String phone;

  const ValidatePhoneWidget({
    super.key,
    required this.name,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController codeController = TextEditingController();

    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is Error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Text(
                      'Wysłano kod weryfikacyjny na numer $phone',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: codeController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      autocorrect: false,
                      autofillHints: const [AutofillHints.oneTimeCode],
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      decoration:
                          const InputDecoration(labelText: 'Kod weryfikacyjny'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the verification code';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return TextButton(
                          onPressed: state is Loading
                              ? null
                              : () async {
                                  if (formKey.currentState!.validate()) {
                                    context
                                        .read<AuthBloc>()
                                        .add(SetProfileInfoEvent(
                                          name: name,
                                          phone: phone,
                                          smsCode: codeController.text,
                                        ));
                                  }
                                },
                          child: state is Loading
                              ? const CircularProgressIndicator()
                              : const Text('Dalej'),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Wyślij kod ponownie'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
