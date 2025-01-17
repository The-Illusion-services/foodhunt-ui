import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/core/utils/helper.dart';
import 'package:food_hunt/screens/app/store/menu/children/dishes/bloc/edit_dish_bloc.dart';
import 'package:food_hunt/screens/app/store/menu/children/dishes/bloc/fetch_dishes_bloc.dart';
import 'package:food_hunt/screens/app/store/menu/children/menu_overview/bloc/fetch_menu_dishes_bloc.dart';
import 'package:food_hunt/services/helpers/cloudinary.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:food_hunt/widgets/buttons/app_input.dart';
import 'package:food_hunt/widgets/toast/app_toast.dart';
import 'package:toastification/toastification.dart';

class ViewDish extends ConsumerStatefulWidget {
  @override
  ConsumerState<ViewDish> createState() => _ViewDishState();
}

class _ViewDishState extends ConsumerState<ViewDish> {
  late TextEditingController _itemNameController;
  late TextEditingController _itemDescriptionController;
  late TextEditingController _basePriceController;
  TextEditingController _menuController = TextEditingController();

  bool _isAvailable = false;
  String? _dishImageUrl;
  File? selectedImage;
  String? dishId;
  String? menuId;

  final CloudinaryService _cloudinaryService = CloudinaryService();
  final GlobalKey<FormState> _editDishFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initializing the controllers
    _itemNameController = TextEditingController();
    _itemDescriptionController = TextEditingController();
    _basePriceController = TextEditingController();
    _menuController = TextEditingController();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    // Fetching arguments from the ModalRoute
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final dishDetails = arguments?['dish'];
    // var menuId = arguments?['menuId'];

    print(dishDetails);
    print(arguments);

    // Populate fields with initial data
    if (dishDetails != null) {
      _itemNameController.text = dishDetails['name'] ?? '';
      _itemDescriptionController.text = dishDetails['description'] ?? '';
      _basePriceController.text = dishDetails['price']?.toString() ?? '';
      _menuController.text = dishDetails['menu']['id']?.toString() ?? '';
      _isAvailable = dishDetails['is_available'] ?? false;
      _dishImageUrl = dishDetails['dish_image'] as String?;
      // selectedImage = await urlToFile(imagePath!);

      dishId = dishDetails['id']?.toString() ?? '';
      // menuId = menuId ?? '';
    }
  }

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
  Widget build(BuildContext context) {
    final _dishBloc = context.read<EditDishBloc>();

    print(selectedImage);

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
                  "Edit dish",
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
      body:
          BlocConsumer<EditDishBloc, EditDishState>(listener: (context, state) {
        if (state is EditDishSuccess) {
          ToastWidget.showToast(
            context: context,
            type: ToastificationType.success,
            title: 'Success',
            description: 'Dish updated successfully!',
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
          if (menuId != null) {
            context
                .read<FetchMenuDishesBloc>()
                .add(FetchMenuDishes(menuId: menuId!));
          }
        }

        if (state is EditDishFailure) {
          ToastWidget.showToast(
            context: context,
            type: ToastificationType.error,
            title: 'Error',
            description: '${state.error}',
            icon: SvgPicture.string(
              SvgIcons.errorIcon,
              width: 20,
              height: 20,
              semanticsLabel: "Error",
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          );
        }
      }, builder: (context, state) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              children: [
                Form(
                  key: _editDishFormKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      AppInputField(
                        label: "Name",
                        hintText: 'Enter dish name',
                        controller: _itemNameController,
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 24),
                      AppTextArea(
                        label: "Description",
                        hintText: 'Describe the dish',
                        controller: _itemDescriptionController,
                      ),
                      const SizedBox(height: 24),
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
                              width: 1.0,
                            ),
                          ),
                          child: selectedImage == null
                              ? (_dishImageUrl != null &&
                                      _dishImageUrl!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        _dishImageUrl!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Center(
                                          child: Text(
                                            "Image could not be loaded.",
                                            style: TextStyle(
                                              fontFamily: 'JK_Sans',
                                              fontSize: 14.0,
                                              color: AppColors.labelTextColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        "No image selected. Tap to upload.",
                                        style: TextStyle(
                                          fontFamily: 'JK_Sans',
                                          fontSize: 14.0,
                                          color: AppColors.labelTextColor,
                                        ),
                                      ),
                                    ))
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
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
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            inactiveTrackColor: AppColors.grayBackground,
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
                      const SizedBox(height: 32),
                      AppButton(
                        label: "Save Changes",
                        isLoading: state is EditDishLoading,
                        isDisabled: state is EditDishLoading,
                        onPressed: () {
                          if (_editDishFormKey.currentState!.validate()) {
                            _dishBloc.add(
                              SubmitDishDetails(
                                  name: _itemNameController.text,
                                  description: _itemDescriptionController.text,
                                  price: _basePriceController.text,
                                  isAvailable: _isAvailable,
                                  dishImage: selectedImage!,
                                  dishId: dishId!),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
