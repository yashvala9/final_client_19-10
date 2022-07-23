class Base {
  static const _url = 'http://13.234.159.127';

  static const register = "$_url/users/";
  static const login = '$_url/login';
  // static const createProfile = '$_url/profiles';
  static const forgetPassword = '$_url/auth/forgot-password';
  static const verifyOtp = '$_url/auth/register/verifyOTP';
  static const getProfileId =  '$_url/users/me';
  static const getProfileByToken = '$_url/users/getcurrent_user';  
  static const getProfilebyId = '$_url/user-profiles';
  static const getReelsbyId = '$_url/getReelsByUserId';
  static const createProfile = '$_url/user-profiles';
  static const searchUser = '$_url/searchByUserName';
  static const updateProfile = '$_url/users/profile/update';

  //Reels
  static const getReelsByUserId = '$_url/getReelsByUserId';
  static const getFeedsByUserId ='$_url/getFeed';
  static const getPhotosByUserId ='$_url/getPhotosByUserId';
  static const addReel = '$_url/reels';

  //Upload Video and photo
  static const uploadVideo = '$_url/upload';

  //Like
  static const toggleLike = '$_url/toggleLike';
  static const getLikeFlag = '$_url/getLikeFlag';

  //Comment
  static const getCommentByReelId = '$_url/getCommentsByReelId';
  static const addCommentToReelId = '$_url/addComment';
  static const toggleCommentLike = '$_url/toggleCommentLike';

  //Follow UnFollow
  static const toggleFollow = '${_url}/sendFollowRequest';

  //Giveaway
  static const giveaway = '$_url/contests';
  static const CreateGiveaway = '$_url/createContest';
  static const getAdsEntryCountByUserId = '$_url/ads-histories/count';
  static const getReferralsEntryCountByUserId = '$_url/referrals/count';
  static const getTotalEntryCountByUserId = '$_url/totalEntries';
  static const getBuddyPairByUserId = '$_url/getBuddy';
  static const imageUpload = '$_url/upload';
  static const winners = '$_url/winners';
  
  



}
