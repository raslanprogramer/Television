import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Television/pages/chanel_of_group.dart';

import '../main.dart';
import '../utils/modal_channel_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ChannelInfo> channels = [];
  late Map<String, List<ChannelInfo>> groupedChanels={};
  bool isDownloadChanel=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchChannels("https://raw.githubusercontent.com/Free-TV/IPTV/master/playlist.m3u8");
  }
  @override
  Widget build(BuildContext context) {

     return Scaffold(

       appBar:AppBar(
         actions: [IconButton(onPressed: (){}, icon: Icon(Icons.settings,color: Colors.white,))],
         // backgroundColor: Colors.blueGrey,
         backgroundColor: Colors.blue,

         title:const Center(child: Text("مجموعات القنوات",style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),),),leading:Container(),leadingWidth: 0,

       ),
       body:  isDownloadChanel==true?
       ListView(
         children: [
           for(var entry in groupedChanels.entries)
             Container(child: ElevatedButton(
               onPressed: () {
                 Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  ChanelOfGroup(channelInfo:entry.value,)),
              );
               },
               child: Text(entry.key,
             )))
         ],
       ):
      const Center(child: CircularProgressIndicator(),),
     );
  }
  Future<void> fetchChannels(String mUrl) async {
    final response = await http.get(Uri.parse(mUrl));

    if (response.statusCode == 200) {
      final lines = response.body.split('\n');
      final filteredLines = lines.where((line) => line.startsWith('#EXTINF:')).toList();

      setState(() async {
        channels = filteredLines.map((line) {
          final streamLine = lines[lines.indexOf(line) + 1];
          return ChannelInfo.fromM3U(line, streamLine);
        }).toList();

        _groupChannelsByCategory();
        setState(() {
          isDownloadChanel=true;
        });
      });
    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to fetch channels'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
  void _groupChannelsByCategory() {


    for (var channel in channels) {

      if (!groupedChanels.containsKey(channel.category)) {
        groupedChanels[channel.category] = [];
      }
      groupedChanels[channel.category]!.add(channel);
    }
  }
}
