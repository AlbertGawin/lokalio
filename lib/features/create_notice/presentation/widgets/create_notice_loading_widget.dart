import 'package:flutter/material.dart';

class CreateNoticeLoadingWidget extends StatelessWidget {
  const CreateNoticeLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
