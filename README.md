# Bankrs iOS Example App

This is a simple application that illustrates how to the bankrs API from iOS. The app implements a typical multi-banking use case that uses bankrs OS as the only backend.

It is written in Swift 4 as requires Xcode 9 or higher.

## How to get started

```
brew install cocoapods
pod install
open bankrs-ios-example.xcworkspace
```

## Architecture

The `Model` group contains the model classes that handle JSON (de-)serialization.

`BankrsApi` uses Alamofire to communicate with bankrs OS and provides an asynchronous, strongly-typed interface to the backend. The URL routing is done in `BankrsRouter`.

Several controllers such as `BankAccessTableViewController` show how to use `BankrsApi` and the model classes to present views to the user.

This example does not include any kind of persistence layer such as Core Data. If you need to persist data, you could take the example model as a starting point.

## Use cases

The following use cases are implemented:

- User login/logout
- Displaying and managing bank accesses
- Displaying bank accounts
- Getting transactions
- Searching for financial institutions (providers)

Not shown:

- Making payments
