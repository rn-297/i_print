import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MaterialController extends GetxController {
  late TabController tabController;
  late TabController nestedTabController;

// Define the outer tabs
  var outerTabs = ['Basics', 'Animal', 'Sketch'].obs;

  // Define the nested tabs
  var nestedTabs = [
    ['Tattoo', 'Animal', "Thank"],
    ['Mammals', 'Insects', "Fish"],
    ['Animal', 'Flower', 'Scenery']
  ].obs;

  var images = [
    [
      "assets/images/tatto 1.jpeg",
      "assets/images/tattoo2.jpeg",
      "assets/images/tattoo3.jpeg",
      "assets/images/tattoo4.png",
    ],
    [
      "assets/images/animal1.png",
      "assets/images/animal2.webp",
      "assets/images/animal3.webp",
    ],
    [
      "assets/images/thank you.png",
      "assets/images/thank1.jpeg",
      "assets/images/thank3.png",
      "assets/images/thank4.jpeg",
    ],

    [
      "assets/images/mammal1.png",
      "assets/images/mammal2.png",
      "assets/images/mammal3.webp",
    ],
    [
      "assets/images/insects1.png",
      "assets/images/insects2.png",
    ],
    [
      "assets/images/fish 1.webp",
      "assets/images/fish3.png",
    ],
    [
      "assets/images/animal sketch 4.png",
      "assets/images/animal sketch 2.webp",
      "assets/images/animal sketch 5.png",
    ],
    [
      "assets/images/flower1.jpeg",
      "assets/images/flower2.png",
    ],
    [
      "assets/images/scenery1.jpeg",
      "assets/images/scenery2.png",
    ]
  ];

  MaterialController() {
    // Add any initialization logic here if needed

  }
}
