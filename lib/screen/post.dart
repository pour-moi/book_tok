import 'package:book_tok/models/book_dao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_tok/providers.dart';

class Post extends ConsumerStatefulWidget {
  const Post({super.key});

  @override
  ConsumerState createState() => _PostState();
}

class _PostState extends ConsumerState<Post> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _authorController = TextEditingController();
  final _imageLinkController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _authorController.dispose();
    _imageLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postDao = ref.watch(postDaoProvider);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(hintText: "Title"),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _contentController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Write your summary here",
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _authorController,
                decoration: InputDecoration(hintText: "Author"),
              ),
              TextField(
                controller: _imageLinkController,
                decoration: InputDecoration(hintText: "Image link"),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() => isLoading = true);
                  final user = FirebaseAuth.instance.currentUser;
                  final userDoc =
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user!.uid)
                          .get();
                  final name = userDoc.data()?['name'] ?? "BookTok";
                  try {
                    await postDao.post(
                      _titleController.text,
                      _contentController.text,
                      _authorController.text,
                      _imageLinkController.text,
                      user.uid,
                      user.email ?? "Anon",
                      name,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Post successfully uploaded!')),
                    );
                    _titleController.clear();
                    _contentController.clear();
                    _authorController.clear();
                    _imageLinkController.clear();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to post: $e')),
                    );
                  } finally {
                    setState(() => isLoading = false);
                  }
                },
                child:
                    isLoading
                        ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        )
                        : Text("Post"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
