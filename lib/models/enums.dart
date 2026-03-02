import 'package:flutter/material.dart';
import 'package:what_to_wear_flutter/l10n/app_localizations.dart';
import 'package:what_to_wear_flutter/theme/app_colors.dart';

// ═══════ Clothing Category ═══════
enum ClothingCategory {
  top,
  bottom,
  shoes,
  accessory,
  outerwear;

  String get label {
    switch (this) {
      case top:
        return '上衣';
      case bottom:
        return '裤子';
      case shoes:
        return '鞋履';
      case accessory:
        return '配饰';
      case outerwear:
        return '外套';
    }
  }
}

// ═══════ Season ═══════
enum Season {
  spring,
  summer,
  autumn,
  winter,
  all;

  String get label {
    switch (this) {
      case spring:
        return '春季';
      case summer:
        return '夏季';
      case autumn:
        return '秋季';
      case winter:
        return '冬季';
      case all:
        return '四季';
    }
  }
}

// ═══════ Style ═══════
enum Style {
  casual,
  formal,
  sport,
  retro,
  trendy,
  minimalist;

  String get label {
    switch (this) {
      case casual:
        return '休闲';
      case formal:
        return '商务';
      case sport:
        return '运动';
      case retro:
        return '复古';
      case trendy:
        return '潮流';
      case minimalist:
        return '极简';
    }
  }
}

// ═══════ Occasion ═══════
enum Occasion {
  commute,
  date,
  sport,
  party,
  travel,
  work,
  casual,
  formal;

  String get label {
    switch (this) {
      case commute:
        return '通勤';
      case date:
        return '约会';
      case sport:
        return '运动';
      case party:
        return '聚会';
      case travel:
        return '旅行';
      case work:
        return '通勤';
      case casual:
        return '日常休闲';
      case formal:
        return '正式场合';
    }
  }
}

// ═══════ User Identity ═══════
enum UserIdentity {
  student,
  it,
  business,
  freelancer,
  fashionista,
  artist,
  other;

  String get name {
    switch (this) {
      case student:
        return '校园学生';
      case it:
        return '互联网/IT';
      case business:
        return '商务人士';
      case freelancer:
        return '自由职业';
      case fashionista:
        return '时尚达人';
      case artist:
        return '艺术工作者';
      case other:
        return '其他';
    }
  }

  String get description {
    switch (this) {
      case student:
        return '轻松休闲';
      case it:
        return '极客风格';
      case business:
        return '正式干练';
      case freelancer:
        return '随性舒适';
      case fashionista:
        return '潮流前线';
      case artist:
        return '个性独特';
      case other:
        return '自定义';
    }
  }

  IconData get icon {
    switch (this) {
      case student:
        return Icons.school;
      case it:
        return Icons.code;
      case business:
        return Icons.business_center;
      case freelancer:
        return Icons.coffee;
      case fashionista:
        return Icons.checkroom;
      case artist:
        return Icons.palette;
      case other:
        return Icons.more_horiz;
    }
  }

  Color get color {
    switch (this) {
      case student:
        return AppColors.primaryBlue;
      case it:
        return AppColors.accentPurple;
      case business:
        return AppColors.darkTextTertiary;
      case freelancer:
        return AppColors.warningYellow;
      case fashionista:
        return AppColors.accentPink;
      case artist:
        return AppColors.accentTeal;
      case other:
        return AppColors.darkTextTertiary;
    }
  }
}

// ═══════ L10n Extensions ═══════
extension LocalizedClothingCategory on ClothingCategory {
  String localizedName(BuildContext context) {
    switch (this) {
      case ClothingCategory.top:
        return AppLocalizations.of(context)?.top ?? label;
      case ClothingCategory.bottom:
        return AppLocalizations.of(context)?.bottom ?? label;
      case ClothingCategory.shoes:
        return AppLocalizations.of(context)?.shoes ?? label;
      case ClothingCategory.accessory:
        return AppLocalizations.of(context)?.accessory ?? label;
      case ClothingCategory.outerwear:
        return AppLocalizations.of(context)?.outerwear ?? label;
    }
  }
}

extension LocalizedSeason on Season {
  String localizedName(BuildContext context) {
    switch (this) {
      case Season.spring:
        return AppLocalizations.of(context)?.spring ?? label;
      case Season.summer:
        return AppLocalizations.of(context)?.summer ?? label;
      case Season.autumn:
        return AppLocalizations.of(context)?.autumn ?? label;
      case Season.winter:
        return AppLocalizations.of(context)?.winter ?? label;
      case Season.all:
        return AppLocalizations.of(context)?.fourSeasons ?? label;
    }
  }
}
