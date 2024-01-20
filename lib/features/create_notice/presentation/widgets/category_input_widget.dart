import 'package:flutter/material.dart';
import 'package:lokalio/core/util/create_route.dart';
import 'package:lokalio/features/create_notice/domain/entities/notice_category.dart';
import 'package:lokalio/features/create_notice/presentation/pages/choose_category_page.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/card_widget.dart';

class CategoryInputWidget extends StatefulWidget {
  const CategoryInputWidget({super.key, required this.getCategory});

  final void Function(int categoryIndex) getCategory;

  @override
  State<CategoryInputWidget> createState() => _CategoryInputWidgetState();
}

class _CategoryInputWidgetState extends State<CategoryInputWidget> {
  int? _selectedCategoryIndex;

  void _chooseCategory(FormFieldState state) async {
    var pickedCategoryIndex = await Navigator.of(context).push(
      createRoute(
        const ChooseCategoryPage(),
      ),
    );
    if (pickedCategoryIndex == null) {
      return;
    }

    setState(() {
      _selectedCategoryIndex = pickedCategoryIndex;
    });
    state.didChange(pickedCategoryIndex);

    widget.getCategory(_selectedCategoryIndex!);
  }

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      title: 'Kategoria*',
      content: [
        FormField(
          validator: (value) {
            if (value == null) {
              return 'Please choose a category';
            }
            return null;
          },
          builder: (FormFieldState state) {
            return InkWell(
              onTap: () => _chooseCategory(state),
              borderRadius: BorderRadius.circular(4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                height: 68,
                decoration: BoxDecoration(
                  color: _selectedCategoryIndex == null
                      ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)
                      : NoticeCategory.values[_selectedCategoryIndex!].color
                          .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: _selectedCategoryIndex == null
                        ? Theme.of(context).colorScheme.primary
                        : NoticeCategory.values[_selectedCategoryIndex!].color,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: _selectedCategoryIndex == null
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_selectedCategoryIndex != null)
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          color: NoticeCategory
                              .values[_selectedCategoryIndex!].color
                              .withOpacity(0.5),
                        ),
                        child: Icon(
                          NoticeCategory.values[_selectedCategoryIndex!].icon,
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (_selectedCategoryIndex == null)
                          Icon(
                            Icons.library_add_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        const SizedBox(width: 10),
                        Text(
                          _selectedCategoryIndex == null
                              ? 'WYBIERZ KATEGORIĘ'
                              : NoticeCategory
                                  .values[_selectedCategoryIndex!].name
                                  .toUpperCase(),
                          style: TextStyle(
                            color: _selectedCategoryIndex == null
                                ? Theme.of(context).colorScheme.primary
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    if (_selectedCategoryIndex != null) ...[
                      const Spacer(),
                      Text(
                        'ZMIEŃ',
                        style: TextStyle(
                          color: NoticeCategory
                              .values[_selectedCategoryIndex!].color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
