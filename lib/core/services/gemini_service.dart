import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _defaultApiKey = '';

  Future<String> getAssistantResponse(String prompt) async {
    const apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: _defaultApiKey);
    
    if (apiKey.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 700));
      return _generateAbirAdvancedResponse(prompt);
    }

    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
      final content = [
        Content.text(
          'You are Abir, an ultra-advanced AI Life Assistant, ChatGPT-style polymath, productivity coach, and expert translator in the LifeLoop app. '
          'If the user writes in Bengali (বাংলা), respond in fluent, natural Bengali. If they write in English, respond in English. '
          'You can write code, translate languages, plan daily routines, solve problems, and give profound life advice. '
          'User prompt: $prompt'
        )
      ];
      final response = await model.generateContent(content);
      return response.text ?? 'আমি আবির, আপনার এআই লাইফ অ্যাসিস্ট্যান্ট। আমি কীভাবে সাহায্য করতে পারি? (I am Abir, your AI Life Assistant. How can I help?)';
    } catch (e) {
      return 'Abir AI Connection Note: ${e.toString()}. Operating in advanced offline intelligence mode.';
    }
  }

  String _generateAbirAdvancedResponse(String prompt) {
    final lower = prompt.toLowerCase();
    
    // Check if prompt is in Bengali or asks for translation / routines
    final isBengali = prompt.runes.any((rune) => rune >= 0x0980 && rune <= 0x09FF);

    if (isBengali) {
      if (lower.contains('রুটিন') || lower.contains('routine') || lower.contains('সকাল')) {
        return '🤖 **আবির এআই (Abir AI):** আপনার আজকের এআই-অপ্টিমাইজড রুটিন:\n\n'
            '🌅 **সকাল ৭:০০ টা:** ঘুম থেকে ওঠা ও পানি পান (Hydration)\n'
            '🧘 **সকাল ৭:১৫ টা:** ১৫ মিনিট হালকা ব্যায়াম বা মেডিটেশন\n'
            '💻 **সকাল ৮:০০ টা:** দিনের সবচেয়ে গুরুত্বপূর্ণ কাজের জন্য ডিপ ওয়ার্ক (Deep Work)\n'
            '🥗 **সকাল ১০:০০ টা:** পুষ্টিকর সকালের নাস্তা\n\n'
            'আপনার কি অন্য কোনো বিষয়ে সাহায্য লাগবে?';
      } else if (lower.contains('অনুবাদ') || lower.contains('translate') || lower.contains('इंग्लिश')) {
        return '🌐 **অনুবাদ সেবা (Translation):** আপনি যেকোনো ভাষা থেকে বাংলা বা ইংরেজিতে অনুবাদ করতে বলতে পারেন। যেমন:\n'
            '• *"Translate this to Bengali..."*\n'
            '• *"এটা ইংরেজিতে অনুবাদ করো..."*\n\n'
            'আপনার টেক্সটটি এখানে পাঠান!';
      } else {
        return '💡 **আবির এআই পরামর্শ:** "${prompt}"\n\n'
            'আপনার লক্ষ্য অর্জনে আমি সর্বদা প্রস্তুত। ছোট ছোট পদক্ষেপে কাজ করুন এবং প্রতিটি দিনকে কাজে লাগান। কোডিং, পড়াশোনা বা রুটিন তৈরিতে আমি কীভাবে সাহায্য করতে পারি বলুন!';
      }
    } else {
      if (lower.contains('routine') || lower.contains('morning') || lower.contains('schedule')) {
        return '🤖 **Abir AI Assistant:** Here is your advanced daily schedule:\n\n'
            '🌅 **07:00 AM** - Hydration & 10-min mindfulness\n'
            '⚡ **07:30 AM** - High-focus Deep Work sprint\n'
            '🥗 **09:00 AM** - Nutritious breakfast & planning\n\n'
            'How else can I assist you today?';
      } else {
        return '💡 **Abir AI Insights:** "${prompt}"\n\n'
            'As your ChatGPT-class assistant in LifeLoop, I can write code, translate languages, plan your schedule, and answer complex questions. Let me know what you would like to do next!';
      }
    }
  }
}
