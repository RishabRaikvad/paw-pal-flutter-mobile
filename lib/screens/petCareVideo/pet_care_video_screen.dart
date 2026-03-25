import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paw_pal_mobile/bloc/videoBloc/video_cubit.dart';
import 'package:paw_pal_mobile/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_mobile/utils/widget_helper.dart';

import '../../core/constant.dart';

class PetCareVideoScreen extends StatefulWidget {
  const PetCareVideoScreen({super.key});

  @override
  State<PetCareVideoScreen> createState() => _PetCareVideoScreenState();
}

class _PetCareVideoScreenState extends State<PetCareVideoScreen> {
  late VideoCubit cubit;

  @override
  void initState() {
    super.initState();
    initScreen();
  }

  void initScreen() async {
    cubit = context.read<VideoCubit>();
    await cubit.getPetCareVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GradientBackground(child: mainView()));
  }

  Widget mainView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            commonTitle(
              title: "Watch & Learn",
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<VideoCubit, VideoState>(
                builder: (context, state) {
                  if (state is VideoLoadingState) {
                    return videoLoadingView();
                  } else if (state is VideoErrorState) {
                    return commonTitle(title: state.error);
                  }
                  return commonRefreshIndicator(
                    onRefresh: cubit.getPetCareVideos,
                    child: CustomScrollView(slivers: [buildPetCareVideoList()]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverList buildPetCareVideoList() {
    final videoCount = cubit.lstPetCareVideo.length > Constant.staticCount
        ? Constant.staticCount
        : cubit.lstPetCareVideo.length;
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final video = cubit.lstPetCareVideo[index];
        return commonPetCareVideoCard(
          thumbnail: video.thumbnail,
          channelImage: video.ownerImage,
          channelName: video.ownerName,
          duration: video.videoTime,
          videoTitle: video.videoTitle,
          videoUrl: video.videoUrl,
        );
      }, childCount: videoCount),
    );
  }

  Widget videoLoadingView() {
    return CustomScrollView(slivers: [shimmerListSliver(height: 200)]);
  }
}
