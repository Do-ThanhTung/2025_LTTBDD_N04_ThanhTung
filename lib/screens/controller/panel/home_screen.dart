import 'package:education/models/response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:education/widgets/circle_button.dart';
import 'package:education/models/api.dart';
import 'package:education/screens/controller/panel/settings_screen.dart';
import 'package:education/l10n/app_localizations.dart';
import 'package:translator_plus/translator_plus.dart';
import 'package:education/services/translation_service.dart';
import 'package:education/services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool inProgress = false;
  ResponseModel? responseModel;
  String noDataText = "";
  final translator = GoogleTranslator();
  final Map<int, bool> _translating = {};
  bool _notifEnabled = true;
  final TextEditingController _searchController = TextEditingController();
  Map<String, String> _suggestionMap = {};

  @override
  void initState() {
    super.initState();
    // ensure notification setting is loaded before UI interactions
    NotificationService.instance.loadConfig().then((_) {
      if (!mounted) return;
      setState(() {
        _notifEnabled = NotificationService.instance.enabled;
      });
    });
    // Load local suggestion words (original -> translation)
    TranslationService.instance.getEnglishMap().then((map) {
      if (!mounted) return;
      setState(() {
        _suggestionMap = map;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
              ),
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF98A77C),
                    Color(0xFFB6C99B),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            AppLocalizations.t(
                              context,
                              'practice_dictionary',
                            ),
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CircleButton(
                            icon: _notifEnabled
                                ? Icons.notifications
                                : Icons.notifications_none,
                            onPressed: () async {
                              // toggle notification enabled state
                              final newVal = !_notifEnabled;
                              // compute feedback message before awaiting to avoid using context after async gap
                              final toastMsg = newVal
                                  ? 'Thông báo đã bật'
                                  : 'Thông báo đã tắt';
                              await NotificationService.instance
                                  .saveConfig(newVal);
                              if (!mounted) return;
                              setState(() {
                                _notifEnabled = newVal;
                              });
                              // immediate feedback regardless of setting
                              if (!mounted) return;
                              // ignore: use_build_context_synchronously
                              NotificationService.instance
                                  .showToastWithoutContext(
                                toastMsg,
                                duration: const Duration(seconds: 1),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          // Ensure settings button is tappable even if custom widget
                          Material(
                            color: Colors.transparent,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.settings,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSearchWidget(),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (inProgress)
              const LinearProgressIndicator()
            else if (responseModel != null)
              Expanded(child: _buildResponseWidget())
            else
              _noDataWidget(),
          ],
        ),
      ),
    );
  }

  _buildSearchWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          final input = textEditingValue.text.toLowerCase();
          if (input.isEmpty) {
            return const Iterable<String>.empty();
          }
          return _suggestionMap.keys
              .where((k) => k.toLowerCase().contains(input));
        },
        displayStringForOption: (option) => option,
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 6,
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.12 * 255).round()),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                constraints:
                    const BoxConstraints(maxHeight: 260, maxWidth: 520),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options.elementAt(index);
                    final vi = _suggestionMap[option] ?? '';
                    return InkWell(
                      onTap: () => onSelected(option),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(option,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black87)),
                            ),
                            const SizedBox(width: 12),
                            if (vi.isNotEmpty)
                              Text(vi,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700])),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          // keep the local controller in sync
          controller.text = _searchController.text;
          controller.selection = _searchController.selection;
          controller.addListener(() {
            _searchController.value = controller.value;
          });
          // styled pill container
          return Container(
            height: 56,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color:
                  const Color(0xFFCBD9A8), // light green fill matching header
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.12 * 255).round()),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: AppLocalizations.t(context, 'vocabulary'),
                hintStyle: TextStyle(
                    color: Colors.white.withAlpha((0.9 * 255).round())),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 12.0, right: 8.0),
                  child: Icon(Icons.search, color: Colors.white),
                ),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 36, minHeight: 36),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
              ),
              onSubmitted: (value) {
                _getMeaningFromApi(value);
              },
            ),
          );
        },
        onSelected: (selection) {
          _searchController.text = selection;
          _getMeaningFromApi(selection);
        },
      ),
    );
  }

  _getMeaningFromApi(String word) async {
    setState(() {
      inProgress = true;
    });
    try {
      responseModel = await API.fetchMeaning(word);
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      responseModel = null;
      // capture localized string safely (avoid using context after await if disposed)
      final msg = AppLocalizations.t(
        context,
        'meaning_cannot_be_fetched',
      );
      noDataText = msg;
      if (!mounted) return;
      setState(() {});
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }

  _buildResponseWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        Text(
          responseModel!.word!,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        Text(responseModel!.phonetic ?? ""),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return _buildMeaningWidget(
                responseModel!.meanings![index],
                index,
              );
            },
            itemCount: responseModel!.meanings!.length,
          ),
        ),
      ],
    );
  }

  _noDataWidget() {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(
          noDataText.isNotEmpty
              ? noDataText
              : AppLocalizations.t(
                  context,
                  'welcome_start',
                ),
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  _buildMeaningWidget(Meanings meanings, int meaningIndex) {
    String definitionList = "";
    meanings.definitions?.forEach((element) {
      int index = meanings.definitions!.indexOf(
        element,
      );
      definitionList += "\n${index + 1}. ${element.definition}\n";
    });
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    meanings.partOfSpeech!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                _translating[meaningIndex] == true
                    ? const SizedBox(
                        width: 36,
                        height: 36,
                        child: Padding(
                          padding: EdgeInsets.all(6.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        tooltip:
                            '${AppLocalizations.t(context, 'translation')} (${TranslationService.instance.targetLang})',
                        icon: const Icon(Icons.translate),
                        onPressed: () async {
                          setState(() => _translating[meaningIndex] = true);
                          try {
                            // Build the text to translate
                            final synonymsText = (meanings.synonyms
                                        ?.toSet()
                                        .toList()
                                        .join(', ') ??
                                    '')
                                .trim();
                            final antonymsText = (meanings.antonyms
                                        ?.toSet()
                                        .toList()
                                        .join(', ') ??
                                    '')
                                .trim();
                            final combined = StringBuffer();
                            // Include the header (part of speech) and labels so the
                            // translation covers the entire visible card content.
                            combined.writeln(meanings.partOfSpeech ?? '');
                            combined.writeln(
                                '${AppLocalizations.t(context, 'definition')} :');
                            combined.writeln(definitionList);
                            if (synonymsText.isNotEmpty) {
                              combined.writeln(
                                  '${AppLocalizations.t(context, 'synonyms')}: $synonymsText');
                            }
                            if (antonymsText.isNotEmpty) {
                              combined.writeln(
                                  '${AppLocalizations.t(context, 'antonyms')}: $antonymsText');
                            }

                            final combinedStr = combined.toString().trim();
                            if (combinedStr.isEmpty) {
                              final title =
                                  AppLocalizations.t(context, 'translation');
                              final content = AppLocalizations.t(
                                  context, 'nothing_to_translate');
                              final okText = AppLocalizations.t(context, 'ok');
                              if (!mounted) return;
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text(title),
                                  content: Text(content),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(),
                                      child: Text(okText),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }

                            // limit input size to avoid heavy work
                            // component-based translation (no global length limit)
                            // Translate components individually using local dictionary
                            final part = meanings.partOfSpeech ?? '';
                            final tgt = TranslationService.instance.targetLang;
                            final translatedPart = await TranslationService
                                    .instance
                                    .translateLocal(part, to: tgt) ??
                                part;

                            // Translate each definition separately
                            final List<String> translatedDefs = [];
                            for (var def in meanings.definitions ?? []) {
                              final d = def.definition ?? '';
                              final td = await TranslationService.instance
                                      .translateLocal(d, to: tgt) ??
                                  d;
                              translatedDefs.add(td);
                            }

                            // Translate synonyms list items
                            final List<String> translatedSyns = [];
                            for (var s in meanings.synonyms ?? []) {
                              final ts = await TranslationService.instance
                                      .translateLocal(s, to: tgt) ??
                                  s;
                              translatedSyns.add(ts);
                            }

                            // Capture localization strings and build formatted output to match requested Vietnamese layout.
                            // ignore: use_build_context_synchronously
                            final locDefinition =
                                AppLocalizations.t(context, 'definition');
                            // ignore: use_build_context_synchronously
                            final locSynonyms =
                                AppLocalizations.t(context, 'synonyms');
                            // ignore: use_build_context_synchronously
                            final locTranslation =
                                AppLocalizations.t(context, 'translation');
                            // ignore: use_build_context_synchronously
                            final locOk = AppLocalizations.t(context, 'ok');
                            // ignore: use_build_context_synchronously
                            final locNotFoundInLocal = AppLocalizations.t(
                                context, 'not_found_in_local');
                            // ignore: use_build_context_synchronously
                            final locSourceText =
                                AppLocalizations.t(context, 'source_text');
                            // ignore: use_build_context_synchronously
                            final locTranslationText =
                                AppLocalizations.t(context, 'translation_text');

                            // Build formatted output to match requested Vietnamese layout.
                            // - Show 'Definition' label, blank line, then each definition as its own
                            //   paragraph wrapped in smart quotes.
                            // - Then show 'Synonyms' label, blank line, then each synonym on its own line.
                            final out = StringBuffer();
                            // include the part-of-speech header (e.g., 'noun')
                            out.writeln(translatedPart);
                            out.writeln();
                            // Definition section
                            out.writeln(locDefinition);
                            out.writeln();
                            for (int i = 0; i < translatedDefs.length; i++) {
                              var d = translatedDefs[i].trim();
                              // Add smart quotes if the translation doesn't already include quotes
                              if (!(d.startsWith('“') ||
                                  d.startsWith('"') ||
                                  d.startsWith('\u201c'))) {
                                d = '“$d”';
                              }
                              out.writeln(d);
                              // blank line after each definition paragraph
                              out.writeln();
                            }

                            // Synonyms section (if any)
                            if (translatedSyns.isNotEmpty) {
                              out.writeln(locSynonyms);
                              out.writeln();
                              // show each synonym on its own line for clarity
                              out.writeln(translatedSyns.join('\n'));
                            }

                            if (!mounted) return;
                            final formatted = out.toString().trim();
                            if (formatted.isNotEmpty) {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text(locTranslation),
                                  content: SingleChildScrollView(
                                      child: Text(formatted)),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(),
                                      child: Text(locOk),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (ctx) {
                                  final TextEditingController srcCtrl =
                                      TextEditingController(text: combinedStr);
                                  final TextEditingController tgtCtrl =
                                      TextEditingController();
                                  return AlertDialog(
                                    title: Text(locTranslation),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(locNotFoundInLocal),
                                          const SizedBox(height: 12),
                                          TextField(
                                            controller: srcCtrl,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                              labelText: locSourceText,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          TextField(
                                            controller: tgtCtrl,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                              labelText: locTranslationText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(),
                                        child: Text(locOk),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          final src = srcCtrl.text.trim();
                                          final tgt = tgtCtrl.text.trim();
                                          if (src.isNotEmpty &&
                                              tgt.isNotEmpty) {
                                            // capture a pop callback tied to the dialog context before awaiting
                                            void popDialog() {
                                              Navigator.of(ctx).pop();
                                            }

                                            await TranslationService.instance
                                                .addMapping(src, tgt, to: 'vi');
                                            if (!mounted) return;
                                            popDialog();
                                            NotificationService.instance
                                                .showSnackBarWithoutContext(
                                                    'Saved to local dictionary');
                                          }
                                        },
                                        child: const Text('Save'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          } finally {
                            if (mounted) {
                              setState(
                                  () => _translating[meaningIndex] = false);
                            }
                          }
                        },
                      ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${AppLocalizations.t(context, 'definition')} : ',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(definitionList),
            _buildSet(
              AppLocalizations.t(context, 'synonyms'),
              meanings.synonyms,
            ),
            _buildSet(
              AppLocalizations.t(context, 'antonyms'),
              meanings.antonyms,
            ),
          ],
        ),
      ),
    );
  }

  _buildSet(String title, List<String>? setList) {
    if (setList?.isNotEmpty ?? false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title : ",
            style: TextStyle(
              color:
                  Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            setList!.toSet().toString().replaceAll("{", "").replaceAll("}", ""),
          ),
          const SizedBox(height: 10),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
