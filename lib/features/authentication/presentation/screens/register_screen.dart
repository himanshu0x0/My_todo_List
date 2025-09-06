import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mytodoapp/common_widgets/async_value_ui.dart';
import 'package:mytodoapp/features/authentication/presentation/controllera/auth_controller.dart';
import 'package:mytodoapp/features/authentication/presentation/widgets/common_text_field.dart';
import 'package:mytodoapp/routes/routes.dart';
import 'package:mytodoapp/utils/appstyles.dart';
import 'package:mytodoapp/utils/size_config.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailEditingController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isChecked = false;

  void _validateDetails() {
    String email = _emailEditingController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ensure all details are filled!',
            style: AppStyle.normalTextStyle.copyWith(color: Colors.red),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ref.read(authControllerProvider.notifier).createUserWithEmailAndPassword(
        email: email, 
        password: password,
        );
    }
  }

  @override
  void dispose() {
    _emailEditingController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final state = ref.watch(authControllerProvider);

    ref.listen<AsyncValue>(authControllerProvider, (_, state ){
      state.showAlertDialogOnError(context);
    });

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          SizeConfig.getProportionatewidth(10),
          SizeConfig.getProportionateHeight(50),
          SizeConfig.getProportionatewidth(10),
          0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Create your account',
                 style: AppStyle.titleTextStyle),
              SizedBox(height: SizeConfig.getProportionateHeight(25),),
              CommonTextField(
                hintText: 'Enter Email...',
                textInputType: TextInputType.emailAddress,
                controller: _emailEditingController, 
                obscureText: false, 
              ),

              SizedBox(height: SizeConfig.getProportionateHeight(10)),
              CommonTextField(
                hintText: 'Enter password...',
                textInputType: TextInputType.text,
                obscureText: true,
                controller: _passwordController,
              ),
              SizedBox(height: SizeConfig.getProportionateHeight(15)),

              Row(children: [
                Checkbox(value: isChecked, onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                }),

                Text('I agree with policy and terms', style: AppStyle.normalTextStyle,)
              ],),
              SizedBox(height: SizeConfig.getProportionateHeight(25)),

              InkWell(
                onTap: _validateDetails,
                child: Container(
                  alignment: Alignment.center,
                  height: SizeConfig.getProportionateHeight(50),
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: state.isLoading? const CircularProgressIndicator() : Text(
                    'Register me now',
                    style: AppStyle.normalTextStyle.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.getProportionateHeight(10)),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Container(
                  height: SizeConfig.getProportionateHeight(1),
                  width: SizeConfig.screenWidth * 0.4,
                  decoration: const BoxDecoration(color: Colors.grey),
                ),
                SizedBox(height: SizeConfig.getProportionatewidth(5)),
                Text('OR', style: AppStyle.normalTextStyle),
                SizedBox(height: SizeConfig.getProportionatewidth(5)),
                Container(
                  height: SizeConfig.getProportionateHeight(1),
                  width: SizeConfig.screenWidth * 0.4,
                  decoration: const BoxDecoration(color: Colors.grey),
                ),
              ],),
              SizedBox(height: SizeConfig.getProportionateHeight(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: SizeConfig.getProportionateHeight(40),
                    width: SizeConfig.screenWidth * 0.25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.google,
                      color: Colors.red,
                    ),
                  ),
                  Container(
                    height: SizeConfig.getProportionateHeight(40),
                    width: SizeConfig.screenWidth * 0.25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.apple,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    height: SizeConfig.getProportionateHeight(40),
                    width: SizeConfig.screenWidth * 0.25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.facebook,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.getProportionateHeight(40)),
              Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(
      'Already have an account?',
      style: AppStyle.normalTextStyle,
    ),
    GestureDetector(
      onTap: () {
        context.goNamed(AppRoutes.signIn.name);
      },
      child: Text(
        ' Sign In',
        style: AppStyle.normalTextStyle.copyWith(
          color: Colors.green,
        ),
      ),
    ),
  ],
),
            ],
          ),
        ),
      ),
    );
  }
}