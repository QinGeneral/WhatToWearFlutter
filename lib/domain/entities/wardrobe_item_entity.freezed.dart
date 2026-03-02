// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wardrobe_item_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WardrobeItemEntity _$WardrobeItemEntityFromJson(Map<String, dynamic> json) {
  return _WardrobeItemEntity.fromJson(json);
}

/// @nodoc
mixin _$WardrobeItemEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  ClothingCategoryEntity get category => throw _privateConstructorUsedError;
  String? get subCategory => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  String? get optimizedImage => throw _privateConstructorUsedError;
  List<String> get color => throw _privateConstructorUsedError;
  List<Map<String, String>>? get colorPalette =>
      throw _privateConstructorUsedError;
  List<StyleEntity> get style => throw _privateConstructorUsedError;
  SeasonEntity get season => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  String? get purchaseDate => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this WardrobeItemEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WardrobeItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WardrobeItemEntityCopyWith<WardrobeItemEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WardrobeItemEntityCopyWith<$Res> {
  factory $WardrobeItemEntityCopyWith(
    WardrobeItemEntity value,
    $Res Function(WardrobeItemEntity) then,
  ) = _$WardrobeItemEntityCopyWithImpl<$Res, WardrobeItemEntity>;
  @useResult
  $Res call({
    String id,
    String name,
    ClothingCategoryEntity category,
    String? subCategory,
    List<String> images,
    String? optimizedImage,
    List<String> color,
    List<Map<String, String>>? colorPalette,
    List<StyleEntity> style,
    SeasonEntity season,
    String? brand,
    String? purchaseDate,
    List<String> tags,
    String createdAt,
    String? updatedAt,
  });
}

/// @nodoc
class _$WardrobeItemEntityCopyWithImpl<$Res, $Val extends WardrobeItemEntity>
    implements $WardrobeItemEntityCopyWith<$Res> {
  _$WardrobeItemEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WardrobeItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? subCategory = freezed,
    Object? images = null,
    Object? optimizedImage = freezed,
    Object? color = null,
    Object? colorPalette = freezed,
    Object? style = null,
    Object? season = null,
    Object? brand = freezed,
    Object? purchaseDate = freezed,
    Object? tags = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as ClothingCategoryEntity,
            subCategory: freezed == subCategory
                ? _value.subCategory
                : subCategory // ignore: cast_nullable_to_non_nullable
                      as String?,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            optimizedImage: freezed == optimizedImage
                ? _value.optimizedImage
                : optimizedImage // ignore: cast_nullable_to_non_nullable
                      as String?,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            colorPalette: freezed == colorPalette
                ? _value.colorPalette
                : colorPalette // ignore: cast_nullable_to_non_nullable
                      as List<Map<String, String>>?,
            style: null == style
                ? _value.style
                : style // ignore: cast_nullable_to_non_nullable
                      as List<StyleEntity>,
            season: null == season
                ? _value.season
                : season // ignore: cast_nullable_to_non_nullable
                      as SeasonEntity,
            brand: freezed == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                      as String?,
            purchaseDate: freezed == purchaseDate
                ? _value.purchaseDate
                : purchaseDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WardrobeItemEntityImplCopyWith<$Res>
    implements $WardrobeItemEntityCopyWith<$Res> {
  factory _$$WardrobeItemEntityImplCopyWith(
    _$WardrobeItemEntityImpl value,
    $Res Function(_$WardrobeItemEntityImpl) then,
  ) = __$$WardrobeItemEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    ClothingCategoryEntity category,
    String? subCategory,
    List<String> images,
    String? optimizedImage,
    List<String> color,
    List<Map<String, String>>? colorPalette,
    List<StyleEntity> style,
    SeasonEntity season,
    String? brand,
    String? purchaseDate,
    List<String> tags,
    String createdAt,
    String? updatedAt,
  });
}

/// @nodoc
class __$$WardrobeItemEntityImplCopyWithImpl<$Res>
    extends _$WardrobeItemEntityCopyWithImpl<$Res, _$WardrobeItemEntityImpl>
    implements _$$WardrobeItemEntityImplCopyWith<$Res> {
  __$$WardrobeItemEntityImplCopyWithImpl(
    _$WardrobeItemEntityImpl _value,
    $Res Function(_$WardrobeItemEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WardrobeItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? subCategory = freezed,
    Object? images = null,
    Object? optimizedImage = freezed,
    Object? color = null,
    Object? colorPalette = freezed,
    Object? style = null,
    Object? season = null,
    Object? brand = freezed,
    Object? purchaseDate = freezed,
    Object? tags = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$WardrobeItemEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as ClothingCategoryEntity,
        subCategory: freezed == subCategory
            ? _value.subCategory
            : subCategory // ignore: cast_nullable_to_non_nullable
                  as String?,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        optimizedImage: freezed == optimizedImage
            ? _value.optimizedImage
            : optimizedImage // ignore: cast_nullable_to_non_nullable
                  as String?,
        color: null == color
            ? _value._color
            : color // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        colorPalette: freezed == colorPalette
            ? _value._colorPalette
            : colorPalette // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, String>>?,
        style: null == style
            ? _value._style
            : style // ignore: cast_nullable_to_non_nullable
                  as List<StyleEntity>,
        season: null == season
            ? _value.season
            : season // ignore: cast_nullable_to_non_nullable
                  as SeasonEntity,
        brand: freezed == brand
            ? _value.brand
            : brand // ignore: cast_nullable_to_non_nullable
                  as String?,
        purchaseDate: freezed == purchaseDate
            ? _value.purchaseDate
            : purchaseDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WardrobeItemEntityImpl implements _WardrobeItemEntity {
  const _$WardrobeItemEntityImpl({
    required this.id,
    required this.name,
    required this.category,
    this.subCategory,
    required final List<String> images,
    this.optimizedImage,
    required final List<String> color,
    final List<Map<String, String>>? colorPalette,
    required final List<StyleEntity> style,
    required this.season,
    this.brand,
    this.purchaseDate,
    required final List<String> tags,
    required this.createdAt,
    this.updatedAt,
  }) : _images = images,
       _color = color,
       _colorPalette = colorPalette,
       _style = style,
       _tags = tags;

  factory _$WardrobeItemEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$WardrobeItemEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final ClothingCategoryEntity category;
  @override
  final String? subCategory;
  final List<String> _images;
  @override
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final String? optimizedImage;
  final List<String> _color;
  @override
  List<String> get color {
    if (_color is EqualUnmodifiableListView) return _color;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_color);
  }

  final List<Map<String, String>>? _colorPalette;
  @override
  List<Map<String, String>>? get colorPalette {
    final value = _colorPalette;
    if (value == null) return null;
    if (_colorPalette is EqualUnmodifiableListView) return _colorPalette;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<StyleEntity> _style;
  @override
  List<StyleEntity> get style {
    if (_style is EqualUnmodifiableListView) return _style;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_style);
  }

  @override
  final SeasonEntity season;
  @override
  final String? brand;
  @override
  final String? purchaseDate;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String createdAt;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'WardrobeItemEntity(id: $id, name: $name, category: $category, subCategory: $subCategory, images: $images, optimizedImage: $optimizedImage, color: $color, colorPalette: $colorPalette, style: $style, season: $season, brand: $brand, purchaseDate: $purchaseDate, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WardrobeItemEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.subCategory, subCategory) ||
                other.subCategory == subCategory) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.optimizedImage, optimizedImage) ||
                other.optimizedImage == optimizedImage) &&
            const DeepCollectionEquality().equals(other._color, _color) &&
            const DeepCollectionEquality().equals(
              other._colorPalette,
              _colorPalette,
            ) &&
            const DeepCollectionEquality().equals(other._style, _style) &&
            (identical(other.season, season) || other.season == season) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.purchaseDate, purchaseDate) ||
                other.purchaseDate == purchaseDate) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    category,
    subCategory,
    const DeepCollectionEquality().hash(_images),
    optimizedImage,
    const DeepCollectionEquality().hash(_color),
    const DeepCollectionEquality().hash(_colorPalette),
    const DeepCollectionEquality().hash(_style),
    season,
    brand,
    purchaseDate,
    const DeepCollectionEquality().hash(_tags),
    createdAt,
    updatedAt,
  );

  /// Create a copy of WardrobeItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WardrobeItemEntityImplCopyWith<_$WardrobeItemEntityImpl> get copyWith =>
      __$$WardrobeItemEntityImplCopyWithImpl<_$WardrobeItemEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WardrobeItemEntityImplToJson(this);
  }
}

abstract class _WardrobeItemEntity implements WardrobeItemEntity {
  const factory _WardrobeItemEntity({
    required final String id,
    required final String name,
    required final ClothingCategoryEntity category,
    final String? subCategory,
    required final List<String> images,
    final String? optimizedImage,
    required final List<String> color,
    final List<Map<String, String>>? colorPalette,
    required final List<StyleEntity> style,
    required final SeasonEntity season,
    final String? brand,
    final String? purchaseDate,
    required final List<String> tags,
    required final String createdAt,
    final String? updatedAt,
  }) = _$WardrobeItemEntityImpl;

  factory _WardrobeItemEntity.fromJson(Map<String, dynamic> json) =
      _$WardrobeItemEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  ClothingCategoryEntity get category;
  @override
  String? get subCategory;
  @override
  List<String> get images;
  @override
  String? get optimizedImage;
  @override
  List<String> get color;
  @override
  List<Map<String, String>>? get colorPalette;
  @override
  List<StyleEntity> get style;
  @override
  SeasonEntity get season;
  @override
  String? get brand;
  @override
  String? get purchaseDate;
  @override
  List<String> get tags;
  @override
  String get createdAt;
  @override
  String? get updatedAt;

  /// Create a copy of WardrobeItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WardrobeItemEntityImplCopyWith<_$WardrobeItemEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
