
import 'package:shop_listify/models/category.dart';

const categories = {
  Categories.vegetables: Category(
    'Vegetables',
    '🥦',
    [
      SubCategory('potato', '🥔'),
      SubCategory('Carrot', '🥕'),
      SubCategory('Broccoli', '🥦'),
      SubCategory('Tomato', '🍅'),
      SubCategory('Pepper', '🌶️'),
      SubCategory('Corn', '🌽'),
    ],
  ),
  Categories.fruit: Category(
    'Fruit',
    '🧺',
    [
      SubCategory('Apple', '🍎'),
      SubCategory('Banana', '🍌'),
      SubCategory('Grapes', '🍇'),
      SubCategory('Orange', '🍊'),
      SubCategory('Strawberry', '🍓'),
    ],

  ),
  Categories.meat: Category(
    'Meat',
    '🍗',
  ),
  Categories.dairy: Category(
    'Dairy',
    '🥛',
  ),
  Categories.carbs: Category(
    'Carbs',
    '🍞',
  ),
  Categories.sweets: Category(
    'Sweets',
    '🍰',
  ),
  Categories.spices: Category(
    'Spices',
    '🌶️',
  ),
  Categories.convenience: Category(
    'Convenience',
    '🏪',
  ),
  Categories.hygiene: Category(
    'Hygiene',
    '🧴',
  ),
  Categories.other: Category(
    'Other',
    '🔖',
  ),
};