import 'package:containsafe/pages/SnackBarDesign.dart';
import 'package:containsafe/pages/authentication/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:containsafe/bloc/authentication/register/register_event.dart';
import 'package:containsafe/bloc/authentication/register/register_state.dart';
import 'package:containsafe/bloc/authentication/register/register_bloc.dart';

import '../../bloc/role/get/getRole_bloc.dart';
import '../../bloc/role/get/getRole_event.dart';
import '../../bloc/role/get/getRole_state.dart';
import '../../model/role/role.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static Future<bool> getToken() async{
    print('trying to get token');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') != null){
      return true;
    }else {
      return false;
    }
  }

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final GetAllRoleBloc _getAllRoleBloc  = GetAllRoleBloc();
  Role? _selectedRole; // Selected node

  // controller
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController confirmpwdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();


  final FocusNode confirmPasswordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  String password = '';
  String confirmpassword = '';

  late RegisterBloc registerBloc;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllRoleBloc.add(GetAllRoleList());
    registerBloc = BlocProvider.of<RegisterBloc>(context);
  }
  @override
  Widget build(BuildContext context) {
    final msg = BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state){
        if (state is RegisterLoadingState){
          return Center(child: CircularProgressIndicator(color:  HexColor("#3c1e08"),));
        }
        return Container();
      },
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body:
      BlocListener<RegisterBloc, RegisterState>(
        listener: (context,state) async {
          if (state is RegisterSuccessState) {
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(
                builder: (context) => LoginScreen()), (Route<dynamic> route) => false
            );
          } else if (state is UsernameFailState) {
            final snackBar = SnackBarDesign.customSnackBar('Username has been taken');
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (state is EmailFailState) {
            final snackBar = SnackBarDesign.customSnackBar('Email has been taken');
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (state is RegisterFailState){
            final snackBar = SnackBarDesign.customSnackBar('Network error. Please try again');
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _signUpText(),
                  const SizedBox(height: 12.0,),
                  _usernameField(),
                  _emailField(),
                  _nameField(),
                  const SizedBox(height: 10.0,),
                  _passwordField(),
                  _confirmpasswordField(),
                  _matchPassword(),
                  _buildRoleDropdown(),
                  const SizedBox(height: 10.0,),
                  msg,
                  _signupButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return BlocProvider<GetAllRoleBloc>(
      create: (context) => _getAllRoleBloc, // Provide the instance of GetAllNodeBloc
      child: BlocBuilder<GetAllRoleBloc, GetAllRoleState>(
        builder: (context, state) {
          if (state is GetAllRoleLoaded) {
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child:
                  Text('Role'),

                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: DropdownButton<Role>(
                    hint: Text('Select Role'),
                    value: _selectedRole,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedRole = newValue; // Update selected node
                      });
                    },
                    items: _getRoleDropdownItems(state.roleList),
                    // Display the hostname for each item
                    // value will be the Node object itself
                  ),
                ),
              ],
            );
          } else {
            // Handle loading or error state
            return SizedBox.shrink(); // Or display an error message
          }
        },
      ),
    );
  }

  List<DropdownMenuItem<Role>> _getRoleDropdownItems(List<Role> roles) {
    return roles.map((role) {
      return DropdownMenuItem<Role>(
        value: role,
        child: Text(role.role!),
      );
    }).toList();
  }

  Widget _signUpText(){
    return const Text("Create your account", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);
  }

  Widget _usernameField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty){
            return 'Please enter username';
          }
          if (value.trim().contains(' ')){
            List<String> words = value.split(' ');
            if (words.length > 1){
              return 'Username cannot contain whitespace';
            }
          }
          return null;
        },
        controller: usernameController,
        decoration:  InputDecoration(
            prefixIcon: Icon(Icons.person, color: HexColor("#3c1e08"),),
            labelText: 'Username',
            labelStyle: TextStyle(color: HexColor("#3c1e08")),
            focusColor: HexColor("#3c1e08"),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a4a4a4")),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color:  HexColor("#3c1e08")),
            )
        ),
      ),
    );
  }

  Widget _emailField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty){
            return 'Please enter email';
          }
          if (!value.trim().contains('@')){
            return 'Email is not completed';
          }
          return null;
        },
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        decoration:  InputDecoration(
          prefixIcon: Icon(Icons.email_rounded, color: HexColor("#3c1e08"),),
          labelText: 'Email',
          labelStyle: TextStyle(color: HexColor("#3c1e08")),
          focusColor: HexColor("#3c1e08"),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: HexColor("#a4a4a4")),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color:  HexColor("#3c1e08")),
          ),
        ),
      ),
    );
  }

  Widget _nameField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty){
            return 'Please enter full name';
          }
          return null;
        },
        controller: nameController,
        decoration:  InputDecoration(
          prefixIcon: Icon(Icons.account_box_rounded, color: HexColor("#3c1e08"),),
          labelText: 'Full name',
          labelStyle: TextStyle(color: HexColor("#3c1e08")),
          focusColor: HexColor("#3c1e08"),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: HexColor("#a4a4a4")),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color:  HexColor("#3c1e08")),
          ),
        ),
      ),
    );
  }

  Widget _passwordField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty){
            return 'Please enter password';
          }
          if (value.length < 8){
            return 'Password needs to be minimum 8 character';
          }
          return null;
        },
        obscureText: true,
        controller: pwdController,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock, color: HexColor("#3c1e08"),),
            labelText: 'Password',
            labelStyle: TextStyle(color: HexColor("#3c1e08")),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a4a4a4")),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color:  HexColor("#3c1e08")),
            )
        ),
        onChanged: (value) {
          setState(() {
            password = value;
            print('Confirm password: ${password}');
          });
        },
      ),
    );
  }

  Widget _confirmpasswordField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty){
            return 'Please enter password';
          }
          return null;
        },
        obscureText: true,
        focusNode: confirmPasswordFocusNode,
        controller: confirmpwdController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_outline_rounded, color: HexColor("#3c1e08"),),
          labelText: 'Retype password',
          labelStyle: TextStyle(color: HexColor("#3c1e08")),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: HexColor("#a4a4a4")),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color:  HexColor("#3c1e08")),
          ),
        ),
        onChanged: (value) {
          setState(() {
            confirmpassword = value;
            print('Confirm password: ${confirmpassword}');
          });
        },
      ),
    );
  }

  Widget _matchPassword(){
    if(password.isNotEmpty && confirmpassword.isNotEmpty){
      if (password != confirmpassword){
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Password does not match!', style: TextStyle(color: Colors.red)),
        );
      }
    }
    return Container();
  }

  Widget _signupButton() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: SizedBox(
          width: 400.0,
          height: 55.0,
          child: ElevatedButton(
            onPressed: () {
              if(_formKey.currentState!.validate()){
                // success validation
                registerBloc.add(SignUpButtonPressed(
                  username: usernameController.text.trim(),
                  name: nameController.text.trim(),
                  email: emailController.text.trim(),
                  //gender: int.parse(_gender.toString()),
                  password: pwdController.text.trim(),
                  confirmPassword: confirmpwdController.text.trim(),
                  phoneNumber: phoneNumController.text.trim(),
                  roleId: _selectedRole!.id!,
                ));
              }

            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder( borderRadius: BorderRadius.circular(24.0),)
              ),
              backgroundColor: MaterialStateProperty.all<HexColor>(HexColor("#3c1e08")),

            ),
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text('SIGN UP', style: TextStyle(fontSize: 16),),
            ),
          ),
        ),
      ),
    );
  }

}
