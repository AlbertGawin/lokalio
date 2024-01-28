import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:lokalio/features/profile/presentation/widgets/my_profile_widget.dart';
import 'package:lokalio/injection_container.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: _buildBody(context),
    );
  }

  BlocProvider<ProfileBloc> _buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = sl<ProfileBloc>();
        bloc.add(const ReadMyProfileEvent());
        return bloc;
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileInitial) {
            return const Center(child: Text('MyProfilePage'));
          } else if (state is Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Done) {
            return const MyProfileWidget();
          } else if (state is Error) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}
