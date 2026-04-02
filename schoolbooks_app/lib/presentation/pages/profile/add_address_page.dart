import 'package:flutter/material.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});
  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Address')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full Name'), validator: (v) => v?.isEmpty == true ? 'Required' : null),
            const SizedBox(height: 16),
            TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone Number'), keyboardType: TextInputType.phone, validator: (v) => v?.isEmpty == true ? 'Required' : null),
            const SizedBox(height: 16),
            TextFormField(controller: _addressLine1Controller, decoration: const InputDecoration(labelText: 'Address Line 1'), validator: (v) => v?.isEmpty == true ? 'Required' : null),
            const SizedBox(height: 16),
            TextFormField(controller: _addressLine2Controller, decoration: const InputDecoration(labelText: 'Address Line 2')),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: TextFormField(controller: _cityController, decoration: const InputDecoration(labelText: 'City'), validator: (v) => v?.isEmpty == true ? 'Required' : null)),
                const SizedBox(width: 16),
                Expanded(child: TextFormField(controller: _pincodeController, decoration: const InputDecoration(labelText: 'Pincode'), keyboardType: TextInputType.number, validator: (v) => v?.isEmpty == true ? 'Required' : null)),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(controller: _stateController, decoration: const InputDecoration(labelText: 'State'), validator: (v) => v?.isEmpty == true ? 'Required' : null),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Address'),
            ),
          ],
        ),
      ),
    );
  }
}
