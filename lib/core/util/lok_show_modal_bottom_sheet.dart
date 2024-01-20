import 'package:flutter/material.dart';

void lokShowModalBottomSheet({
  required BuildContext context,
  required List<String> titleList,
  required List<IconData> leadingList,
  required List<Function()> onTapList,
}) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: titleList.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  onTapList[index]();
                },
                title: Text(titleList[index]),
                leading: Icon(leadingList[index]),
              );
            },
          ),
          ListTile(
            onTap: () => Navigator.of(context).pop(),
            title: const Text(
              'ANULUJ',
              textAlign: TextAlign.center,
            ),
            textColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      );
    },
  );
}
