import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/common/no_internet_connection.dart';
import 'package:uuid/uuid.dart';

import '../../../../setUp/size/app_size.dart';
import '../../domain/entities/chat/chat_participant_entity.dart';
import '../bloc/chat/chat_bloc.dart' as chat_bloc;
import '../bloc/chat/chat_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/app_bar_one.dart';
import '../widgets/shimmer/chat_message_shimmer.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.receiver});

  final ChatParticipantEntity receiver;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final types.User _user;
  File? image;

  @override
  void initState() {
    super.initState();

    context.read<chat_bloc.ChatBloc>().add(
          GetChatsEvent(
            user: context.read<UserBloc>().state.user,
            receiverId: widget.receiver.id,
          ),
        );

    context.read<chat_bloc.ChatBloc>().add(SignalRStartEvent());

    _user = types.User(
      id: context.read<UserBloc>().state.user?.id ?? const Uuid().v4(),
      imageUrl: context.read<UserBloc>().state.user?.profilePicture ?? '',
      firstName: context.read<UserBloc>().state.user?.firstName ?? '',
      lastName: context.read<UserBloc>().state.user?.lastName ?? '',
    );
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    context.read<chat_bloc.ChatBloc>().add(
          SendMessageEvent(
            message: textMessage,
            receiverId: widget.receiver.id,
            token: context.read<UserBloc>().state.user?.token ?? '',
            type: 0,
          ),
        );
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSize.xSmallSize,
            horizontal: AppSize.smallSize - 4,
          ),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSize.mediumSize),
                topRight: Radius.circular(AppSize.mediumSize),
              )),
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt,
                    color: Theme.of(context).colorScheme.primaryContainer),
                title:
                    Text(AppLocalizations.of(context)!.addProductScreenCamera,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                        )),
                onTap: () {
                  Navigator.pop(context);
                  takeImage();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo,
                    color: Theme.of(context).colorScheme.primaryContainer),
                title:
                    Text(AppLocalizations.of(context)!.addProductScreenGallery,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                        )),
                onTap: () {
                  Navigator.pop(context);
                  pickImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _sendImage() async {
    if (image != null) {
      final bytes = await image!.readAsBytes();
      final decodedImage = await decodeImageFromList(bytes);

      final imageMessage = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: decodedImage.height.toDouble(),
        id: const Uuid().v4(),
        name: image!.path.split('/').last,
        size: bytes.length,
        uri: image!.path,
        width: decodedImage.width.toDouble(),
      );

      () {
        context.read<chat_bloc.ChatBloc>().add(
              SendImageMessageEvent(
                message: imageMessage,
                logo: image!,
                receiverId: widget.receiver.id,
                token: context.read<UserBloc>().state.user?.token ?? '',
                type: 1,
              ),
            );
      }();
    }
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final croppedFile = await _cropImage(pickedFile);
      setState(() {
        if (croppedFile != null) {
          image = File(croppedFile.path);
          _sendImage();
        }
      });
    }
  }

  Future<void> takeImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final croppedFile = await _cropImage(pickedFile);
      setState(() {
        if (croppedFile != null) {
          image = File(croppedFile.path);
          _sendImage();
        }
      });
    }
  }

  Future<XFile?> _cropImage(XFile pickedFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Theme.of(context).colorScheme.secondary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio4x3,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio5x4,
            CropAspectRatioPreset.ratio7x5,
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio5x4,
            CropAspectRatioPreset.ratio7x5,
          ],
        ),
      ],
    );

    return croppedFile != null ? XFile(croppedFile.path) : null;
  }

  Future<void> _handleEndReached() async {
    context.read<chat_bloc.ChatBloc>().add(
          GetChatsMoreEvent(
            user: context.read<UserBloc>().state.user,
            receiverId: widget.receiver.id,
          ),
        );
  }

  Future<void> _handleMessageTap(
      BuildContext context, types.Message message) async {
    if (message.author.id != _user.id) {
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSize.xSmallSize,
            horizontal: AppSize.smallSize,
          ),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSize.mediumSize),
                topRight: Radius.circular(AppSize.mediumSize),
              )),
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error),
                title: Text(AppLocalizations.of(context)!.delete,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                    )),
                onTap: () {
                  context.read<chat_bloc.ChatBloc>().add(
                        DeleteChatEvent(
                          chatId: message.id,
                          receiverId: widget.receiver.id,
                          token:
                              context.read<UserBloc>().state.user?.token ?? '',
                        ),
                      );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: Column(
          children: [
            const AppBarOne(),
            Divider(
              color: Theme.of(context).colorScheme.primaryContainer,
              height: 1,
            ),
            if (context
                    .watch<chat_bloc.ChatBloc>()
                    .signalRService
                    .isConnected ==
                false)
              const NoInternetConnection()
            else
              Expanded(
                child: BlocBuilder<chat_bloc.ChatBloc, chat_bloc.ChatState>(
                  builder: (context, state) {
                    if (state.getChatsStatus == GetChatsStatus.loading) {
                      return ListView.builder(
                        itemCount: 11,
                        itemBuilder: (context, index) {
                          return ChatMessageShimmer(isSender: index % 2 == 0);
                        },
                      );
                    } else if (state.getChatsStatus == GetChatsStatus.failure ||
                        state.getChatsStatus == GetChatsStatus.initial ||
                        state.messages.isEmpty) {
                      return Chat(
                        messages: state.messages,
                        onSendPressed: _handleSendPressed,
                        showUserAvatars: true,
                        user: _user,
                        emptyState: Center(
                          child: Text(
                            AppLocalizations.of(context)!.chatScreenNoMessages,
                          ),
                        ),
                        onAttachmentPressed: _handleAttachmentPressed,
                        isAttachmentUploading: state.sendMessageStatus ==
                            SendMessageStatus.sending,
                        theme: DefaultChatTheme(
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          inputBackgroundColor: Theme.of(context)
                              .colorScheme
                              .primaryContainer
                              .withOpacity(0.8),
                          inputTextColor:
                              Theme.of(context).colorScheme.secondary,
                          inputTextStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium ??
                              TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                          primaryColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.8),
                          secondaryColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          userAvatarImageBackgroundColor:
                              Theme.of(context).colorScheme.primary,
                          sentMessageBodyTextStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                          receivedMessageBodyTextStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      );
                    } else if (state.getChatsStatus == GetChatsStatus.success &&
                        state.messages.isNotEmpty) {
                      return Chat(
                        messages: state.messages,
                        onSendPressed: _handleSendPressed,
                        showUserAvatars: true,
                        user: _user,
                        onAttachmentPressed: _handleAttachmentPressed,
                        isAttachmentUploading: state.sendMessageStatus ==
                            SendMessageStatus.sending,
                        onEndReached: _handleEndReached,
                        emojiEnlargementBehavior:
                            EmojiEnlargementBehavior.multi,
                        emptyState: Center(
                          child: Text(
                            AppLocalizations.of(context)!.chatScreenNoMessages,
                          ),
                        ),
                        isLastPage: state.getChatsMoreStatus ==
                            GetChatsMoreStatus.noMore,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        theme: DefaultChatTheme(
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          inputBackgroundColor: Theme.of(context)
                              .colorScheme
                              .primaryContainer
                              .withOpacity(0.8),
                          inputTextColor:
                              Theme.of(context).colorScheme.secondary,
                          inputTextStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium ??
                              TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                          primaryColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.8),
                          secondaryColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          userAvatarImageBackgroundColor:
                              Theme.of(context).colorScheme.primary,
                          sentMessageBodyTextStyle:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                          receivedMessageBodyTextStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                        onMessageTap: _handleMessageTap,
                        onMessageVisibilityChanged: (p0, visible) {
                          if (p0.author.id != _user.id &&
                              p0.status == types.Status.delivered) {
                            context.read<chat_bloc.ChatBloc>().add(
                                  MarkChatAsReadEvent(
                                    chatId: p0.id,
                                    senderId: widget.receiver.id,
                                    token: context
                                            .read<UserBloc>()
                                            .state
                                            .user
                                            ?.token ??
                                        '',
                                  ),
                                );
                          }
                        },
                      );
                    }

                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.chatScreenNoMessages,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
