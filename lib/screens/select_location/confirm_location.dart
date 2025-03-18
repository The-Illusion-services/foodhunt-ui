import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/config/enums.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/screens/app/user/home/bloc/address_bloc.dart';
import 'package:food_hunt/screens/app/user/profile/children/add_address/bloc/add_address_bloc.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:food_hunt/widgets/buttons/app_input.dart';
import 'package:food_hunt/widgets/toast/app_toast.dart';
import 'package:toastification/toastification.dart';

// Stateful Widget
class ConfirmLocationScreen extends StatefulWidget {
  final List<dynamic> coordinates;
  final String placeName;

  const ConfirmLocationScreen({
    Key? key,
    required this.coordinates,
    required this.placeName,
  }) : super(key: key);

  @override
  _ConfirmLocationScreenState createState() => _ConfirmLocationScreenState();
}

class _ConfirmLocationScreenState extends State<ConfirmLocationScreen> {
  final _addressController = TextEditingController();
  final _labelController = TextEditingController();

  bool _isPrimary = false;
  String _selectedLabel = 'Home';
  bool _showOtherLabelInput = false;

  final List<Map<String, dynamic>> _labelOptions = [
    {'label': 'Home', 'icon': Icons.home},
    {'label': 'Work', 'icon': Icons.work},
    {'label': 'School', 'icon': Icons.school},
    {'label': 'Gym', 'icon': Icons.fitness_center},
    {'label': 'Other', 'icon': Icons.more_horiz},
  ];

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.placeName;
  }

  @override
  Widget build(BuildContext context) {
    final _addressBloc = context.read<AddAddressBloc>();

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
                  "Save Address",
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
      body: BlocConsumer<AddAddressBloc, AddAddressState>(
        listener: (context, state) {
          if (state is AddressAdded) {
            ToastWidget.showToast(
              context: context,
              type: ToastificationType.success,
              title: 'Success',
              description: 'Address saved!',
              icon: SvgPicture.string(
                SvgIcons.successIcon,
                width: 20,
                height: 20,
                semanticsLabel: "Success",
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            );
            Navigator.pop(context);
            context.read<UserAddressBloc>().add(FetchUserAddress());
          }

          if (state is AddressError) {
            ToastWidget.showToast(
              context: context,
              type: ToastificationType.error,
              title: 'Error',
              description: '${state.message}',
              icon: SvgPicture.string(
                SvgIcons.errorIcon,
                width: 20,
                height: 20,
                semanticsLabel: "Success",
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppInputField(
                    label: "Address",
                    hintText: 'Enter address',
                    controller: _addressController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Address is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Text(
                  //   'Coordinates: ${widget.coordinates[0]}, ${widget.coordinates[1]}',
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     color: AppColors.grayTextColor,
                  //   ),
                  // ),
                  // SizedBox(height: 20),
                  Text(
                    "Give your address a label",
                    style: TextStyle(
                      fontFamily: 'JK_Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.labelTextColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _labelOptions.map((option) {
                      return OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _selectedLabel = option['label'];
                            _showOtherLabelInput = option['label'] == 'Other';
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: _selectedLabel == option['label']
                                ? AppColors.primary
                                : AppColors.grayTextColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        icon: Icon(
                          option['icon'],
                          size: 16,
                          color: _selectedLabel == option['label']
                              ? AppColors.primary
                              : AppColors.grayTextColor,
                        ),
                        label: Text(
                          option['label'],
                          style: TextStyle(
                            color: _selectedLabel == option['label']
                                ? AppColors.primary
                                : AppColors.grayTextColor,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  if (_showOtherLabelInput)
                    AppInputField(
                      label: "Custom Label",
                      hintText: 'Enter custom label',
                      controller: _labelController,
                      maxLength: 30,
                    ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        activeColor: AppColors.primary,
                        value: _isPrimary,
                        onChanged: (value) {
                          setState(() {
                            _isPrimary = value!;
                          });
                        },
                      ),
                      Text('Set as primary address',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: Font.jkSans.fontName,
                              fontWeight: FontWeight.w500,
                              color: AppColors.grayTextColor)),
                    ],
                  ),

                  SizedBox(height: 100),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: AppButton(
                label: "Save address",
                isLoading: state is AddressLoading,
                isDisabled: state is AddressLoading,
                onPressed: () {
                  final label = _selectedLabel == 'Other'
                      ? _labelController.text
                      : _selectedLabel;

                  _addressBloc.add(
                    AddAddress(
                      address: _addressController.text,
                      isPrimary: _isPrimary,
                      label: label,
                      longitude: widget.coordinates[0].toString(),
                      latitude: widget.coordinates[1].toString(),
                    ),
                  );
                },
              ),
            ),
          ]);
        },
      ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    _labelController.dispose();
    super.dispose();
  }
}
