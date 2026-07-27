import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")

    // The Flutter Gradle Plugin must be applied after
    // the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load properties from local.properties file
val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")

if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use {
        localProperties.load(it)
    }
}

// Load signing properties from android/key.properties if present
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use {
        keystoreProperties.load(it)
    }
}

val googleMapsApiKey: String =
    localProperties.getProperty("GOOGLE_MAPS_API_KEY")
        ?: "YOUR_API_KEY_HERE"

android {
    namespace = "com.ahizaz.dalil"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.ahizaz.dalil"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Inject Google Maps API Key into AndroidManifest.xml
        manifestPlaceholders["googleMapsApiKey"] = googleMapsApiKey
    }

    buildTypes {
        release {
            // Use release signing when key.properties exists
            if (keystorePropertiesFile.exists()) {
                signingConfig = signingConfigs.create("release") {
                    val storeFileProp =
                        keystoreProperties.getProperty("storeFile")

                    if (storeFileProp != null) {
                        storeFile = file(storeFileProp)
                    }

                    storePassword =
                        keystoreProperties.getProperty("storePassword")

                    keyAlias =
                        keystoreProperties.getProperty("keyAlias")

                    keyPassword =
                        keystoreProperties.getProperty("keyPassword")
                }
            } else {
                // Temporary debug signing
                signingConfig = signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}