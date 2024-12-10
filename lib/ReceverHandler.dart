import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ReceverHandler extends StatefulWidget {
  @override
  _ReceverHandlerState createState() => _ReceverHandlerState();
}

class _ReceverHandlerState extends State<ReceverHandler> {
 
  final supabas = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    handleReferral();
  }

  Future<void> handleReferral() async {
    final url = Uri.base; 

    final reseverId =
        url.queryParameters['resever_id']; // الحصول على referral_id
   
    try {
      if (html.window.localStorage['referr_uuid'] != null) {
        if (reseverId != null) {
          final respos = await supabas
              .from('referr')
              .insert({
                'sender_id': reseverId,
                'resever_id': html.window.localStorage['referr_uuid'],
                'type': 2,
              })
              .select()
              .single();
        }
      }
    } catch (e) {
      print(e);
    }
    await _launchURL();
  }

  Future<void> _launchURL() async {
    final String url =
        'https://play.google.com/store/apps/details?id=com.Alsouq365.Alsouq';
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Referral Handler'),
      ),
      body: const Center(
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Handling Referral...'),
           
          ],
        ),
      ),
    );
  }
}
