import 'dart:typed_data';

import 'package:crm_application/Models/SSSModel.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../Utils/Colors.dart';

class ViewClosedLeads extends StatelessWidget {
  const ViewClosedLeads({Key? key, required this.sss}) : super(key: key);
  final SSSModel sss;

  @override
  Widget build(BuildContext context) {
    return PdfPreviewPage(invoice: sss);
  }
}

class PdfPreviewPage extends StatelessWidget {
  final SSSModel invoice;
  const PdfPreviewPage({Key? key, required this.invoice}) : super(key: key);

  Future<Uint8List> makePdf(SSSModel invoice) async {
    final pdf = pw.Document();
    final emoji = await PdfGoogleFonts.notoColorEmoji();

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(children: [
            pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Personal Details',
                    style: pw.TextStyle(
                      fontFallback: [emoji], fontWeight: pw.FontWeight.bold,
                      // fontSize: ,
                    ),
                  ),

                  ///
                  pw.SizedBox(height: 1),
                  pw.Table(
                    border: pw.TableBorder.all(),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text('Name in full as in EID/Passport :',
                                // textAlign: pw.TextAlign.left,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text('Forename(s) :',
                                // textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text('Surname:',
                                // textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                        ],
                      ),
                      pw.TableRow(children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(invoice.fname ?? '',
                              textAlign: pw.TextAlign.left),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(invoice.forename ?? '',
                              textAlign: pw.TextAlign.left),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(invoice.surname ?? '',
                              textAlign: pw.TextAlign.left),
                        ),
                      ]),
                    ],
                  ),
                ]),

            ///
            pw.SizedBox(height: 2),
            pw.SizedBox(height: 3),
            pw.Column(children: [
              pw.SizedBox(height: 1),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('EID/ Passport Number:',
                            // textAlign: pw.TextAlign.left,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(invoice.passportNumber ?? '',
                          textAlign: pw.TextAlign.left),
                    ),
                  ]),
                ],
              ),
            ]),
            pw.SizedBox(height: 2),

            pw.Column(children: [
              pw.SizedBox(height: 2),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Nationality:',
                            // textAlign: pw.TextAlign.left,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Country of Birth:',
                            // textAlign: pw.TextAlign.center,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Passport Expiry Date:',
                            // textAlign: pw.TextAlign.center,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(invoice.nationality ?? '',
                          textAlign: pw.TextAlign.left),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(invoice.birthCountry ?? '',
                          textAlign: pw.TextAlign.left),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(invoice.passportExpiryDate ?? '',
                          textAlign: pw.TextAlign.left),
                    ),
                  ]),
                ],
              ),
            ]),
            pw.SizedBox(height: 2),
            pw.Row(children: [
              pw.Text(
                'Other Nationality Held',
                style: pw.TextStyle(
                  fontFallback: [emoji], fontWeight: pw.FontWeight.bold,
                  // fontSize: ,
                ),
              ),
              pw.SizedBox(width: 5),
              pw.Text(invoice.otherNationality ?? '',
                  textAlign: pw.TextAlign.left),
            ]),

            ///
            pw.SizedBox(height: 7),
            pw.Row(children: [
              pw.Text(
                'Occupation / Employment Details',
                style: pw.TextStyle(
                  fontFallback: [emoji], fontWeight: pw.FontWeight.bold,
                  // fontSize: ,
                ),
              ),
            ]),
            pw.SizedBox(height: 3),
            pw.Row(children: [
              pw.Text(
                'Occupation Detail:',
                style: pw.TextStyle(
                  fontFallback: [emoji], fontWeight: pw.FontWeight.normal,
                  // fontSize: ,
                ),
              ),
              pw.SizedBox(width: 5),
              pw.Text(
                invoice.occupation ?? "",
                textAlign: pw.TextAlign.left,
                style: pw.TextStyle(
                  fontFallback: [emoji], fontWeight: pw.FontWeight.bold,
                  // fontSize: ,
                ),
              ),
            ]),
            pw.Row(children: [
              pw.Text(
                'If Salaried',
                style: pw.TextStyle(
                  fontFallback: [emoji], fontWeight: pw.FontWeight.bold,
                  // fontSize: ,
                ),
              ),
            ]),
            pw.Column(children: [
              pw.SizedBox(height: 1),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Name of Company:',
                            // textAlign: pw.TextAlign.left,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Country:',
                            // textAlign: pw.TextAlign.center,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Position Held:',
                            // textAlign: pw.TextAlign.center,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(invoice.jobCompanyName??'',
                          textAlign: pw.TextAlign.left),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(invoice.jobCountryName??'',
                          textAlign: pw.TextAlign.left),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(invoice.jobPosition??'',
                          textAlign: pw.TextAlign.left),
                    ),
                  ]),
                ],
              ),
            ]),

            pw.SizedBox(height: 6),
            pw.Row(children: [
              pw.Text(
                'If Business Owner',
                style: pw.TextStyle(
                  fontFallback: [emoji], fontWeight: pw.FontWeight.bold,
                  // fontSize: ,
                ),
              ),
            ]),
            pw.Column(children: [
              pw.SizedBox(height: 1),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Name of Company:',
                            // textAlign: pw.TextAlign.left,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Country:',
                            // textAlign: pw.TextAlign.center,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Position Held:',
                            // textAlign: pw.TextAlign.center,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(invoice.businessCompanyName ?? '',
                          textAlign: pw.TextAlign.left),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(invoice.businessCountryName ?? '',
                          textAlign: pw.TextAlign.left),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(invoice.businessEntityType??'',
                          textAlign: pw.TextAlign.left),
                    ),
                  ]),
                ],
              ),
            ]),
            pw.SizedBox(height: 3),
            pw.Column(children: [
              pw.SizedBox(height: 1),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Nature of Business:',
                            // textAlign: pw.TextAlign.left,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(
                            'Countries the entity does business with or has business links to:',
                            // textAlign: pw.TextAlign.center,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child:
                          pw.Text(invoice.businessNature??'', textAlign: pw.TextAlign.left),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('',
                          textAlign: pw.TextAlign.left),
                    ),
                  ]),
                ],
              ),
            ]),

            ///
            pw.SizedBox(height: 8),
            pw.Row(children: [
              pw.Text(
                'Contact Details',
                style: pw.TextStyle(
                  fontFallback: [emoji], fontWeight: pw.FontWeight.bold,
                  // fontSize: ,
                ),
              ),
            ]),
            pw.SizedBox(height: 3),
            pw.Row(children: [
              pw.Expanded(
                child: pw.Text(
                  'Please state phone number the firm may use to contact you as: Country code - Area code - Home/Mobile/Office/Fax*',
                  style: pw.TextStyle(
                    fontFallback: [emoji], fontWeight: pw.FontWeight.normal,
                    color: PdfColor.fromInt(0xFFd72f22),
                    // fontSize: ,
                  ),
                ),
              ),
            ]),

            pw.Column(children: [
              pw.SizedBox(height: 1),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Contact',
                            // textAlign: pw.TextAlign.left,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Email:',
                            // textAlign: pw.TextAlign.center,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(invoice.phone ?? '',
                          textAlign: pw.TextAlign.left),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(invoice.email ?? '',
                          textAlign: pw.TextAlign.left),
                    ),
                  ]),
                ],
              ),
            ]),

            //
            pw.SizedBox(height: 9),
            pw.Row(children: [
              pw.Text(
                'Residential Address',
                style: pw.TextStyle(
                  fontFallback: [emoji], fontWeight: pw.FontWeight.bold,
                  // fontSize: ,
                ),
              ),
            ]),
            pw.SizedBox(height: 3),
            pw.Row(children: [
              pw.Text(
                'Residential address is the place where you are currently residing',
                style: pw.TextStyle(
                  fontFallback: [emoji], fontWeight: pw.FontWeight.normal,
                  // fontSize: ,
                ),
              ),
            ]),

            pw.Column(children: [
              pw.SizedBox(height: 1),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Address Line 1:',
                            // textAlign: pw.TextAlign.left,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(invoice.address1 ?? '',
                          textAlign: pw.TextAlign.left),
                    ),
                  ]),
                ],
              ),
            ]),

            pw.SizedBox(height: 5),

            pw.Column(children: [
              pw.SizedBox(height: 1),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Address Line 2:',
                            // textAlign: pw.TextAlign.left,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(invoice.address2 ?? '',
                          textAlign: pw.TextAlign.left),
                    ),
                  ]),
                ],
              ),
            ]),
            pw.SizedBox(height: 3),
            pw.Column(children: [
              pw.SizedBox(height: 1),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('City',
                            // textAlign: pw.TextAlign.left,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Postal Code:',
                            // textAlign: pw.TextAlign.center,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(invoice.city ?? '',
                          textAlign: pw.TextAlign.left),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(invoice.pincode ?? '',
                          textAlign: pw.TextAlign.left),
                    ),
                  ]),
                ],
              ),
            ]),
            pw.SizedBox(height: 3),
          ]);
        }));
    pdf.addPage(pw.Page(build: (context) {
      return pw.Column(
        children: [
          pw.Row(children: [
            pw.Expanded(
              child: pw.Text(
                'Note: Copies of the mandatory documents as required within the KYC & CDD process will need to be collected along with the form',
                style: pw.TextStyle(
                  fontFallback: [emoji], fontWeight: pw.FontWeight.normal,
                  // fontSize: ,
                ),
              ),
            ),
          ]),
          pw.Column(children: [
            pw.SizedBox(height: 1),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Date of Onboarding Form:',
                          // textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Full Name(AGENT)',
                          // textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Signature',
                          // textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(invoice.onboardingDate ?? '',
                        textAlign: pw.TextAlign.left),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(invoice.agentName ?? '',
                        textAlign: pw.TextAlign.left),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(invoice.signature ?? '',
                        textAlign: pw.TextAlign.left),
                  ),
                ]),
              ],
            ),
          ]),
          pw.SizedBox(height: 3),
          pw.Column(children: [
            pw.SizedBox(height: 1),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Date Of Client Meeting:',
                          // textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Client Introduced',
                          // textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Mode Of Payment',
                          // textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(invoice.dateOfClientMeeting ?? '',
                        textAlign: pw.TextAlign.left),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(invoice.clientIntroduced ?? '',
                        textAlign: pw.TextAlign.left),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(invoice.modeOfPayment ?? '',
                        textAlign: pw.TextAlign.left),
                  ),
                ]),
              ],
            ),
          ]),
          pw.SizedBox(height: 3),
          pw.Column(children: [
            pw.SizedBox(height: 1),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Unit No :',
                          // textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Developer Name',
                          // textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Property value',
                          // textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(invoice.unitNo ?? '',
                        textAlign: pw.TextAlign.left),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(invoice.developerName ?? '',
                        textAlign: pw.TextAlign.left),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(invoice.propertyValue ?? '',
                        textAlign: pw.TextAlign.left),
                  ),
                ]),
              ],
            ),
          ]),
          pw.SizedBox(height: 3),
          pw.Column(children: [
            pw.SizedBox(height: 1),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Source of Wealth/Source of fund',
                          // textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),
                pw.TableRow(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(invoice.sowSof ?? '',
                        textAlign: pw.TextAlign.left),
                  ),
                ]),
              ],
            ),
          ]),
        ],
      );
    })); // Page
    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor,
      appBar: AppBar(
        backgroundColor: themeColor,
        title:  Text(invoice.fname??''),
      ),
      body: PdfPreview(
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,

        // actions: [IconButton(onPressed: (){}, icon: Icon(Icons.print))],
        build: (context) => makePdf(invoice),
      ),
    );
  }
}
