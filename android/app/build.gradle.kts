plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.sandra_contab_erp"
    compileSdkVersion(36) // O la versión que tengas
    ndkVersion = "27.0.12077973" // Añade esta línea

    defaultConfig {
        applicationId = "com.example.sandra_contab_erp"
        minSdkVersion(24) // <--- Corregido
        targetSdkVersion(34) // <--- Corregido
        versionCode = 1
        versionName = "1.0.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

//    defaultConfig {
//        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
//        applicationId = "com.example.sandra_contab_erp"
//        // You can update the following values to match your application needs.
//        // For more information, see: https://flutter.dev/to/review-gradle-config.
//        minSdk = flutter.minSdkVersion
//        targetSdk = flutter.targetSdkVersion
//        versionCode = flutter.versionCode
//        versionName = flutter.versionName
//    }

    buildTypes {
        release {
            isMinifyEnabled = true // <--- Habilita la reducción de código (obfuscation/tree-shaking)
            isShrinkResources = true // <--- Habilita la reducción de recursos
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
