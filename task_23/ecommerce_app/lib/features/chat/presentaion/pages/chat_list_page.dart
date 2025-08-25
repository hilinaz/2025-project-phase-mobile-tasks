import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc.dart';
import '../widgets/widget.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadAllChatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context), 
        ),
        title: const Text('Chats'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            children: [
              BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is LoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is LoadedChatsState) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.chats.length,
                      itemBuilder: (context, index) {
                        final chat = state.chats[index];
                        return chatCard(
                          chat.user2,
                          onTap: () {
                            final chatBloc = context.read<ChatBloc>();
                            Navigator.pushNamed(
                              context,
                              '/chat',
                              arguments: chat,
                            ).then((_) {
                              chatBloc.add(LoadAllChatsEvent());
                            });

                            context.read<ChatBloc>().add(
                                  LoadSingleChatEvent(chatId: chat.id),
                                );
                          },
                        );
                      },
                    );
                  } else if (state is ErrorState) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         final chatBloc = context.read<ChatBloc>();
          Navigator.pushNamed(
            context,
            '/chat',
          ).then((_) {
            chatBloc.add(LoadAllChatsEvent());
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: const [
            Icon(Icons.messenger_outline_sharp, size: 28),
            Positioned(
              right: 0,
              bottom: 0,
              child: Icon(Icons.add,
                  size: 16, color: Color.fromARGB(255, 14, 50, 211)),
            ),
          ],
        ),
      ),
    );
  }
}
