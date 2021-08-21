# swift-zip

[![Test](https://github.com/sinoru/swift-zip/actions/workflows/test.yml/badge.svg)](https://github.com/sinoru/swift-zip/actions/workflows/test.yml)

This library will make you access zip files.

## Getting started

Below you'll find all you need to know to get started.

#### Adding the dependency

`swift-zip` is designed for Swift 5.3 and later. To depend on the zip package, you need to declare your dependency in your `Package.swift`:

```swift
.package(url: "https://github.com/sinoru/swift-zip.git", from: "0.0.1"),
```

and to your application/library target, add `"ZIP"` to your `dependencies`, e.g. like this:

```swift
.target(name: "BestExampleApp", dependencies: [
    .product(name: "ZIP", package: "swift-zip")
],
```