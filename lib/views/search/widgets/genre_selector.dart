import 'package:flutter/material.dart';
import 'package:gourmet_search/constants/app_color.dart';
import 'package:gourmet_search/constants/app_data.dart';

class GenreSelector extends StatelessWidget {
  final String selectedGenre;
  final Function(String) onGenreChanged;

  const GenreSelector({
    super.key,
    required this.selectedGenre,
    required this.onGenreChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: AppData.genres.length,
        itemBuilder: (context, index) {
          String genreCode = AppData.genres.keys.elementAt(index);
          String genreName = AppData.genres.values.elementAt(index);
          bool isSelected = selectedGenre == genreCode;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(
                genreName,
                style: TextStyle(
                  color: isSelected
                      ? AppColor.text.white
                      : AppColor.text.darkgray,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColor.ui.primary,
              backgroundColor: Colors.grey[200],
              showCheckmark: false,
              onSelected: (selected) {
                onGenreChanged(genreCode);
              },
            ),
          );
        },
      ),
    );
  }
}
