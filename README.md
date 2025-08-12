# SwiftyLogger

A simple, thread-safe logging utility for Swift, built on top of Apple's `os.Logger` framework. **SwiftyLogger** leverages Swift's concurrency with actors to provide both synchronous and asynchronous logging methods, ensuring your log calls are always safe, no matter where they are called from.

## Features

  - **Thread-Safe by Design:** Uses a Swift `actor` to guarantee that logging operations are performed in an isolated, serial queue, preventing data races and ensuring consistency.
  - **Asynchronous & Synchronous APIs:** Offers an `async` method for use within other `async` functions and a `nonisolated` synchronous method for legacy or non-isolated code.
  - **Source Context:** Automatically captures and logs the file, function, and line number of the log call, making it easy to pinpoint the source of a message.
  - **Customizable:** You can initialize `SwiftyLogger` with your own `LoggerProtocol` implementation, allowing you to use a custom logging backend for testing or different environments.
  - **Singleton Instance:** A shared singleton instance is provided for convenient, global access throughout your app.

-----

## Installation

Add this package to your project using Xcode's Swift Package Manager.

```
dependencies: [
    .package(url: "https://github.com/your-repo/SwiftyLogger.git", from: "1.0.0")
]
```

-----

## Usage

### Getting Started

SwiftyLogger is designed to be as simple as possible. You can use the shared singleton instance for most logging needs.

```swift
import SwiftyLogger

// Log a simple debug message using the shared instance
SwiftyLogger.shared.log("This is a debug message.")
```

-----

### Asynchronous Logging (`logAsync`)

Use the `logAsync` method when calling from an `async` context. This is the preferred method as it directly communicates with the actor.

```swift
// usage
class MyAsyncClass {
    // This is an async method
    func testAsync() async {
        // Use `await` to log the message
        await SwiftyLogger.shared.logAsync("This is an asynchronous log message.", level: .debug)
    }
}
```

-----

### Synchronous Logging (`log`)

Use the `log` method when you need to log from a non-isolated, synchronous context. This method internally creates a `Task` to safely hand the message off to the actor without blocking the caller's thread.

```swift
// usage
class MySyncClass {
    // This is a synchronous method
    func testNonIsolated() {
        // Use the synchronous log method, which doesn't require `await`
        SwiftyLogger.shared.log("This is a synchronous log message.", level: .debug)
    }
}
```

-----

### Custom Initialization

For testing or dependency injection, you can initialize a `SwiftyLogger` with a custom logger that conforms to `LoggerProtocol`.

```swift
// usage
class A {
    func testSwifty() {
        let logger = SwiftyLogger()
        logger.log("This message goes to the default logger.", level: .debug)
    }
    
    func testDI() {
        // Create a custom Logger from the OS framework
        let osLogger = Logger(subsystem: "com.example.MyApp", category: "myCustomCategory")
        
        // Initialize SwiftyLogger with the custom instance
        let swiftyLogger = SwiftyLogger(osLogger)
        
        swiftyLogger.log("This message goes to the custom OS logger.", level: .debug)
    }
}
```

-----

### Logging Levels

You can specify a logging level using `OSLogType` to control the severity of your messages.

```swift
import SwiftyLogger
import os.log

// Log with different severity levels
SwiftyLogger.shared.log("An informational message.", level: .info)
SwiftyLogger.shared.log("Something went wrong.", level: .error)
SwiftyLogger.shared.log("A critical system failure.", level: .fault)
```
