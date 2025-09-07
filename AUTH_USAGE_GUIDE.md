# دليل استخدام نظام المصادقة الاجتماعية

## البنية المعمارية (MVC with Provider)

### 1. Model (النموذج)
- `UserModel`: نموذج بيانات المستخدم
- يحتوي على معلومات المستخدم من Firebase

### 2. Services (الخدمات)
- `AuthenticationService`: خدمة المصادقة المركزية التي تجمع جميع طرق المصادقة
- `GoogleSignInService`: خدمة المصادقة مع Google
- `FacebookSignInService`: خدمة المصادقة مع Facebook
- `TwitterSignInService`: خدمة المصادقة مع Twitter

### 3. Controller (المتحكم)
- `AuthController`: التحكم في منطق المصادقة
- إدارة الحالات والأخطاء

### 4. Provider (مزود الحالة)
- `AuthProvider`: ربط المتحكم مع واجهة المستخدم
- إشعار واجهة المستخدم بالتغييرات

### 5. View (الواجهة)
- `AuthSocialScreen`: شاشة تسجيل الدخول الاجتماعي
- `AuthWrapper`: للتحكم في التنقل حسب حالة المصادقة

## كيفية الاستخدام:

### 1. تهيئة Firebase
تأكد من أن Firebase معد بشكل صحيح في مشروعك:
- أضف `google-services.json` للأندرويد
- أضف `GoogleService-Info.plist` للآيفون

### 2. إعداد مزودي المصادقة الاجتماعية
#### Google Sign-In
في `android/app/build.gradle` أضف:
```gradle
dependencies {
    implementation 'com.google.android.gms:play-services-auth:20.4.1'
}
```

#### Facebook Sign-In
- قم بإنشاء حساب مطور على [Facebook Developer Portal](https://developers.facebook.com/)
- أنشئ تطبيقًا جديدًا واحصل على App ID وApp Secret
- قم بتعديل ملف `AndroidManifest.xml` لإضافة:
```xml
<meta-data android:name="com.facebook.sdk.ApplicationId" android:value="@string/facebook_app_id"/>
<meta-data android:name="com.facebook.sdk.ClientToken" android:value="@string/facebook_client_token"/>
```

#### Twitter Sign-In
- قم بإنشاء حساب مطور على [Twitter Developer Portal](https://developer.twitter.com/en)
- احصل على API Key وAPI Secret Key
- قم بتحديث قيم `apiKey` و`apiSecretKey` و`redirectURI` في ملف `twitterService.dart`

### 3. استخدام AuthenticationService للمصادقة
```dart
// تسجيل الدخول باستخدام Google
final UserCredential? googleResult = await AuthenticationService.signInWithProvider(AuthProvider.google);

// تسجيل الدخول باستخدام Facebook
final UserCredential? facebookResult = await AuthenticationService.signInWithProvider(AuthProvider.facebook);

// تسجيل الدخول باستخدام Twitter
final UserCredential? twitterResult = await AuthenticationService.signInWithProvider(AuthProvider.twitter);

// التحقق من حالة المصادقة
if (AuthenticationService.isLoggedIn()) {
  // المستخدم مسجل الدخول
}

// تسجيل الخروج من جميع الحسابات
await AuthenticationService.signOut();
```

### 4. استخدام AuthProvider في التطبيق
```dart
// في main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    // باقي المزودين...
  ],
  child: MyApp(),
)
```

### 4. استخدام AuthWrapper للتنقل التلقائي
```dart
// في الصفحة الرئيسية
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthWrapper(), // سيوجه المستخدم حسب حالة المصادقة
    );
  }
}
```

### 5. تسجيل الدخول
```dart
// في أي شاشة
final authProvider = Provider.of<AuthProvider>(context, listen: false);
final success = await authProvider.signInWithGoogle();
```

### 6. تسجيل الخروج
```dart
await authProvider.signOut();
```

### 7. التحقق من حالة المصادقة
```dart
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    if (authProvider.isAuthenticated) {
      return DashboardScreen();
    } else {
      return LoginScreen();
    }
  },
)
```

## الميزات المتوفرة:

✅ تسجيل الدخول بواسطة Google
✅ تسجيل الدخول بواسطة Facebook
✅ تسجيل الدخول بواسطة Twitter
✅ واجهة موحدة للمصادقة
✅ تسجيل الخروج من جميع الحسابات
✅ حذف الحساب
✅ التحقق من حالة المصادقة تلقائياً
✅ إدارة الأخطاء
✅ واجهات منظمة ومرتبة
✅ اتباع نمط MVC مع Provider
✅ حفظ حالة المستخدم

## ملاحظات مهمة:

1. تأكد من تكوين Firebase بشكل صحيح
2. أضف SHA-1 fingerprint لتطبيق الأندرويد في Firebase Console
3. قم بتحديث الـ dependencies في pubspec.yaml
4. اختبر التطبيق على جهاز حقيقي للحصول على أفضل النتائج
