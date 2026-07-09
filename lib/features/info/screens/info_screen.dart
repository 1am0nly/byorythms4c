import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:biorhythms_flutter/core/constants/strings.dart';
import 'package:biorhythms_flutter/features/info/data/info_articles.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.biorhythmInfo)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: getArticles(context).length,
        itemBuilder: (context, index) {
          final article = getArticles(context)[index];
          final descriptions = [
            s.infoDescTheory,
            s.infoDescPhysical,
            s.infoDescEmotional,
            s.infoDescIntellectual,
            s.infoDescCritical,
            s.infoDescCompatibility,
            s.infoDescIntuitive,
          ];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(
                article.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                descriptions[index],
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/info/${article.id}'),
            ),
          );
        },
      ),
    );
  }
}
