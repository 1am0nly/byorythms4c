import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:biorhythms_flutter/core/constants/strings.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.feedbackTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.feedbackBody,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 16),
            Text(
              s.feedbackSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const Spacer(),
            Center(
              child: FilledButton.icon(
                icon: const Icon(Icons.mail_outline),
                label: Text(s.feedbackButton),
                onPressed: () => launchUrl(
                  Uri.parse('mailto:ant.ignasev@gmail.com?subject=Biorhythms%20Feedback'),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
