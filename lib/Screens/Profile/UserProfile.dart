import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:crm_application/Provider/AuthProvider.dart';
import 'package:crm_application/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../ApiManager/Apis.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int? userId, phone;
  var authToken,
      fName = '',
      lName = '',
      email = ''; //address='Please fill the address';
  late SharedPreferences prefs;
  bool _isLoading = true;
  File? _image;
  final picker = ImagePicker();
  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _altPhoneController = TextEditingController();
  final _addressController = TextEditingController();
  var images = '';
  String? userProfile, address;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckState();
  }

  void CheckState() async {
    prefs = await SharedPreferences.getInstance();
    setState(
      () {
        userId = prefs.getInt('userId')!;
        fName = prefs.getString('fname')!;
        lName = prefs.getString('lname')!;
        email = prefs.getString('email')!;
        phone = prefs.getInt('phone')!;
        address = prefs.getString('address');
        authToken = prefs.getString('token');
        userProfile = prefs.getString('image');
      },
    );

    debugPrint('CheckUserId : $userId');
    debugPrint('CheckUserName : $fName');
    debugPrint('CheckUserLName : $lName');
  }

  Future<void> uploadImage() async {
    var url = ApiManager.BASE_URL + ApiManager.updateProfilePicture;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $authToken',
      'Accept': 'application/json',
    };
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );
    request.files
        .add(await http.MultipartFile.fromPath('user_profile', _image!.path));
    request.fields['user_id'] = userId.toString();
    request.headers.addAll(headers);
    var res = await request.send();
    var responseData = await res.stream.toBytes();
    var result = String.fromCharCodes(responseData);
    log('ImageResponse : ${result.toString()}');
    var imageResponse = json.decode(result.toString());
    var success = imageResponse['success'];
    var data = imageResponse['data'];
    if (success == 200) {
      setState(
        () {
          var images = data['user_profile'];
          prefs.setString('image', images);
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('success'),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const UserProfile(),
        ),
      );
    } else {
      setState(
        () {
          _isLoading = false;
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        titleSpacing: 0,
        title: const Text(
          "User Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) => Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1),
                        ),
                        child: Badge(
                          badgeColor: themeColor,
                          animationDuration: const Duration(seconds: 10),
                          position: BadgePosition.bottomEnd(),
                          badgeContent: const Icon(
                            Icons.camera_alt_outlined,
                            size: 15,
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: userProfile == null
                                ? Image.asset(
                                    'assets/images/person.jpeg',
                                    scale: 3,
                                  )
                                : SizedBox(
                                    height: 85.h,
                                    width: 80.w,
                                    child: Image.network(
                                      userProfile!,
                                      // height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User ID : ${userId.toString()}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          '$fName $lName', //"Testing User",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Phone : $phone",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'First Name',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _fNameController,
                      decoration: InputDecoration(
                        fillColor: Colors.grey[150],
                        filled: true,
                        labelText: fName,
                        prefixIcon: const Icon(Icons.edit),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: const [
                        Text(
                          'Last Name',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _lNameController,
                      decoration: InputDecoration(
                          fillColor: Colors.grey[150],
                          filled: true,
                          labelText: lName,
                          prefixIcon: const Icon(Icons.edit),
                          border: const OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: const [
                        Text(
                          'Email Id',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                          fillColor: Colors.grey[150],
                          filled: true,
                          hintText: email,
                          prefixIcon: const Icon(Icons.email),
                          border: const OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: const [
                        Text(
                          'Phone',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                      decoration: InputDecoration(
                          fillColor: Colors.grey[150],
                          filled: true,
                          labelText: phone.toString(),
                          prefixIcon: const Icon(Icons.edit),
                          border: const OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: const [
                        Text(
                          'Alternate Contact',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _altPhoneController,
                      decoration: InputDecoration(
                        fillColor: Colors.grey[150],
                        filled: true,
                        labelText: 'Please fill alternate contact',
                        prefixIcon: const Icon(Icons.edit),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: const [
                        Text(
                          'Address',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        fillColor: Colors.grey[150],
                        filled: true,
                        labelText: address ?? 'Please fill the address',
                        //'Please fill the address',
                        prefixIcon: const Icon(Icons.edit),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    !authProvider.isLoading
                        ? InkWell(
                            onTap: () {
                              setState(
                                () {
                                  authProvider.UpdateProfile(
                                    userId.toString(),
                                    _fNameController.text.isEmpty
                                        ? fName
                                        : _fNameController.text,
                                    _lNameController.text.isEmpty
                                        ? lName
                                        : _lNameController.text,
                                    _phoneController.text.isEmpty
                                        ? phone.toString()
                                        : _phoneController.text,
                                    _altPhoneController.text,
                                    _addressController.text,
                                    authToken.toString(),
                                    context,
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  "UPDATE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          uploadImage();
          debugPrint('Image path : ${_image!.path.toString()}');
        } else {
          debugPrint("No image selected");
        }
      });
    } catch (e) {
      debugPrint("Image picker error $e");
    }
  }

  Future getImageWithCamera() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 90);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      uploadImage();
    } else {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No image selected'),
          ),
        );
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Pick From Gallery'),
                      onTap: () {
                        _pickImage();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      getImageWithCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
