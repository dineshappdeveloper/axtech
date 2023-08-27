import 'package:crm_application/Screens/Cold%20Calls/MyLeads/LeadFilter/Models/agentsModel.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/MyLeadScreen.dart';
import 'package:crm_application/Utils/Colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im_stepper/main.dart';
import 'package:im_stepper/stepper.dart';

class EditClosedLeads extends StatefulWidget {
  const EditClosedLeads({Key? key}) : super(key: key);

  @override
  State<EditClosedLeads> createState() => _EditClosedLeadsState();
}

class _EditClosedLeadsState extends State<EditClosedLeads> {
  // THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
  int activeStep = 0; // Initial step set to 5.
  int previousStep = 0; // Initial step set to 5.
  bool steppingEnabled = true;
  int upperBound = 6; // upperBound MUST BE total number of icons minus 1.
  final GlobalKey<FormState> _introFormKey = GlobalKey();

  ///TODO:1

  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController surNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController comissionController = TextEditingController();
  TextEditingController bgController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController birthCountryController = TextEditingController();
  TextEditingController passExDateController = TextEditingController();
  bool otherNationalityHeld = false;

  ///TODO:2
  final GlobalKey<FormState> _occupationFormKey = GlobalKey();
  List<MapEntry> occupationOption = const [
    MapEntry(1, 'Salaried'),
    MapEntry(2, 'Business Owner'),
    MapEntry(3, 'Housewife'),
    MapEntry(4, 'Retired'),
    MapEntry(5, 'Student'),
    MapEntry(6, 'Other (please specify):'),
  ];
  int? selectedOccupation;
  TextEditingController occupationController = TextEditingController();

  ///TODO:3
  final GlobalKey<FormState> _salariedFormKey = GlobalKey();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController positionHeldController = TextEditingController();

  ///TODO:4
  final GlobalKey<FormState> _bussinessFormKey = GlobalKey();
  TextEditingController bcomnameController = TextEditingController();
  TextEditingController bconController = TextEditingController();
  TextEditingController bentityController = TextEditingController();
  TextEditingController bnatureController = TextEditingController();
  TextEditingController blinksController = TextEditingController();

  ///TODO:5
  final GlobalKey<FormState> _contactFormKey = GlobalKey();
  TextEditingController contactemailController = TextEditingController();
  TextEditingController contactPhoneController = TextEditingController();

  //
  List<Widget> bankList = [];

  ///TODO:6
  final GlobalKey<FormState> _residentialAddressFormKey = GlobalKey();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController dateOfOnBoardingController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController signatureController = TextEditingController();
  TextEditingController dateOfClientMeetingController = TextEditingController();
  TextEditingController clientIntroducedController = TextEditingController();
  TextEditingController paymentModeController = TextEditingController();
  TextEditingController unitNoController = TextEditingController();
  TextEditingController developerNameController = TextEditingController();
  TextEditingController propertyValueeController = TextEditingController();
  TextEditingController sowsofController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: const Text('Closed Lead Edit'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.save)),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            IconStepper(
              stepReachedAnimationEffect: Curves.easeInOut,
              enableNextPreviousButtons: false,
              enableStepTapping: true,
              stepColor: themeColor.withOpacity(0.2),
              activeStepColor: themeColor,
              activeStepBorderColor: themeColor,
              activeStepBorderWidth: 2,
              // steppingEnabled: steppingEnabled,
              icons: const [
                Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                Icon(
                  Icons.business,
                  color: Colors.white,
                ),
                Icon(
                  Icons.work,
                  color: Colors.white,
                ),
                Icon(
                  Icons.contact_mail,
                  color: Colors.white,
                ),
                Icon(
                  Icons.contact_phone,
                  color: Colors.white,
                ),
                Icon(
                  Icons.home,
                  color: Colors.white,
                ),
              ],
              activeStep: activeStep,
              onStepReached: (index) {
                setState(() {
                  activeStep = index;
                });
                if (previousStep == 0) {
                  var validate = _introFormKey.currentState!.validate();
                  print(validate);
                  if (validate) {
                    print('validated');
                  } else {
                    setState(() {
                      activeStep = previousStep;
                    });
                  }
                }
                if (previousStep == 2) {
                  var validate = _salariedFormKey.currentState!.validate();
                  print(validate);
                  if (validate) {
                    print('validated');
                  } else {
                    setState(() {
                      activeStep = previousStep;
                    });
                  }
                }
                previousStep = activeStep;
                if (kDebugMode) {
                  print(activeStep);
                  print(previousStep);
                }
              },
            ),
            header(),
            Expanded(
              child: activeStep == 0
                  ? Form(
                      key: _introFormKey,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CustomTextField(
                                // formKey: _fNameKey,
                                title: 'Name in full as in EID/Passport: *',
                                label: 'Name in full as in EID/Passport',
                                maxline: 1,
                                onChange: (val) {
                                  print(val);
                                },
                                required: true, controller: fnameController,
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                // formKey: _lastNameKey,
                                title: 'Forename(s): *',
                                label: 'Forename(s)',
                                maxline: 1,
                                onChange: (val) {
                                  print(val);
                                },
                                required: true, controller: lnameController,
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                // formKey: _lastNameKey,
                                title: 'Surname',
                                label: 'Surname',
                                maxline: 1,
                                onChange: (val) {
                                  print(val);
                                },
                                required: false, controller: surNameController,
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                // formKey: _lastNameKey,
                                title: 'Date Of Birth',
                                label: 'Date Of Birth', maxline: 1,
                                onChange: (val) {
                                  print(val);
                                },
                                required: false, controller: dobController,
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                // formKey: _lastNameKey,
                                title: 'Commission',
                                label: 'Date Of Joining', maxline: 1,
                                onChange: (val) {
                                  print(val);
                                },
                                required: false,
                                controller: comissionController,
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                // formKey: _lastNameKey,
                                title: 'EID/ Passport Number:',
                                label: 'EID/ Passport Number', maxline: 1,
                                inputType: TextInputType.number,
                                onChange: (val) {
                                  print(val);
                                },
                                required: false, controller: bgController,
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                // formKey: _lastNameKey,
                                title: 'Nationality',
                                label: 'Nationality ', maxline: 1,
                                inputType: TextInputType.text,
                                onChange: (val) {
                                  print(val);
                                },
                                required: false,
                                controller: nationalityController,
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                // formKey: _lastNameKey,
                                title: 'Country of Birth',
                                label: 'Country of Birth', maxline: 1,
                                inputType: TextInputType.text,
                                onChange: (val) {
                                  print(val);
                                },
                                required: false,
                                controller: birthCountryController,
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                // formKey: _lastNameKey,
                                title: 'Passport Expiry Date',
                                label: 'Passport Expiry Date', maxline: 1,
                                inputType: TextInputType.text,
                                onChange: (val) {
                                  print(val);
                                },
                                required: false,
                                controller: passExDateController,
                              ),
                              const SizedBox(height: 10),
                              CheckboxListTile(
                                  title: const Text(
                                    'Other Nationality Held:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  value: otherNationalityHeld,
                                  onChanged: (val) {
                                    setState(() {
                                      otherNationalityHeld =
                                          !otherNationalityHeld;
                                    });
                                  }),
                            ],
                          ),
                        ),
                      ),
                    )
                  : activeStep == 1
                      ? Form(
                          key: _occupationFormKey,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Wrap(
                                children: [
                                  ...occupationOption.map((e) {
                                    return RadioListTile<int>(
                                      value: e.key,
                                      groupValue: selectedOccupation,
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() {
                                            selectedOccupation = val;
                                          });
                                        }
                                      },
                                      title: Text(e.value),
                                    );
                                  }),
                                  if (selectedOccupation == 6)
                                    CustomTextField(
                                        onChange: (val) {},
                                        title: 'Occupation Name',
                                        label: 'Occupation Name',
                                        required: false,
                                        controller: occupationController)
                                ],
                              ),
                            ),
                          ),
                        )
                      : activeStep == 2
                          ? Form(
                              key: _salariedFormKey,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      CustomTextField(
                                        // formKey: _fNameKey,
                                        title: 'Name of Company',
                                        label: 'Name of Company',
                                        onChange: (val) {
                                          print(val);
                                        },
                                        required: false,
                                        controller: companyNameController,
                                      ),
                                      const SizedBox(height: 10),
                                      CustomTextField(
                                        // formKey: _lastNameKey,
                                        title: 'Country',
                                        label: 'Country',
                                        onChange: (val) {
                                          print(val);
                                        },
                                        required: false,
                                        controller: countryController,
                                      ),
                                      const SizedBox(height: 10),
                                      CustomTextField(
                                        // formKey: _lastNameKey,
                                        title: 'Position Held',
                                        label: 'Position Held',
                                        onChange: (val) {
                                          print(val);
                                        },
                                        required: false,
                                        controller: positionHeldController,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : activeStep == 3
                              ? Form(
                                  key: _bussinessFormKey,
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          CustomTextField(
                                            // formKey: _fNameKey,
                                            title: 'Name of Company',
                                            label: 'Name of Company',
                                            onChange: (val) {
                                              print(val);
                                            },
                                            required: false,
                                            controller: bcomnameController,
                                          ),
                                          const SizedBox(height: 10),
                                          CustomTextField(
                                            // formKey: _lastNameKey,
                                            title: 'Country',
                                            label: 'Country',
                                            onChange: (val) {
                                              print(val);
                                            },
                                            required: false,
                                            controller: bconController,
                                          ),
                                          const SizedBox(height: 10),
                                          CustomTextField(
                                            // formKey: _lastNameKey,
                                            title: 'Entity Type',
                                            label: 'Entity Type',
                                            onChange: (val) {
                                              print(val);
                                            },
                                            required: false,
                                            controller: bentityController,
                                          ),
                                          const SizedBox(height: 10),
                                          CustomTextField(
                                            // formKey: _lastNameKey,
                                            title: 'Nature of Business',
                                            label: 'Nature of Business',
                                            onChange: (val) {
                                              print(val);
                                            },
                                            required: false,
                                            controller: bnatureController,
                                          ),
                                          const SizedBox(height: 10),
                                          CustomTextField(
                                            // formKey: _lastNameKey,
                                            title:
                                                'Countries the entity does business with or has business links to:',
                                            label: 'links',
                                            onChange: (val) {
                                              print(val);
                                            },
                                            required: false,
                                            controller: blinksController,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : activeStep == 4
                                  ? Form(
                                      key: _contactFormKey,
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              CustomTextField(
                                                // formKey: _fNameKey,
                                                title: 'Phone Number',
                                                label: 'Phone Number',
                                                onChange: (val) {
                                                  print(val);
                                                },
                                                required: false,
                                                controller:
                                                    contactPhoneController,
                                              ),
                                              const SizedBox(height: 10),
                                              CustomTextField(
                                                // formKey: _lastNameKey,
                                                title: 'Email Address',
                                                label: 'Email Address',
                                                onChange: (val) {
                                                  print(val);
                                                },
                                                required: false,
                                                controller:
                                                    contactemailController,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Form(
                                      key: _residentialAddressFormKey,
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              CustomTextField(
                                                // formKey: _lastNameKey,
                                                title: 'Address Line 1',
                                                label: 'Address Line 1',
                                                maxline: 1,
                                                onChange: (val) {
                                                  print(val);
                                                },
                                                required: true,
                                                controller: address1Controller,
                                              ),
                                              const SizedBox(height: 10),
                                              CustomTextField(
                                                // formKey: _lastNameKey,
                                                title: 'Address Line 2',
                                                label: 'Address Line 2',
                                                maxline: 1,
                                                onChange: (val) {
                                                  print(val);
                                                },
                                                required: false,
                                                controller: address2Controller,
                                              ),
                                              const SizedBox(height: 10),
                                              CustomTextField(
                                                // formKey: _lastNameKey,
                                                title: 'City',
                                                label: 'City', maxline: 1,
                                                onChange: (val) {
                                                  print(val);
                                                },
                                                required: false,
                                                controller: cityController,
                                              ),
                                              const SizedBox(height: 10),
                                              CustomTextField(
                                                // formKey: _lastNameKey,
                                                title: 'Postal Code',
                                                label: 'Postal Code',
                                                maxline: 1,
                                                onChange: (val) {
                                                  print(val);
                                                },
                                                required: false,
                                                controller:
                                                    postalCodeController,
                                              ),
                                              const SizedBox(height: 10),

                                              //
                                              CustomTextField(
                                                // formKey: _fNameKey,
                                                title:
                                                    'Date of Onboarding Form',
                                                label:
                                                    'Date of Onboarding Form',
                                                onChange: (val) {
                                                  print(val);
                                                },
                                                maxline: 2,
                                                required: false,
                                                controller:
                                                    dateOfOnBoardingController,
                                              ),
                                              const SizedBox(height: 10),
                                              CustomTextField(
                                                inputType: TextInputType.phone,
                                                title: 'Full Name(AGENT)',
                                                label: 'Full Name(AGENT)',
                                                onChange: (val) {
                                                  print(val);
                                                },
                                                required: false,
                                                controller: fullNameController,
                                              ),
                                              const SizedBox(height: 10),
                                              CustomTextField(
                                                title: 'Signature',
                                                label: 'Signature',
                                                onChange: (val) {
                                                  print(val);
                                                },
                                                required: false,
                                                controller: signatureController,
                                              ),
                                              const SizedBox(height: 10),
                                              CustomTextField(
                                                inputType: TextInputType.phone,
                                                title: 'Date Of Client Meeting',
                                                label: 'Date Of Client Meeting',
                                                onChange: (val) {
                                                  print(val);
                                                },
                                                required: false,
                                                controller:
                                                    dateOfClientMeetingController,
                                              ),
                                              const SizedBox(height: 10),
                                              CustomTextField(
                                                // formKey: _lastNameKey,
                                                maxline: 2,
                                                title: 'Client Introduced',
                                                label: 'Client Introduced',
                                                onChange: (val) {
                                                  print(val);
                                                },
                                                required: false,
                                                controller:
                                                    clientIntroducedController,
                                              ),
                                              const SizedBox(height: 10),
                                              CustomTextField(
                                                // formKey: _lastNameKey,
                                                maxline: 2,
                                                title: 'Mode Of Payment',
                                                label: 'Mode Of Payment',
                                                onChange: (val) {
                                                  print(val);
                                                },
                                                required: false,
                                                controller:
                                                    paymentModeController,
                                              ),
                                              const SizedBox(height: 10),
                                              CustomTextField(
                                                // formKey: _lastNameKey,
                                                maxline: 2,
                                                title: 'Unit No.',
                                                label: 'Unit No.',
                                                onChange: (val) {
                                                  print(val);
                                                },
                                                required: false,
                                                controller: unitNoController,
                                              ),
                                              const SizedBox(height: 10),
                                              CustomTextField(
                                                // formKey: _lastNameKey,
                                                maxline: 2,
                                                title: 'Developer Name',
                                                label: 'Developer Name',
                                                onChange: (val) {
                                                  print(val);
                                                },
                                                required: false,
                                                controller:
                                                    developerNameController,
                                              ),
                                              const SizedBox(height: 10),
                                              CustomTextField(
                                                // formKey: _lastNameKey,
                                                maxline: 2,
                                                title: 'Property value',
                                                label: 'Property value',
                                                onChange: (val) {
                                                  print(val);
                                                },
                                                required: false,
                                                controller:
                                                    propertyValueeController,
                                              ),
                                              const SizedBox(height: 10),
                                              CustomTextField(
                                                // formKey: _lastNameKey,
                                                maxline: 2,
                                                title: 'SOW/SOF',
                                                label: 'SOW/SOF',
                                                onChange: (val) {
                                                  print(val);
                                                },
                                                required: false,
                                                controller: sowsofController,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns the next button.
  Widget nextButton() {
    return ElevatedButton(
      onPressed: () {
        // Increment activeStep, when the next button is tapped. However, check for upper bound.
        if (activeStep < upperBound) {
          setState(() {
            activeStep++;
          });
        }
      },
      child: const Text('Next'),
    );
  }

  /// Returns the previous button.
  Widget previousButton() {
    return ElevatedButton(
      onPressed: () {
        // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
        if (activeStep > 0) {
          setState(() {
            activeStep--;
          });
        }
      },
      child: const Text('Prev'),
    );
  }

  /// Returns the header wrapping the header text.
  Widget header() {
    return Container(
      decoration: BoxDecoration(
        color: themeColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                headerText(),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Returns the header text based on the activeStep.
  String headerText() {
    switch (activeStep) {
      case 1:
        return 'Occupation / Employment Details';

      case 2:
        return 'If Salaried';

      case 3:
        return 'If Business Owner';

      case 4:
        return 'Contact Details';

      case 5:
        return 'Residential Address';

      default:
        return 'Personal Details';
    }
  }
}

class CustomTextField extends StatelessWidget {
  CustomTextField({
    Key? key,
    required this.onChange,
    required this.title,
    required this.label,
    required this.required,
    required this.controller,
    this.inputType,
    this.maxline,
    // required this.formKey,
  }) : super(key: key);
  final void Function(String val) onChange;
  final String title;
  final String label;
  final bool required;
  final TextEditingController controller;
  final TextInputType? inputType;
  final int? maxline;

  // final GlobalKey<FormState> formKey;
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                // key: formKey,
                // focusNode: focusNode,
                controller: controller,
                keyboardType: inputType,
                maxLines: maxline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: label,
                ),
                onChanged: (val) {
                  onChange(val);
                },
                validator: (val) {
                  if (required) {
                    print(val);

                    if (val!.isEmpty) {
                      return '$title is required';
                    }
                  } else {
                    print('No');
                  }
                },
                onEditingComplete: () {
                  // print('Editing completed');
                  // formKey.currentState?.validate();
                },
              ),
            )
          ],
        )
      ],
    );
  }
}

class AddBankForm extends StatelessWidget {
  AddBankForm({Key? key}) : super(key: key);
  TextEditingController bankNameController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController bankAccountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          // formKey: _fNameKey,
          title: 'Bank Name',
          label: 'Bank Name',
          onChange: (val) {
            print(val);
          },
          required: true,
          controller: bankNameController,
        ),
        const SizedBox(height: 10),
        CustomTextField(
          // formKey: _lastNameKey,
          title: 'IFSC Code of Bank',
          label: 'IFSC Code of Bank',
          onChange: (val) {
            print(val);
          },
          required: false,
          controller: ifscController,
        ),
        const SizedBox(height: 10),
        CustomTextField(
          // formKey: _lastNameKey,
          title: 'Bank Account Number',
          label: 'Bank Account Number',
          onChange: (val) {
            print(val);
          },
          required: false,
          controller: bankAccountController,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
