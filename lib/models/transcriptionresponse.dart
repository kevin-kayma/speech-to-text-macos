class ResTranscriptionResponse {
  final ResResults results;

  ResTranscriptionResponse({required this.results});

  factory ResTranscriptionResponse.fromJson(Map<String, dynamic> json) {
    return ResTranscriptionResponse(
      results: ResResults.fromJson(json['results']),
    );
  }
}

class ResResults {
  final List<ResChannel> channels;

  ResResults({required this.channels});

  factory ResResults.fromJson(Map<String, dynamic> json) {
    return ResResults(
      channels: (json['channels'] as List)
          .map((channel) => ResChannel.fromJson(channel))
          .toList(),
    );
  }
}

class ResChannel {
  final List<ResAlternative> alternatives;

  ResChannel({required this.alternatives});

  factory ResChannel.fromJson(Map<String, dynamic> json) {
    return ResChannel(
      alternatives: (json['alternatives'] as List)
          .map((alt) => ResAlternative.fromJson(alt))
          .toList(),
    );
  }
}

class ResAlternative {
  final String transcript;
  final double confidence;
  final ResParagraphs paragraphs;

  ResAlternative({
    required this.transcript,
    required this.confidence,
    required this.paragraphs,
  });

  factory ResAlternative.fromJson(Map<String, dynamic> json) {
    return ResAlternative(
      transcript: json['transcript'],
      confidence: json['confidence'].toDouble(),
      paragraphs: ResParagraphs.fromJson(json['paragraphs']),
    );
  }
}

class ResParagraphs {
  final String transcript;
  final List<ResParagraph> paragraphs;

  ResParagraphs({required this.transcript, required this.paragraphs});

  factory ResParagraphs.fromJson(Map<String, dynamic> json) {
    return ResParagraphs(
      transcript: json['transcript'],
      paragraphs: (json['paragraphs'] as List)
          .map((para) => ResParagraph.fromJson(para))
          .toList(),
    );
  }
}

class ResParagraph {
  final List<ResSentence> sentences;
  final int numWords;
  final double start;
  final double end;

  ResParagraph({
    required this.sentences,
    required this.numWords,
    required this.start,
    required this.end,
  });

  factory ResParagraph.fromJson(Map<String, dynamic> json) {
    return ResParagraph(
      sentences: (json['sentences'] as List)
          .map((sentence) => ResSentence.fromJson(sentence))
          .toList(),
      numWords: json['num_words'],
      start: json['start'].toDouble(),
      end: json['end'].toDouble(),
    );
  }
}

class ResSentence {
  final String text;
  final double start;
  final double end;

  ResSentence({required this.text, required this.start, required this.end});

  factory ResSentence.fromJson(Map<String, dynamic> json) {
    return ResSentence(
      text: json['text'],
      start: json['start'].toDouble(),
      end: json['end'].toDouble(),
    );
  }
}
