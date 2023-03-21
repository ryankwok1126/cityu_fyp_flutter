import 'package:camera/camera.dart';
import 'package:cityu_fyp_flutter/APIManager/api_manager.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:tflite/tflite.dart';

class JitsiMeetMethods {
  late CameraController cameraController;
  late CameraImage cameraImage;
  String output = '';

  Future _loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
        model: "assets/ai_model/emotion_recognition_model.tflite",
        labels: "assets/ai_model/emotion_recognition_label.txt");
  }

  _initCamera() async {
    List<CameraDescription> cameras = await availableCameras();
    cameraController = CameraController(cameras[1], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      cameraController.startImageStream((image) => {
            cameraImage = image,
            runModel(),
          });
    });
  }

  runModel() async {
    var prediction = await Tflite.runModelOnFrame(
      bytesList: cameraImage.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      numResults: 1,
      threshold: 0.4,
      asynch: true,
    );
    prediction?.forEach((element) {
      output = element['label'];
    });
  }

  _setLessonStatus(int lessonId, int status) async {
    String path = '/lesson/set_lesson_status';
    Map<String, dynamic> params = {
      'lesson_id': lessonId,
      'status': status,
    };
    ApiManager.instance.post(path, params).then((response) async {
      print(response);
      Map<String, dynamic> data = response;
      if (data['status'] == 1) {}
    });
  }

  void createNewMeeting(String roomName, bool isAudioMuted, bool isVideoMuted,
      String subject, String username, String email,
      {int? lessonId}) async {
    try {
      Map<FeatureFlag, Object> featureFlags = {
        FeatureFlag.isIosScreensharingEnabled: true,
      };

      // Define meetings options here
      var options = JitsiMeetingOptions(
        roomNameOrUrl: roomName,
        subject: subject,
        isAudioMuted: isAudioMuted,
        isVideoMuted: isVideoMuted,
        userDisplayName: username,
        userEmail: email,
        featureFlags: featureFlags,
      );

      print("JitsiMeetingOptions: $options");
      await JitsiMeetWrapper.joinMeeting(
        options: options,
        listener: JitsiMeetingListener(
          onOpened: () async {
            debugPrint("onOpened");
            if (lessonId != null) {
              _setLessonStatus(lessonId, 1);
            } else {
              _loadModel();
              _initCamera();
            }
          },
          onConferenceWillJoin: (url) {
            debugPrint("onConferenceWillJoin: url: $url");
          },
          onConferenceJoined: (url) {
            debugPrint("onConferenceJoined: url: $url");
          },
          onConferenceTerminated: (url, error) {
            debugPrint("onConferenceTerminated: url: $url, error: $error");
          },
          onAudioMutedChanged: (isMuted) {
            debugPrint("onAudioMutedChanged: isMuted: $isMuted");
          },
          onVideoMutedChanged: (isMuted) {
            debugPrint("onVideoMutedChanged: isMuted: $isMuted");
          },
          onScreenShareToggled: (participantId, isSharing) {
            debugPrint(
              "onScreenShareToggled: participantId: $participantId, "
              "isSharing: $isSharing",
            );
          },
          onParticipantJoined: (email, name, role, participantId) {
            debugPrint(
              "onParticipantJoined: email: $email, name: $name, role: $role, "
              "participantId: $participantId",
            );
          },
          onParticipantLeft: (participantId) {
            debugPrint("onParticipantLeft: participantId: $participantId");
          },
          onParticipantsInfoRetrieved: (participantsInfo, requestId) {
            debugPrint(
              "onParticipantsInfoRetrieved: participantsInfo: $participantsInfo, "
              "requestId: $requestId",
            );
          },
          onChatMessageReceived: (senderId, message, isPrivate) {
            debugPrint(
              "onChatMessageReceived: senderId: $senderId, message: $message, "
              "isPrivate: $isPrivate",
            );
          },
          onChatToggled: (isOpen) =>
              debugPrint("onChatToggled: isOpen: $isOpen"),
          onClosed: () {
            debugPrint("onClosed");
            if (lessonId != null) {
              _setLessonStatus(lessonId, 2);
            } else {
              cameraController.stopImageStream();
              Tflite.close();
            }
          },
        ),
      );
    } catch (e) {
      print("error: $e");
    }
  }
}
