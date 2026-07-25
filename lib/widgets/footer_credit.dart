import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterCredit extends StatelessWidget {
  const FooterCredit({super.key});

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://digitalheroesco.com');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch \$url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: InkWell(
          onTap: _launchUrl,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              'Built for Digital Heroes Training Task',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
