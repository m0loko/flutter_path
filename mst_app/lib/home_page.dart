import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart'; // Импорт для перехода при сбросе

// --- ЦВЕТА (Те же, что и раньше) ---
class AppColors {
  static const Color backgroundBlue = Color(0xFFCDE6F8);
  static const Color accentPurple = Color(0xFF6C63FF);
  static const Color textDark = Color(0xFF2D3436);
  static const Color textGrey = Color(0xFF636E72);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Логика сброса (для демонстрации)
  Future<void> _resetSubscription(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    // Удаляем ключ подписки
    await prefs.remove('is_premium');

    if (!context.mounted) return;

    // Возвращаемся на Онбординг
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Главная",
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Иконка выхода (сброса)
          IconButton(
            onPressed: () => _resetSubscription(context),
            icon: const Icon(Icons.logout, color: AppColors.accentPurple),
            tooltip: "Сбросить подписку",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // --- 1. КАРТОЧКА СТАТУСА (PREMIUM) ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.accentPurple,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentPurple.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.workspace_premium, color: Colors.white, size: 40),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Premium Активен",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Спасибо за подписку!",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Доступный контент",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 15),

            // --- 2. СПИСОК КОНТЕНТА (Requirement: List) ---
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _buildContentItem(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Виджет элемента списка
  Widget _buildContentItem(int index) {
    // Просто фейковые данные для примера
    final titles = [
      "Секретные проекты MST",
      "Уроки Flutter Architecture",
      "Аналитика рынка",
      "Закрытый чат",
      "Настройки профиля",
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.backgroundBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.lock_open, color: AppColors.accentPurple),
        ),
        title: Text(
          titles[index],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        subtitle: const Text("Нажмите, чтобы открыть"),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {
          // Просто клик
        },
      ),
    );
  }
}
