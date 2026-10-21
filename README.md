# firebase1
Firebase: real time database no deadlock

git config --global --add safe.directory C:/src/flutter

https://console.firebase.google.com/?_gl=1*1jjnmyq*_up*MQ..*_ga*MTYwMzk2NjE5Ni4xNzkyNjEzMjgx*_ga_CW55HF8NVT*czE3OTI2MTMyODAkbzEkZzAkdDE3OTI2MTMyODAkajYwJGwwJGgw&pli=1

create a space storage on Google cloud for us s

when we use chat - reatime database 
Firestore is used for user data 


Start in production mode
Your data is private by default. Client read/write access will only be granted as specified by your security rules.

Start in test mode
Your data is open by default to enable quick setup. However, you must update your security rules within 30 days to enable long-term client read/write access.
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if
          request.time < timestamp.date(2026, 11, 20);
    }
  }
}
caution:
The default security rules for test mode allow anyone with your database reference to view, edit and delete all data in your database for the next 30 days


use test mode -> it will delete in 30 days for safe API


data will be store in a file in a folder called collection 

general - click android 

open android studio > android > app>build.grade(app level) >copy name to firebase 
download googleservices/json and drag to the applevel 

Copy this to root level 
plugins {
  // ...

  // Add the dependency for the Google services Gradle plugin
  id("com.google.gms.google-services") version "4.5.0" apply false

} 	
yaml file 
dependencies:
  flutter:
    sdk: flutter
// plateform
  cloud_firestore: any
  firebase_core: any 
