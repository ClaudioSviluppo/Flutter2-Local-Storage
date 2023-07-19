# shared_preferences

## Internationalize
### To use flutter_localizations, add the package as a dependency to your pubspec.yaml file, as well as the intl package:

#### flutter pub add flutter_localizations --sdk=flutter
#### flutter gen-l10n per generare file lingue
#### flutter pub add intl:any


#
## Esempio launch.json
"version": "0.2.0",
    "configurations": [

        {
            "name": "Launch Chrome",
            "request": "launch",
            "type": "dart",
            "deviceId": "chrome",
            "program": "lib/main.dart",
            "args": [
                "--web-hostname=127.0.0.1",
                "--web-port=8080",
            ],
        },
        {
            "name": "Android Phone",
            "request": "launch",
            "type": "dart",
            "deviceId": "emulator-5554"
          },
          {
            "name": "Android Tablet",
            "request": "launch",
            "type": "dart",
            "deviceId": "Device Name"
          },
    ]
}
