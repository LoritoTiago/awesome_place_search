# Awesome Place Search

# Description

The awesome_place_search package is a Flutter library that provides a user interface for searching places using the Google Places API. With this package, you can easily implement a location search bar that shows suggestions as the user types.

## Installation

### Add pubspec.yaml

```yaml
dependencies:
  awesome_place_search: ^1.0.10
```

### Basic

```dart
import 'package:flutter/material.dart';

import 'package:awesome_place_search/awesome_place_search.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  PredictionModel? prediction;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          child: Text(prediction.description??"Prediction is null")
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
                _searchPlaces();
            },
            child: const Icon(Icons.add,
        ),
      ),
      ),

    );
  }



  void _searchPlaces(){
     AwesomePlaceSearch(
        context: context,
        key: "Your Google map key", //Insert Your google Api Key
        onTap: (value) async {
           final result = await value;
           setState(() {
                prediction=result;
            });
        },
     ).show();
  }
}
```

# The constructor has 6 attributes:

- `String apiKey is the required attribute. It is the Google Maps API Key your application is using`

- `(Future<PredictionModel>) onTap is a callback function called when the user selects one of the autocomplete options.`
- `BuildContext context is a locator that is used to track each widget in a tree and locate them and their position in the tree.`

- `String hint is the text that suggests what sort of input the field accepts.`
- `Widget onError this widget is for customizing searching widgets.`
- `Widget onEmpty this widget is for customizing error widgets.`

---

### Demo

<img src="https://user-images.githubusercontent.com/58330997/231830074-d9c9c65a-cc42-4bcf-80b6-3828b0374fc5.gif" width="230" height="440" alt="Awesome Place Search Demo" />
