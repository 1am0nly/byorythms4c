import 'package:flutter/material.dart';
import 'package:biorhythms_flutter/features/info/data/info_articles.dart';

class InfoArticleDetailScreen extends StatelessWidget {
  final String articleId;

  const InfoArticleDetailScreen({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    final articles = getArticles(context);
    final article = articles.firstWhere(
      (a) => a.id == articleId,
      orElse: () => articles.first,
    );

    return Scaffold(
      appBar: AppBar(title: Text(article.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              article.body,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
            ),
            if (article.footnote != null) ...[
              const SizedBox(height: 24),
              Divider(color: Theme.of(context).colorScheme.outlineVariant),
              const SizedBox(height: 8),
              Text(
                article.footnote!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
