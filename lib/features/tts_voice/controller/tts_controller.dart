import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../service/tts_service.dart';

part 'tts_controller.g.dart';

@riverpod
TtsService ttsVoice(Ref ref) {
  return TtsService();
}