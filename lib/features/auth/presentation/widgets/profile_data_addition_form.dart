import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:lokalio/features/auth/presentation/cubit/profile_data_addition_cubit.dart';
import 'package:lokalio/features/auth/presentation/cubit/profile_data_addition_state.dart';

class ProfileDataAdditionForm extends StatelessWidget {
  const ProfileDataAdditionForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileDataAdditionCubit, ProfileDataAdditionState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          Navigator.of(context).pop();
        } else if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Profile Data Addition Failure',
                ),
              ),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _UsernameInput(),
            const SizedBox(height: 8),
            _PhoneNumberInput(),
            const SizedBox(height: 8),
            _CityInput(),
            const SizedBox(height: 8),
            _SubmitButton(),
          ],
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileDataAdditionCubit, ProfileDataAdditionState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          key: const Key('profileDataAdditionForm_usernameInput_textField'),
          onChanged: (username) => context
              .read<ProfileDataAdditionCubit>()
              .usernameChanged(username),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: 'Nazwa użytkownika',
            helperText: '',
            errorText:
                state.username.displayError != null ? 'invalid username' : null,
          ),
        );
      },
    );
  }
}

class _PhoneNumberInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileDataAdditionCubit, ProfileDataAdditionState>(
      buildWhen: (previous, current) =>
          previous.phoneNumber != current.phoneNumber,
      builder: (context, state) {
        return TextField(
          key: const Key('profileDataAdditionForm_phoneNumberInput_textField'),
          onChanged: (phoneNumber) => context
              .read<ProfileDataAdditionCubit>()
              .phoneNumberChanged(phoneNumber),
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: 'Numer Telefonu',
            helperText: '',
            errorText: state.phoneNumber.displayError != null
                ? 'invalid phoneNumber'
                : null,
          ),
        );
      },
    );
  }
}

class _CityInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileDataAdditionCubit, ProfileDataAdditionState>(
      buildWhen: (previous, current) => previous.city != current.city,
      builder: (context, state) {
        return TextField(
          key: const Key('profileDataAdditionForm_cityInput_textField'),
          onChanged: (city) =>
              context.read<ProfileDataAdditionCubit>().cityChanged(city),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Miasto',
            helperText: '',
            errorText: state.city.displayError != null ? 'invalid city' : null,
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileDataAdditionCubit, ProfileDataAdditionState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('profileDataAdditionForm_submitButton'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.orangeAccent,
                ),
                onPressed: state.isValid
                    ? () =>
                        context.read<ProfileDataAdditionCubit>().formSubmitted()
                    : null,
                child: const Text('DODAJ DANE'),
              );
      },
    );
  }
}
