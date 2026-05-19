import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/services/accessibility_service.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _announced = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_announced) {
        _announced = true;
        AccessibilityService.announceWithRTL('Chats screen');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.only(
              top: 60,
              left: 16,
              right: 16,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              color: Color(0xff2F80ED),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const Center(
                  child: Text(
                    'Chats',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // SEARCH
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.trim().toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Semantics(
                        label: 'Search conversations',
                        child: Icon(Icons.search),
                      ),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : Semantics(
                              button: true,
                              label: 'Clear search',
                              child: Tooltip(
                                message: 'Clear search',
                                child: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                ),
                              ),
                            ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

         


          // CHAT LIST
          Expanded(
            child: ZIMKitConversationListView(
              filter: (context, conversations) {
                if (_searchQuery.isEmpty) {
                  return conversations;
                }

                return conversations.where((item) {
                  final searchableText = _conversationSearchText(item);
                  return searchableText.contains(_searchQuery);
                }).toList();
              },
              onPressed: (
                context,
                conversation,
                defaultAction,
              ) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ZIMKitMessageListPage(
                      
                        theme:ThemeData(
                          primaryColor: AppColors.primary,
                          appBarTheme: const AppBarTheme(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            
                          ),
                        ),
                        conversationID: conversation.id,
                        conversationType: conversation.type,
                      );
                    },
                  ),
                );
              },

              itemBuilder: (
                context,
                conversation,
                defaultWidget,
              ) {
                final semanticLabel = _conversationSemanticLabel(conversation);

                return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Semantics(
                    button: true,
                    container: true,
                    label: semanticLabel,
                    child: defaultWidget,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _conversationSearchText(dynamic item) {
    final parts = <String>[];

    try {
      final dynamic conversation = item.value;
      if (conversation != null) {
        parts.add((conversation.name ?? '').toString());
        parts.add((conversation.lastMessage?.toString() ?? '').toString());
      }
    } catch (_) {}

    try {
      final dynamic conversation = item.conversation;
      if (conversation != null) {
        parts.add((conversation.name ?? '').toString());
        parts.add((conversation.lastMessage?.toString() ?? '').toString());
      }
    } catch (_) {}

    parts.add(item.toString());
    return parts.join(' ').toLowerCase();
  }

  String _conversationSemanticLabel(dynamic conversation) {
    try {
      final dynamic value = conversation.value;
      final name = (value?.name ?? conversation.conversation?.name ?? 'Conversation')
          .toString();
      final lastMessage = (value?.lastMessage ?? conversation.conversation?.lastMessage)
          ?.toString();

      if (lastMessage != null && lastMessage.isNotEmpty) {
        return 'Conversation with $name, last message $lastMessage';
      }

      return 'Conversation with $name';
    } catch (_) {
      return 'Conversation item';
    }
  }
}