class ResultModel {
  final DateTime date;
  final String timeSlot;
  final String resultNumbers;
  final String pdfUrl;

  ResultModel({
    required this.date,
    required this.timeSlot,
    required this.resultNumbers,
    required this.pdfUrl,
  });

  static String generatePdfUrl(DateTime date, String type) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString().substring(2);
    return "https://nagalandstatelotterysambad.com/wp-content/uploads/20$year/$month/$type$day$month$year.pdf";
  }

  factory ResultModel.forDate(DateTime date, String timeSlot) {
    String type;
    switch (timeSlot) {
      case 'Morning':
        type = 'MD';
        break;
      case 'Evening':
        type = 'DD';
        break;
      case 'Night':
        type = 'ED';
        break;
      default:
        type = 'MD';
    }
    
    return ResultModel(
      date: date,
      timeSlot: timeSlot,
      resultNumbers: 'a[###]b[###]', // Placeholder for actual results
      pdfUrl: generatePdfUrl(date, type),
    );
  }
}
