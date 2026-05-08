import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  static Future<void> generateReport({
    required String title,
    required List<Map<String, String>> summaryData,
    required List<Map<String, String>> topRoutes,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('SomSafar System Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.Text(DateTime.now().toString().split(' ')[0]),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(title, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Divider(),
            pw.SizedBox(height: 20),
            
            pw.Text('Executive Summary', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              context: context,
              data: <List<String>>[
                <String>['Metric', 'Value'],
                ...summaryData.map((e) => [e['label']!, e['value']!]),
              ],
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
              cellHeight: 30,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
              },
            ),
            
            pw.SizedBox(height: 30),
            pw.Text('Top Performing Routes', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              context: context,
              data: <List<String>>[
                <String>['Route', 'Revenue', 'Tickets'],
                ...topRoutes.map((e) => [e['name']!, e['revenue']!, e['tickets']!]),
              ],
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
              cellHeight: 30,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
              },
            ),
            
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 50),
              child: pw.Text('Report generated automatically by SomSafar Admin System.', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
            ),
          ];
        },
      ),
    );

    // Save or Preview
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'SomSafar_Report_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }
}
