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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _selectedCategoryIndex != null;
    final selectedCategory =
        isSelected ? NoticeCategory.values[_selectedCategoryIndex!] : null;

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
                  color: isSelected
                      ? selectedCategory!.color.withOpacity(0.2)
                      : colorScheme.onPrimary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isSelected
                        ? selectedCategory!.color
                        : colorScheme.primary,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: isSelected
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (isSelected)
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          color: selectedCategory!.color.withOpacity(0.5),
                        ),
                        child: Icon(
                          selectedCategory.icon,
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (!isSelected)
                          Icon(
                            Icons.library_add_outlined,
                            color: colorScheme.primary,
                          ),
                        const SizedBox(width: 10),
                        Text(
                          isSelected
                              ? selectedCategory!.name.toUpperCase()
                              : 'WYBIERZ KATEGORIĘ',
                          style: TextStyle(
                            color:
                                isSelected ? Colors.black : colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    if (isSelected) ...[
                      const Spacer(),
                      Text(
                        'ZMIEŃ',
                        style: TextStyle(
                          color: selectedCategory!.color,
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

  Future<void> _chooseCategory(FormFieldState state) async {
    var pickedCategoryIndex = await Navigator.of(context).push(
      createRoute(const ChooseCategoryPage()),
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
}
