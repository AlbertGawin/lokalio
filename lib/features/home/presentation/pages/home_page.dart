import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/home/presentation/bloc/notice_list_bloc.dart';
import 'package:lokalio/injection_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokalio'),
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<NoticeListBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = sl<NoticeListBloc>();

        bloc.add(GetAllNoticesEvent());

        return bloc;
      },
      child: BlocBuilder<NoticeListBloc, NoticeListState>(
        builder: (context, state) {
          if (state is Empty) {
            return const Center(child: Text('Press the button below to load'));
          } else if (state is Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Done) {
            return ListView.builder(
              itemCount: state.noticeList.length,
              itemBuilder: (context, index) {
                final notice = state.noticeList[index];
                return ListTile(
                  title: Text(notice.title),
                  subtitle: const Text('opis'),
                );
              },
            );
          } else if (state is Error) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}
