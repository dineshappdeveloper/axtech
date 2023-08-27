import 'package:crm_application/Screens/Cold%20Calls/MyLeads/LeadFilter/Models/agentsModel.dart';
import 'package:crm_application/Screens/Cold%20Calls/MyLeads/MyLeadScreen.dart';
import 'package:crm_application/Utils/Colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im_stepper/main.dart';
import 'package:im_stepper/stepper.dart';

class EditUser extends StatefulWidget {
  const EditUser({Key? key}) : super(key: key);

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  // THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
  int activeStep = 0; // Initial step set to 5.
  int previousStep = 0; // Initial step set to 5.
  bool steppingEnabled = true;
  int upperBound = 6; // upperBound MUST BE total number of icons minus 1.
  final GlobalKey<FormState> _introFormKey = GlobalKey();

  ///TODO:1

  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController dojController = TextEditingController();
  TextEditingController bgController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController altPhoneController = TextEditingController();

  ///TODO:2
  final GlobalKey<FormState> _addressFormKey = GlobalKey();
  TextEditingController addressController = TextEditingController();
  TextEditingController ecnumberController = TextEditingController();
  TextEditingController ecnameController = TextEditingController();
  TextEditingController ecrelationController = TextEditingController();
  TextEditingController curAddController = TextEditingController();

  ///TODO:3
  final GlobalKey<FormState> _workFormKey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool sssPermission = false;
  bool closedLeadsPermission = false;

  ///TODO:4
  final GlobalKey<FormState> _personalFormKey = GlobalKey();
  TextEditingController hccnController = TextEditingController();
  TextEditingController pemailController = TextEditingController();
  TextEditingController passportnumberController = TextEditingController();
  TextEditingController passExDateController = TextEditingController();
  TextEditingController visaExDateController = TextEditingController();
  TextEditingController visaTypeController = TextEditingController();
  TextEditingController visaNumberController = TextEditingController();

  bool allowExecution = false;

  ///TODO:5
  final GlobalKey<FormState> _bankFormKey = GlobalKey();
  List<Widget> bankList = [];

  ///TODO:6
  final GlobalKey<FormState> _travelFormKey = GlobalKey();
  TextEditingController ticketNumberController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController otherInfoController = TextEditingController();
  TextEditingController actionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: const Text('Edit User'),
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
                  Icons.supervised_user_circle,
                  color: Colors.white,
                ),
                Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                Icon(
                  Icons.work,
                  color: Colors.white,
                ),
                Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                Icon(
                  Icons.account_balance,
                  color: Colors.white,
                ),
                Icon(
                  Icons.train,
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
                  var validate = _workFormKey.currentState!.validate();
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
                                title: 'First Name',
                                label: 'First Name', maxline: 1,
                                onChange: (val) {
                                  print(val);
                                },
                                required: true, controller: fnameController,
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                // formKey: _lastNameKey,
                                title: 'Last Name',
                                label: 'Last Name',
                                maxline: 1,
                                onChange: (val) {
                                  print(val);
                                },
                                required: false, controller: lnameController,
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
                                title: 'Date Of Joining',
                                label: 'Date Of Joining', maxline: 1,
                                onChange: (val) {
                                  print(val);
                                },
                                required: false, controller: dojController,
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                // formKey: _lastNameKey,
                                title: 'Blood Group',
                                label: 'Blood Group', maxline: 1,
                                onChange: (val) {
                                  print(val);
                                },
                                required: false, controller: bgController,
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                // formKey: _lastNameKey,
                                title: 'Phone ',
                                label: 'Phone ', maxline: 1,
                                inputType: TextInputType.phone,
                                onChange: (val) {
                                  print(val);
                                },
                                required: true, controller: phoneController,
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                // formKey: _lastNameKey,
                                title: 'Alternate Contact',
                                label: 'Alternate Contact', maxline: 1,
                                inputType: TextInputType.phone,
                                onChange: (val) {
                                  print(val);
                                },
                                required: false, controller: altPhoneController,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : activeStep == 1
                      ? Form(
                          key: _addressFormKey,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  CustomTextField(
                                    // formKey: _fNameKey,
                                    title: 'Address',
                                    label: 'Address',
                                    onChange: (val) {
                                      print(val);
                                    },
                                    maxline: 2,
                                    required: true,
                                    controller: addressController,
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextField(
                                    inputType: TextInputType.phone,
                                    title: 'Emergency Contact Number',
                                    label: 'Emergency Contact Number',
                                    onChange: (val) {
                                      print(val);
                                    },
                                    required: false,
                                    controller: ecnumberController,
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextField(
                                    title: 'Emergency Contact Name',
                                    label: 'Emergency Contact Name',
                                    onChange: (val) {
                                      print(val);
                                    },
                                    required: false,
                                    controller: ecnameController,
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextField(
                                    inputType: TextInputType.phone,
                                    title: 'Emergency Contact Relationship',
                                    label: 'Emergency Contact Relationship',
                                    onChange: (val) {
                                      print(val);
                                    },
                                    required: false,
                                    controller: ecrelationController,
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextField(
                                    // formKey: _lastNameKey,
                                    maxline: 2,
                                    title: 'Current address (in U.A.E)',
                                    label: 'Current address (in U.A.E)',
                                    onChange: (val) {
                                      print(val);
                                    },
                                    required: false,
                                    controller: curAddController,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : activeStep == 2
                          ? Form(
                              key: _workFormKey,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      TestPage(
                                          title: 'Company',
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          list: [
                                            AgentById(
                                                id: 1.toString(),
                                                name: 'Range'),
                                            AgentById(
                                                id: 2.toString(),
                                                name: 'Xpertise'),
                                            AgentById(
                                                id: 3.toString(),
                                                name: 'Mymortgage'),
                                          ],
                                          onTap: (int) {
                                            print(int);
                                          },
                                          formKey: GlobalKey()),
                                      const SizedBox(height: 10),
                                      CustomTextField(
                                        // formKey: _lastNameKey,
                                        title: 'Email ',
                                        label: 'Email ', maxline: 1,
                                        onChange: (val) {
                                          print(val);
                                        },
                                        required: true,
                                        controller: emailController,
                                      ),
                                      const SizedBox(height: 10),
                                      CustomTextField(
                                        // formKey: _lastNameKey,
                                        title: 'Password ',
                                        label: 'Password ', maxline: 1,
                                        onChange: (val) {
                                          print(val);
                                        },
                                        required: false,
                                        controller: passwordController,
                                      ),
                                      const SizedBox(height: 10),
                                      TestPage(
                                          title: 'Select Role ',
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          list: [
                                            AgentById(
                                                id: 1.toString(),
                                                name: 'Admin'),
                                            AgentById(
                                                id: 2.toString(), name: 'Hr'),
                                            AgentById(
                                                id: 3.toString(),
                                                name: 'Agent'),
                                            AgentById(
                                                id: 4.toString(),
                                                name: 'Account'),
                                            AgentById(
                                                id: 5.toString(),
                                                name: 'Team Leader'),
                                            AgentById(
                                                id: 6.toString(),
                                                name: 'Jr. Team Leader'),
                                            AgentById(
                                                id: 7.toString(),
                                                name: 'Staff'),
                                          ],
                                          onTap: (int) {
                                            print(int);
                                          },
                                          formKey: GlobalKey()),
                                      const SizedBox(height: 10),
                                      TestPage(
                                          title: 'Select Designation',
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          list: [
                                            AgentById(
                                                id: 1.toString(),
                                                name: 'Admin'),
                                            AgentById(
                                                id: 2.toString(), name: 'Hr'),
                                            AgentById(
                                                id: 3.toString(),
                                                name: 'Agent'),
                                            AgentById(
                                                id: 4.toString(),
                                                name: 'Account'),
                                            AgentById(
                                                id: 5.toString(),
                                                name: 'Team Leader'),
                                            AgentById(
                                                id: 6.toString(),
                                                name: 'Jr. Team Leader'),
                                            AgentById(
                                                id: 7.toString(),
                                                name: 'Staff'),
                                          ],
                                          onTap: (int) {
                                            print(int);
                                          },
                                          formKey: GlobalKey()),
                                      const SizedBox(height: 10),
                                      TestPage(
                                          title: 'Reporting Perso',
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          list: [
                                            AgentById(
                                                id: 1.toString(),
                                                name: 'Admin'),
                                            AgentById(
                                                id: 2.toString(), name: 'Hr'),
                                            AgentById(
                                                id: 3.toString(),
                                                name: 'Agent'),
                                            AgentById(
                                                id: 4.toString(),
                                                name: 'Account'),
                                            AgentById(
                                                id: 5.toString(),
                                                name: 'Team Leader'),
                                            AgentById(
                                                id: 6.toString(),
                                                name: 'Jr. Team Leader'),
                                            AgentById(
                                                id: 7.toString(),
                                                name: 'Staff'),
                                          ],
                                          onTap: (int) {
                                            print(int);
                                          },
                                          formKey: GlobalKey()),
                                      const SizedBox(height: 10),
                                      TestPage(
                                          title: 'Status',
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          list: [
                                            AgentById(
                                                id: 1.toString(),
                                                name: 'Active'),
                                            AgentById(
                                                id: 2.toString(),
                                                name: 'InActive'),
                                          ],
                                          onTap: (int) {
                                            print(int);
                                          },
                                          formKey: GlobalKey()),
                                      const SizedBox(height: 10),
                                      TestPage(
                                          title: 'Availability',
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          list: [
                                            AgentById(
                                                id: 1.toString(),
                                                name: 'Available'),
                                            AgentById(
                                                id: 2.toString(),
                                                name: 'In Meating'),
                                            AgentById(
                                                id: 3.toString(),
                                                name: 'Seek Leave'),
                                            AgentById(
                                                id: 4.toString(),
                                                name: 'Annual Leave'),
                                          ],
                                          onTap: (int) {
                                            print(int);
                                          },
                                          formKey: GlobalKey()),
                                      const SizedBox(height: 10),
                                      CheckboxListTile(
                                          title: const Text(
                                            'Permission for SSS ?',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          value: sssPermission,
                                          onChanged: (val) {
                                            setState(() {
                                              sssPermission = !sssPermission;
                                            });
                                          }),
                                      const SizedBox(height: 10),
                                      CheckboxListTile(
                                          title: const Text(
                                            'Permission for Closed Leads ?',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          value: closedLeadsPermission,
                                          onChanged: (val) {
                                            setState(() {
                                              closedLeadsPermission =
                                                  !closedLeadsPermission;
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : activeStep == 3
                              ? Form(
                                  key: _personalFormKey,
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          CustomTextField(
                                            // formKey: _fNameKey,
                                            title:
                                                'Home Country Contact Number',
                                            label:
                                                'Home Country Contact Number',
                                            onChange: (val) {
                                              print(val);
                                            },
                                            required: true,
                                            controller: hccnController,
                                          ),
                                          const SizedBox(height: 10),
                                          CustomTextField(
                                            // formKey: _lastNameKey,
                                            title: 'Personal Email',
                                            label: 'Personal Email',
                                            onChange: (val) {
                                              print(val);
                                            },
                                            required: false,
                                            controller: pemailController,
                                          ),
                                          const SizedBox(height: 10),
                                          CustomTextField(
                                            // formKey: _lastNameKey,
                                            title: 'Passport Number',
                                            label: 'Passport Number',
                                            onChange: (val) {
                                              print(val);
                                            },
                                            required: false,
                                            controller:
                                                passportnumberController,
                                          ),
                                          const SizedBox(height: 10),
                                          CustomTextField(
                                            // formKey: _lastNameKey,
                                            title: 'Passport Expiry date',
                                            label: 'Passport Expiry date',
                                            onChange: (val) {
                                              print(val);
                                            },
                                            required: true,
                                            controller: passExDateController,
                                          ),
                                          const SizedBox(height: 10),
                                          CustomTextField(
                                            // formKey: _lastNameKey,
                                            title: 'Visa Expiry date',
                                            label: 'Visa Expiry date',
                                            onChange: (val) {
                                              print(val);
                                            },
                                            required: true,
                                            controller: visaExDateController,
                                          ),
                                          const SizedBox(height: 10),
                                          CustomTextField(
                                            // formKey: _lastNameKey,
                                            title: 'Visa Type',
                                            label: 'Visa Type',
                                            onChange: (val) {
                                              print(val);
                                            },
                                            required: true,
                                            controller: visaTypeController,
                                          ),
                                          const SizedBox(height: 10),
                                          CustomTextField(
                                            // formKey: _lastNameKey,
                                            title: 'Visa Number',
                                            label: 'Visa Number',
                                            onChange: (val) {
                                              print(val);
                                            },
                                            required: true,
                                            controller: visaNumberController,
                                          ),
                                          const SizedBox(height: 10),
                                          TestPage(
                                              title: 'Education Details',
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                              list: [
                                                AgentById(
                                                    id: 1.toString(),
                                                    name: 'High School'),
                                                AgentById(
                                                    id: 2.toString(),
                                                    name: 'Graduation'),
                                                AgentById(
                                                    id: 3.toString(),
                                                    name: 'Master'),
                                              ],
                                              onTap: (int) {
                                                print(int);
                                              },
                                              formKey: GlobalKey()),
                                          const SizedBox(height: 10),
                                          CheckboxListTile(
                                              title: const Text(
                                                'Allow exclusion list',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              value: allowExecution,
                                              onChanged: (val) {
                                                setState(() {
                                                  allowExecution =
                                                      !allowExecution;
                                                });
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : activeStep == 4
                                  ? Form(
                                      key: _bankFormKey,
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              ...bankList
                                                  .map((e) => Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Account ${bankList.indexOf(e)}',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        22,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .green),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 20),
                                                          e,
                                                        ],
                                                      ))
                                                  .toList(),
                                              const SizedBox(height: 20),
                                              ElevatedButton(
                                                onPressed: () {
                                                  bankList.add(AddBankForm());
                                                  setState(() {});
                                                },
                                                child: Text('Add New Bank'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Form(
                                      key: _travelFormKey,
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              CustomTextField(
                                                // formKey: _fNameKey,
                                                title: 'TICKET NUMBER	',
                                                label: 'TICKET NUMBER	',
                                                onChange: (val) {
                                                  print(val);
                                                },
                                                required: true,
                                                controller:
                                                    ticketNumberController,
                                              ),
                                              const SizedBox(height: 10),
                                              CustomTextField(
                                                // formKey: _lastNameKey,
                                                title: 'DATE',
                                                label: 'DATE',
                                                onChange: (val) {
                                                  print(val);
                                                },
                                                required: false,
                                                controller: dateController,
                                              ),
                                              const SizedBox(height: 10),
                                              CustomTextField(
                                                // formKey: _lastNameKey,
                                                title: 'OTHER INFORMATION	',
                                                label: 'OTHER INFORMATION	',
                                                onChange: (val) {
                                                  print(val);
                                                },
                                                required: false,
                                                controller: otherInfoController,
                                              ),
                                              const SizedBox(height: 10),
                                              CustomTextField(
                                                // formKey: _lastNameKey,
                                                title: 'ACTION',
                                                label: 'ACTION',
                                                onChange: (val) {
                                                  print(val);
                                                },
                                                required: false,
                                                controller: actionController,
                                              ),
                                              const SizedBox(height: 30),
                                              ElevatedButton(
                                                  onPressed: () {},
                                                  child:
                                                      const Text('Add New ')),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     previousButton(),
            //     nextButton(),
            //   ],
            // ),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              headerText(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
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
        return 'Address';

      case 2:
        return 'Work Info';

      case 3:
        return 'Personal Information';

      case 4:
        return 'Bank Details';

      case 5:
        return 'Add Travel details';

      default:
        return 'Introduction';
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
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
