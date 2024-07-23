class WSRCColor {
  static const GeneralBgColor = 0xffEFEFEF; //通用背景色

  //会话列表相关颜色
  static const ConListTitleColor = 0xff000000;
  static const ConListDigestColor = 0xff6C7B8B;
  static const ConListUnreadColor = 0xffCD3333;
  static const ConListUnreadTextColor = 0xffffffff;
  static const ConListTimeColor = 0xff6C7B8B;
  static const ConListItemBgColor = 0xffffffff;
  static const ConListBorderColor = 0xff6C7B8B;
  static const ConListTopBgColor = 0xFFBBDEFB;
  static const ConCombineMsgContentColor = 0xFF9E9E9E;
  static const ConReferenceMsgContentColor = 0xFF9E9E9E;

  //会话页面，消息相关颜色
  static const MessageSendBgColor = 0xFFE6FF4E;
  static const MessageReceiveBgColor = 0xffffffff;
  static const MessageTimeBgColor = 0xffC8C8C8;
  static const MessageNameBgColor = 0xff9B9B9B;

  // 底部引用消息
  static const BottomReferenceNameColor = 0xff999999;
  static const BottomReferenceContentColor = 0xff333333;
  static const BottomReferenceContentColorFile = 0xff436EEE;
}

class WSRCFont {
  //会话列表相关字体大小
  static const double ConListTitleFont = 16;
  static const double ConListTimeFont = 12;
  static const double ConListUnreadFont = 8;
  static const double ConListDigestFont = 12;

  //会话页面，消息相关字体大小
  static const double MessageTextFont = 18;
  static const double MessageTimeFont = 12;
  static const double MessageNameFont = 14;
  static const double MessageNotifiFont = 15;
  static const double MessageCombineTitleFont = 12;
  static const double MessageCombineContentFont = 10;
  static const double MessageReferenceTitleFont = 12;
  static const double MessageReferenceContentFont = 10;

  //加号扩展栏
  static const double ExtIconSize = 40;
  static const double ExtTextFont = 13;
  static const double CommonPhrasesSize = 14;

  // 底部引用消息
  static const double BottomReferenceNameSize = 13;
  static const double BottomReferenceContentSize = 14;
}

class WSRCLayout {
  //会话列表页面布局
  static const double ConListPortraitSize = 45; //会话列表头像大小
  static const double ConListItemHeight = 70; //会话列表 item 高度
  static const double ConListUnreadSize = 15; //会话列表未读数大小

  //消息页面布局
  static const double MessageTimeItemWidth = 80;
  static const double MessageTimeItemHeight = 22;
  static const double MessageErrorHeight = 20;
  static const double RichMessageImageSize = 45;

  //小灰条消息宽高
  static const double MessageNotifiItemWidth = 140;
  static const double MessageNotifiItemHeight = 30;

  //加号扩展栏
  static const double ExtIconLayoutSize = 50;
  static const double ExtentionLayoutWidth = 200;
  static const double CommonPhrasesHeight = 36;

  //底部输入框
  static const double BottomIconLayoutSize = 32;
}

//长按 menu 的 Action
class WSRCLongPressAction {
  //如果用户点击了空白，会触发 UndefinedKey
  static const String UndefinedKey = "UndefinedKey";

  static const String DeleteConversationKey = "DeleteConversationKey";

  static const String ClearUnreadKey = "ClearUnreadKey";

  static const String SetConversationToTopKey = "SetConversationToTopKey";

  static const String CopyKey = "CopyKey";

  static const String DeleteKey = "DeleteKey";
  static const String DeleteValue = "Delete";

  static const String RecallKey = "RecallMessage";
  static const String RecallValue = "Recall";

  static const String MutiSelectKey = "MutiSelectMessage";
  static const String MutiSelectValue = "Multi";

  static const String ReferenceKey = "ReferenceMessage";
  static const String ReferenceValue = "Reference Msg";
}

class RCString {
  static const String BottomInputTextHint = "Enter here...";
  static const String BottomTapSpeak = "Hold to talk";
  static const String BottomCommonPhrases = "phrases";
  static const String ConRecallMessageSuccess = "recall successfully";
  static const String ConHaveMentioned = "[@me] ";
  static const String ConDraft = "[draft] ";
  static const String ConNoIdentify = "";
  static const String ConTyping = "typeing...";
  static const String ConSpeaking = "speaking...";
  static const String ExtPhoto = "Pic";
  static const String ExtFolder = "File";
  static const String ConCancel = "Cancel";
  static const String SelectConTitle = "selec conversation";
  static const String ForwardHint = "";
  static const String ChatRecord = "Chat history";
  static const String GroupChatRecord = "chat record";
  static const String ExtSecretChat = "Secret Chat";

  // 合并消息
  static const String RCMessageContentImage = "[pic]";
  static const String RCMessageContentVoice = "[voice]";
  static const String RCMessageContentRichText = "[rich text]";
  static const String RCMessageContentLocation = "[location]";
  static const String RCMessageContentDraft = "[draft]";
  static const String RCMessageContentMentioned = "[@me]";
  static const String RCMessageContentFile = "[file]";
  static const String RCMessageContentSight = "[video]";
  static const String RCMessageContentBurn = "[burn]";
  static const String RCMessageContentCombine = "[combine]";
  static const String RCMessageContentCard = "[card]";
  static const String RCMessageContentSticker = "[sticker]";
  static const String RCMessageContentRp = "[red packet]";
  static const String RCMessageContentVst = "[vst]";
  static const String RCCombineChatHistory = "Chat history";
  static const String RCCombineGroupChatHistory = "chat record";
}

class WSEmoji {
  // 格式："\u{1f3a4}"
  static const List emojiList = [
    "\u{1f603}",
    "\u{1f600}",
    "\u{1f60a}",
    "\u{263a}",
    "\u{1f609}",
    "\u{1f60d}",
    "\u{1f618}",
    "\u{1f61a}",
    "\u{1f61c}",
    "\u{1f61d}",
    "\u{1f633}",
    "\u{1f601}",
    "\u{1f614}",
    "\u{1f60c}",
    "\u{1f612}",
    "\u{1f61f}",
    "\u{1f61e}",
    "\u{1f623}",
    "\u{1f622}",
    "\u{1f602}",
    "\u{1f62d}",
    "\u{1f62a}",
    "\u{1f630}",
    "\u{1f605}",
    "\u{1f613}",
    "\u{1f62b}",
    "\u{1f629}",
    "\u{1f628}",
    "\u{1f631}",
    "\u{1f621}",
    "\u{1f624}",
    "\u{1f616}",
    "\u{1f606}",
    "\u{1f60b}",
    "\u{1f637}",
    "\u{1f60e}",
    "\u{1f634}",
    "\u{1f632}",
    "\u{1f635}",
    "\u{1f608}",
    "\u{1f47f}",
    "\u{1f62f}",
    "\u{1f62c}",
    "\u{1f615}",
    "\u{1f636}",
    "\u{1f607}",
    "\u{1f60f}",
    "\u{1f611}",
    "\u{1f648}",
    "\u{1f649}",
    "\u{1f64a}",
    "\u{1f47d}",
    "\u{1f4a9}",
    "\u{2764}",
    "\u{1f494}",
    "\u{1f525}",
    "\u{1f4a2}",
    "\u{1f4a4}",
    "\u{1f6ab}",
    "\u{2b50}",
    "\u{26a1}",
    "\u{1f319}",
    "\u{2600}",
    "\u{26c5}",
    "\u{2601}",
    "\u{2744}",
    "\u{2614}",
    "\u{26c4}",
    "\u{1f44d}",
    "\u{1f44e}",
    "\u{1f91d}",
    "\u{1f44c}",
    "\u{1f44a}",
    "\u{270a}",
    "\u{270c}",
    "\u{270b}",
    "\u{1f64f}",
    "\u{261d}",
    "\u{1f44f}",
    "\u{1f4aa}",
    "\u{1f46a}",
    "\u{1f46b}",
    "\u{1f47c}",
    "\u{1f434}",
    "\u{1f436}",
    "\u{1f437}",
    "\u{1f47b}",
    "\u{1f339}",
    "\u{1f33b}",
    "\u{1f332}",
    "\u{1f384}",
    "\u{1f381}",
    "\u{1f389}",
    "\u{1f4b0}",
    "\u{1f382}",
    "\u{1f356}",
    "\u{1f35a}",
    "\u{1f366}",
    "\u{1f36b}",
    "\u{1f349}",
    "\u{1f377}",
    "\u{1f37b}",
    "\u{2615}",
    "\u{1f3c0}",
    "\u{26bd}",
    "\u{1f3c2}",
    "\u{1f3a4}",
    "\u{1f3b5}",
    "\u{1f3b2}",
    "\u{1f004}",
    "\u{1f451}",
    "\u{1f484}",
    "\u{1f48b}",
    "\u{1f48d}",
    "\u{1f4da}",
    "\u{1f393}",
    "\u{270f}",
    "\u{1f3e1}",
    "\u{1f6bf}",
    "\u{1f4a1}",
    "\u{1f4de}",
    "\u{1f4e2}",
    "\u{1f556}",
    "\u{23f0}",
    "\u{23f3}",
    "\u{1f4a3}",
    "\u{1f52b}",
    "\u{1f48a}",
    "\u{1f680}",
    "\u{1f30f}"
  ];
}
