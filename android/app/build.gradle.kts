
import java.util.Properties
import java.io.FileInputStream

// تحميل keystore.properties
val keystoreProperties = Properties().apply {
    val keystoreFile = rootProject.file("key.properties")
    if (keystoreFile.exists()) {
        load(FileInputStream(keystoreFile))
    }
}



plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}
 
android {
    namespace = "com.wishcrafted.iq.net"
    compileSdk = 36
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

  kotlin {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_11)
        }
    }

    defaultConfig {


        applicationId = "com.wishcrafted.iq.net"
        minSdk = 24
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
//           ndk {
//      abiFilters 'armeabi-v7a', 'arm64-v8a', 'x86', 'x86_64'
//    }
    }
 signingConfigs {
    
        signingConfig = signingConfigs.getByName("debug")
  create("release") {
        storeFile = keystoreProperties["storeFile"]?.let { file(it) }
        storePassword = keystoreProperties["storePassword"] as String?
        keyAlias = keystoreProperties["keyAlias"] as String?
        keyPassword = keystoreProperties["keyPassword"] as String?
    }
    
}
    buildTypes {

         getByName("release") {
         isMinifyEnabled = true   // يشتغل R8/ProGuard
        isShrinkResources = true  // يگص الموارد غير المستعملة
        proguardFiles(
            getDefaultProguardFile("proguard-android.txt"),
            "proguard-rules.pro"
        )
        signingConfig = signingConfigs.getByName("release")
    }
     getByName("debug") {
            isMinifyEnabled = false
            isShrinkResources = false
        }
      
    }
}

flutter {
    source = "../.."
}
