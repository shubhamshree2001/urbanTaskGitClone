import 'package:get/get.dart';
import 'package:urban_task/models/commit_modelResponse.dart';
import 'package:urban_task/models/repoModelResponse.dart';
import 'package:urban_task/services/git_services.dart';

class LandingScreenController extends GetxController {
  var isLoading = true.obs;
  var isavail = true.obs;
  var repoList = <RepoModel>[].obs;
  var commitList = <CommitModel>[].obs;
  @override
  void onInit() {
    fetchRepo();
    super.onInit();
  }

  void fetchRepo() async {
    try {
      isLoading(true);
      var repo = await GitApiRepository.fetchRepos();
      if (repo != null) {
        repoList.assignAll(repo);
        //log(repoList.string);
      }
    } finally {
      isLoading(false);
    }
  }

  void fetchCommits(String url) async {
    try {
      isavail(true);
      var commits = await GitApiRepository.fetchLastCommit(url);
      if (commits != null) {
        commitList.assignAll(commits);
        //log(commitList.string);
      }
    } finally {
      isLoading(false);
    }
  }
}
