class Base {
  static const _url = 'https://reelro-strapi.herokuapp.com';

  static const register = "$_url/auth/register/sendOTP";
  static const login = '$_url/auth/local/';
  static const createProfile = '$_url/profiles';
  static const forgetPassword = '$_url/auth/forgot-password';
  static const verifyOtp = '$_url/auth/register/verifyOTP';
}
