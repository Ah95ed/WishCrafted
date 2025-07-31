
class Words{
  static const appName = 'appName';
  static const login = 'login';
  static const welcome = 'welcome';
  static const register = 'register';
  static const forgotPassword = 'forgot Password';
  static const userName = 'userName';
  static const password = 'password';
  static const email = 'email';
  static const phonenumber = 'PhoneNumber';

  @override
 static Map<String, Map<String, String>> get keys => {
        'ar': {
          appName: 'متجر ملابس',
          login: 'تسجيل الدخول',
          welcome: "مرحبا بك في متجر ملابس",
          register: 'تسجيل جديد',
          forgotPassword: 'نسيت كلمة المرور',
          userName : 'اسم المستخدم',
          password : 'كلمة السر',
          email : 'البريد الالكتروني',
           phonenumber:"رقم الهاتف"
        },
        'en': {
          appName: "Clothes Store",
          login: 'Login',
          welcome: "Welcome To Clothes Store",
          register: 'Register',
          forgotPassword: 'Forgot Password',
          userName : 'User Name',
          password : 'Password',
          email : 'Email',
          phonenumber:"PhoneNumber"
        },
      };
}
