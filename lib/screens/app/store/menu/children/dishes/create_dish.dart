import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/constants/app_constants.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/core/utils/helper.dart';
import 'package:food_hunt/screens/app/store/menu/children/dishes/bloc/create_dish_bloc.dart';
import 'package:food_hunt/screens/app/store/menu/children/dishes/bloc/fetch_dishes_bloc.dart';
import 'package:food_hunt/screens/app/store/menu/children/dishes/widgets/menu_selector.dart';
import 'package:food_hunt/services/helpers/cloudinary.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:food_hunt/widgets/buttons/app_input.dart';
import 'package:food_hunt/widgets/toast/app_toast.dart';
import 'package:toastification/toastification.dart';

class CreateDish extends ConsumerStatefulWidget {
  @override
  ConsumerState<CreateDish> createState() => _CreateDishState();
}

class _CreateDishState extends ConsumerState<CreateDish> {
  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _itemDescriptionController = TextEditingController();
  TextEditingController _basePriceController = TextEditingController();
  TextEditingController _menuController = TextEditingController();
  TextEditingController minController = TextEditingController();

  final CloudinaryService _cloudinaryService = CloudinaryService();
  final GlobalKey<FormState> _createDishFormKey = GlobalKey<FormState>();

  bool _isAvailable = false;
  String? dishImageUrl;
  File? selectedImage;

  Future<void> _pickAndUploadImage() async {
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
    final _dishBloc = context.read<CreateDishBloc>();

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
                    "Create New Dish",
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
        body: BlocConsumer<CreateDishBloc, CreateDishState>(
            listener: (context, state) {
          if (state is CreateDishSuccess) {
            ToastWidget.showToast(
              context: context,
              type: ToastificationType.success,
              title: 'Success',
              description: 'Dish created successfully!',
              icon: SvgPicture.string(
                SvgIcons.successIcon,
                width: 20,
                height: 20,
                semanticsLabel: "Success",
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            );
            Navigator.pop(context);
            context.read<FetchDishBloc>().add(FetchAllDishes());
          }

          if (state is CreateDishFailure) {
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
              child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(children: [
                        Form(
                            key: _createDishFormKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 24),
                                AppInputField(
                                  label: "Dish Name",
                                  hintText: 'Enter dish name',
                                  controller: _itemNameController,
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Dish name is required';
                                    }

                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),
                                AppTextArea(
                                  label: "Description",
                                  hintText: 'Describe the dish',
                                  controller: _itemDescriptionController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Description is required';
                                    }

                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Text(
                                      "Attach image",
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
                                    width: double.infinity,
                                    height: 168,
                                    decoration: BoxDecoration(
                                        color: AppColors.grayBackground,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: AppColors.grayBorderColor,
                                            width: 1.0)),
                                    child: selectedImage == null
                                        ? Center(
                                            child: SizedBox(
                                            width: 190,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                    color:
                                                        AppColors.unActiveTab,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ))
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                              selectedImage!,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                AppInputField(
                                  label: "Price",
                                  hintText: 'Enter dish cost',
                                  controller: _basePriceController,
                                  keyboardType: TextInputType.number,
                                  prefixIcon: IconButton(
                                      icon: Text(
                                        naira,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: AppColors.subTitleTextColor),
                                      ),
                                      onPressed: null),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Price is required';
                                    }

                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Make available",
                                      style: TextStyle(
                                        fontFamily: 'JK_Sans',
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.bodyTextColor,
                                      ),
                                    ),
                                    Switch.adaptive(
                                      inactiveTrackColor:
                                          AppColors.grayBackground,
                                      activeTrackColor: AppColors.primary,
                                      value: _isAvailable,
                                      onChanged: (value) {
                                        setState(() {
                                          _isAvailable = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                MenuSelector(
                                  controller: _menuController,
                                  cursorColor: AppColors.primary,
                                  textColor: AppColors.bodyTextColor,
                                  onCategorySelected: (value) {
                                    print('Selected category: $value');
                                  },
                                ),
                                const SizedBox(height: 32),
                                AppButton(
                                  label: "Next",
                                  isLoading: state is CreateDishLoading,
                                  isDisabled: state is CreateDishLoading,
                                  onPressed: () {
                                    final stuff = {
                                      'name': _itemNameController.text,
                                      'description':
                                          _itemDescriptionController.text,
                                      'price': _basePriceController.text,
                                      'menu': _menuController.text,
                                      'is_available': _isAvailable,
                                      'dish_image': selectedImage
                                    };
                                    print(stuff);
                                    if (_createDishFormKey.currentState!
                                        .validate()) {
                                      _dishBloc.add(
                                        SubmitDishDetails(
                                            name: _itemNameController.text,
                                            description:
                                                _itemDescriptionController.text,
                                            price: _basePriceController.text,
                                            isAvailable: _isAvailable,
                                            dishImage: selectedImage!,
                                            menuId: _menuController.text),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 24),
                              ],
                            )),
                      ]))));
        }));
  }
}
