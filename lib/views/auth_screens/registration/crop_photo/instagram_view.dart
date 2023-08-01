import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/instagram_constants.dart';
import 'package:nest_matrimony/services/instagram_services.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InstagramView extends StatefulWidget {
  final bool isFromManage;
  const InstagramView({Key? key,  this.isFromManage=false}) : super(key: key);

  @override
  State<InstagramView> createState() => _InstagramViewState();
}

class _InstagramViewState extends State<InstagramView> {
  late final ValueNotifier<bool> enableLoader;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: buildAppBar(context),
        body:
         Column(
           children: [
            ValueListenableBuilder<bool>(
              valueListenable: enableLoader,
              builder: (context, value, _) {
                return value ? const LinearProgressIndicator() : const SizedBox.shrink();
              }
            ),
             Expanded(
               child: 
               WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: InstagramConstant.instance.url,
                onPageStarted: (url) async {
                  buildRedirectToHome(
                      url, context.read<InstagramServiceProvider>(), context);
                },
                onPageFinished: (url){
                 enableLoader.value= false;
                  print("---------------------------$url");
                },
                     ),

                     
             ),
           ],
         ),
      );
    });
  }

  Future<void> buildRedirectToHome(String url,
      InstagramServiceProvider instagram, BuildContext context) async {
    if (url.contains(InstagramConstant.redirectUri)) {
      instagram.getAuthorizationCode(url);
      await instagram.getTokenAndUserID().then((isDone) {
        if (isDone) {
          instagram.getUserProfile(context,widget.isFromManage).then((isDone) async {
            debugPrint('${instagram.username} logged in!');
            debugPrint('${instagram.userFields} userfield');
          });
        }
      });
    }
  }

  AppBar buildAppBar(BuildContext context) => AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Instagram Login',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.black),
        ),
      );

      @override
  void initState() {
    enableLoader = ValueNotifier(true);
    super.initState();
  }
}
