import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<String> categories = [
    "Leonisa",
    "Adidas",
    "Nike",
    "Esika",
    "Victoria Secret",
    "Vogue",
    "Skala",
    "Nivea"
  ];
  int selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            categories.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                  bottom: 20 / 4,
                  top: 20 / 4,
                  right: 20,
                  left: index == 0 ? 20 : 0),
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.all(
                        20,
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                        selectedIndex == index
                            ? Color(0xFF8063D4)
                            : Color(0xFFB4AEE8))),
                child: Text(
                  categories[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: selectedIndex == index
                        ? Colors.white
                        : Colors.black.withOpacity(0.5),
                  ),
                ),
                onPressed: () {
                  if (selectedIndex == index) {
                    print('Igual');
                    selectedIndex = -1;
                  } else {
                    setState(() {
                      selectedIndex = index;
                    });
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
