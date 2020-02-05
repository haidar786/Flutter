import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'l10n/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get title {
    return Intl.message('Hello world App',
        name: 'title', desc: 'The application title');
  }

  String get hello {
    return Intl.message('Hello', name: 'hello');
  }

  String get reportTrash {
    return Intl.message('Report Trash');
  }

  String get reportTrashAnywhere {
    return Intl.message("Report trash from anywhere in the world");
  }

  String get cleanItUp {
    return Intl.message("Clean it up");
  }

  String get cleanItUpAndPost {
    return Intl.message("Clean it up and post a picture");
  }

  String get earnMoney {
    return Intl.message("Earn MONEY!");
  }

  String get earnMoneyCleaning {
    return Intl.message("Earn MONEY when your cleanup is verified");
  }

  String get letsGo {
    return Intl.message("Lets Go!");
  }

  String get language {
    return Intl.message("Language");
  }

  String get rewardingCleanup {
    return Intl.message("rewarding city cleanup");
  }

  String get signUpHere {
    return Intl.message("SIGN UP HERE");
  }

  /// I started from here.
  String get sendBitcoin {
    return Intl.message("Send BTC");
  }

  String get buyEmrals {
    return Intl.message("Buy Emrals");
  }

  String get amountOfEmralsToBuy {
    return Intl.message("Amount of EMRALS to buy");
  }

  String get error {
    return Intl.message("Error");
  }

  String get emralsNotAvailable {
    return Intl.message("EMRALS not available");
  }

  String get send {
    return Intl.message("Send");
  }

  String get btc {
    return Intl.message("BTC");
  }

  String get pleaseEnterValidAmountGreaterThan100 {
    return Intl.message("Please enter a valid amount > 100");
  }

  String get emrals {
    return Intl.message("EMRALS");
  }

  String get emralsChargesNoFees {
    return Intl.message("Emrals charges no fees when you buy or sell EMRALS.");
  }

  String get howeverEmralsMayApplyExchangeRate {
    return Intl.message(
        "However, Emrals may apply an exchange rate based on the size of your transaction and a spread determined by volatility across exchanges.");
  }

  String get cleanUpReport {
    return Intl.message("Cleanup Report");
  }

  String get selectCameraFirst {
    return Intl.message("select a camera first.");
  }

  String get goToActivity {
    return Intl.message("Go to Activity");
  }

  String get pleaseEnableGPS {
    return Intl.message("Please enable GPS");
  }

  String get inviteContacts {
    return Intl.message("Invite Contacts");
  }

  String get invite {
    return Intl.message("Invite");
  }

  String get activity {
    return Intl.message("Activity");
  }

  String get zones {
    return Intl.message("Zones");
  }

  String get report {
    return Intl.message("Report");
  }

  String get stats {
    return Intl.message("Stats");
  }

  String get map {
    return Intl.message("Map");
  }

  String get leaderBoard {
    return Intl.message("LeaderBoard");
  }

  String get topReporters {
    return Intl.message("Top Reporters");
  }

  String get topCleaners {
    return Intl.message("Top Cleaners");
  }

  /// most use in login screen
  String get rewardingCityCleanUp {
    return Intl.message(
        "Rewarding city cleanup"); // duplicate string with Capital R use in Login screen
  }

  String get versionApp {
    return Intl.message("Version APP_VERSION_NUMBER (BUILD_NUMBER)");
  }

  String get userName {
    return Intl.message("Username");
  }

  String get password {
    return Intl.message("Password");
  }

  String get login {
    return Intl.message("LOGIN");
  }

  String get forgetPassword {
    return Intl.message("Forgot password?");
  }

  ///most in map
  String get unableToLoadReports {
    return Intl.message("Unable to load reports.");
  }

  ///most in profile

  String get emralsEarned {
    return Intl.message("Emrals Earned");
  }

  String get reportsPosted {
    return Intl.message("Reports Posted");
  }

  String get emralsDonated {
    return Intl.message("Emrals Donated");
  }

  String get reportsCleaned {
    return Intl.message("Reports Cleaned");
  }

  String get sendEmrals {
    return Intl.message("Send Emrals");
  }

  String get errorUploadingImage {
    return Intl.message("Error Uploading Image"); //not used in any widget
  }

  String get profilePhoto {
    return Intl.message("Profile photo");
  }

  String get gallery {
    return Intl.message("Gallery");
  }

  String get camera {
    return Intl.message("Camera");
  }

  ///most use in report detail

  String get reportDetail {
    return Intl.message("Report Detail");
  }

  String get before {
    return Intl.message("Before");
  }

  String get areYouSureAboutDeleteReport {
    return Intl.message("Are you sure you want to delete this report?");
  }

  String get cancel {
    return Intl.message("Cancel");
  }

  String get tipEmrals {
    return Intl.message("Tip Emrals");
  }

  String get share {
    return Intl.message("Share");
  }

  String get cleaned {
    return Intl.message("CLEANED");
  }

  String get goodJob {
    return Intl.message("Good Job");
  }

  String get clean {
    return Intl.message("Clean");
  }

  String get comments {
    return Intl.message("Comments");
  }

  String get add {
    return Intl.message("Add");
  }

  String get commentsPosted {
    return Intl.message("Comments Posted");
  }

  String get noComments {
    return Intl.message("No comments :(");
  }

  String get hoursAgo {
    return Intl.message("hours ago");
  }

  String get areYouSureYouWantTo {
    return Intl.message("Are you sure you want to");
  }

  String get delete {
    return Intl.message("delete");
  }

  String get deleteCapital {
    return Intl.message("Delete");
  }

  String get flag {
    return Intl.message("flag");
  }

  String get flagCapital {
    return Intl.message("Flag");
  }

  String get thisComment {
    return Intl.message("this comment?");
  }

  String get yes {
    return Intl.message("Yes");
  }

  String get insufficientBalance {
    return Intl.message("Insufficient balance");
  }

  String get recent {
    return Intl.message("Recent");
  }

  String get closest {
    return Intl.message("Closest");
  }

  String get cleans {
    return Intl.message("cleans");
  }

  String get ago {
    return Intl.message("ago");
  }

  String get reports {
    return Intl.message("Reports");
  }

  String get earned {
    return Intl.message("earned");
  }

  String get tip {
    return Intl.message("TIP");
  }

  String get okay {
    return Intl.message("OKAY");
  }

  String get noPostFound {
    return Intl.message("No posts found.");
  }

  ///most use in report map
  String get emralsMap {
    return Intl.message("Emrals Map");
  }

  String get openInMapApp {
    return Intl.message("Open in map app.");
  }

  ///most use in send btc
  String get buying {
    return Intl.message("Buying");
  }

  String get btcToAddress {
    return Intl.message("BTC to address");
  }

  String get copiedToClipBoard {
    return Intl.message("Copied to Clipboard");
  }

  String get emralsToBeAdded {
    return Intl.message(
        "EMRALS will be added to your balance after 1 blockchain confirmation. This usually takes 10 - 30 minutes. You will get an email when the purchase is complete.");
  }

  String get btcAddress {
    return Intl.message("BTC Address");
  }

  String get balance {
    return Intl.message("Balance");
  }

  String get confirmation {
    return Intl.message("Confirmation");
  }

  ///most use in settings
  String get profile {
    return Intl.message("profile");
  }

  String get receive {
    return Intl.message("receive");
  }

  String get transactions {
    return Intl.message("transactions");
  }

  String get inviteContact {
    return Intl.message("Invite Contacts");
  }

  String get uploads {
    return Intl.message("Uploads");
  }

  String get walletAddress {
    return Intl.message("Wallet Address");
  }

  String get userNotGrantCameraPermission {
    return Intl.message("The user did not grant the camera permission!");
  }

  String get unknownError {
    return Intl.message("Unknown error");
  }

  String get userReturnUsingBack {
    return Intl.message(
        'null (User returned using the "back"-button before scanning anything. Result)');
  }

  String get sendEmralsto {
    return Intl.message("Send EMRALS to");
  }

  String get pleaseEnterValidWalletAddress {
    return Intl.message("Please enter a valid wallet address");
  }

  String get enterValidAmount {
    return Intl.message("Please enter a valid amount");
  }

  String get amount {
    return Intl.message("Amount");
  }

  String get notHaveEnoughEmrals {
    return Intl.message("You don't have enough emrals for that");
  }

  String get noTransactionMade {
    return Intl.message("No transactions have been made.");
  }

  String get tippedUserReportingAlert {
    return Intl.message("tipped user for reporting alert");
  }

  String get tippedUserCleaningAlert {
    return Intl.message("tipped user for cleaning alert");
  }

  String get subscriptionId {
    return Intl.message("subscription id");
  }

  ///most use in sign up

  String get email {
    return Intl.message("Email");
  }

  String get signUp {
    return Intl.message("SIGN UP");
  }

  String get bySigningUpAgreeToTerms {
    return Intl.message("By signing up you agree to our");
  }

  String get termsAndConditions {
    return Intl.message("Terms and Conditions");
  }

  String get emralsSignUp {
    return Intl.message("Emrals Signup");
  }

  String get loggedInAs {
    return Intl.message("Logged in as");
  }

  ///most use in stats

  String get cities {
    return Intl.message("Cities");
  }

  String get countries {
    return Intl.message("Countries");
  }

  String get cleansUp {
    return Intl.message("Cleanups");
  }

  String get users {
    return Intl.message("Users");
  }

  String get emralsAdded {
    return Intl.message("Emrals Added");
  }

  String get subscriptions {
    return Intl.message("Subscriptions");
  }

  String get tosses {
    return Intl.message("Tosses");
  }

  String get scans {
    return Intl.message("Scans");
  }

  String get barcodes {
    return Intl.message("Barcodes");
  }

  String get links {
    return Intl.message("Links");
  }

  String get pools {
    return Intl.message("Pools");
  }

  String get explorer {
    return Intl.message("Explorer");
  }

  String get price {
    return Intl.message("Price");
  }

  String get high {
    return Intl.message("High");
  }

  String get low {
    return Intl.message("Low");
  }

  String get bid {
    return Intl.message("Bid");
  }

  String get ask {
    return Intl.message("Ask");
  }

  String get height {
    return Intl.message("Height");
  }

  String get hashRate {
    return Intl.message("Hashrate");
  }

  String get difficulty {
    return Intl.message("Difficulty");
  }

  String get masterNodes {
    return Intl.message("Masternodes");
  }

  String get mnWorth {
    return Intl.message("MN Worth");
  }

  String get supply {
    return Intl.message("Supply");
  }

  String get connections {
    return Intl.message("Connections");
  }

  String get hosts {
    return Intl.message("Hosts");
  }

  String get lastBlkTime {
    return Intl.message("Last BlkTime");
  }

  String get updatingIn {
    return Intl.message("Updating in");
  }

  ///most use in uploads
  String get pendingUploads {
    return Intl.message("Pending Uploads");
  }

  ///most use in zone_list
  String get noZonesFound {
    return Intl.message("No zones found.");
  }

  String get noImage {
    return Intl.message("No Image");
  }

  String get cleanUps {
    return Intl.message("cleanups");
  }

  String get views {
    return Intl.message("views");
  }

  String get fund {
    return Intl.message("FUND");
  }

  String get sponser {
    return Intl.message("sponser");
  }

  String get emralsPerMonth {
    return Intl.message("EMRALS / month");
  }

  String get ok {
    return Intl.message("OK");
  }

  String get sortZones {
    return Intl.message("Sort Zones");
  }

  ///most in form util
  String get pleaseEnterYour {
    return Intl.message("Please enter your");
  }

  String get enterYourPassword {
    return Intl.message("Please enter your password");
  }

  String get nameInvalidMessage {
    return Intl.message("Please enter 3-20 upper or lowercase characters");
  }

  String get emailInvalidMessage {
    return Intl.message("Please enter a valid email address");
  }

  String get passwordInvalidMessage {
    return Intl.message("8-200 letters, 1 number, 1 special character");
  }

  ///most in network util
  String get errorWhileFetchingData {
    return Intl.message("Error while fetching data"); // not implemented in network util
  }

}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
