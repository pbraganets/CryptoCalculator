## The Crypto Calculator App

The iOS application allows user to view trade pairs for different crypto currencies and calculate custom amount based on a selected pair.
Application has two screens:
- Trade pairs
- Currency calculator.

**Trade pairs **
Using API https://cex.io/api/last_prices/{CURRENCY} to collect data
about trading pairs you need to show Collection View with prices based on a selected currency. Current currency must be displayed on the top of a screen and user can change it by tapping on it and selecting another one. Selected currency must be saved between application runs. Default currency is **USD**. List of currencies: **USD, EUR, GBP** (currency in the API must be in uppercase). Data must be auto updated every 5 seconds. If some price changed then this change must be animated (it is your decision how to animate). Tap on a pair Cell should open currency calculator screen with selected currency pair.
**Currency calculator** screen shows trade pair (like **BTC / USD**), price per one item (like **8000** ), currency amount which user want to buy/sell, calculated value based amount and price, and a keyboard. User can change pair direction like BTC/USD to USD/BTC by tapping special button ⇵.


## Source code programming languages:
- The Trade pairs screen is written in **Swift**
- The Currency calculator page is written in **Dart** and **Flutter**

## How to run the app:
- `pod install`

P.S. The app contains the screen powered by **Flutter** embeded as *Frameworks*.
Alternatively, in order apply changes promtly to **Dart** and **Flutter** code base, such changes can be done :
- Uncomment `AppDelegate.swift:11`
- Uncomment `Podfile:4,5,15`
- Comment `CryptoCalculator-Bridging-Header.h:5`
- Remove reference to the `Flutter` folder within the `CryptoCalculator` xcworkspace
- Remove `App.Framework` and `Flutter.framework` from *General->Frameworks, Libraries, and Embedded Content*
- `pod install` or `pod update`



