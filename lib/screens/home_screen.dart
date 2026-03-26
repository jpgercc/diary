import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/entry.dart';
import '../providers/diary_provider.dart';

class EntryScreen extends StatefulWidget {
  final Entry? entry;
  const EntryScreen({super.key, this.entry});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry?.title ?? '');
    _contentController = TextEditingController(text: widget.entry?.content ?? '');
  }

  void _save(BuildContext context) {
    if (_contentController.text.isEmpty) return;

    final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);

    final newEntry = Entry(
      id: widget.entry?.id ?? DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text.isEmpty ? 'Sem título' : _titleController.text,
      content: _contentController.text,
      date: widget.entry?.date ?? DateTime.now(),
    );

    diaryProvider.addOrUpdate(newEntry);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (widget.entry != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                Provider.of<DiaryProvider>(context, listen: false).delete(widget.entry!.id);
                Navigator.pop(context);
              },
            ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => _save(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Título', border: InputBorder.none),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                decoration: const InputDecoration(hintText: 'Escreva aqui...', border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
    );
  }
}