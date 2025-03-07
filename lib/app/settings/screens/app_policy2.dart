import 'package:flutter/material.dart';

class AppIntroductionPage extends StatelessWidget {
  const AppIntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "تعريف التطبيق",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ArabicFont'),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                _buildSectionContent(
                    "يتيح لك طلب الطعام أو المنتجات الأخرى من متاجر ومطاعم مختلفة وتوصيلها مباشرة إلى باب منزلك أو مكان عملك."),
                const SizedBox(height: 20),
                _buildSectionTitle("كيف يعمل؟"),
                _buildSectionContent(
                    "* التنزيل والتسجيل: تقوم بتنزيل التطبيق على هاتفك وتسجيل حساب فيه.\n"
                    "* البحث عن المنتجات: تستعرض قائمة المطاعم والمتاجر المتاحة في منطقتك وتختار ما تريد طلبه.\n"
                    "* إضافة إلى السلة: تضيف المنتجات التي ترغب بها إلى سلة التسوق الخاصة بك.\n"
                    "* الدفع: تقوم بدفع قيمة الطلب عند وصوله إليك."),
                const SizedBox(height: 20),
                _buildSectionTitle("مزايا استخدام تطبيقات توصيل الطلبات"),
                _buildSectionContent(
                    "* راحة: لا تحتاج للخروج من المنزل أو المكتب لتلبية احتياجاتك.\n"
                    "* تتوفر مجموعة واسعة من المتاجر للاختيار من بينها.\n"
                    "* مقارنة الأسعار: يمكنك مقارنة الأسعار والعروض المختلفة بين المطاعم والمتاجر.\n"
                    "* توفير الوقت: يوفر عليك وقت الانتظار أو البحث عن منتجات معينة."),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("عودة",
                        style: TextStyle(fontFamily: 'ArabicFont')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 5),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'ArabicFont'),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: const TextStyle(fontSize: 14, fontFamily: 'ArabicFont'),
      textAlign: TextAlign.right,
    );
  }
}
