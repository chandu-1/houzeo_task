import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houzeo_task/models/contact_model.dart';

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<String> items;
  final bool isPhone;
  final TitleLabel initial;
  final Function(TitleLabel?) onChange;
  final Function(String?) validator;

  CustomTextField({
    Key? key,
    required this.icon,
    required this.isPhone,
    required this.label,
    required this.validator,
    required this.items,
    required this.initial,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: initial.title,
          decoration: InputDecoration(
            icon: Icon(icon),
            label: Text(label),
          ),
          keyboardType: isPhone ? TextInputType.phone : null,
          maxLength: isPhone ? 10 : null,
          inputFormatters: isPhone
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                ]
              : null,
          validator: (v) => validator(v),
          onSaved: (v) => onChange(initial.copyWith(
            title: v,
          )),
          onChanged: (v) => onChange(initial.copyWith(
            title: v,
          )),
        ),
        Container(
          width: 200,
          margin: isPhone ? null : const EdgeInsets.symmetric(vertical: 10),
          child: DropdownButtonFormField<String>(
            value: items.contains(initial.label) ? initial.label : null,
            decoration: const InputDecoration(
              icon: SizedBox(
                width: 21,
              ),
              label: Text("Label"),
            ),
            items: items
                .map(
                  (e) => DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  ),
                )
                .toList(),
            onSaved: (v) {
              onChange(initial.copyWith(label: v));
            },
            onChanged: (v) {
              onChange(initial.copyWith(label: v));
            },
          ),
        ),
      ],
    );
  }
}
