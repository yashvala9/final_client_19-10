class Base {
  static const _url = 'http://13.234.159.127';

  static const register = "$_url/users/";
  static const login = '$_url/login';
  static const sendVeifyEmailLink = '$_url/users/send_activation_email';
  // static const createProfile = '$_url/profiles';
  static const verifyOtp = '$_url/auth/register/verifyOTP';
  static const getProfileId = '$_url/users/me';
  static const getProfileByToken = '$_url/users/getcurrent_user';
  static const getProfilebyId = '$_url/user-profiles';
  static const getReelsbyId = '$_url/getReelsByUserId';
  // static const createProfile = '$_url/user-profiles';
  static const searchUser = '$_url/searchByUserName';

  //Forget password
  static const generateForgetPasswordToken =
      '$_url/forgot_password/generate_token';
  static const validateForgetPasswordtoken =
      '$_url/forgot_password/validate_token';
  static const setForgetPassword = '$_url/forgot_password';

  //Profile
  static const currentUser = '$_url/users/getcurrent_user';
  static const createProfile = '$_url/users/profile';
  static const updateProfile = '$_url/users/profile/update';

  //Reels
  static const getReelsByUserId = '$_url/getReelsByUserId';
  static const getFeedsByUserId = '$_url/getFeed';
  static const getPhotosByUserId = '$_url/getPhotosByUserId';
  static const updateStatus = '$_url/reels/update/status/';
  static const reels = '$_url/reels/';
  static const addReel = '$_url/reels';
  static const getComment = '$_url/reels/comments/';
  static const isLiked = '$_url/reels/isLiked/';

  //Upload Video and photo
  static const uploadVideo = '$_url/upload';

  //Profile Bucket base url
  static const profileBucketUrl =
      'https://reelro-image-bucket.s3.ap-south-1.amazonaws.com/inputs';

  //Like
  static const toggleLike = '$_url/toggleLike';
  static const getLikeFlag = '$_url/getLikeFlag';

  //Comment
  static const getCommentByReelId = '$_url/getCommentsByReelId';
  static const addCommentToReelId = '$_url/reels/comments';
  static const toggleCommentLike = '$_url/toggleCommentLike';

  //Follow UnFollow
  static const toggleFollow = '${_url}/sendFollowRequest';

  //Giveaway
  static const giveaway = '$_url/contests/';
  static const CreateGiveaway = '$_url/createContest';
  static const getAdsEntryCountByUserId = '$_url/ads-histories/count';
  static const getReferralsEntryCountByUserId = '$_url/referrals/count';
  static const getTotalEntryCountByUserId = '$_url/totalEntries';
  static const getBuddyPairByUserId = '$_url/referrals/get_buddy';
  static const imageUpload = '$_url/upload';
  static const winners = '$_url/winners';
  static const referrals = '$_url/referrals';
}
