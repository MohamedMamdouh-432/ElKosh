import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'سياسة الخصوصية',
          style: TextStyle(fontFamily: 'ArabicFont', color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 105, 151, 231),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "سياسة الخصوصية",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ArabicFont'),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 10),
              const Text(
                "آخر تحديث: فبراير 2025",
                style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'ArabicFont'),
                textAlign: TextAlign.right,
              ),
              const Divider(),
              const SizedBox(height: 10),
              _buildSectionTitle("1. المقدمة"),
              _buildSectionContent(
                  "خصوصيتك تهمنا. توضح سياسة الخصوصية هذه كيفية جمعنا واستخدامنا وكشفنا عن معلوماتك وحمايتها عند استخدامك لتطبيقنا."),
              _buildSectionTitle("2. المعلومات التي نجمعها"),
              _buildSectionContent(
                  "قد نقوم بجمع بيانات شخصية مثل الاسم والبريد الإلكتروني  عند تفاعلك مع تطبيقنا."),
              _buildSectionTitle("3. كيفية استخدامنا لمعلوماتك"),
              _buildSectionContent(
                  "نستخدم معلوماتك لتقديم خدماتنا وتحسينها وتخصيصها، بما في ذلك وظائف التطبيق والأمان."),
              _buildSectionTitle("4. مشاركة معلوماتك"),
              _buildSectionContent(
                  "نحن لا نبيع أو نؤجر بياناتك الشخصية. ومع ذلك، قد نشاركها مع خدماتنا لتعزيز ميزات التطبيق."),
              _buildSectionTitle("5. أمان البيانات"),
              _buildSectionContent(
                  "نحن نأخذ الأمان على محمل الجد ونستخدم طرق التشفير والتخزين الآمن لحماية بياناتك."),
              _buildSectionTitle("6. التغييرات على هذه السياسة"),
              _buildSectionContent(
                  "قد نقوم بتحديث سياسة الخصوصية هذه من وقت لآخر. نوصي بمراجعتها بشكل دوري."),
              const SizedBox(height: 20),
              _buildSectionTitle("7. إلغاء الطلب"),
              _buildSectionContent(
                  "- فى حالة إلغاء الطلب قبل تحركه من المتجر إلى المستخدم فإنه لا يوجد أى رسوم.\n"
                  "- وفى حالة إلغاء الطلب عند وصوله للموقع المحدد أو وصوله للمستخدم يكون هناك رسوم التوصيل والعودة."),
              _buildSectionTitle("8. حذف الحساب والبيانات"),
              _buildSectionContent(
                  "عند اختيار حذف الحساب يتم حذف حساب المستخدم وحذف كل بياناته."),
              const Divider(),
              _buildSectionTitle(" ملحوظة هامة"),
              _buildSectionContent(
                  "نظرًا لتغير الأسعار من وقت لآخر، إذا طلب المستخدم سلعة بسعر وتم تحديث السعر، سوف يتم التواصل مع المستخدم لتنبيهه على السعر الجديد. نرجوا من المستخدمين قبول العذر."),
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
