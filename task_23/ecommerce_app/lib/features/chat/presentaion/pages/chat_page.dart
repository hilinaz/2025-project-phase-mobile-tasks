import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/chat_model.dart';
import '../bloc/chat_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatModel? chat;
  bool isNew = false;
  final TextEditingController messageController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    chat = ModalRoute.of(context)!.settings.arguments as ChatModel?;
    if (chat == null) {
      isNew = true;
    } else {
      context.read<ChatBloc>().add(LoadChatMessageEvent(chatId: chat!.id));
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (value.isNotEmpty) {
      context.read<ChatBloc>().add(GetAllUsersEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is InitializedChatState) {
       
          final ChatModel chat = state.chat;
          Navigator.pushNamed(context, '/chat', arguments: chat);
        } else if (state is ErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(chat != null ? chat!.user2.name : 'New Conversation'),
        ),
        body: Column(
          children: [
            Expanded(
              child: chat != null
                  ? BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, state) {
                        if (state is LoadingState) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is LoadedMessageState) {
                          return ListView.builder(
                            reverse: true,
                            itemCount: state.messages.length,
                            itemBuilder: (context, index) {
                              final msg = state.messages[index];
                              return Align(
                                alignment: msg.sender == "me"
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: msg.sender == "me"
                                        ? const Color.fromARGB(
                                            255, 57, 118, 232)
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(msg.content),
                                ),
                              );
                            },
                          );
                        } else if (state is ErrorState) {
                          return Center(child: Text(state.message));
                        }
                        return const SizedBox();
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: searchController,
                            onChanged: _onSearchChanged,
                            decoration: InputDecoration(
                              hintText: 'Search for a user...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: BlocBuilder<ChatBloc, ChatState>(
                              builder: (context, state) {
                                if (state is LoadingState) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (state is LoadedAllUsersState) {
                                  final query = searchController.text
                                      .trim()
                                      .toLowerCase();
                                  final filtered = state.users
                                      .where((u) =>
                                          u.name.toLowerCase().contains(query))
                                      .toList();

                                  if (filtered.isEmpty) {
                                    return const Center(
                                      child: Text('No users found'),
                                    );
                                  }

                                  return ListView.builder(
                                    itemCount: filtered.length,
                                    itemBuilder: (context, index) {
                                      final user = filtered[index];
                                      return ListTile(
                                        leading: const CircleAvatar(
                                            child: Icon(Icons.person)),
                                        title: Text(user.name),
                                        onTap: () {
                                          context.read<ChatBloc>().add(
                                              InitiateNewChatEvent(
                                                  userId: user.id));
                                        },
                                      );
                                    },
                                  );
                                }
                                return const Center(
                                  child: Text(
                                    'Start a new conversation',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (messageController.text.trim().isEmpty) return;

                        context.read<ChatBloc>().add(SendMessageEvent(
                              ChatId: chat?.id ?? '',
                              Content: messageController.text.trim(),
                              type: 'text',
                            ));
                        messageController.clear();
                      },
                      icon: const Icon(Icons.send),
                      color: const Color.fromARGB(255, 17, 21, 145),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
