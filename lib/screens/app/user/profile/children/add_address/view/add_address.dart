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

class AddAddressScreen extends StatefulWidget {
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _addressController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _streetController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _labelController = TextEditingController();

  bool _isPrimary = false;
  String _selectedLabel = 'Home';
  bool _showOtherLabelInput = false;
  String _selectedState = 'Delta';

  final List<Map<String, dynamic>> _labelOptions = [
    {'label': 'Home', 'icon': Icons.home},
    {'label': 'Work', 'icon': Icons.work},
    {'label': 'School', 'icon': Icons.school},
    {'label': 'Other', 'icon': Icons.more_horiz},
  ];

  final List<Map<String, String>> _landmarkOptions = [
    {'value': 'IVIE ROAD', 'label': 'IVIE ROAD'},
    {'value': 'OLORI19 AREA', 'label': 'OLORI19 AREA'},
    {'value': 'NEWEKU AGBOR ROAD', 'label': 'NEWEKU AGBOR ROAD'},
    {'value': 'FSP/HOSPITALROAD', 'label': 'FSP/HOSPITALROAD'},
    {'value': 'NUT', 'label': 'NUT'},
    {'value': 'NUTEXTENSION', 'label': 'NUTEXTENSION'},
    {'value': 'OBADUDU', 'label': 'OBADUDU'},
    {'value': 'POLICESTATION ROAD', 'label': 'POLICESTATION ROAD'},
    {'value': 'CAMPUS3 BIG GATE', 'label': 'CAMPUS3 BIG GATE'},
    {'value': 'BEMBO', 'label': 'BEMBO'},
    {'value': 'URHUOKA', 'label': 'URHUOKA'},
    {'value': 'CAMPUS2 AREA', 'label': 'CAMPUS2 AREA'},
    {'value': 'AGHWANAAVENUE', 'label': 'AGHWANAAVENUE'},
    {'value': 'IGBOQUATERS', 'label': 'IGBOQUATERS'},
    {'value': 'POULTRYROAD BEGINNING', 'label': 'POULTRYROAD BEGINNING'},
    {'value': 'POULTRYROAD ENDING', 'label': 'POULTRYROAD ENDING'},
    {'value': 'CAMPUS4 ROAD', 'label': 'CAMPUS4 ROAD'},
    {'value': 'CAMPUS1 ROAD', 'label': 'CAMPUS1 ROAD'},
    {'value': 'COLLEGEROAD', 'label': 'COLLEGEROAD'},
    {'value': 'EKREJETA', 'label': 'EKREJETA'},
    {'value': 'RIVERROAD', 'label': 'RIVERROAD'},
    {'value': 'BENINROAD/JUNCTION', 'label': 'BENINROAD/JUNCTION'},
    {'value': 'UMONO', 'label': 'UMONO'},
    {'value': 'NEWROAD(EXPRESS)', 'label': 'NEWROAD(EXPRESS)'},
    {'value': 'OLDROAD', 'label': 'OLDROAD'},
    {'value': 'WINNERSROAD', 'label': 'WINNERSROAD'},
    {'value': 'LUCAS', 'label': 'LUCAS'},
    {'value': 'LUCASEXTENSION', 'label': 'LUCASEXTENSION'},
    {'value': 'JEHOVAHSTREET', 'label': 'JEHOVAHSTREET'},
    {'value': 'NEWLAYOUT', 'label': 'NEWLAYOUT'},
    {'value': 'URUVIE', 'label': 'URUVIE'},
    {'value': 'ETAEGENE', 'label': 'ETAEGENE'},
  ];

  void _showLandmarkBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => LandmarkSelectionSheet(
        landmarks: _landmarkOptions,
        onLandmarkSelected: (landmark) {
          setState(() {
            _landmarkController.text = landmark;
          });
          Navigator.pop(context);
        },
      ),
    );
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
                  "Add Address",
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
                    label: "House Number",
                    hintText: 'Enter house number',
                    controller: _houseNumberController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'House number is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  AppInputField(
                    label: "Street",
                    hintText: 'Enter street name',
                    controller: _streetController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Street is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "State",
                        style: TextStyle(
                          fontFamily: 'JK_Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.labelTextColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedState,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.grayTextColor,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.grayTextColor,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 1,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: ['Delta']
                            .map((state) => DropdownMenuItem<String>(
                                  value: state,
                                  child: Text(state),
                                ))
                            .toList(),
                        onChanged: null, // Disabled
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: _showLandmarkBottomSheet,
                    child: AbsorbPointer(
                      child: AppInputField(
                        label: "Landmark",
                        hintText: 'Select landmark',
                        controller: _landmarkController,
                        suffixIcon: Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.grayTextColor,
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(height: 16),
                  // AppTextArea(
                  //   label: "Full Address",
                  //   hintText: 'Enter full address',
                  //   controller: _addressController,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Address is required';
                  //     }
                  //     return null;
                  //   },
                  //   maxLines: 3,
                  // ),
                  SizedBox(height: 20),
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
                  SizedBox(height: 10),
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
                  SizedBox(height: 32),
                  AppButton(
                    label: "Save address",
                    isLoading: state is AddressLoading,
                    isDisabled: state is AddressLoading,
                    onPressed: () {
                      final label = _selectedLabel == 'Other'
                          ? _labelController.text
                          : _selectedLabel;

                      // _addressBloc.add(
                      //   AddAddress(
                      //     address: _addressController.text,
                      //     houseNumber: _houseNumberController.text,
                      //     street: _streetController.text,
                      //     state: _selectedState,
                      //     landmark: _landmarkController.text,
                      //     isPrimary: _isPrimary,
                      //     label: label,
                      //   ),
                      // );
                    },
                  ),
                  SizedBox(height: 20),
                ],
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
    _houseNumberController.dispose();
    _streetController.dispose();
    _landmarkController.dispose();
    _labelController.dispose();
    super.dispose();
  }
}

class LandmarkSelectionSheet extends StatelessWidget {
  final List<Map<String, String>> landmarks;
  final Function(String) onLandmarkSelected;

  const LandmarkSelectionSheet({
    Key? key,
    required this.landmarks,
    required this.onLandmarkSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          Text(
            'Select Landmark',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: landmarks.length,
              itemBuilder: (context, index) {
                final landmark = landmarks[index];
                return ListTile(
                  title: Text(landmark['label']!),
                  onTap: () => onLandmarkSelected(landmark['value']!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
