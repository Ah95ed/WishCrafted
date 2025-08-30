# دليل استخدام نظام المصادقة مع Google

## البنية المعمارية (MVC with Provider)

### 1. Model (النموذج)
- `UserModel`: نموذج بيانات المستخدم
- يحتوي على معلومات المستخدم من Firebase

### 2. Service (الخدمة)
- `AuthService`: خدمة المصادقة مع Firebase و Google
- تحتوي على جميع العمليات المتعلقة بالمصادقة

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

### 2. إعداد Google Sign-In
في `android/app/build.gradle` أضف:
```gradle
dependencies {
    implementation 'com.google.android.gms:play-services-auth:20.4.1'
}
```

### 3. استخدام AuthProvider في التطبيق
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
✅ تسجيل الخروج
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
