import 'package:flutter/material.dart';
import '../models/archetype.dart';
import '../models/requirements.dart';
import '../models/content_block.dart';

class AppProvider extends ChangeNotifier {
  Archetype? _selectedArchetype;
  Requirements _requirements = Requirements();
  List<ContentBlock> _contentBlocks = [];
  int _nextBlockOrder = 0;

  Archetype? get selectedArchetype => _selectedArchetype;
  Requirements get requirements => _requirements;
  List<ContentBlock> get contentBlocks => List.unmodifiable(_contentBlocks);

  void selectArchetype(Archetype archetype) {
    _selectedArchetype = archetype;
    notifyListeners();
  }

  void updateRequirements(Requirements requirements) {
    _requirements = requirements;
    notifyListeners();
  }

  void addImage(String imageName) {
    _requirements = _requirements.copyWith(
      imageNames: [..._requirements.imageNames, imageName],
    );
    notifyListeners();
  }

  void updateTextDescription(String description) {
    _requirements = _requirements.copyWith(textDescription: description);
    notifyListeners();
  }

  void updateVoiceNoteDescription(String description) {
    _requirements = _requirements.copyWith(voiceNoteDescription: description);
    notifyListeners();
  }

  // Content Block Management
  void addContentBlock(ContentBlock block) {
    _contentBlocks.add(block);
    _contentBlocks.sort((a, b) => a.order.compareTo(b.order));
    notifyListeners();
  }

  void addTextBlock() {
    final block = TextBlock(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      order: _nextBlockOrder++,
    );
    addContentBlock(block);
  }

  void addImageBlock() {
    final block = ImageBlock(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      order: _nextBlockOrder++,
    );
    addContentBlock(block);
  }

  void addVoiceBlock() {
    final block = VoiceBlock(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      order: _nextBlockOrder++,
    );
    addContentBlock(block);
  }

  void updateContentBlock(ContentBlock updatedBlock) {
    final index = _contentBlocks.indexWhere((block) => block.id == updatedBlock.id);
    if (index != -1) {
      _contentBlocks[index] = updatedBlock;
      notifyListeners();
    }
  }

  void removeContentBlock(String blockId) {
    _contentBlocks.removeWhere((block) => block.id == blockId);
    notifyListeners();
  }

  void reorderContentBlocks(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final ContentBlock item = _contentBlocks.removeAt(oldIndex);
    _contentBlocks.insert(newIndex, item);
    
    // Update order values
    for (int i = 0; i < _contentBlocks.length; i++) {
      _contentBlocks[i] = _contentBlocks[i].copyWith(order: i);
    }
    
    notifyListeners();
  }

  Requirements buildRequirementsFromBlocks() {
    final textBlocks = _contentBlocks.whereType<TextBlock>();
    final imageBlocks = _contentBlocks.whereType<ImageBlock>();
    final voiceBlocks = _contentBlocks.whereType<VoiceBlock>();

    final combinedText = textBlocks
        .where((block) => block.content.isNotEmpty)
        .map((block) => block.content)
        .join('\n\n');

    final imageNames = imageBlocks
        .where((block) => block.fileName != null)
        .map((block) => block.fileName!)
        .toList();

    final voiceNotes = voiceBlocks
        .where((block) => block.description.isNotEmpty)
        .map((block) => block.description)
        .join('\n\n');

    return Requirements(
      textDescription: combinedText.isNotEmpty ? combinedText : null,
      imageNames: imageNames,
      voiceNoteDescription: voiceNotes.isNotEmpty ? voiceNotes : null,
    );
  }

  void reset() {
    _selectedArchetype = null;
    _requirements = Requirements();
    _contentBlocks.clear();
    _nextBlockOrder = 0;
    notifyListeners();
  }
}