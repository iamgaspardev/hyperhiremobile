import 'package:flutter/material.dart';
import 'package:hyperhire/services/service.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];
  late OpenChannel channel;

  @override
  void initState() {
    super.initState();

    // Initialize Sendbird and join the channel
    HandleService.initialize().then((_) async {
      channel = await OpenChannel.getChannel(HandleService.CHANNEL_URL);
      print("data retrived ------------------------------");
      print(channel);
      channel.enter();
      print("data retrived ------------------------------");
      
    });
  }

  void _sendMessage(String message) async {
    try {
      // Send the message through Sendbird
      await channel.sendUserMessage(
          UserMessageParams(data: _messageController.text, message: message));
      setState(() {
        _messages.add(_messageController.text);
      });
      _messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> messageContainers = _messages.map((message) {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              color: Color.fromARGB(255, 35, 35, 36),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      );
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: messageContainers,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: _messageController,
                    decoration: InputDecoration(
                      focusColor: Colors.white,
                      hoverColor: Colors.white,
                      border: const OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(60)),
                      ),
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 180, 176, 176)),
                      hintText: 'Type a message...',
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.arrow_circle_up_sharp,
                          color: Color(0xFFFF006B),
                          size: 40,
                        ),
                        onPressed: () {
                          if (_messageController.text.isNotEmpty) {
                            _sendMessage(_messageController.text);
                          }
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
