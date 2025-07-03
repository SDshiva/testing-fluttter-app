import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class ApiDataScreen extends StatefulWidget {
  const ApiDataScreen({super.key});

  @override
  State<ApiDataScreen> createState() => _ApiDataScreenState();
}

class _ApiDataScreenState extends State<ApiDataScreen> {
  final ApiService _apiService = ApiService();
  List<Post> _posts = [];
  Post? _randomPost;
  bool _isLoading = false;
  bool _isLoadingRandom = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final posts = await _apiService.getPosts();
      setState(() {
        _posts = posts.take(10).toList(); // Show only first 10 posts
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadRandomPost() async {
    setState(() {
      _isLoadingRandom = true;
      _errorMessage = null;
    });

    try {
      final post = await _apiService.getRandomPost();
      setState(() {
        _randomPost = post;
        _isLoadingRandom = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoadingRandom = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Data'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: RefreshIndicator(
        key: const Key('refresh_indicator'),
        onRefresh: _loadPosts,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Random Post Section
              Card(
                key: const Key('random_post_card'),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Random Post',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            key: const Key('load_random_button'),
                            onPressed:
                                _isLoadingRandom ? null : _loadRandomPost,
                            child: _isLoadingRandom
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Load Random'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_randomPost != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ID: ${_randomPost!.id}',
                              key: const Key('random_post_id'),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _randomPost!.title,
                              key: const Key('random_post_title'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _randomPost!.body,
                              key: const Key('random_post_body'),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        )
                      else
                        const Text(
                          'No random post loaded yet',
                          key: Key('no_random_post_text'),
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Posts List Section
              const Text(
                'Posts List',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              if (_errorMessage != null)
                Card(
                  key: const Key('error_card'),
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Error: $_errorMessage',
                          key: const Key('error_message'),
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          key: const Key('retry_button'),
                          onPressed: _loadPosts,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    key: Key('loading_indicator'),
                  ),
                )
              else if (_posts.isEmpty)
                const Center(
                  child: Text(
                    'No posts available',
                    key: Key('no_posts_text'),
                  ),
                )
              else
                ListView.builder(
                  key: const Key('posts_list'),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    final post = _posts[index];
                    return Card(
                      key: Key('post_card_${post.id}'),
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(
                          post.title,
                          key: Key('post_title_${post.id}'),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ID: ${post.id} | User: ${post.userId}',
                              key: Key('post_meta_${post.id}'),
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              post.body,
                              key: Key('post_body_${post.id}'),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
