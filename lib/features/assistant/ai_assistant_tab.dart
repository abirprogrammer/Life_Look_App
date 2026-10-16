import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/app_providers.dart';

class AiAssistantTab extends ConsumerStatefulWidget {
  const AiAssistantTab({super.key});

  @override
  ConsumerState<AiAssistantTab> createState() => _AiAssistantTabState();
}

class _AiAssistantTabState extends ConsumerState<AiAssistantTab> {
  final _controller = TextEditingController();
  bool _isSending = false;

  final List<String> _quickPrompts = [
    'আজকের রুটিন তৈরি করো',
    'Translate to English',
    'How to beat procrastination',
    'কোডিং এ সাহায্য করো (Code help)',
  ];

  Future<void> _send(String text) async {
    if (text.trim().isEmpty) return;
    _controller.clear();
    setState(() => _isSending = true);
    await ref.read(chatMessagesProvider.notifier).sendMessage(text);
    if (mounted) setState(() => _isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: AppTheme.primaryPurple, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.psychology, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Text('Abir AI — ChatGPT & Translator', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppTheme.primaryPurple.withOpacity(0.08),
            child: const Row(
              children: [
                Icon(Icons.translate, size: 16, color: AppTheme.primaryPurple),
                SizedBox(width: 8),
                Expanded(child: Text('বাংলা বা ইংরেজিতে কথা বলুন, কোড করুন বা অনুবাদ করুন।', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: msg.isUser ? AppTheme.primaryPurple : Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4)),
                      ],
                      border: msg.isUser ? null : Border.all(color: AppTheme.primaryPurple.withOpacity(0.2)),
                    ),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!msg.isUser) ...[
                          const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome, size: 14, color: AppTheme.primaryPurple),
                              SizedBox(width: 4),
                              Text('Abir AI (ChatGPT Engine)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryPurple)),
                            ],
                          ),
                          const SizedBox(height: 6),
                        ],
                        Text(
                          msg.text,
                          style: TextStyle(color: msg.isUser ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isSending)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: LinearProgressIndicator(color: AppTheme.primaryPurple),
            ),
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _quickPrompts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(_quickPrompts[index], style: const TextStyle(fontSize: 12)),
                    onPressed: () => _send(_quickPrompts[index]),
                    backgroundColor: AppTheme.primaryPurple.withOpacity(0.1),
                    labelStyle: const TextStyle(color: AppTheme.primaryPurple, fontWeight: FontWeight.w600),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).cardTheme.color,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Ask Abir in Bengali or English...',
                      border: InputBorder.none,
                      filled: false,
                    ),
                    onSubmitted: (val) => _send(val),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: AppTheme.primaryPurple),
                  onPressed: _isSending ? null : () => _send(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
