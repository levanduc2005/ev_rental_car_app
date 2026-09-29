import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Clean Architecture Dependency Rules', () {
    final featuresDir = Directory('lib/features');

    List<File> getDartFiles(String subfolder) {
      if (!featuresDir.existsSync()) return [];
      return featuresDir.listSync(recursive: true).whereType<File>().where((f) {
        final p = f.path.replaceAll('\\', '/');
        return p.contains('/$subfolder/') &&
            p.endsWith('.dart') &&
            !p.endsWith('.g.dart') &&
            !p.endsWith('.freezed.dart');
      }).toList();
    }

    test('Rule 1: Domain layer must NEVER import from Data layer', () {
      final domainFiles = getDartFiles('domain');
      final violations = <String>[];
      final dataPattern = RegExp(r'import\s+.*\/data\/');

      for (final file in domainFiles) {
        final content = file.readAsStringSync();
        if (dataPattern.hasMatch(content)) {
          violations.add(file.path);
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'Vi phạm Clean Architecture: Các file domain sau đây KHÔNG ĐƯỢC import từ data:\n'
            '${violations.join('\n')}',
      );
    });

    test('Rule 2: Domain layer must NEVER import from Presentation layer', () {
      final domainFiles = getDartFiles('domain');
      final violations = <String>[];
      final presentationPattern = RegExp(r'import\s+.*\/presentation\/');

      for (final file in domainFiles) {
        final content = file.readAsStringSync();
        if (presentationPattern.hasMatch(content)) {
          violations.add(file.path);
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'Vi phạm Clean Architecture: Các file domain sau đây KHÔNG ĐƯỢC import từ presentation:\n'
            '${violations.join('\n')}',
      );
    });

    test('Rule 3: Domain layer must be pure Dart (no Flutter UI or Dio)', () {
      final domainFiles = getDartFiles('domain');
      final violations = <String>[];

      for (final file in domainFiles) {
        final content = file.readAsStringSync();
        if (content.contains('package:flutter/') ||
            content.contains('package:dio')) {
          violations.add(file.path);
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'Vi phạm Clean Architecture: Domain phải là pure Dart, không được phụ thuộc Flutter UI hay Dio:\n'
            '${violations.join('\n')}',
      );
    });

    test('Rule 4: Data layer must NEVER import from Presentation layer', () {
      final dataFiles = getDartFiles('data');
      final violations = <String>[];
      final presentationPattern = RegExp(r'import\s+.*\/presentation\/');

      for (final file in dataFiles) {
        final content = file.readAsStringSync();
        if (presentationPattern.hasMatch(content)) {
          violations.add(file.path);
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'Vi phạm Clean Architecture: Các file data sau đây KHÔNG ĐƯỢC import từ presentation:\n'
            '${violations.join('\n')}',
      );
    });

    test(
      'Rule 5: UI (pages & widgets) must NEVER directly import DataSources or RepositoryImpls',
      () {
        if (!featuresDir.existsSync()) return;

        final uiFiles = featuresDir
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) {
              final p = f.path.replaceAll('\\', '/');
              return (p.contains('/presentation/pages/') ||
                      p.contains('/presentation/widgets/')) &&
                  p.endsWith('.dart');
            })
            .toList();

        final violations = <String>[];
        final forbiddenPattern = RegExp(
          r'import\s+.*(_data_source|_repository_impl)\.dart',
        );

        for (final file in uiFiles) {
          final content = file.readAsStringSync();
          if (forbiddenPattern.hasMatch(content)) {
            violations.add(file.path);
          }
        }

        expect(
          violations,
          isEmpty,
          reason:
              'Vi phạm Clean Architecture: Giao diện UI (pages/widgets) KHÔNG ĐƯỢC gọi trực tiếp DataSource hoặc RepositoryImpl (phải thông qua Providers/Controllers):\n'
              '${violations.join('\n')}',
        );
      },
    );

    test('Rule 6: Every feature with a Repository MUST have domain/usecases', () {
      final features = featuresDir.listSync().whereType<Directory>();
      final missingUsecases = <String>[];

      for (final feature in features) {
        final repoDir = Directory('${feature.path}/domain/repositories');
        final usecaseDir = Directory('${feature.path}/domain/usecases');

        if (repoDir.existsSync()) {
          final hasDartFiles = repoDir.listSync().any(
            (f) => f.path.endsWith('.dart'),
          );
          if (hasDartFiles &&
              (!usecaseDir.existsSync() ||
                  usecaseDir.listSync().whereType<File>().isEmpty)) {
            missingUsecases.add(feature.path.replaceAll(r'\', '/'));
          }
        }
      }

      expect(
        missingUsecases,
        isEmpty,
        reason:
            'Vi phạm Clean Architecture: Các feature sau có Repository nhưng THIẾU TẦNG USECASES:\n'
            '${missingUsecases.join('\n')}',
      );
    });

    test(
      'Rule 7: UI pages & widgets must NEVER directly call Repository or RepositoryProvider',
      () {
        if (!featuresDir.existsSync()) return;

        final uiFiles = featuresDir
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) {
              final p = f.path.replaceAll(r'\', '/');
              return (p.contains('/presentation/pages/') ||
                      p.contains('/presentation/widgets/')) &&
                  p.endsWith('.dart');
            })
            .toList();

        final violations = <String>[];

        for (final file in uiFiles) {
          final content = file.readAsStringSync();
          if (content.contains('RepositoryProvider') ||
              content.contains('Repository>')) {
            violations.add(file.path.replaceAll(r'\', '/'));
          }
        }

        expect(
          violations,
          isEmpty,
          reason:
              'Vi phạm Clean Architecture: Giao diện UI (pages/widgets) KHÔNG ĐƯỢC gọi trực tiếp Repository/RepositoryProvider:\n'
              '${violations.join('\n')}',
        );
      },
    );
  });
}
