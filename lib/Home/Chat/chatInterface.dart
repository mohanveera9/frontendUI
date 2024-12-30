import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Chatinterface extends StatefulWidget {
  final String name;
  final String role;
  final String userId;
  final String supportId;

  const Chatinterface({
    super.key,
    required this.name,
    required this.role,
    required this.userId,
    required this.supportId,
  });

  @override
  State<Chatinterface> createState() => _ChatinterfaceState();
}

class _ChatinterfaceState extends State<Chatinterface> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isTyping = false;
  final List<String> receivedMessages = [
    "Hello, how are you?",
    "I'm doing great, thanks!",
    "How about you?"
  ];
  final List<String> sentMessages = [];
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    
    // Initialize the socket connection
    socket = IO.io(
      'https://tech-hackathon-glowhive.onrender.com', // Your server URL
      IO.OptionBuilder()
          .setTransports(['websocket']) // Use WebSocket transport
          .build(),
    );

    // Listen for incoming messages
    socket.on('recieveMessage', (data) {
      setState(() {
        receivedMessages.add(data['message']);
      });
    });

    // Listen for connection status
    socket.on('connect', (_) {
      print('Connected to socket server');
      socket.emit('connect', widget.userId); // Join room or do any initial setup
    });

    socket.on('disconnect', (_) {
      print('Disconnected from socket server');
    });

    // Handle typing event
    _controller.addListener(() {
      setState(() {
        isTyping = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    socket.dispose();  // Close the socket when widget is disposed
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Send message function
  void sendMessage() {
    if (_controller.text.isNotEmpty) {
      // Emit the message to the server
      socket.emit('sendMessage', {
        'senderId': widget.userId,
        'receiverId': widget.supportId,
        'message': _controller.text,
      });

      setState(() {
        sentMessages.add(_controller.text);
        _controller.clear();
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (FocusScope.of(context).isFirstFocus) {
          FocusScope.of(context).unfocus(); // Dismiss the keyboard if it's open
          return false; // Prevents back button closing the app directly
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 70,
          backgroundColor: const Color(0xFF39D0D1),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
          automaticallyImplyLeading: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        widget.role,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      details.globalPosition.dx + 10,
                      details.globalPosition.dy + 20,
                      details.globalPosition.dx + 40,
                      details.globalPosition.dy + 40,
                    ),
                    items: [
                      const PopupMenuItem(
                        value: 'Clear Chat',
                        child: Text(
                          'Clear Chat',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'Report',
                        child: Text(
                          'Report',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'Block',
                        child: Text(
                          'Block',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                    elevation: 10,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    shadowColor: Colors.black,
                  ).then((value) {
                    switch (value) {
                      case 'Clear Chat':
                        // Handle clear chat logic
                        break;
                      case 'Report':
                        // Handle report action
                        break;
                      case 'Block':
                        // Handle block action
                        break;
                    }
                  });
                },
                child: const Icon(
                  Icons.more_vert_outlined,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
        body: SizedBox(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController, // Attach the ScrollController
                      itemCount: receivedMessages.length + sentMessages.length,
                      itemBuilder: (context, index) {
                        if (index < receivedMessages.length) {
                          return buildReceivedMessage(
                            receivedMessages[index], 
                            index,
                          );
                        } else {
                          return buildSentMessage(
                            sentMessages[index - receivedMessages.length],
                            index - receivedMessages.length,
                          );
                        }
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            color: const Color(0xFF39D0D1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  cursorColor: Colors.black,
                                  decoration: const InputDecoration(
                                    hintText: 'Type a message...',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: Color(0xFF0C3F9E),
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.send,
                                  color: Color(0xFF0C3F9E),
                                ),
                                onPressed: () {
                                  sendMessage();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build received messages widget
  Widget buildReceivedMessage(String message, int index) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 30, 123, 179),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to build sent messages widget
  Widget buildSentMessage(String message, int index) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Color(0xFF39D0D1),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
