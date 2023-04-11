import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:grocery_store/models/customer.dart';
import 'package:grocery_store/util/api_service.dart';
import 'package:grocery_store/util/form_helper.dart';
import 'package:grocery_store/util/progress_hud.dart';
import 'package:grocery_store/util/validator_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  /* ------------------------------ Project Setup ----------------------------- */

  APIService apiService = APIService();
  CustomerModel customer = CustomerModel();
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: true,
      ),
      body: ProgressHUD(
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
        child: Form(
          key: globalKey,
          child: _formUI(),
        ),
      ),
    );
  }

  Widget _formUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /* ------------------------------- First Name ------------------------------- */

              FormHelper.fieldLabel("First Name"),
              FormHelper.textInput(
                context,
                customer.firstName,
                (value) => {customer.firstName = value},
                onValidate: (value) {
                  if (value.toString().isEmpty) {
                    return "First Name is required";
                  } else {
                    return null;
                  }
                },
                prefixIcon: const Icon(Icons.person),
              ),

              /* -------------------------------- Last Name ------------------------------- */

              FormHelper.fieldLabel("Last Name"),
              FormHelper.textInput(
                context,
                customer.lastName,
                (value) => {customer.lastName = value},
                onValidate: (value) {
                  // if (value.toString().isEmpty) {
                  //   return "Last Name is Required";
                  // }
                  return null;
                },
                prefixIcon: const Icon(Icons.person),
              ),

              /* -------------------------------- Email Id -------------------------------- */

              FormHelper.fieldLabel("Email Id"),
              FormHelper.textInput(
                context,
                customer.email,
                (value) => {customer.email = value},
                onValidate: (value) {
                  if (value.toString().isEmpty) {
                    return "Email Id is Required";
                  }
                  if (value.toString().isNotEmpty &&
                      !value.toString().isValidEmail()) {
                    return "Email Id is not valid";
                  }
                  return null;
                },
                prefixIcon: const Icon(Icons.email),
              ),

              /* ----------------------------- Password Field ----------------------------- */

              FormHelper.fieldLabel("Password"),
              FormHelper.textInput(
                context,
                customer.password,
                (value) => {customer.password = value},
                onValidate: (value) {
                  if (value.toString().isEmpty) {
                    return "Password is required";
                  }
                  return null;
                },
                prefixIcon: const Icon(Icons.password),
                obscureText: hidePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    hidePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  color: Colors.blueAccent.withOpacity(0.4),
                ),
              ),
              const SizedBox(height: 20),

              /* ----------------------------- Register Button ---------------------------- */
              Center(
                child: FormHelper.saveButton(
                  "Register",
                  () {
                    if (validateAndSave()) {
                      log(customer.toJson().toString());
                      setState(() {
                        isApiCallProcess = true;
                      });

                      apiService.createCustomerData(customer).then(
                        (ret) {
                          if (ret) {
                            FormHelper.showMessage(
                              context,
                              "WooCommerce Api",
                              "Registration Successfull",
                              "Ok",
                              () {
                                Navigator.of(context).pop();
                              },
                            );
                          } else {
                            FormHelper.showMessage(
                              context,
                              "WooCommerce Api",
                              "Email Already Exists",
                              "Ok",
                              () {
                                Navigator.of(context).pop();
                              },
                            );
                          }
                        },
                      );
                    }
                  },
                  color: Colors.redAccent,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
