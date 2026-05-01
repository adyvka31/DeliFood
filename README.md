# 🍔 DeliFood - Real-time Food Delivery App 🍔

> A seamless, real-time mobile e-commerce application designed to simplify the food ordering experience.

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

## 📖 About The Project

DeliFood is a mobile e-commerce application built to dive deep into mobile development and backend integration. The main goal of this application is to provide a seamless user interface (UI) connected to a real-time database, ensuring that users have the most up-to-date information on their orders, products, and deliveries. 

## ✨ Key Features

* **🔐 Authentication:** Secure Login and Sign Up using Firebase Authentication.
* **🔍 Dynamic Search:** A real-time search bar that filters products instantly.
* **🔄 Real-time Data Synchronization:** Live product listings, catalog updates, and order syncing using Firebase Streams.
* **❤️ Wishlist System:** Users can easily save their favorite products to a dedicated Firestore collection.
* **🛒 Cart & Checkout:** Dynamic and intuitive cart management system.
* **📍 Order Tracking:** Real-time delivery status tracking for active orders.
* **🔔 Push Notifications:** Real-time updates and alerts for order status and transaction changes.

## 🛠️ Tech Stack

* **Framework:** Flutter (Dart)
* **Backend:** Firebase (Authentication & Cloud Firestore)
* **State Management:** `setState` & Firebase Streams
* **Architecture Highlight:** Built asynchronous data architecture utilizing streams for responsive layouts.

## 🚀 Installation & Running the App

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/yourusername/delifood.git
    ```
2.  **Navigate to the project directory:**
    ```bash
    cd delifood
    ```
3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Firebase Setup:**
    * Create a Firebase project and add your Android/iOS apps.
    * Add the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to their respective directories within the Flutter project.
5.  **Run the application:**
    ```bash
    flutter run
    ```

---
*Built with ❤️ to explore the possibilities of Flutter & Firebase.*
