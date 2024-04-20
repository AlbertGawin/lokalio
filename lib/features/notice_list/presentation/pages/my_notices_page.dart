import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/core/util/create_route.dart';
import 'package:lokalio/features/auth/domain/repositories/auth_repository.dart';
import 'package:lokalio/features/create_notice/presentation/pages/create_notice_page.dart';
import 'package:lokalio/features/notice_list/domain/repositories/notice_list_repository.dart';
import 'package:lokalio/features/notice_list/presentation/bloc/notice_list_bloc.dart';
import 'package:lokalio/features/notice_list/presentation/widgets/notice_list_widget.dart';
import 'package:lokalio/injection_container.dart';

class MyNoticesPage extends StatelessWidget {
  const MyNoticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NoticeListBloc(repository: sl<NoticeListRepository>())
        ..add(GetUserNoticesEvent(
            userId: context.read<AuthRepository>().currentProfile.id)),
      child: BlocBuilder<NoticeListBloc, NoticeListState>(
        builder: (context, state) {
          switch (state.status) {
            case NoticeListStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case NoticeListStatus.failure:
              return const Center(child: Text('Failed to fetch notices'));
            case NoticeListStatus.success:
              return _buildSuccessScaffold(context);
          }
        },
      ),
    );
  }

  Scaffold _buildSuccessScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Moje ogłoszenia')),
      floatingActionButton: _buildFloatingActionButton(context),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: NoticeListWidget(),
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(createRoute(const CreateNoticePage()));
      },
      child: const Icon(Icons.add),
    );
  }
}
