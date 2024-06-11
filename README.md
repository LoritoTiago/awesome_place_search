# Awesome Place Search

# Description

`awesome_place_search` is a Flutter package for integrating place search functionality in your application using a custom API.

## Features

- Customizable UI for the place search dialog.
- Support for loading and error states.
- Customizable styles and decorations for the search input field and result items.
- Optional country filtering for place search results.
- Customizable search hint and error messages.
- Various customization options for look and feel.

## Installation

### Add pubspec.yaml

```yaml
dependencies:
  awesome_place_search: ^2.0.0
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
            apiKey: "Your Google Map Key",
            countries: ["ao", "pt"],
            dividerItemColor: Colors.grey.withOpacity(.5),
            dividerItemWidth: .5,
            elevation: 5,
            hint: "Search data",
            indicatorColor: Colors.blue,
            modalBorderRadius: 50.0,
            onTap: (value) async {
               result = await value;

              setState(() {
                prediction = result;
              });
            },
          ).show();
  }
}
```

- ``

# Parameters:

# Required Parameters

- `apiKey: Your API key for the place search service.`
- `context: The build context for the widget, used to show the search modal.`
- `onTap: Callback function triggered when a place is selected. Receives a Future that resolves to a PredictionModel.`

# Optional Parameters

- `hint: Hint text to show in the search input field. (Default: "Search places...")`
- `errorText: Text to display when an error occurs during the search. (Default: "An error occurred. Please try again.")`
- `modalBorderRadius: Border radius for the search modal. (Default: 12.0)`
- `loadingWidget: Custom widget to display while loading search results. (Default: CircularProgressIndicator())`
- `searchTextFieldDecoration: Decoration for the search input field. (Default: InputDecoration() with default settings)`
- `dividerItemColor: Color for the divider between search results. (Default: Colors.grey)`
- `dividerItemWidth: Width for the divider between search results. (Default: 1.0)`
- `placeIconWidget: Custom widget for the place icon in the search results. (Default: Icon(Icons.place))`
- `onErrorWidget: Custom widget to display when an error occurs. (Default: Text(errorText))`
- `elevation: Elevation for the search modal. (Default: 4.0)`
- `countries: List of country codes to restrict the search results. (Default: [] - No restriction)`
- `indicatorColor: Color for the loading indicator. (Default: Theme's primary color)`
- `subtitleStyle: Text style for the subtitle in the search results. (Default: TextStyle() with default settings)`
- `invalidKeyWidget: Custom widget to display when the API key is invalid. (Default: Text("Invalid API key"))`
- `titleStyle: Text style for the title in the search results. (Default: TextStyle() with default settings)`

---

### Demo

<img src="https://github.com/LoritoTiago/awesome_place_search/assets/58330997/ae9d8e84-a059-4894-b1bf-ac81ab957c51" width="230" height="440" alt="Awesome Place Search Demo" />
