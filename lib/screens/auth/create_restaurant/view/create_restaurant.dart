import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/config/enums.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/core/utils/helper.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/screens/auth/create_restaurant/bloc/create_restaurant_bloc.dart';
import 'package:food_hunt/services/helpers/cloudinary.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:food_hunt/widgets/buttons/app_input.dart';
import 'package:food_hunt/widgets/inputs/app_select.dart';
import 'package:food_hunt/widgets/inputs/phone_input.dart';
import 'package:food_hunt/widgets/toast/app_toast.dart';
import 'package:toastification/toastification.dart';

class CreateStoreScreen extends StatefulWidget {
  const CreateStoreScreen({Key? key}) : super(key: key);

  @override
  State<CreateStoreScreen> createState() => _CreateStoreScreenState();
}

class _CreateStoreScreenState extends State<CreateStoreScreen>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final CloudinaryService _cloudinaryService = CloudinaryService();

  File? _headerImage;
  File? _profileImage;
  String? storeType;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage(bool isHeader) async {
    try {
      final File? image = await _cloudinaryService.pickImage();
      if (image != null) {
        if (isImageSizeValid(image)) {
          setState(() {
            if (isHeader) {
              _headerImage = image;
            } else {
              _profileImage = image;
            }
          });
        } else {
          showErrorDialog(
              "Image size exceeds 5.0 MB. Please select a smaller image.",
              context);
        }
      }
    } catch (e) {
      showErrorDialog("An error occurred while uploading the image.", context);
    }
  }

  void _goToKYC() {
    Navigator.pushNamed(context, AppRoute.kycScreen);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CreateStoreBloc>();

    void _onSubmit() {
      if (_nameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _phoneController.text.isEmpty ||
          _descriptionController.text.isEmpty ||
          _addressController.text.isEmpty ||
          storeType == null ||
          _headerImage == null ||
          _profileImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please add all required details.',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: Font.jkSans.fontName),
            ),
          ),
        );
        return;
      }

      bloc.add(
        SubmitStoreDetails(
          name: _nameController.text,
          email: _emailController.text,
          phoneNumber: _phoneController.text,
          address: _addressController.text,
          description: _descriptionController.text,
          storeType: storeType!,
          profileImage: _profileImage,
          headerImage: _headerImage,
        ),
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<CreateStoreBloc, CreateStoreState>(
            listener: (context, state) {
          if (state is CreateStoreSuccess) {
            ToastWidget.showToast(
              context: context,
              type: ToastificationType.success,
              title: 'Success',
              description: 'Restaurant profile created successfully!.',
              icon: SvgPicture.string(
                SvgIcons.successIcon,
                width: 20,
                height: 20,
                semanticsLabel: "Success",
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            );
            _goToKYC();
          }

          if (state is CreateStoreFailure) {
            ToastWidget.showToast(
              context: context,
              type: ToastificationType.error,
              title: 'Error',
              description: '${state.error}',
              icon: SvgPicture.string(
                SvgIcons.errorIcon,
                width: 20,
                height: 20,
                semanticsLabel: "Success",
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            );
          }
        }, builder: (BuildContext context, CreateStoreState state) {
          return ListView(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                const Text(
                  'Create your Restaurant',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: "JK_Sans",
                    color: AppColors.bodyTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                const Text(
                  "Enter your restaurant's details, including the name, contact info, and business email, to help customers easily reach you.",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: "JK_Sans",
                    color: AppColors.subTitleTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ]),
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () {
                    _pickAndUploadImage(true);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 184,
                    decoration: BoxDecoration(
                        color: AppColors.grayBackground,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.grayBorderColor, width: 1.0)),
                    child: _headerImage == null
                        ? Center(
                            child: SizedBox(
                            width: 184,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.string(
                                  SvgIcons.thumbnailIcon,
                                  width: 50,
                                  height: 50,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "File types supported: JPG, PNG, GIF, SVG, Max size: 5 MB",
                                  style: TextStyle(
                                    fontFamily: 'JK_Sans',
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.unActiveTab,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _headerImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                  ),
                ),
                // if (_profileImage != null)
                //   Positioned(
                //     bottom: 10,
                //     right: 10,
                //     child: GestureDetector(
                //       onTap: () {
                //         _pickAndUploadImage(false);
                //       },
                //       child: CircleAvatar(
                //         radius: 20,
                //         backgroundColor: Colors.white,
                //         child: Icon(
                //           Icons.camera_alt_outlined,
                //           size: 20,
                //           color: AppColors.primary,
                //         ),
                //       ),
                //     ),
                //   ),
                Positioned(
                    bottom: -32,
                    left: 20,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.orange, // Border color
                          width: 2.0, // Border width
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          _pickAndUploadImage(false);
                        },
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: AppColors.grayBackground,
                          child: ClipOval(
                            child: Image.file(
                              _profileImage ?? File(''),
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                Icons.camera_alt_rounded,
                                size: 20,
                                color: AppColors.grayTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
            const SizedBox(height: 48),
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppInputField(
                      label: "Name",
                      hintText: 'Enter store or restaurant name',
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    AppInputField(
                      label: "Email",
                      hintText: 'Enter email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Phone number",
                          style: TextStyle(
                            fontFamily: 'JK_Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.labelTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        PhoneNumberInput(
                          label: "Phone number",
                          hintText: 'Enter phone number',
                          controller: _phoneController,
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    AppInputField(
                      label: "Address",
                      hintText: 'Enter store address',
                      controller: _addressController,
                      keyboardType: TextInputType.streetAddress,
                    ),
                    const SizedBox(height: 20),
                    AppTextArea(
                      label: "Description",
                      hintText: 'Enter restaurant description',
                      controller: _descriptionController,
                    ),
                    const SizedBox(height: 20),
                    AppDropdownSheet<String>(
                      label: 'Store type',
                      hintText: 'Select one...',
                      options: [
                        'Restaurant',
                        'Bar',
                        'Pub',
                        'Canteen',
                      ],
                      selectedValue: null,
                      optionLabelBuilder: (option) => option,
                      onChanged: (value) {
                        setState(() {
                          storeType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    AppButton(
                      label: "Next",
                      onPressed: _onSubmit,
                      isLoading: state is CreateStoreLoading,
                    ),
                  ],
                ),
              ),
            ),
          ]);
        }));
  }
}
