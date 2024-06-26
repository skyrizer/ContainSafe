import 'package:containsafe/pages/authentication/loginScreen.dart';
import 'package:containsafe/repository/webSocket_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:containsafe/bloc/authentication/login/login_state.dart';
import 'package:containsafe/bloc/authentication/login/login_bloc.dart';
import 'package:containsafe/bloc/authentication/login/login_event.dart';
import 'RoutePage.dart';


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late AuthBloc authBloc;
  //late WebSocketRepository webSocketRepository;
  //final webSocketRepository = WebSocketRepository('ws://192.168.0.115:8080'); // Adjust IP for your case

  Future<String> checkToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');
    if (token != null) {
      return token;
    } else {
      return "";
    }
  }

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);

    sendEmail();
    // Delay the execution of the FutureBuilder for 2000 milliseconds.
    Future.delayed(Duration(milliseconds: 1000), () {
      redirect();
    });
  }

  Future<void> sendEmail() async {
    var pref = await SharedPreferences.getInstance();
    String? ipAddress = pref.getString("ipAddress");
    String? email = pref.getString("email");
    final webSocketRepository = WebSocketRepository('ws://$ipAddress:8765');
    webSocketRepository.sendEmailUser(email!);
  }

  Future<void> redirect() async {
    String hasToken = await checkToken();
    if (hasToken != "") {
      authBloc.add(GetRefreshToken());
    } else {
      authBloc.add(GetLogin());
    }
  }

  @override
  Widget build(BuildContext context) {
    // webSocketRepository.sendMessage('Hello from Flutter!');
    // webSocketRepository.messages.listen((message) {
    //   print('Received message: $message');
    // });
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          final prefs = await SharedPreferences.getInstance();
          final roleId = prefs.getInt('roleId');
          print(roleId);
          if (state is RefreshTokenSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const RoutePage()),
              (Route<dynamic> route) => false,
            );
          } else if (state is RefreshTokenFail || state is LoginInitState) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false);
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'ContainSafe',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 10.0),
              Container(
                child: Image.asset('assets/logo.png', width: 200.0),
                alignment: Alignment.center,
              ),
              SizedBox(height: 10.0),
              Text(
                'Stay safe with us',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 5.0),
              CircularProgressIndicator(color: HexColor("#3c1e08")),
            ],
          ),
        ),
      ),
    );
  }
}
