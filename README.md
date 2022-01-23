# LiveEventsApp
MVP-Clean sample iOS Swift project

The purpose of this document is to explain the architecture of application.

This application shows live events.
It also has features to show events as per searched text by user. It shows details of event on tap of event row.
This app also supports pagination for events list.

Below are running app screenshots:



## Table of Contents
1. Architecture
2. Implementation
3. Testing
4. Project Setup
5. Pending Improvements (// TODOs)

## 1. Architecture
The project is divided into different folder which act as logical units. Each unit has its own responsibility and behaviour. All components communication is done using abstraction with protocols. 
This app divided into below folder structure:

<img width="268" alt="Screenshot 2022-01-23 at 1 35 54 PM" src="https://user-images.githubusercontent.com/4067755/150669918-88ff8a39-738d-4ffc-8f48-1421eb62aa84.png">


This diagram will illustrate high level implementation of architecture(3 + 1 architecture)
<img width="404" alt="architecture" src="https://user-images.githubusercontent.com/4067755/147442126-a0e16c53-571e-42ce-b441-fba50cfaf7b7.png">

### Presentation:
Responsible to handle all user events on view.
It consists of below things:

***Presenter***:
It is responsible to update the result of business logic to viewController. this update is handled using viewState binding.

***ViewController***: It links the user controls to update them when needed. View will inform presenter about user action.

### Domain:

Handler of all business logic and models.
It consist below things:

***Models***: Models are Entities domain model representation.

***UseCases***: It is responsible to handle use case and business logic. Protocols and their implementations to represent business logics

***ProviderProtocols***: These are Protocol which can be confirmed in data layer.

### Data:
Responsible to retrieve all the data required by the application.
It consist below things:

***Entities***: It defines structs for responses representation.

***Services***: Service layer is for getting the data through data source, in this case it is network.

***Providers***: It handle sthe services and retrieve the data from services and updates domain model about the data.

### App:
Responsible to manage app level responibilities.
It consist below things:

***Routers***: It defines and implements all the navigation logic.

***Builder***: Builders is used for injecting dependencies across modules.


## 2. Implementation
To develop this, MVP-CLEAN architecture is used.


## 3. Testing
* Under PresentationTests, there are unit test cases for Presenters.
* Under DomainTests, there are unit test cases for Models and UseCases.
* Under DataTests, there are unit test cases for Repositories. (Pending to be add tests for data layer)


## 4. Project Setup
To run this project on a local machine follow below steps:

* Open LiveEvents.xcodeproj file in Xcode 13.x version, 
* Wait till swift package manager loads all the required dependancies and run it on the simulator.

## 5. Pending Improvements (// TODOs)
* Add favourite events implementation.
* Add unit test cases for data layer.
* Improve overall test code coverage.
* Create dynamic frameworks for each layer.
* Create Xcode templates to repeat this code structure easily.
