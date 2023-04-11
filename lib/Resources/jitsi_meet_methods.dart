import 'package:cityu_fyp_flutter/APIManager/api_manager.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';

class JitsiMeetMethods {
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
            }
          },
        ),
      );
    } catch (e) {
      print("error: $e");
    }
  }
}
