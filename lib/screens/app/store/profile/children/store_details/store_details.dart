import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/states/error_state.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/core/utils/helper.dart';
import 'package:food_hunt/screens/app/store/profile/bloc/store_profile_bloc.dart';
import 'package:food_hunt/screens/app/store/profile/children/store_details/bloc/upload_store_details_bloc.dart';
import 'package:food_hunt/services/helpers/cloudinary.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:food_hunt/widgets/buttons/app_input.dart';
import 'package:food_hunt/widgets/inputs/app_select.dart';
import 'package:food_hunt/widgets/inputs/phone_input.dart';
import 'package:food_hunt/widgets/toast/app_toast.dart';
import 'package:toastification/toastification.dart';

class StoreDetails extends StatefulWidget {
  @override
  _StoreDetailsState createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final CloudinaryService _cloudinaryService = CloudinaryService();
  File? _profileImage;
  File? _headerImage;
  String? _storeType;

  @override
  void initState() {
    super.initState();
    context.read<StoreProfileBloc>().add(FetchStoreProfile());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x40BEBEBE),
                offset: Offset(0, 4),
                blurRadius: 21.0,
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: SvgPicture.string(
                        SvgIcons.arrowLeftIcon,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  "Store Details",
                  style: TextStyle(
                    fontFamily: 'JK_Sans',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.bodyTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocListener<UpdateStoreDetailsBloc, UpdateStoreDetailsState>(
        listener: (context, state) {
          if (state is StoreDetailsUpdated) {
            ToastWidget.showToast(
              context: context,
              type: ToastificationType.success,
              title: 'Success',
              description: 'Store details updated successfully!',
              icon: SvgPicture.string(SvgIcons.successIcon),
            );
            Navigator.pop(context);
          } else if (state is StoreDetailsUpdateError) {
            ToastWidget.showToast(
              context: context,
              type: ToastificationType.error,
              title: 'Error',
              description: state.message,
              icon: SvgPicture.string(SvgIcons.errorIcon),
            );
          }
        },
        child: BlocBuilder<StoreProfileBloc, StoreProfileState>(
          builder: (context, state) {
            if (state is StoreProfileLoading) {
              return Center(
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? const CupertinoActivityIndicator(
                        radius: 20,
                        color: AppColors.primary,
                      )
                    : const CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
              );
            } else if (state is StoreProfileLoaded) {
              _nameController.text =
                  state.profileData['restaurant']['name'] ?? '';
              _descriptionController.text =
                  state.profileData['restaurant']['bio'] ?? '';
              _emailController.text =
                  state.profileData['restaurant']['email'] ?? '';
              _addressController.text =
                  state.profileData['restaurant']['address']['address'] ?? '';
              _phoneController.text =
                  state.profileData['restaurant']['phone'] ?? '';

              _storeType = state.profileData['restaurant']['category'] ?? '';

              return ListView(
                children: [
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
                                  color: AppColors.grayBorderColor,
                                  width: 1.0)),
                          child: _headerImage == null
                              ? Center(
                                  child: SizedBox(
                                  width: 184,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AppInputField(
                            label: "Store Name",
                            hintText: 'Enter store name',
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Store name is required.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          AppTextArea(
                            label: "Description",
                            hintText: 'Enter description',
                            controller: _descriptionController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Description is required.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          AppInputField(
                            label: "Business Address",
                            hintText: 'Enter business address',
                            controller: _addressController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Business address is required.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          AppInputField(
                            label: "Business Email",
                            hintText: 'Enter business email',
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Business email is required.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          PhoneNumberInput(
                            label: "Phone Number",
                            hintText: 'Enter phone number',
                            controller: _phoneController,
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
                            selectedValue: _storeType,
                            optionLabelBuilder: (option) => option,
                            onChanged: (value) {
                              setState(() {
                                _storeType = value;
                              });
                            },
                          ),
                          const SizedBox(height: 40),
                          AppButton(
                            onPressed: () {
                              // if (_formKey.currentState!.validate()) {
                              context.read<UpdateStoreDetailsBloc>().add(
                                    UpdateStoreProfile(
                                      name: _nameController.text.trim(),
                                      description:
                                          _descriptionController.text.trim(),
                                      address: _addressController.text.trim(),
                                      email: _emailController.text.trim(),
                                      phoneNumber: _phoneController.text.trim(),
                                      storeType: _storeType!,
                                      profileImage: _profileImage,
                                      headerImage: _headerImage,
                                    ),
                                  );
                              // }
                            },
                            label: 'Save',
                            isLoading: context
                                .watch<UpdateStoreDetailsBloc>()
                                .state is StoreDetailsUpdating,
                            isDisabled: context
                                .watch<UpdateStoreDetailsBloc>()
                                .state is StoreDetailsUpdating,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is StoreProfileError) {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: errorState(
                    context: context,
                    onTap: () => context.read<StoreProfileBloc>().add(
                          FetchStoreProfile(),
                        ),
                  ));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
