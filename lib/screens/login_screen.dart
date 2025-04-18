import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'sign_up_screen.dart'; // SignUpPage가 들어 있는 파일 import
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final idController = TextEditingController();
    final pwController = TextEditingController();

    // 로그인 함수
    Future<void> login() async {
      var url = Uri.parse('$baseUrl/login/');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': idController.text,
          'password': pwController.text,
        }),
      );

      var data = jsonDecode(utf8.decode(response.bodyBytes));

      if (data['success']) {
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(content: Text(data['message'])),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(content: Text(data['message'])),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 로고 + 앱 타이틀
                Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4DFB8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Icon(Icons.chair, size: 40, color: Colors.brown),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '방꾸석',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // 아이디 입력
                Container(
                  width: 300,
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: idController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '아이디를 입력해주세요.',
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // 비밀번호 입력
                Container(
                  width: 300,
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: pwController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '비밀번호를 입력해주세요.',
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // 로그인 버튼
                GestureDetector(
                  onTap: login,  // 여기에 로그인 함수 연결
                  child: Container(
                    width: 340,
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4DFB8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        '로그인',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.brown,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // 회원가입 텍스트 → 클릭 시 이동
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: const Text(
                    '아이디 찾기 / 비밀번호 찾기 / 회원가입',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),

                const SizedBox(height: 30),

                // 소셜 로그인
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ✅ 카카오 로그인 버튼
                    GestureDetector(
                      onTap: signInWithKakao,
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFFFFE105), // 카카오 노랑
                        child: Icon(Icons.chat, color: Colors.brown), // 아이콘도 변경 가능
                      ),
                    ),
                    const SizedBox(width: 20),

                    // ✅ 네이버 로그인 버튼
                    GestureDetector(
                      onTap: () {
                        // 여기에 네이버 로그인 함수 작성 또는 연결
                        print('네이버 로그인 클릭됨');
                      },
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFF03C75A), // 네이버 녹색
                        child: Icon(Icons.nature, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // ✅ 구글 로그인 버튼
                    GestureDetector(
                      onTap: () {
                        // 여기에 구글 로그인 함수 작성 또는 연결
                        print('구글 로그인 클릭됨');
                      },
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFFFFDADA), // 구글 스타일 색상
                        child: Icon(Icons.email, color: Colors.redAccent),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


Future<void> signInWithKakao() async {
  if (await isKakaoTalkInstalled()) {
    try {
      await UserApi.instance.loginWithKakaoTalk();
      print('카카오톡으로 로그인 성공');
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
      if (error is PlatformException && error.code == 'CANCELED') return;
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  } else {
    try {
      await UserApi.instance.loginWithKakaoAccount();
      print('카카오계정으로 로그인 성공');
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
    }
  }
}
