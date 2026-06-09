// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prediction_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$predictionRepoHash() => r'03201a6546ae58cf8c1a06846e7bef083edc878b';

/// See also [predictionRepo].
@ProviderFor(predictionRepo)
final predictionRepoProvider =
    AutoDisposeProvider<PredictionRepository>.internal(
      predictionRepo,
      name: r'predictionRepoProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$predictionRepoHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PredictionRepoRef = AutoDisposeProviderRef<PredictionRepository>;
String _$predictionListHash() => r'935a77d6e35f567f375b2149e1d46c618789c9b6';

/// See also [predictionList].
@ProviderFor(predictionList)
final predictionListProvider = AutoDisposeProvider<List<String>>.internal(
  predictionList,
  name: r'predictionListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$predictionListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PredictionListRef = AutoDisposeProviderRef<List<String>>;
String _$inputTextHash() => r'1b59d8209e52b01f4aac3f817a4c16bf3bde940b';

/// See also [InputText].
@ProviderFor(InputText)
final inputTextProvider =
    AutoDisposeNotifierProvider<InputText, String>.internal(
      InputText.new,
      name: r'inputTextProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$inputTextHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$InputText = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
