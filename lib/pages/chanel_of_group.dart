import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Television/pages/vedioplayer.dart';

import '../utils/modal_channel_info.dart';

class ChanelOfGroup extends StatefulWidget {
  const ChanelOfGroup({this.channelInfo,super.key});
  final List<ChannelInfo>? channelInfo;

  @override
  State<ChanelOfGroup> createState() => _ChanelOfGroupState();
}

class _ChanelOfGroupState extends State<ChanelOfGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.channelInfo?[0].category??"",style: TextStyle(color: Colors.white)),),
      actions: [Icon(Icons.search,color: Colors.white,),SizedBox(width: 20,)],
        backgroundColor: Colors.blue,
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          // childAspectRatio: 2.4 / 3,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
        ),
        itemCount: widget.channelInfo?.length??0,
        itemBuilder: (context, index) {
          ChannelInfo channel = widget.channelInfo![index];
          return InkWell(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) =>  VedioPlayer(currentChanel: widget.channelInfo![index],channelsInfo:widget.channelInfo ,)),
              // );
              showGeneralDialog(
                barrierLabel: "page_key",
                barrierDismissible: false,
                barrierColor: Colors.black.withOpacity(0.5),
                transitionDuration: Duration(milliseconds: 200),
                context: context,
                pageBuilder: (context, anim1, anim2) {
                  return VideoPlayer(currentChanel: widget.channelInfo![index],channelsInfo:widget.channelInfo ,);
                },
                transitionBuilder: (context, anim1, anim2, child) {
                  return SlideTransition(
                    position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
                    child: child,
                  );
                },
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 90,
                    child: channel.image?.isNotEmpty ?? false
                        ? Image.network(
                      channel.image!,
                      errorBuilder: (context, error, stackTrace) =>Image.asset(
                        'assets/images/empty.png',
                        fit: BoxFit.cover,
                      ) ,
                      fit: BoxFit.contain,
                    )
                        : Image.asset(
                      'assets/images/empty.png',
                      fit: BoxFit.cover,
                    ),

                  ),
                  SizedBox(height: 4),
                  Text(
                    channel.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    channel.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
