import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_app/resources/auth_methods.dart';
import 'package:new_app/responsive/mobile_screen_layout.dart';
import 'package:new_app/responsive/responsive_layout_screen.dart';
import 'package:new_app/responsive/web_screen_layout.dart';
import 'package:new_app/utils/colors.dart';
import 'package:new_app/utils/utils.dart';
import 'package:new_app/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _username = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _pass.dispose();
    _bio.dispose();
    _username.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _email.text,
      password: _pass.text,
      username: _username.text,
      bio: _bio.text,
      file: _image!,
    );

    if (!mounted) return;
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => const ResponsiveLayout(
                webScreenLayout: WebScreenLayout(),
                mobileScreenLayout: MobileScreenLayout(),
              ),
            ),
            (route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        showSnackbar(res, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          width: double.infinity,
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(),
                    ),
                    SvgPicture.asset(
                      'assets/ic_instagram.svg',
                      height: 64,
                      // ignore: deprecated_member_use
                      color: primary,
                    ),
                    const SizedBox(
                      height: 64,
                    ),
                    Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : const CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(
                                    'https://i.stack.imgur.com/l60Hf.png'),
                              ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: () {
                              selectImage();
                            },
                            icon: const Icon(Icons.add_a_photo),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                      textEditingController: _username,
                      isPass: false,
                      hintText: 'Enter your username',
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                      textEditingController: _email,
                      isPass: false,
                      hintText: 'Enter your email',
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                      textEditingController: _pass,
                      isPass: true,
                      hintText: 'Enter your password',
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                      textEditingController: _bio,
                      isPass: false,
                      hintText: 'Enter your bio',
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    InkWell(
                      onTap: signUpUser,
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          color: blue,
                        ),
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: primary,
                                ),
                              )
                            : const Text('Sign up'),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text("Already have an account? "),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: const Text(
                              "Login.",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
