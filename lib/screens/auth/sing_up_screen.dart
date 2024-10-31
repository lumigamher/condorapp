import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:condorapp/theme.dart';
import 'package:condorapp/models/user.dart';
import 'package:condorapp/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 6570)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: AppTheme.lightTheme,
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Crear cuenta"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Información Personal
              Text(
                "Información Personal",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 16),

              // Nombre
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: "Nombre", prefixIcon: Icon(Icons.person_outline)),
                validator: (value) => value?.isEmpty ?? true ? 'Ingresa tu nombre' : null,
              ),
              SizedBox(height: 16),

              // Apellidos
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: "Apellidos", prefixIcon: Icon(Icons.person_outline)),
                validator: (value) => value?.isEmpty ?? true ? 'Ingresa tus apellidos' : null,
              ),
              SizedBox(height: 24),

              // Información de Contacto
              Text(
                "Información de Contacto",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Correo electrónico", prefixIcon: Icon(Icons.email_outlined)),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Ingresa tu correo electrónico';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) return 'Correo electrónico inválido';
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Teléfono
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: "Teléfono", prefixIcon: Icon(Icons.phone_outlined)),
              ),
              SizedBox(height: 16),

              // Dirección
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: "Dirección", prefixIcon: Icon(Icons.home_outlined)),
              ),
              SizedBox(height: 24),

              // Información de Cuenta
              Text(
                "Información de Cuenta",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 16),

              // Usuario
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: "Nombre de usuario", prefixIcon: Icon(Icons.account_circle_outlined)),
                validator: (value) => value?.isEmpty ?? true ? 'Ingresa un nombre de usuario' : null,
              ),
              SizedBox(height: 16),

              // Contraseña
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Ingresa una contraseña';
                  if (value!.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Confirmar Contraseña
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: "Confirmar contraseña",
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                ),
                validator: (value) {
                  if (value != _passwordController.text) return 'Las contraseñas no coinciden';
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Información Adicional
              Text(
                "Información Adicional",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 16),

              // Fecha de Nacimiento
              TextFormField(
                controller: _birthDateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  labelText: "Fecha de nacimiento",
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
              ),
              SizedBox(height: 16),

              // Género
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(
                  labelText: "Género",
                  prefixIcon: Icon(Icons.person_outline),
                ),
                items: [
                  DropdownMenuItem(value: "M", child: Text("Masculino")),
                  DropdownMenuItem(value: "F", child: Text("Femenino")),
                  DropdownMenuItem(value: "O", child: Text("Otro")),
                  DropdownMenuItem(value: "N", child: Text("Prefiero no decirlo")),
                ],
                onChanged: (value) => setState(() => _selectedGender = value),
              ),
              SizedBox(height: 32),

              // Botón de registro
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final user = User(
                      username: _usernameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      phone: _phoneController.text,
                      address: _addressController.text,
                      birthDate: _selectedDate,
                      gender: _selectedGender,
                    );
                    authProvider.signup(user);
                    Navigator.pop(context);
                  }
                },
                child: Text("Crear cuenta"),
              ),
              SizedBox(height: 16),

              // Enlace para iniciar sesión
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("¿Ya tienes una cuenta? Inicia sesión"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
