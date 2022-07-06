class Base {
  static const _url = 'https://reelro-strapi.herokuapp.com';

  static const register = "$_url/auth/register/sendOTP";
  static const login = '$_url/auth/local/';
  // static const createProfile = '$_url/profiles';
  static const forgetPassword = '$_url/auth/forgot-password';
  static const verifyOtp = '$_url/auth/register/verifyOTP';
  static const getProfileId =  '$_url/users/me';
  static const getProfilebyId = '$_url/user-profiles';
  static const createProfile = '$_url/user-profiles';
  static const searchUser = '$_url/searchByUserName';

  //Reels
  static const getReelsByUserId = '$_url/getReelsByUserId';
  static const getFeedsByUserId ='$_url/getFeed';
  static const addReel = '$_url/addReelByUserId';

  //Like
  static const toggleLike = '$_url/toggleLike';
  static const getLikeFlag = '$_url/getLikeFlag';

  //Comment
  static const getCommentByReelId = '$_url/getCommentsByReelId';
  static const addCommentToReelId = '$_url/addComment';
  

  //Photos
  static const getPhotosByUserId = '$_url/getPhotosByUserId';


}
