import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:Television/utils/modal_channel_info.dart';
import 'package:video_player/video_player.dart';
class VideoPlayer extends StatefulWidget {
    VideoPlayer({this.currentChanel,this.channelsInfo,Key? key}) : super(key: key);
   final List<ChannelInfo>? channelsInfo;
   final ChannelInfo? currentChanel;


  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  bool isSaved=false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() async {
    videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.currentChanel?.url??""));
    await videoPlayerController.initialize();

    //national geographic
    //https://vo-live.cdb.cdn.orange.com/Content/Channel/NationalGeographicHDChannel/HLS/index.m3u8
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: true,
      cupertinoProgressColors: ChewieProgressColors(backgroundColor: Colors.white),
      additionalOptions: (context) {
        return <OptionItem>[

          OptionItem(
            onTap: () =>
                debugPrint('Option 2 pressed!'),
            iconData: Icons.share,
            title: 'share',
          ),
        ];
      },
    );
    setState(() {

    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      // background: Container(color: Colors.transparent,),
      direction: DismissDirection.vertical,
      key: const Key('page_key'),
      onDismissed: (_) {
        if(Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: chewieController!=null? Column(
          children: [
            Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height*(0.4),
              child: Chewie(
                controller: chewieController!,
              ),

            ),
            Container(
              height: 50,
              decoration:const BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.elliptical(40, 30),topLeft: Radius.circular(0),bottomLeft:  Radius.elliptical(30, 20),bottomRight: Radius.circular(0)),
                color: Colors.grey,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      widget.currentChanel?.title??"",
                      maxLines: 1,
                      style:const TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark_added : Icons.bookmark_add_outlined,
                      color: isSaved ? Colors.blue : Colors.black45,
                    ),
                    onPressed: (){
                      setState(() {
                        isSaved=!isSaved;
                      });
                    },
                  ),
                  IconButton(
                    icon:const Icon(Icons.share, color: Colors.black45),
                    onPressed: () {
                      // Handle share button press
                    },
                  ),
                ],
              ),

            ),
            Expanded(child: ListView(
              children: [
                if(widget.channelsInfo?.isNotEmpty==true)
                for( var chanel in widget.channelsInfo!)
                  InkWell(
                    onTap: (){
                      //iiiiiiiiiiiiiiiiiiiiiiii
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  VideoPlayer(currentChanel: chanel,channelsInfo:widget.channelsInfo ,)),
                      );
                    },
                    child: Container(

                      margin:const EdgeInsets.symmetric(vertical: 4),

                       decoration:const BoxDecoration(

                         color: Colors.black12,
                           border: Border.symmetric(vertical: BorderSide(color: Colors.white,width: 2) ),

                           borderRadius: BorderRadius.only(topRight: Radius.elliptical(40, 30),topLeft: Radius.circular(0),bottomLeft:  Radius.elliptical(30, 20),bottomRight: Radius.circular(0))),
                      child: Row(
                        children: [
                         const SizedBox(width: 20,),
                          Image.network(
                            chanel.image,
                            width: 70,
                            height: 80,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Container(color: Colors.transparent,width: 60,height: 60,),),
                          const SizedBox(width: 20,),

                          Text(chanel.title,style:const TextStyle(color: Colors.white),)
                        ],
                      ),
                    ),
                  )
              ],
            ))
          ],
        ) :const Center(
            child: CircularProgressIndicator(color: Colors.blue,)

        ),
      ),
    );
  }
}

