# [Noor App | تطبيق نُور](https://noorathkar.com)

<p>
  <a href="https://apps.apple.com/sa/app/نور-noor/id1463334485">
    <img src="https://user-images.githubusercontent.com/41123719/117558302-db848980-b084-11eb-8ef8-1dac2eb5ea56.png" atl="app-store-badge" width="125"/>     
  </a>
  <a href="https://play.google.com/store/apps/details?id=com.noor.sa">
    <img src="https://user-images.githubusercontent.com/41123719/117558323-243c4280-b085-11eb-857d-219e2c9d88c6.png" atl="google-play-badge" width="125"/>     
  </a>
</p>

## Overview

Noor is an islamic mobile app, consists of four main pages: home, favorite, alsabha, and settings. The data is structured in Cards that are easy to read, and has some actions that can be performed with the card content. Noor is designed to help in providing a comfortable reading experience for Muslims, by referencing the book "Hisnul Muslim", and some other references.

This project contains the codebase for the Android version that is on Play Store, it can run on iOS as well. Built with Flutter, and Firebase.

## App Preview

<p>
   <img src="https://user-images.githubusercontent.com/41123719/118995957-3759e700-b990-11eb-99dc-2964369af25a.gif" atl="Noor Light Mode" width="200"/>     
   <img src="https://user-images.githubusercontent.com/41123719/118996008-40e34f00-b990-11eb-86ac-e82c3c99b61d.gif" atl="Noor Dark Mode" width="200"/>     
</p>

## How to run
*Note: the assets were replaced by placeholders, so the version you will run locally is different in look than the version in stores.*

### 1. Firebase Setup
It's important to put your own Firebase service file in order to run the app, as it requires initializing Firebase on launch.

1. Create a [new Firebase project](https://console.firebase.google.com/).
2. Add a new Android or iOS app, depending on which device you want to use, and follow the configuration steps to connect Noor to your Firebase project.
3. Go to Remote Config page.
4. Add a new parameter with name `noorThekr`, with any value of your choice.
5. **(Soon)** ~~follow the steps in this repo, which contains the backend function that will be triggered whenevr you update the Remote Config value from the console.~~


### 2. Run

1. Clone the project:
```bash
git clone https://github.com/pr-Mais/noor.git
```
2. Get packages:
```bash
flutter pub get
```
3. Start an iOS simulator or Android emulator, or a real device, then run:
```bash
flutter run
```

## Want to contribute?

If you encounter any bug while using the apps in store, or running it locally, please file an issue.
<br /> Contribution for enhancments are also welcome! just create a PR, and describe precisly what is your contribution.

For features request, contact us on [noorathkarapplication@gmail.com](mailto:noorathkarapplication@gmail.com?subject=%D8%A7%D9%82%D8%AA%D8%B1%D8%A7%D8%AD&body=%D8%A7%D9%84%D8%B3%D9%84%D8%A7%D9%85%20%D8%B9%D9%84%D9%8A%D9%83%D9%85%D8%8C)

## Credits
Shout out to the amazing designer [Shaikha Alqahtani](https://twitter.com/Ishaiookh).
<br/> The iOS version from Noor was made with native Swift by [Maryam Aljamea](https://twitter.com/0_1Mary).

