import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appName.
  ///
  /// In zh, this message translates to:
  /// **'今天穿什么'**
  String get appName;

  /// No description provided for @tabRecommendation.
  ///
  /// In zh, this message translates to:
  /// **'推荐'**
  String get tabRecommendation;

  /// No description provided for @tabWardrobe.
  ///
  /// In zh, this message translates to:
  /// **'衣橱'**
  String get tabWardrobe;

  /// No description provided for @tabProfile.
  ///
  /// In zh, this message translates to:
  /// **'我的'**
  String get tabProfile;

  /// No description provided for @guest.
  ///
  /// In zh, this message translates to:
  /// **'访客'**
  String get guest;

  /// No description provided for @unknown.
  ///
  /// In zh, this message translates to:
  /// **'未知'**
  String get unknown;

  /// No description provided for @favoriteOutfits.
  ///
  /// In zh, this message translates to:
  /// **'收藏穿搭'**
  String get favoriteOutfits;

  /// No description provided for @outfitHistory.
  ///
  /// In zh, this message translates to:
  /// **'穿搭历史'**
  String get outfitHistory;

  /// No description provided for @switchLightMode.
  ///
  /// In zh, this message translates to:
  /// **'切换浅色主题'**
  String get switchLightMode;

  /// No description provided for @switchDarkMode.
  ///
  /// In zh, this message translates to:
  /// **'切换深色主题'**
  String get switchDarkMode;

  /// No description provided for @switchLanguage.
  ///
  /// In zh, this message translates to:
  /// **'切换语言'**
  String get switchLanguage;

  /// No description provided for @helpAndFeedback.
  ///
  /// In zh, this message translates to:
  /// **'帮助与反馈'**
  String get helpAndFeedback;

  /// No description provided for @developerOptions.
  ///
  /// In zh, this message translates to:
  /// **'开发者选项'**
  String get developerOptions;

  /// No description provided for @wardrobeEmpty.
  ///
  /// In zh, this message translates to:
  /// **'衣橱为空，点击 + 添加衣物'**
  String get wardrobeEmpty;

  /// No description provided for @all.
  ///
  /// In zh, this message translates to:
  /// **'全部'**
  String get all;

  /// No description provided for @top.
  ///
  /// In zh, this message translates to:
  /// **'上装'**
  String get top;

  /// No description provided for @bottom.
  ///
  /// In zh, this message translates to:
  /// **'下装'**
  String get bottom;

  /// No description provided for @shoes.
  ///
  /// In zh, this message translates to:
  /// **'鞋履'**
  String get shoes;

  /// No description provided for @accessory.
  ///
  /// In zh, this message translates to:
  /// **'配饰'**
  String get accessory;

  /// No description provided for @outerwear.
  ///
  /// In zh, this message translates to:
  /// **'外套'**
  String get outerwear;

  /// No description provided for @addClothing.
  ///
  /// In zh, this message translates to:
  /// **'添加衣物'**
  String get addClothing;

  /// No description provided for @pleaseEnterClothingName.
  ///
  /// In zh, this message translates to:
  /// **'请输入衣物名称'**
  String get pleaseEnterClothingName;

  /// No description provided for @color.
  ///
  /// In zh, this message translates to:
  /// **'颜色'**
  String get color;

  /// No description provided for @material.
  ///
  /// In zh, this message translates to:
  /// **'材质'**
  String get material;

  /// No description provided for @brand.
  ///
  /// In zh, this message translates to:
  /// **'品牌'**
  String get brand;

  /// No description provided for @season.
  ///
  /// In zh, this message translates to:
  /// **'季节'**
  String get season;

  /// No description provided for @category.
  ///
  /// In zh, this message translates to:
  /// **'分类'**
  String get category;

  /// No description provided for @saveToWardrobe.
  ///
  /// In zh, this message translates to:
  /// **'保存到衣橱'**
  String get saveToWardrobe;

  /// No description provided for @selectCategory.
  ///
  /// In zh, this message translates to:
  /// **'选择分类'**
  String get selectCategory;

  /// No description provided for @selectSeason.
  ///
  /// In zh, this message translates to:
  /// **'请选择适用季节'**
  String get selectSeason;

  /// No description provided for @selectColor.
  ///
  /// In zh, this message translates to:
  /// **'请选择衣物颜色'**
  String get selectColor;

  /// No description provided for @clothingDetails.
  ///
  /// In zh, this message translates to:
  /// **'衣物详情'**
  String get clothingDetails;

  /// No description provided for @spring.
  ///
  /// In zh, this message translates to:
  /// **'春季'**
  String get spring;

  /// No description provided for @summer.
  ///
  /// In zh, this message translates to:
  /// **'夏季'**
  String get summer;

  /// No description provided for @autumn.
  ///
  /// In zh, this message translates to:
  /// **'秋季'**
  String get autumn;

  /// No description provided for @winter.
  ///
  /// In zh, this message translates to:
  /// **'冬季'**
  String get winter;

  /// No description provided for @fourSeasons.
  ///
  /// In zh, this message translates to:
  /// **'四季'**
  String get fourSeasons;

  /// No description provided for @confirmDelete.
  ///
  /// In zh, this message translates to:
  /// **'确认删除'**
  String get confirmDelete;

  /// No description provided for @confirmDeleteClothing.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除这件衣物吗？'**
  String get confirmDeleteClothing;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In zh, this message translates to:
  /// **'编辑'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @customOutfit.
  ///
  /// In zh, this message translates to:
  /// **'定制穿搭'**
  String get customOutfit;

  /// No description provided for @yourOutfitNeeds.
  ///
  /// In zh, this message translates to:
  /// **'您的搭配需求？'**
  String get yourOutfitNeeds;

  /// No description provided for @date.
  ///
  /// In zh, this message translates to:
  /// **'日期'**
  String get date;

  /// No description provided for @location.
  ///
  /// In zh, this message translates to:
  /// **'地点'**
  String get location;

  /// No description provided for @activity.
  ///
  /// In zh, this message translates to:
  /// **'活动'**
  String get activity;

  /// No description provided for @people.
  ///
  /// In zh, this message translates to:
  /// **'人物'**
  String get people;

  /// No description provided for @getOutfitPlan.
  ///
  /// In zh, this message translates to:
  /// **'获取搭配方案'**
  String get getOutfitPlan;

  /// No description provided for @today.
  ///
  /// In zh, this message translates to:
  /// **'今天'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In zh, this message translates to:
  /// **'明天'**
  String get tomorrow;

  /// No description provided for @dayAfterTomorrow.
  ///
  /// In zh, this message translates to:
  /// **'后天'**
  String get dayAfterTomorrow;

  /// No description provided for @thisWeekend.
  ///
  /// In zh, this message translates to:
  /// **'周末'**
  String get thisWeekend;

  /// No description provided for @nextWeek.
  ///
  /// In zh, this message translates to:
  /// **'下周'**
  String get nextWeek;

  /// No description provided for @workday.
  ///
  /// In zh, this message translates to:
  /// **'工作日'**
  String get workday;

  /// No description provided for @indoor.
  ///
  /// In zh, this message translates to:
  /// **'室内'**
  String get indoor;

  /// No description provided for @outdoor.
  ///
  /// In zh, this message translates to:
  /// **'户外'**
  String get outdoor;

  /// No description provided for @office.
  ///
  /// In zh, this message translates to:
  /// **'办公室'**
  String get office;

  /// No description provided for @mall.
  ///
  /// In zh, this message translates to:
  /// **'商场'**
  String get mall;

  /// No description provided for @park.
  ///
  /// In zh, this message translates to:
  /// **'公园'**
  String get park;

  /// No description provided for @cafe.
  ///
  /// In zh, this message translates to:
  /// **'咖啡厅'**
  String get cafe;

  /// No description provided for @daily.
  ///
  /// In zh, this message translates to:
  /// **'日常'**
  String get daily;

  /// No description provided for @leisure.
  ///
  /// In zh, this message translates to:
  /// **'休闲'**
  String get leisure;

  /// No description provided for @meeting.
  ///
  /// In zh, this message translates to:
  /// **'开会'**
  String get meeting;

  /// No description provided for @dateActivity.
  ///
  /// In zh, this message translates to:
  /// **'约会'**
  String get dateActivity;

  /// No description provided for @sports.
  ///
  /// In zh, this message translates to:
  /// **'运动'**
  String get sports;

  /// No description provided for @birthdayParty.
  ///
  /// In zh, this message translates to:
  /// **'生日聚会'**
  String get birthdayParty;

  /// No description provided for @formalDinner.
  ///
  /// In zh, this message translates to:
  /// **'正式晚宴'**
  String get formalDinner;

  /// No description provided for @partner.
  ///
  /// In zh, this message translates to:
  /// **'伴侣'**
  String get partner;

  /// No description provided for @friends.
  ///
  /// In zh, this message translates to:
  /// **'朋友'**
  String get friends;

  /// No description provided for @colleagues.
  ///
  /// In zh, this message translates to:
  /// **'同事'**
  String get colleagues;

  /// No description provided for @family.
  ///
  /// In zh, this message translates to:
  /// **'家人'**
  String get family;

  /// No description provided for @client.
  ///
  /// In zh, this message translates to:
  /// **'客户'**
  String get client;

  /// No description provided for @custom.
  ///
  /// In zh, this message translates to:
  /// **'自定义'**
  String get custom;

  /// No description provided for @enterCustomContent.
  ///
  /// In zh, this message translates to:
  /// **'请输入自定义内容'**
  String get enterCustomContent;

  /// No description provided for @confirm.
  ///
  /// In zh, this message translates to:
  /// **'确认'**
  String get confirm;

  /// No description provided for @shareOutfit.
  ///
  /// In zh, this message translates to:
  /// **'分享穿搭'**
  String get shareOutfit;

  /// No description provided for @saveShareImage.
  ///
  /// In zh, this message translates to:
  /// **'保存/分享图片'**
  String get saveShareImage;

  /// No description provided for @todayOutfitRecommendation.
  ///
  /// In zh, this message translates to:
  /// **'我的今日穿搭推荐'**
  String get todayOutfitRecommendation;

  /// No description provided for @todayWeather.
  ///
  /// In zh, this message translates to:
  /// **'今日天气'**
  String get todayWeather;

  /// No description provided for @matchPercentage.
  ///
  /// In zh, this message translates to:
  /// **'匹配度'**
  String get matchPercentage;

  /// No description provided for @generatingOutfit.
  ///
  /// In zh, this message translates to:
  /// **'正在为您定制专属穿搭...'**
  String get generatingOutfit;

  /// No description provided for @fashionItem.
  ///
  /// In zh, this message translates to:
  /// **'时尚单品'**
  String get fashionItem;

  /// No description provided for @alternativePlan.
  ///
  /// In zh, this message translates to:
  /// **'备选方案'**
  String get alternativePlan;

  /// No description provided for @noMatchingClothing.
  ///
  /// In zh, this message translates to:
  /// **'没有找到匹配的衣物'**
  String get noMatchingClothing;

  /// No description provided for @searchClothing.
  ///
  /// In zh, this message translates to:
  /// **'搜索衣物...'**
  String get searchClothing;

  /// No description provided for @uploadClothingPhoto.
  ///
  /// In zh, this message translates to:
  /// **'请上传衣物照片'**
  String get uploadClothingPhoto;

  /// No description provided for @enterMaterialInfo.
  ///
  /// In zh, this message translates to:
  /// **'请输入材质信息'**
  String get enterMaterialInfo;

  /// No description provided for @completeInfo.
  ///
  /// In zh, this message translates to:
  /// **'请完善信息'**
  String get completeInfo;

  /// No description provided for @saveFailedCause.
  ///
  /// In zh, this message translates to:
  /// **'保存失败：可能是因为图片过大或存储空间不足'**
  String get saveFailedCause;

  /// No description provided for @aiOptimizationSuccess.
  ///
  /// In zh, this message translates to:
  /// **'图片优化成功！'**
  String get aiOptimizationSuccess;

  /// No description provided for @aiOptimizationFailed.
  ///
  /// In zh, this message translates to:
  /// **'优化失败'**
  String get aiOptimizationFailed;

  /// No description provided for @aiRecognitionFailed.
  ///
  /// In zh, this message translates to:
  /// **'AI 识别失败'**
  String get aiRecognitionFailed;

  /// No description provided for @basicInfo.
  ///
  /// In zh, this message translates to:
  /// **'基础信息'**
  String get basicInfo;

  /// No description provided for @itemName.
  ///
  /// In zh, this message translates to:
  /// **'衣物名称'**
  String get itemName;

  /// No description provided for @egWhiteLinenShirt.
  ///
  /// In zh, this message translates to:
  /// **'例如：白色亚麻衬衫'**
  String get egWhiteLinenShirt;

  /// No description provided for @details.
  ///
  /// In zh, this message translates to:
  /// **'详细细节'**
  String get details;

  /// No description provided for @egHundredPercentCotton.
  ///
  /// In zh, this message translates to:
  /// **'例如：100% 纯棉'**
  String get egHundredPercentCotton;

  /// No description provided for @egUniqlo.
  ///
  /// In zh, this message translates to:
  /// **'例如：优衣库'**
  String get egUniqlo;

  /// No description provided for @saveChanges.
  ///
  /// In zh, this message translates to:
  /// **'保存修改'**
  String get saveChanges;

  /// No description provided for @aiOptimizing.
  ///
  /// In zh, this message translates to:
  /// **'AI 优化中...'**
  String get aiOptimizing;

  /// No description provided for @aiRecognizing.
  ///
  /// In zh, this message translates to:
  /// **'AI 识别中...'**
  String get aiRecognizing;

  /// No description provided for @clickToUploadPhoto.
  ///
  /// In zh, this message translates to:
  /// **'点击上传照片'**
  String get clickToUploadPhoto;

  /// No description provided for @forYouRecommendation.
  ///
  /// In zh, this message translates to:
  /// **'为你推荐'**
  String get forYouRecommendation;

  /// No description provided for @clickFabToGetRecommendation.
  ///
  /// In zh, this message translates to:
  /// **'点击右下角按钮获取穿搭推荐'**
  String get clickFabToGetRecommendation;

  /// No description provided for @uvIndexPrefix.
  ///
  /// In zh, this message translates to:
  /// **'紫外线'**
  String get uvIndexPrefix;

  /// No description provided for @humidityPrefix.
  ///
  /// In zh, this message translates to:
  /// **'湿度 '**
  String get humidityPrefix;

  /// No description provided for @comfortLevelPrefix.
  ///
  /// In zh, this message translates to:
  /// **'舒适度：'**
  String get comfortLevelPrefix;

  /// No description provided for @matchSuffix.
  ///
  /// In zh, this message translates to:
  /// **'% 匹配'**
  String get matchSuffix;

  /// No description provided for @businessCasualBreathable.
  ///
  /// In zh, this message translates to:
  /// **'商务休闲 • 透气棉质'**
  String get businessCasualBreathable;

  /// No description provided for @classicBusiness.
  ///
  /// In zh, this message translates to:
  /// **'经典商务'**
  String get classicBusiness;

  /// No description provided for @uvMedium.
  ///
  /// In zh, this message translates to:
  /// **'中'**
  String get uvMedium;

  /// No description provided for @comfortNormal.
  ///
  /// In zh, this message translates to:
  /// **'一般'**
  String get comfortNormal;

  /// No description provided for @customOutfitTitle.
  ///
  /// In zh, this message translates to:
  /// **'定制穿搭'**
  String get customOutfitTitle;

  /// No description provided for @customOutfitSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'您的搭配需求？'**
  String get customOutfitSubtitle;

  /// No description provided for @customOutfitDescription.
  ///
  /// In zh, this message translates to:
  /// **'按指引填写日期、地点、活动和人物，获取精准方案'**
  String get customOutfitDescription;

  /// No description provided for @customOutfitHint.
  ///
  /// In zh, this message translates to:
  /// **'日期: [例如：本周末，下午]\n地点: [例如：户外，城市公园]\n活动: [例如：朋友的休闲生日聚会]\n人物: [例如：亲近的朋友]'**
  String get customOutfitHint;

  /// No description provided for @addCustomOptionPrefix.
  ///
  /// In zh, this message translates to:
  /// **'添加\"'**
  String get addCustomOptionPrefix;

  /// No description provided for @addCustomOptionSuffix.
  ///
  /// In zh, this message translates to:
  /// **'\"选项'**
  String get addCustomOptionSuffix;

  /// No description provided for @customOption.
  ///
  /// In zh, this message translates to:
  /// **'自定义'**
  String get customOption;

  /// No description provided for @generatingOutcome.
  ///
  /// In zh, this message translates to:
  /// **'生成中...'**
  String get generatingOutcome;

  /// No description provided for @generatingExclusiveOutfit.
  ///
  /// In zh, this message translates to:
  /// **'正在为您定制专属穿搭...'**
  String get generatingExclusiveOutfit;

  /// No description provided for @categoryDate.
  ///
  /// In zh, this message translates to:
  /// **'日期'**
  String get categoryDate;

  /// No description provided for @categoryLocation.
  ///
  /// In zh, this message translates to:
  /// **'地点'**
  String get categoryLocation;

  /// No description provided for @categoryActivity.
  ///
  /// In zh, this message translates to:
  /// **'活动'**
  String get categoryActivity;

  /// No description provided for @categoryPerson.
  ///
  /// In zh, this message translates to:
  /// **'人物'**
  String get categoryPerson;

  /// No description provided for @optToday.
  ///
  /// In zh, this message translates to:
  /// **'今天'**
  String get optToday;

  /// No description provided for @optTomorrow.
  ///
  /// In zh, this message translates to:
  /// **'明天'**
  String get optTomorrow;

  /// No description provided for @optDayAfter.
  ///
  /// In zh, this message translates to:
  /// **'后天'**
  String get optDayAfter;

  /// No description provided for @optWeekend.
  ///
  /// In zh, this message translates to:
  /// **'周末'**
  String get optWeekend;

  /// No description provided for @optNextWeek.
  ///
  /// In zh, this message translates to:
  /// **'下周'**
  String get optNextWeek;

  /// No description provided for @optWorkday.
  ///
  /// In zh, this message translates to:
  /// **'工作日'**
  String get optWorkday;

  /// No description provided for @optIndoor.
  ///
  /// In zh, this message translates to:
  /// **'室内'**
  String get optIndoor;

  /// No description provided for @optOutdoor.
  ///
  /// In zh, this message translates to:
  /// **'户外'**
  String get optOutdoor;

  /// No description provided for @optMall.
  ///
  /// In zh, this message translates to:
  /// **'商场'**
  String get optMall;

  /// No description provided for @optCafe.
  ///
  /// In zh, this message translates to:
  /// **'咖啡厅'**
  String get optCafe;

  /// No description provided for @optOffice.
  ///
  /// In zh, this message translates to:
  /// **'办公室'**
  String get optOffice;

  /// No description provided for @optPark.
  ///
  /// In zh, this message translates to:
  /// **'公园'**
  String get optPark;

  /// No description provided for @optBirthday.
  ///
  /// In zh, this message translates to:
  /// **'生日聚会'**
  String get optBirthday;

  /// No description provided for @optMeeting.
  ///
  /// In zh, this message translates to:
  /// **'开会'**
  String get optMeeting;

  /// No description provided for @optDate.
  ///
  /// In zh, this message translates to:
  /// **'约会'**
  String get optDate;

  /// No description provided for @optSports.
  ///
  /// In zh, this message translates to:
  /// **'运动'**
  String get optSports;

  /// No description provided for @optCasual.
  ///
  /// In zh, this message translates to:
  /// **'休闲'**
  String get optCasual;

  /// No description provided for @optDinner.
  ///
  /// In zh, this message translates to:
  /// **'正式晚宴'**
  String get optDinner;

  /// No description provided for @optFriend.
  ///
  /// In zh, this message translates to:
  /// **'朋友'**
  String get optFriend;

  /// No description provided for @optColleague.
  ///
  /// In zh, this message translates to:
  /// **'同事'**
  String get optColleague;

  /// No description provided for @optFamily.
  ///
  /// In zh, this message translates to:
  /// **'家人'**
  String get optFamily;

  /// No description provided for @optPartner.
  ///
  /// In zh, this message translates to:
  /// **'伴侣'**
  String get optPartner;

  /// No description provided for @optClient.
  ///
  /// In zh, this message translates to:
  /// **'客户'**
  String get optClient;

  /// No description provided for @recommendationNotFound.
  ///
  /// In zh, this message translates to:
  /// **'推荐未找到'**
  String get recommendationNotFound;

  /// No description provided for @outfitItems.
  ///
  /// In zh, this message translates to:
  /// **'穿搭单品'**
  String get outfitItems;

  /// No description provided for @favorite.
  ///
  /// In zh, this message translates to:
  /// **'收藏'**
  String get favorite;

  /// No description provided for @tagSummer.
  ///
  /// In zh, this message translates to:
  /// **'夏季'**
  String get tagSummer;

  /// No description provided for @tagWarm.
  ///
  /// In zh, this message translates to:
  /// **'保暖'**
  String get tagWarm;

  /// No description provided for @weatherLabel.
  ///
  /// In zh, this message translates to:
  /// **'天气'**
  String get weatherLabel;

  /// No description provided for @shareBtn.
  ///
  /// In zh, this message translates to:
  /// **'分享'**
  String get shareBtn;

  /// No description provided for @generationFailed.
  ///
  /// In zh, this message translates to:
  /// **'生成失败:'**
  String get generationFailed;

  /// No description provided for @generateTryOnImage.
  ///
  /// In zh, this message translates to:
  /// **'生成试穿图'**
  String get generateTryOnImage;

  /// No description provided for @occasionType.
  ///
  /// In zh, this message translates to:
  /// **'场合类型'**
  String get occasionType;

  /// No description provided for @dailyLiteral.
  ///
  /// In zh, this message translates to:
  /// **'日常'**
  String get dailyLiteral;

  /// No description provided for @topDefault.
  ///
  /// In zh, this message translates to:
  /// **'上装'**
  String get topDefault;

  /// No description provided for @bottomDefault.
  ///
  /// In zh, this message translates to:
  /// **'下装'**
  String get bottomDefault;

  /// No description provided for @weatherClear.
  ///
  /// In zh, this message translates to:
  /// **'晴朗'**
  String get weatherClear;

  /// No description provided for @weatherPartlyCloudy.
  ///
  /// In zh, this message translates to:
  /// **'少云'**
  String get weatherPartlyCloudy;

  /// No description provided for @weatherCloudy.
  ///
  /// In zh, this message translates to:
  /// **'多云'**
  String get weatherCloudy;

  /// No description provided for @weatherOvercast.
  ///
  /// In zh, this message translates to:
  /// **'阴天'**
  String get weatherOvercast;

  /// No description provided for @weatherFog.
  ///
  /// In zh, this message translates to:
  /// **'雾'**
  String get weatherFog;

  /// No description provided for @weatherFreezingFog.
  ///
  /// In zh, this message translates to:
  /// **'冻雾'**
  String get weatherFreezingFog;

  /// No description provided for @weatherLightDrizzle.
  ///
  /// In zh, this message translates to:
  /// **'小毛毛雨'**
  String get weatherLightDrizzle;

  /// No description provided for @weatherDrizzle.
  ///
  /// In zh, this message translates to:
  /// **'毛毛雨'**
  String get weatherDrizzle;

  /// No description provided for @weatherHeavyDrizzle.
  ///
  /// In zh, this message translates to:
  /// **'密集毛毛雨'**
  String get weatherHeavyDrizzle;

  /// No description provided for @weatherLightFreezingDrizzle.
  ///
  /// In zh, this message translates to:
  /// **'轻冻雨'**
  String get weatherLightFreezingDrizzle;

  /// No description provided for @weatherFreezingDrizzle.
  ///
  /// In zh, this message translates to:
  /// **'冻雨'**
  String get weatherFreezingDrizzle;

  /// No description provided for @weatherSlightRain.
  ///
  /// In zh, this message translates to:
  /// **'小雨'**
  String get weatherSlightRain;

  /// No description provided for @weatherModerateRain.
  ///
  /// In zh, this message translates to:
  /// **'中雨'**
  String get weatherModerateRain;

  /// No description provided for @weatherHeavyRain.
  ///
  /// In zh, this message translates to:
  /// **'大雨'**
  String get weatherHeavyRain;

  /// No description provided for @weatherLightFreezingRain.
  ///
  /// In zh, this message translates to:
  /// **'轻冻雨'**
  String get weatherLightFreezingRain;

  /// No description provided for @weatherHeavyFreezingRain.
  ///
  /// In zh, this message translates to:
  /// **'强冻雨'**
  String get weatherHeavyFreezingRain;

  /// No description provided for @weatherSlightSnow.
  ///
  /// In zh, this message translates to:
  /// **'小雪'**
  String get weatherSlightSnow;

  /// No description provided for @weatherModerateSnow.
  ///
  /// In zh, this message translates to:
  /// **'中雪'**
  String get weatherModerateSnow;

  /// No description provided for @weatherHeavySnow.
  ///
  /// In zh, this message translates to:
  /// **'大雪'**
  String get weatherHeavySnow;

  /// No description provided for @weatherSnowGrains.
  ///
  /// In zh, this message translates to:
  /// **'雪粒'**
  String get weatherSnowGrains;

  /// No description provided for @weatherSlightRainShowers.
  ///
  /// In zh, this message translates to:
  /// **'小阵雨'**
  String get weatherSlightRainShowers;

  /// No description provided for @weatherModerateRainShowers.
  ///
  /// In zh, this message translates to:
  /// **'阵雨'**
  String get weatherModerateRainShowers;

  /// No description provided for @weatherViolentRainShowers.
  ///
  /// In zh, this message translates to:
  /// **'强阵雨'**
  String get weatherViolentRainShowers;

  /// No description provided for @weatherSlightSnowShowers.
  ///
  /// In zh, this message translates to:
  /// **'小阵雪'**
  String get weatherSlightSnowShowers;

  /// No description provided for @weatherHeavySnowShowers.
  ///
  /// In zh, this message translates to:
  /// **'强阵雪'**
  String get weatherHeavySnowShowers;

  /// No description provided for @weatherThunderstorm.
  ///
  /// In zh, this message translates to:
  /// **'雷暴'**
  String get weatherThunderstorm;

  /// No description provided for @weatherThunderstormHail.
  ///
  /// In zh, this message translates to:
  /// **'雷暴伴冰雹'**
  String get weatherThunderstormHail;

  /// No description provided for @weatherHeavyThunderstormHail.
  ///
  /// In zh, this message translates to:
  /// **'强雷暴伴冰雹'**
  String get weatherHeavyThunderstormHail;

  /// No description provided for @weatherUnknown.
  ///
  /// In zh, this message translates to:
  /// **'未知'**
  String get weatherUnknown;

  /// No description provided for @comfortHot.
  ///
  /// In zh, this message translates to:
  /// **'炎热'**
  String get comfortHot;

  /// No description provided for @comfortCold.
  ///
  /// In zh, this message translates to:
  /// **'寒冷'**
  String get comfortCold;

  /// No description provided for @comfortComfortable.
  ///
  /// In zh, this message translates to:
  /// **'舒适'**
  String get comfortComfortable;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
