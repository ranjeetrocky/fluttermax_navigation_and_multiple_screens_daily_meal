import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:fluttermax_navigation_and_multiple_screens/dummy_data.dart';

class MealDetailScreen extends StatefulWidget {
  static const String routeName = '/meal_detail_screen';
  final Function selectFavouriteFunction, isFavourite;

  const MealDetailScreen(
      {Key? key,
      required this.selectFavouriteFunction,
      required this.isFavourite})
      : super(key: key);

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final mealId = ModalRoute.of(context)?.settings.arguments;
    final selectedMeal = kDummyMeals.firstWhere((meal) => meal.id == mealId);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedMeal.title),
        actions: [
          Tooltip(
            message: widget.isFavourite(mealId) ? "Remove Meal" : "Add meal",
            child: IconButton(
              icon: Icon(widget.isFavourite(mealId)
                  ? FontAwesomeIcons.solidHeart
                  : FontAwesomeIcons.heart),
              onPressed: () {
                setState(() {
                  widget.selectFavouriteFunction(mealId);
                  Navigator.of(context).pop(mealId);
                });
              },
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: 300,
            width: double.infinity,
            child: Hero(
              tag: selectedMeal.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  selectedMeal.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          _sectionTitle(context, 'Ingredients'),
          _sectionContainer(
              context: context,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Text(selectedMeal.ingredients[index])),
                  );
                },
                itemCount: selectedMeal.ingredients.length,
              )),
          _sectionTitle(context, "Steps"),
          _sectionContainer(
            context: context,
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text('# ${index + 1}'),
                  ),
                  title: Text(selectedMeal.steps[index]),
                );
              },
              itemCount: selectedMeal.steps.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.delete_outline_rounded),
        onPressed: () {
          Navigator.of(context).pop(mealId);
        },
      ),
    );
  }

  Expanded _sectionContainer({required child, required BuildContext context}) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.white,
          color: Theme.of(context).backgroundColor,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        child: child,
      ),
    );
  }

  Container _sectionTitle(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline4,
      ),
    );
  }
}
