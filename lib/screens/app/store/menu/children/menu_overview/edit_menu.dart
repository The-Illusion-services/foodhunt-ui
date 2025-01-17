import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/core/utils/helper.dart';
import 'package:food_hunt/screens/app/store/menu/children/menu_overview/bloc/edit_menu_bloc.dart';
import 'package:food_hunt/screens/app/store/menu/children/menu_overview/bloc/fetch_menu_bloc.dart';
import 'package:food_hunt/services/helpers/cloudinary.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:food_hunt/widgets/buttons/app_input.dart';
import 'package:food_hunt/widgets/toast/app_toast.dart';
import 'package:toastification/toastification.dart';

class EditMenu extends StatefulWidget {
  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  late TextEditingController _menuNameController;
  late TextEditingController _menuDescriptionController;
  final GlobalKey<FormState> _editMenuFormKey = GlobalKey<FormState>();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  late final String? _menuId;

  File? selectedImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args == null || !args.containsKey('menuId')) {
        showErrorDialog(
          "Invalid menu data. Please try again.",
          context,
        );
      } else {
        setState(() {
          _menuNameController =
              TextEditingController(text: args['name'] as String? ?? '');
          _menuDescriptionController =
              TextEditingController(text: args['description'] as String? ?? '');
          final imagePath = args['image'] as String?;
          selectedImage = imagePath != null ? File(imagePath) : null;
          _menuId = args['menuId'] as String? ?? '';
        });
      }
    });
  }

  @override
  void dispose() {
    _menuNameController.dispose();
    _menuDescriptionController.dispose();
    super.dispose();
  }

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
                    "Edit Menu",
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
          )),
      body: BlocConsumer<EditMenuBloc, EditMenuState>(
        listener: (context, state) {
          if (state is EditMenuSuccess) {
            ToastWidget.showToast(
              context: context,
              type: ToastificationType.success,
              title: 'Success',
              description: 'Menu updated successfully!',
            );
            Navigator.pop(context);
            Navigator.pop(context);
            context.read<FetchMenuBloc>()..add(FetchAllMenu());
          } else if (state is EditMenuFailure) {
            ToastWidget.showToast(
              context: context,
              type: ToastificationType.error,
              title: 'Error',
              description: state.error,
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _editMenuFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.grayBackground,
                        backgroundImage: selectedImage != null
                            ? FileImage(selectedImage!)
                            : null,
                        child: selectedImage == null
                            ? Icon(Icons.camera_alt,
                                color: AppColors.grayTextColor)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppInputField(
                      label: "Menu Name",
                      hintText: "Enter menu name",
                      controller: _menuNameController,
                      validator: (value) => value == null || value.isEmpty
                          ? "Menu name is required"
                          : null,
                    ),
                    const SizedBox(height: 24),
                    AppTextArea(
                      label: "Description",
                      hintText: "Enter menu description",
                      controller: _menuDescriptionController,
                      validator: (value) => value == null || value.isEmpty
                          ? "Menu description is required"
                          : null,
                    ),
                    const SizedBox(height: 32),
                    AppButton(
                      label: "Save",
                      isLoading: state is EditMenuLoading,
                      isDisabled: state is EditMenuLoading,
                      onPressed: () {
                        if (_editMenuFormKey.currentState?.validate() == true) {
                          context.read<EditMenuBloc>().add(
                                SubmitMenuDetails(
                                    name: _menuNameController.text,
                                    description:
                                        _menuDescriptionController.text,
                                    menuImage: selectedImage,
                                    menuId: _menuId!),
                              );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
