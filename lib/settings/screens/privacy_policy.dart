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
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("معلومات الاتصال الشخصية"),
                _buildSectionContent(
                    "نقوم بجمع المعلومات عن مستخدمى تطبيق خير بلدنا كالأسم ثلاثى ورقم الهاتف وموقع المستخدم وذلك لتأمين حساب المستخدم وتأمين الطلب حتى وصوله للموقع"),
                _buildSectionContent(
                    "التطبيق لايقوم باستخدام اى معلومات خاصة بالمستخدم إلا عند التواصل للتأكد على وصول الطلب أو الاستفسار عن الخدمة وتقيمها او تعديل سعر مسجل وتم تعديله"),
                _buildSectionTitle("إلغاء الطلب"),
                _buildSectionContent(
                    "- فى حالة إلغاء الطلب قبل تحركه من المتجر إلى المستخدم فإنه لايوجد اى رسوم\n"
                    "- وفى حالة الغاء الطلب عند وصوله للموقع المحدد او وصوله للمستخدم يكون هناك رسوم التوصيل والعودة"),
                _buildSectionTitle("حذف الحساب والبيانات"),
                _buildSectionContent(
                    "عند اختيار حذف الحساب يتم حذف حساب المستخدم وحذف كل بياناته"),
                _buildSectionTitle("ملحوظة هامة"),
                _buildSectionContent(
                    "نظرا لموقف تغير الأسعار من وقت لآخر اذا طلب المستخدم سلعة بسعر وتم تحديث السعر سوف يتم التواصل مع المستخدم لتنبيهه على السعر الجديد ونرجوا من المستخدمين قبول العذر"),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 105, 151, 231),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("عودة",
                        style: TextStyle(
                            fontFamily: 'ArabicFont', color: Colors.white)),
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
