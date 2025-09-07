# Social Login Guide

هذا الدليل يوضح كيفية إعداد وتكوين ميزات تسجيل الدخول الاجتماعي في تطبيق Wishcrafted.

## متطلبات التثبيت

تأكد من تثبيت الحزم التالية:

```yaml
firebase_core: ^2.25.4
firebase_auth: ^4.17.4
google_sign_in: ^7.1.1
flutter_facebook_auth: ^6.0.4
twitter_login: ^4.4.2
```

## خطوات إعداد تسجيل دخول Google

1. قم بإنشاء مشروع في [Firebase Console](https://console.firebase.google.com)
2. أضف تطبيق Android و/أو iOS إلى مشروعك
3. قم بتنزيل ملف `google-services.json` (لـ Android) أو `GoogleService-Info.plist` (لـ iOS)
4. ضع الملفات في المجلدات المناسبة (لـ Android: `/android/app/` ولـ iOS: `/ios/Runner/`)
5. قم بتفعيل Google Sign In من لوحة تحكم Firebase في قسم Authentication

## خطوات إعداد تسجيل دخول Facebook

1. قم بإنشاء حساب مطور على [Facebook Developer Portal](https://developers.facebook.com/)
2. أنشئ تطبيقًا جديدًا واحصل على App ID وApp Secret
3. ضبط إعدادات المنتج (Facebook Login)
4. أضف عنوان URL التحويل الخاص بك في إعدادات OAuth
5. قم بتعديل ملف `AndroidManifest.xml` لإضافة:

```xml
<meta-data android:name="com.facebook.sdk.ApplicationId" android:value="@string/facebook_app_id"/>
<meta-data android:name="com.facebook.sdk.ClientToken" android:value="@string/facebook_client_token"/>
```

6. أضف بروتوكول URL المخصص في `Info.plist` لنظام iOS

## خطوات إعداد تسجيل دخول Twitter

1. قم بإنشاء حساب مطور على [Twitter Developer Portal](https://developer.twitter.com/en)
2. أنشئ مشروعًا وتطبيقًا جديدًا
3. احصل على API Key وAPI Secret Key
4. قم بضبط Callback URL في إعدادات التطبيق (مثال: `wishcrafted://`)
5. قم بتحديث قيم `apiKey` و`apiSecretKey` و`redirectURI` في ملف `twitterService.dart`

## كيفية الاستخدام

1. استخدم `GoogleSignInService.signInWithGoogle()` لتسجيل الدخول باستخدام Google
2. استخدم `FacebookSignInService.signInWithFacebook()` لتسجيل الدخول باستخدام Facebook
3. استخدم `TwitterSignInService.signInWithTwitter()` لتسجيل الدخول باستخدام Twitter

## تخصيص التطبيق

عند الحاجة لتخصيص ظهور أزرار تسجيل الدخول، يمكنك تعديل `SocialButton` widget في ملف `AuthSocialScreen.dart`.

## استكشاف الأخطاء وإصلاحها

1. تأكد من تفعيل مزودي المصادقة في لوحة تحكم Firebase
2. تحقق من تضمين ملفات التكوين الصحيحة للمنصات المستهدفة
3. تأكد من تحديث قيم API Keys لكل مزود مصادقة اجتماعية
4. افحص سجلات التطبيق للحصول على رسائل الخطأ التفصيلية
