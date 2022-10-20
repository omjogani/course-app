class Question {
  final String question;
  final List<Option> options;
  bool isLocked;
  Option? selectedOption;

  Question({
    required this.question,
    required this.options,
    this.isLocked = false,
    this.selectedOption,
  });
}

class Option {
  final String text;
  final bool isCorrect;

  const Option({
    required this.text,
    required this.isCorrect,
  });
}

final questions = [
  Question(
    question: "What is CSS?",
    options: [
      const Option(text: "Server", isCorrect: false),
      const Option(text: "Javascript Framework", isCorrect: false),
      const Option(text: "Stylesheets", isCorrect: true),
      const Option(text: "Game", isCorrect: false),
    ],
  ),
  Question(
    question: "What is Dart?",
    options: [
      const Option(text: "Programming Language", isCorrect: true),
      const Option(text: "Framework", isCorrect: false),
      const Option(text: "Technology of AI", isCorrect: false),
      const Option(text: "Movie", isCorrect: false),
    ],
  ),
  Question(
    question: "What is Flutter?",
    options: [
      const Option(text: "Javascript Framework", isCorrect: false),
      const Option(text: "Google Mobile UI Development Kit that used to build mobile apps", isCorrect: true),
      const Option(text: "Browser", isCorrect: false),
      const Option(text: "Google Mobile UI Development Kit that is not used to build mobile apps", isCorrect: false),
    ],
  ),
];
