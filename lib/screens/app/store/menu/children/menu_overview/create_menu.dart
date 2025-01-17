import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/core/utils/helper.dart';
import 'package:food_hunt/screens/app/store/menu/children/menu_overview/bloc/create_menu_bloc.dart';
import 'package:food_hunt/screens/app/store/menu/children/menu_overview/bloc/fetch_menu_bloc.dart';
import 'package:food_hunt/services/helpers/cloudinary.dart';
import 'package:food_hunt/state/store/store_tab_bloc.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:food_hunt/widgets/buttons/app_input.dart';
import 'package:food_hunt/widgets/toast/app_toast.dart';
import 'package:toastification/toastification.dart';

class CreateMenu extends ConsumerStatefulWidget {
  @override
  ConsumerState<CreateMenu> createState() => _CreateMenuState();
}

class _CreateMenuState extends ConsumerState<CreateMenu> {
  TextEditingController _menuNameController = TextEditingController();
  TextEditingController _menuDescriptionController = TextEditingController();

  final GlobalKey<FormState> _createMenuFormKey = GlobalKey<FormState>();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  File? selectedImage;

  Future<void> _pickImage() async {
    try {
      final File? image = await _cloudinaryService.pickImage();
      if (image != null) {
        if (isImageSizeValid(image)) {
          setState(() {
            selectedImage = image;
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
  Widget build(
    BuildContext context,
  ) {
    final _menuBloc = context.read<CreateMenuBloc>();

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
                    "Create Menu",
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
        body: BlocConsumer<CreateMenuBloc, CreateMenuState>(
            listener: (context, state) {
          if (state is CreateMenuSuccess) {
            ToastWidget.showToast(
              context: context,
              type: ToastificationType.success,
              title: 'Success',
              description: 'Menu created successfully!',
              icon: SvgPicture.string(
                SvgIcons.successIcon,
                width: 20,
                height: 20,
                semanticsLabel: "Success",
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            );
            Navigator.pop(context);
            context.read<StoreTabBloc>().add(OnStoreMenuTabEvent());
            context.read<FetchMenuBloc>().add(FetchAllMenu());
          }

          if (state is CreateMenuFailure) {
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
        }, builder: (context, state) {
          return SafeArea(
              child: Stack(children: [
            SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                  key: _createMenuFormKey, // Attach the GlobalKey to the Form
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Menu image",
                                  style: TextStyle(
                                    fontFamily: 'JK_Sans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.labelTextColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.grayBackground,
                                          image: selectedImage != null
                                              ? DecorationImage(
                                                  image:
                                                      FileImage(selectedImage!),
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                        ),
                                        child: selectedImage == null
                                            ? Center(
                                                child: SvgPicture.string(
                                                  SvgIcons.cameraIcon,
                                                  width: 20,
                                                  height: 20,
                                                  colorFilter: ColorFilter.mode(
                                                      AppColors.grayTextColor,
                                                      BlendMode.srcIn),
                                                ),
                                              )
                                            : null,
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                        ],
                      ),
                      const SizedBox(height: 28),
                      AppInputField(
                        label: "Menu Name",
                        hintText: 'Enter meu name',
                        controller: _menuNameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Menu name is required';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      AppTextArea(
                        label: "Description",
                        hintText: 'Enter menu description',
                        controller: _menuDescriptionController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Menu description is required';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      AppButton(
                        label: "Save",
                        isLoading: state is CreateMenuLoading,
                        isDisabled: state is CreateMenuLoading,
                        onPressed: () {
                          // Validate the form
                          if (_createMenuFormKey.currentState!.validate()) {
                            _menuBloc.add(
                              SubmitMenuDetails(
                                  name: _menuNameController.text,
                                  description: _menuDescriptionController.text,
                                  menuImage: selectedImage),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  )),
            )),
          ]));
        }));
  }
}
