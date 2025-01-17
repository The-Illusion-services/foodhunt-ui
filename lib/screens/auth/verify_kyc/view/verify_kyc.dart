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
import 'package:food_hunt/screens/auth/verify_kyc/bloc/verify_kyc_bloc.dart';
import 'package:food_hunt/services/helpers/cloudinary.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:food_hunt/widgets/buttons/app_input.dart';
import 'package:food_hunt/widgets/toast/app_toast.dart';
import 'package:toastification/toastification.dart';

class VerifyKYCScreen extends StatefulWidget {
  const VerifyKYCScreen({Key? key}) : super(key: key);

  @override
  State<VerifyKYCScreen> createState() => _VerifyKYCScreenState();
}

class _VerifyKYCScreenState extends State<VerifyKYCScreen> {
  final TextEditingController _ninController = TextEditingController();

  final CloudinaryService _cloudinaryService = CloudinaryService();

  bool _isUploading = false;
  String? uploadedNinImageUrl;
  File? selectedImage;

  @override
  void dispose() {
    _ninController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final File? image = await _cloudinaryService.pickImage();
      if (image != null) {
        if (isImageSizeValid(image)) {
          setState(() {
            selectedImage = image;
            _isUploading = true;
          });

          final String? url = await _cloudinaryService.uploadImage(image);
          if (url != null) {
            setState(() {
              uploadedNinImageUrl = url;
            });
          } else {
            showErrorDialog("Image upload failed. Please try again.", context);
          }
        } else {
          showErrorDialog(
              "Image size exceeds 5.0 MB. Please select a smaller image.",
              context);
        }
      }
    } catch (e) {
      showErrorDialog("An error occurred while uploading the image.", context);
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _goToDashboard() {
    Navigator.pushNamed(context, AppRoute.storeLayout);
  }

  void _goToDashboardPlaceholder() {
    // Navigator.pushNamed(context, AppRoute.unverifiedKYCDashboard);
    Navigator.pushNamed(context, AppRoute.storeLayout);
  }

  @override
  Widget build(BuildContext context) {
    final verifyKycBloc = context.read<VerifyKYCBloc>();

    void _onSubmit() {
      if (_ninController.text.isEmpty || uploadedNinImageUrl == null) {
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

      verifyKycBloc.add(
        SubmitKYCDetails(
          nin: _ninController.text,
          ninImage: uploadedNinImageUrl!,
        ),
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<VerifyKYCBloc, VerifyKYCState>(
            listener: (context, state) {
          if (state is VerifyKYCSuccess) {
            ToastWidget.showToast(
              context: context,
              type: ToastificationType.success,
              title: 'Success',
              description: 'KYC details verified successfully!.',
              icon: SvgPicture.string(
                SvgIcons.successIcon,
                width: 20,
                height: 20,
                semanticsLabel: "Success",
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            );
            _goToDashboard();
          }

          if (state is VerifyKYCFailure) {
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
        }, builder: (BuildContext context, VerifyKYCState state) {
          return Stack(children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 48, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        Text(
                          'KYC Verification',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: "JK_Sans",
                            color: AppColors.bodyTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Upload a valid NIN of the admin registering the account. This ensures secure and verified access to manage your restaurant.",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: "JK_Sans",
                            color: AppColors.subTitleTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 50),
                        AppInputField(
                          label: "NIN No.",
                          hintText: 'Enter your NIN number',
                          controller: _ninController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'NIN number is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Upload Image",
                              style: TextStyle(
                                fontFamily: 'JK_Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.labelTextColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _pickAndUploadImage,
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F6F6),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.grayBorderColor,
                              ),
                            ),
                            child: uploadedNinImageUrl == null
                                ? Center(
                                    child: SvgPicture.string(
                                      SvgIcons.cameraIcon,
                                      width: 50,
                                      height: 50,
                                      colorFilter: ColorFilter.mode(
                                          AppColors.grayTextColor,
                                          BlendMode.srcIn),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      uploadedNinImageUrl!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      AppButton(
                        label: "Submit",
                        onPressed: _onSubmit,
                        isLoading: state is VerifyKYCLoading,
                      ),
                      const SizedBox(height: 16),
                      SecondaryAppButton(
                        label: "Skip and finish setup",
                        onPressed: state is VerifyKYCLoading
                            ? null
                            : _goToDashboardPlaceholder,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_isUploading)
              Container(
                color: Colors.black.withOpacity(0.5),
                alignment: Alignment.center,
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? const CupertinoActivityIndicator(radius: 20)
                    : const CircularProgressIndicator(),
              ),
          ]);
        }));
  }
}
