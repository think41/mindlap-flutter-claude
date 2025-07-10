class Requirements {
  final String? textDescription;
  final List<String> imageNames;
  final String? voiceNoteDescription;

  Requirements({
    this.textDescription,
    this.imageNames = const [],
    this.voiceNoteDescription,
  });

  Requirements copyWith({
    String? textDescription,
    List<String>? imageNames,
    String? voiceNoteDescription,
  }) {
    return Requirements(
      textDescription: textDescription ?? this.textDescription,
      imageNames: imageNames ?? this.imageNames,
      voiceNoteDescription: voiceNoteDescription ?? this.voiceNoteDescription,
    );
  }
}