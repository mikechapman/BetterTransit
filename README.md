# BetterTransit

An iOS framework for building real-time transit apps.

## Design

In an ideal world, a timetable in the paper form is all that a commuter needs to catch a bus. No time is wasted waiting at the stop, no need to wonder when the bus will come, and the bus comes on time every time.

Unfortuanately we are not living in such a world. For lots of commuters in cities big or small, who rely on public transit to commute to work or go grocery shopping, waiting endlessly at a bus stop has become a part of life. When will the bus come? You never know.

That's why this iOS framework, BetterTransit, is designed solely around providing real-time transit information. Timetables are not included, since they are mostly useless anyway.

The real-time predictions are only useful if they meet the following two requirements:

1. The real-time arrival prediction needs to be accurate to within a minute.
2. Presenting the arrival prediction should require as little work from the commuter as possible.

Usually the first requirement is in the hands of transit agencies, not indie developers. But even when a good real-time feed is available, the presentation is not always helpful to the commuters. That's where we developers can help.

## What's included

This repository is not a complete application, but a generic implementation of core functionalties in an iOS transit app. This includes models (routes, stops, trips), views and controllers (prediction view, trip view, route view, nearby stops, map view). This framework has been integrated into several transit apps which have been actively maintained for more than three years, so its generality has been proven.

The generality of this framework can be partly attributed to conforming to the [GTFS](https://developers.google.com/transit/gtfs/reference) specification. The data models largely follow the fields defined in the GTFS spec, which makes this framework easily interoperable with many transit systems.

## How to use

To see how this framework is integrated into a real app, you can check out the [HoosBus](https://github.com/HappenApps/HoosBus) app.

Please note that the framework is using ARC, modern Objective-C syntax, and the views are updated for iOS 6 and iPhone 5's tall screen. In a nutshell, the code is using the latest iOS coding practices as of June 2013.

## App Features
* Nearby bus stops
* Search for a bus stop by stop name or stop code
* A map view showing nearby stops
* Real-time prediction of all routes running through a bus stop
* A routes view
* Each route has a trip view, which can be inbound or outbound.

## Database

The framework relies on a local sqlite database which stores all the static transit data. The upside of this approach is obviously that all static data are local thus data retrieval is fast. This is especially important on a mobile device. The downside, of course, is that any transit data change would require an app update.

## License
Released under the MIT license.
