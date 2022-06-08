import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psychosomatics/presentation/widgets/text_field_title.dart';

class PhoneTextField extends StatefulWidget {
  final TextEditingController phoneController;
  final Size size;
  final Map<String, String> mapPhone;

  const PhoneTextField({
    Key? key,
    required this.phoneController,
    required this.size,
    required this.mapPhone,
  }) : super(key: key);

  @override
  _PhoneTextFieldState createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  var lengthCode = 2;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CountryCodePicker(
              onChanged: (var code) {
                setState(() {
                  lengthCode = code.dialCode!.length;
                  widget.mapPhone['code'] = code.toString();
                });
              },
              initialSelection: 'RU',
              favorite: const ['RU'],
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              alignLeft: false,
              padding: EdgeInsets.zero,
              textStyle: const TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 5.0),
            TextFieldTitle(
              title: '',
              hint: 'Введите номер телефона',
              controller: widget.phoneController,
              width: MediaQuery.of(context).size.width -
                  (109.0 + (8 * lengthCode)),
              func: () {
                setState(() {});
              },
              maxLength: 10,
              textInputType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
            ),
          ],
        ),
        const Positioned(
          top: 13.0,
          child: Text(
            'Номер телефона',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
