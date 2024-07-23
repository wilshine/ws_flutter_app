import 'ws_bloc_provider.dart';
import 'package:rxdart/subjects.dart';

class WSMessageBloc extends WSBlocBase {
  late MessageInfoWrapState warpInfo;

  final BehaviorSubject<MessageInfoWrapState> _listDataController = BehaviorSubject<MessageInfoWrapState>(sync: true);

  Sink get inListData => _listDataController.sink;

  Stream<MessageInfoWrapState> get outListData => _listDataController.stream;

  @override
  void dispose() {
    _listDataController.close();
  }

  void updateMessageList(List messageList) {
    warpInfo = MessageInfoWrapState(messageList: messageList);
    inListData.add(warpInfo);
  }
}

class MessageInfoWrapState {
  MessageInfoWrapState({required this.messageList});

  List messageList;
}
