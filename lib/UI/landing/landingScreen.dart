import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:urban_task/UI/landing/landingScreenController.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingScreen extends StatelessWidget {
  final LandingScreenController landingScreenController =
      Get.put(LandingScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Git Repositories"),
        centerTitle: true,
      ),
      body: Obx(
        () => AnimationLimiter(
          child: ListView.builder(
            itemCount: landingScreenController.repoList.length,
            itemBuilder: ((context, index) {
              return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () {
                          landingScreenController.fetchCommits(
                              landingScreenController
                                  .repoList[index].commitsUrl!
                                  .replaceAll("{/sha}", ""));
                          openCommitDetailsBottomSheet();
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          height: MediaQuery.of(context).size.height * 0.09,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      landingScreenController
                                          .repoList[index].name,
                                      style: TextStyle(
                                          fontSize: (MediaQuery.of(context)
                                                      .size
                                                      .aspectRatio *
                                                  2) *
                                              16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      landingScreenController
                                              .repoList[index].description ??
                                          "Description",
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: (MediaQuery.of(context)
                                                      .size
                                                      .aspectRatio *
                                                  2) *
                                              12,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery.of(context).size.width * 0.1,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                      landingScreenController
                                          .repoList[index].avatarUrl!,
                                    ))),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ));
            }),
          ),
        ),
      ),
    );
  }

  openCommitDetailsBottomSheet() {
    return Get.bottomSheet(
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: MediaQuery.of(Get.context!).size.height * 0.005,
                      width: MediaQuery.of(Get.context!).size.width * 0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "Recent Commit Details",
                      style: Theme.of(Get.context!)
                          .textTheme
                          .titleMedium!
                          .copyWith(
                              color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text.rich(
                    TextSpan(
                      text: "Commit SHA: ",
                      style: Theme.of(Get.context!)
                          .textTheme
                          .labelMedium!
                          .copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: landingScreenController.commitList[0].sha,
                          style: Theme.of(Get.context!)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text.rich(
                    TextSpan(
                      text: "Commit Date: ",
                      style: Theme.of(Get.context!)
                          .textTheme
                          .labelMedium!
                          .copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: DateFormat.yMMMd().format(DateTime.parse(
                              landingScreenController
                                  .commitList[0].commitDate!)),
                          style: Theme.of(Get.context!)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text.rich(
                    TextSpan(
                      text: "Commit Message: ",
                      style: Theme.of(Get.context!)
                          .textTheme
                          .labelMedium!
                          .copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: landingScreenController.commitList[0].message,
                          style: Theme.of(Get.context!)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(children: [
                Text.rich(TextSpan(
                  text: "Commit Author: ",
                  style: Theme.of(Get.context!).textTheme.caption!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.normal),
                  children: [
                    TextSpan(
                      text: landingScreenController.commitList[0].name,
                      style: Theme.of(Get.context!)
                          .textTheme
                          .subtitle2!
                          .copyWith(color: Colors.white),
                    ),
                  ],
                )),
                const Spacer(),
                landingScreenController.commitList[0].avatarUrl != null
                    ? Container(
                        height: MediaQuery.of(Get.context!).size.height * 0.05,
                        width: MediaQuery.of(Get.context!).size.width * 0.1,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            onError: (exception, stackTrace) =>
                                const Icon(Icons.error),
                            image: NetworkImage(
                              landingScreenController.commitList[0].avatarUrl ??
                                  "",
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ]),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text.rich(
                TextSpan(
                  text: "Commit URL: ",
                  style: Theme.of(Get.context!).textTheme.labelMedium!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: landingScreenController.commitList[0].url,
                      style: Theme.of(Get.context!)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                    foregroundColor:
                        const MaterialStatePropertyAll(Colors.white),
                    backgroundColor:
                        const MaterialStatePropertyAll(Colors.blue),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)))),
                onPressed: () async {
                  await launchUrl(
                      Uri.parse(landingScreenController.commitList[0].url!));
                },
                icon: const Text("More Details"),
                label: Icon(
                  color: Colors.black,
                  Icons.open_in_new_outlined,
                  size: MediaQuery.of(Get.context!).size.aspectRatio * 30,
                ),
              ),
            ),
          ],
        ),
      ),
      enableDrag: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
    );
  }
}
