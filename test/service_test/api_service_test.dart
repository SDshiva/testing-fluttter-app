import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:testing/services/api_service.dart';
import 'package:testing/models/post.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('ApiService', () {
    late ApiService apiService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      apiService = ApiService(client: mockClient);
    });

    group('getPosts', () {
      test('should return list of posts when API call is successful', () async {
        // Arrange
        const jsonResponse = '''
        [
          {
            "id": 1,
            "userId": 1,
            "title": "Test Title 1",
            "body": "Test Body 1"
          },
          {
            "id": 2,
            "userId": 2,
            "title": "Test Title 2",
            "body": "Test Body 2"
          }
        ]
        ''';

        when(mockClient.get(
          Uri.parse('https://jsonplaceholder.typicode.com/posts'),
          headers: {'Content-Type': 'application/json'},
        )).thenAnswer((_) async => http.Response(jsonResponse, 200));

        // Act
        final posts = await apiService.getPosts();

        // Assert
        expect(posts, isA<List<Post>>());
        expect(posts.length, 2);
        expect(posts[0].id, 1);
        expect(posts[0].title, 'Test Title 1');
        expect(posts[1].id, 2);
        expect(posts[1].title, 'Test Title 2');
      });

      test('should throw exception when API call fails', () async {
        // Arrange
        when(mockClient.get(
          Uri.parse('https://jsonplaceholder.typicode.com/posts'),
          headers: {'Content-Type': 'application/json'},
        )).thenAnswer((_) async => http.Response('Not Found', 404));

        // Act & Assert
        expect(
          () => apiService.getPosts(),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception when network error occurs', () async {
        // Arrange
        when(mockClient.get(
          Uri.parse('https://jsonplaceholder.typicode.com/posts'),
          headers: {'Content-Type': 'application/json'},
        )).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => apiService.getPosts(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getRandomPost', () {
      test('should return a single post when API call is successful', () async {
        // Arrange
        const jsonResponse = '''
        {
          "id": 42,
          "userId": 5,
          "title": "Random Post Title",
          "body": "Random Post Body"
        }
        ''';

        when(mockClient.get(
          argThat(predicate<Uri>((uri) =>
              uri
                  .toString()
                  .contains('https://jsonplaceholder.typicode.com/posts/') &&
              uri.toString().split('/').last != 'posts')),
          headers: {'Content-Type': 'application/json'},
        )).thenAnswer((_) async => http.Response(jsonResponse, 200));

        // Act
        final post = await apiService.getRandomPost();

        // Assert
        expect(post, isA<Post>());
        expect(post.id, 42);
        expect(post.userId, 5);
        expect(post.title, 'Random Post Title');
        expect(post.body, 'Random Post Body');
      });

      test('should throw exception when API call fails', () async {
        // Arrange
        when(mockClient.get(
          argThat(predicate<Uri>((uri) =>
              uri
                  .toString()
                  .contains('https://jsonplaceholder.typicode.com/posts/') &&
              uri.toString().split('/').last != 'posts')),
          headers: {'Content-Type': 'application/json'},
        )).thenAnswer((_) async => http.Response('Not Found', 404));

        // Act & Assert
        expect(
          () => apiService.getRandomPost(),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
