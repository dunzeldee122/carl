import 'package:flutter/material.dart';
import 'database.dart';

class RegisterScreen extends StatefulWidget {
  final UserDatabase databaseHelper;
  const RegisterScreen({Key? key, required this.databaseHelper}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  DateTime? _selectedDate;

  bool _passwordVisible = false; // Variable for password visibility
  bool _registerPressed = false; // Track if register button is pressed as the variable name says,so yeah

  // Map to track field validation errors
  final Map<String, String> _errors = {};

  // Function to validate
  bool _validateField(String field, TextEditingController? controller, {String? value}) {
    if (_errors.containsKey(field)) {
      return false;
    }
    if (field == 'dob') {
      return _selectedDate != null;
    }
    if (field == 'password') {
      // Check password length
      final password = controller?.text ?? value ?? '';
      if (password.isEmpty) {
        _errors['password'] = 'field cannot be empty';
        return false;
      } else if (password.length < 6) {
        _errors['password'] = 'Password must be at least 6 characters';
        return false;
      } else if (password.length > 16) {
        _errors['password'] = 'Password must be at maximum of 16 characters';
        return false;
      }
    }
    return controller != null ? controller.text.isNotEmpty : value != null && value.isNotEmpty;
  }

  // Function to validate date of birth
  String? _validateDateOfBirth(DateTime? selectedDate) {
    if (selectedDate == null) return null;

    final currentDate = DateTime.now();
    final tenYearsAgo = currentDate.subtract(const Duration(days: 365 * 10));

    if (selectedDate.isAfter(tenYearsAgo)) {
      return 'You must be at least 10 years old to register';
    }

    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.black26,
        title: const Text('Register', style: TextStyle(color: Colors.white,fontSize: 28.0)),
    ),
    backgroundColor: Colors.white,
    body: SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const SizedBox(height: 20.0),
    TextFormField(
    controller: _usernameController,
    style: const TextStyle(color: Colors.white, fontSize: 28.0),
    decoration: InputDecoration(
    filled: true,
    fillColor: Colors.orangeAccent,
    hintText: 'Username',
    hintStyle: const TextStyle(color: Colors.white),
    errorText: _errors.containsKey('username') ? 'Field cannot be empty' : null,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    ),
    ),
    ),
    const SizedBox(height: 20.0),
    TextFormField(
    controller: _passwordController,
    style: const TextStyle(color: Colors.white, fontSize: 28.0),
    decoration: InputDecoration(
    filled: true,
    fillColor: Colors.orangeAccent,
    hintText: 'Password',
    hintStyle: const TextStyle(color: Colors.white),
    errorText: _errors.containsKey('password') ? _errors['password'] : null,
    suffixIcon: IconButton(
    icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
    onPressed: () {
    setState(() {
    _passwordVisible = !_passwordVisible;
    });
    },
    ),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    ),
    ),
    obscureText: !_passwordVisible,
    ),
    const SizedBox(height: 20.0),
    TextFormField(
    controller: _nameController,
    style: const TextStyle(color: Colors.white, fontSize: 28.0),
    decoration: InputDecoration(
    filled: true,
    fillColor: Colors.orangeAccent,
    hintText: 'Name',
    hintStyle: const TextStyle(color: Colors.white),
    errorText: _errors.containsKey('name') ? 'Field cannot be empty' : null,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular
      (10.0),
    ),
    ),
    ),
      const SizedBox(height: 20.0),
      TextFormField(
        controller: _emailController,
        style: const TextStyle(color: Colors.white, fontSize: 28.0),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.orangeAccent,
          hintText: 'Email',
          hintStyle: const TextStyle(color: Colors.white),
          errorText: _errors.containsKey('email') ? 'Field cannot be empty' : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      const SizedBox(height: 20.0),
      TextFormField(
        controller: _phoneNumberController,
        style: const TextStyle(color: Colors.white, fontSize: 28.0),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.orangeAccent,
          hintText: 'Phone Number',
          hintStyle: const TextStyle(color: Colors.white),
          errorText: _errors.containsKey('phoneNumber') ? 'Field cannot be empty' : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      const SizedBox(height: 20.0),
      InkWell(
        onTap: () => _selectDate(context),
        child: AbsorbPointer(
          absorbing: true,
          child: TextFormField(
            enabled: false,
            controller: TextEditingController(
              text: _selectedDate != null
                  ? '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}'
                  : null,
            ),
            style: const TextStyle(color: Colors.white, fontSize: 28.0),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.orangeAccent,
              hintText: 'Date of Birth',
              hintStyle: const TextStyle(color: Colors.white),
              errorText: _registerPressed && _selectedDate == null
                  ? 'Date of Birth cannot be empty'
                  : _validateDateOfBirth(_selectedDate),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 20.0),
      TextFormField(
        controller: _addressController,
        style: const TextStyle(color: Colors.white, fontSize: 28.0),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.orangeAccent,
          hintText: 'Address',
          hintStyle: const TextStyle(color: Colors.white),
          errorText: _errors.containsKey('address') ? 'Field cannot be empty' : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      const SizedBox(height: 20.0),
      TextFormField(
        controller: _genderController,
        style: const TextStyle(color: Colors.white, fontSize: 28.0),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.orangeAccent,
          hintText: 'Gender',
          hintStyle: const TextStyle(color: Colors.white),
          errorText: _errors.containsKey('gender') ? 'Field cannot be empty' : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      const SizedBox(height: 20.0),//space
      Center(
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _registerPressed = true;
            });
            _registerUser();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black12,
            minimumSize: Size(double.infinity, 50),//widening
          ),
          child: const Text(
            'Register',
            style: TextStyle(color: Colors.white, fontSize: 28.0),//height
          ),
        ),
      ),
    ],
    ),
    ),
    ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(), // date selector
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> _registerUser() async {
    setState(() {
      _errors.clear();
    });

    // Validate fields
    if (!_validateField('username', _usernameController) ||
        !_validateField('password', _passwordController) ||
        !_validateField('name', _nameController) ||
        !_validateField('email', _emailController) ||
        !_validateField('phoneNumber', _phoneNumberController) ||
        !_validateField('gender', _genderController) ||
        !_validateField('address', _addressController)) {
      setState(() {
        // Set errors for empty fields
        if (!_validateField('username', _usernameController)) {
          _errors['username'] = 'Field cannot be empty';
        }
        if (!_validateField('password', _passwordController)) {

        }
        if (!_validateField('name', _nameController)) {
          _errors['name'] = 'Field cannot be empty';
        }
        if (!_validateField('email', _emailController)) {
          _errors['email'] = 'Field cannot be empty';
        }
        if (!_validateField('phoneNumber', _phoneNumberController)) {
          _errors['phoneNumber'] = 'Field cannot be empty';
        }
        if (!_validateField('gender', _genderController)) {
          _errors['gender'] = 'Field cannot be empty';
        }
        if (!_validateField('address', _addressController))
        {
          _errors['address'] = 'Field cannot be empty';
        }
      });
      return;
    }

    // Check if date of birth is selected
    if (_selectedDate == null) {
      setState(() {
        _errors['dob'] = 'Date of Birth cannot be empty';
      });
      return;
    }

    // Check if user is at least 10 years old
    final tenYearsAgo = DateTime.now().subtract(const Duration(days: 365 * 10));
    if (_selectedDate!.isAfter(tenYearsAgo)) {
      setState(() {
        _errors['dob'] = 'You must be at least 10 years old to register';
      });
      return;
    }

    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String phoneNumber = _phoneNumberController.text;
    final String dob =
        '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}';
    final String gender = _genderController.text;
    final String address = _addressController.text;

    // Check username if taken
    final bool isUsernameAvailable = await widget.databaseHelper.isUsernameAvailable(username);
    if (!isUsernameAvailable) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Username Not Available'),
            content: Text('The username $username is already taken.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Check email is taken
    final bool isEmailAvailable = await widget.databaseHelper.isEmailAvailable(email);
    if (!isEmailAvailable) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Email Not Available'),
            content: Text('The email $email is already registered.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    //user register to the database
    User newUser = User(
      username: username,
      password: password,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      dob: dob,
      gender: gender,
      address: address,
    );

    bool registered = await widget.databaseHelper.registerUser(newUser);

    if (registered) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registration Complete'),
            content: const Text('You have successfully registered.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registration Failed'),
            content: const Text('Failed to register user. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}