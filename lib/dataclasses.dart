class Job {
  final String question;
  final String source;

  Job({required this.question, required this.source});

  factory Job.fromfirestore(Map<String, dynamic> data) {
    return Job(
    question: data['question'] ?? 'enter question',
    source: data['source'] ?? 'google.com');
  }
  Map<String, dynamic> toFirestore(){
    return {
      'question': this.question,
      'source': this.source,
    };
  }
}

class Result {
  final String answer;
  final String summary;
  final int views;
  final int likes;
  final String originalQuestion;
  final String ref;
  final int timestamp;

  const Result({
    required this.answer,
    required this.summary,
    required this.views,
    required this.likes,
    required this.originalQuestion,
    required this.ref,
    required this.timestamp,
  });

  factory Result.fromfirestore(String ref, Map<String, dynamic> data) {
    return Result(
        answer: data['answer'] ?? 'your answer',
        summary: data['summary'] ?? 'your summary',
        views: data['views'] ?? 0,
        likes: data['likes'] ?? 0,
        originalQuestion: data['originalQuestion'] ?? 'your question',
        ref: ref,
        timestamp:  data['timestamp'] ?? 0,
    );
  }
  Map<String, dynamic> toFirestore(){
    return {
      'answer': this.answer,
      'summary': this.summary,
      'views': this.views,
      'likes': this.likes,
    };
  }
}

