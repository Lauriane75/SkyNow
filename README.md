# README 📖


This architecture is split in differents layers/concepts : 
● `AppDelegate`
● `Context`
● `CoreDataStack`
● `Coordinators`
● `Network`
● `ViewControllers`
● `ViewModels`
● `Repositories`
● `Unit & UI Tests`

# Intro

This is a Weather application for the city of Paris for now but I willingly created an other screen view to work on the selection of other cities in the future.
The data is saved in CoreData so the application is working off line too.
Please pay attention to the UITest part to launch the UITests correctly and don't forget to update the Accessibility file according to the item you want to test.

The architecture of this project is following the rules of the MVVM-C pattern.
Please check the screen-view-description in the Description folder

# How to build the app in simulator or device

To build this app, please make sure you have a correct internet connection because it uses api request to receive data from the network.
You can clone the repo on your device and open it in your terminal.
Then cmd + b.

# Unit & UI Tests

Please make sure you have an internet connection.

Then, press `cmd+u`


# Architecture

## Context

Context is the main object injected everywhere in the app. It has the responsibility to provide a dependencies injected first in the `AppDelegate`. In this application, the context is injecting 'HTTPClientType' and 'CoreDataStack'.
Every new dependency should be injected through it.

## Coordinator:

The coordinator is a separate entity responsible for navigation in application flows.
With the help of the screen, it creates, presents and dismisses `UIViewControllers`, by keeping them separate and independent.
The coordinator can, create and run child coordinators too using the function start(). 
The entire logic will be encapsulated by delegation for the rest of the navigation.

In this app there is one 'AppCoordinator' and on 'TabBarCoordinator' which coordinates from the mainTabBar then 2 separate coordinators which coordinate each screen:
WeatherCoordinator for the screen view weather
MapCoordinator for the screen view map

## Network:
As indicated by its name, this layer provides different tools to make request in an efficient way.
The  `HTTPClient` is created to parse Json language in codable object.
The  `HTTPEngine` is sending url requests.

When a request is cancelled  (dequeuing a cell, dismissing a view, etc.), each request should be sent with the token. If the caller is deinit, so  `RequestCancelationToken` willDealocate(), and the request is cancelled.

#### Repository:

This layer is responsible for calling the `Network` layer, and managing the data from it, in order to present it to the viewModel.

Each repository has a protocol `RepositoryType` which will permit us to test everything by dependency injection.

#### ViewModel:

The `ViewModel` encapsulates the whole logic which doesn't have to be in the ViewController. It's divided in two parts :

* **Inputs**: Each event from the viewController needs to be implemented in the viewModel, and added in `viewDidLoad()`.
* **Outputs**:  the `viewModel` is providing reactive var for each data/state and user interactions needed. The main rule is to keep separate the UI logic between viewModel and viewController.

#### ViewController:

The  `ViewController` only exists for **control**.

##### Thanks for reading, enjoy the App  ☀️
