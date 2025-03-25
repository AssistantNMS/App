import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("release.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

if (System.getenv()["CI"] != null) { // CI=true is exported by Codemagic
    keystoreProperties["keyAlias"] = System.getenv()["FCI_KEY_ALIAS"]
    keystoreProperties["keyPassword"] = System.getenv()["FCI_KEY_PASSWORD"]
    keystoreProperties["storeFile"] = file(System.getenv()["FCI_BUILD_DIR"] + "/keystore.jks")
    keystoreProperties["storePassword"] = System.getenv()["FCI_KEYSTORE_PASSWORD"]
}

android {
    namespace = "com.kurtlourens.no_mans_sky_recipes"
    compileSdk = flutter.compileSdkVersion
    // ndkVersion = flutter.ndkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }

    dexOptions {
        preDexLibraries = false
        incremental = true
        javaMaxHeapSize = "4g"
    }

    defaultConfig {
        applicationId = "com.kurtlourens.no_mans_sky_recipes"
        // minSdk = flutter.minSdkVersion
        minSdk = 25
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
       release {
            signingConfig = signingConfigs.getByName("debug")
            signingConfig = signingConfigs.getByName("release")
       }
   }
}

dependencies {
    // https://stackoverflow.com/questions/79158012/dependency-flutter-local-notifications-requires-core-library-desugaring-to-be
    // and https://mvnrepository.com/artifact/com.android.tools/desugar_jdk_libs
    // and https://developer.android.com/studio/write/java8-support#library-desugaring
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}

flutter {
    source = "../.."
}
