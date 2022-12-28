import 'dart:convert';
import 'package:urban_task/models/commit_modelResponse.dart';
import 'package:urban_task/models/repoModelResponse.dart';
import 'package:http/http.dart' as http;

class GitApiRepository {
  static const String apiEndpoint = 'https://api.github.com/users/';
  static Future<List<RepoModel>> fetchRepos() async {
    final response =
        await http.get(Uri.parse('${apiEndpoint}freeCodeCamp/repos'));
    if (response.statusCode == 200) {
      final List<dynamic> repos = jsonDecode(response.body);
      return repos.map((repo) => RepoModel.fromJson(repo)).toList();
    } else {
      throw Exception('Failed to load repos');
    }
  }

  static Future<List<CommitModel>> fetchLastCommit(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> commit = jsonDecode(response.body);
      return commit.map((commits) => CommitModel.fromJson(commits)).toList();
    } else {
      throw Exception('Failed to load commit');
    }
  }
}
