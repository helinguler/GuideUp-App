import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_up/core/dto/conversation/conversation_card_view.dart';
import 'package:guide_up/core/models/category/category_model.dart';
import 'package:guide_up/core/models/conversation/messages/messages.dart';
import 'package:guide_up/core/models/mentor/mentee_model.dart';
import 'package:guide_up/core/models/mentor/mentor_model.dart';
import 'package:guide_up/core/models/mentor/mentor_price_proposal_model.dart';
import 'package:guide_up/repository/category/category_repository.dart';
import 'package:guide_up/repository/conversation/messages/messages_repository.dart';
import 'package:guide_up/repository/mentee/mentee_repository.dart';
import 'package:guide_up/repository/mentor/mentor_price_proposal_repository.dart';
import 'package:guide_up/repository/mentor/mentor_repository.dart';
import 'package:guide_up/service/conversation/messages/messages_service.dart';
import 'package:guide_up/service/user/user_detail/user_categories_service.dart';
import 'package:guide_up/ui/material/custom_material.dart';
import 'package:intl/intl.dart';

import '../../../core/constant/color_constants.dart';
import '../../../core/utils/user_info_helper.dart';

class ChatMainPage extends StatefulWidget {
  const ChatMainPage({Key? key}) : super(key: key);

  @override
  State<ChatMainPage> createState() => _ChatMainPageState();
}

enum EnMenteeStatus {
  myHaveProposalSuite,
  myHaveProposal,
  myHaveProposalWait,
  otherHaveProposal,
  otherHaveProposalWait,
  hidden
}

class _ChatMainPageState extends State<ChatMainPage> {
  late ConversationCardView conversationCardView;
  final _messageController = TextEditingController();
  List<Messages> messagesList = [];
  bool _checkMessagesControl = false;
  final FocusNode _messagesFocusNode = FocusNode();
  bool _checkProposalControl = false;
  final ScrollController _scrollController = ScrollController();
  EnMenteeStatus enMenteeStatus = EnMenteeStatus.hidden;
  Mentor? _myMentor;
  Mentor? _otherMentor;
  MentorPriceProposal? _proposal;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    conversationCardView =
        ModalRoute.of(context)!.settings.arguments as ConversationCardView;
    getStatus();
    getMessagesList(conversationCardView);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: CustomMaterial.appBarFlexibleSpace,
        actions: [
          Visibility(
            visible: enMenteeStatus != EnMenteeStatus.hidden,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
              child: FloatingActionButton(
                onPressed: () {
                  if (enMenteeStatus == EnMenteeStatus.myHaveProposalSuite) {
                    showMentorDialog(context);
                  } else if (enMenteeStatus ==
                      EnMenteeStatus.myHaveProposalWait) {
                    showMenteeDialog(context);
                  }
                },
                tooltip: "Mentorum",
                mini: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                shape: const CircleBorder(),
                child: const FaIcon(
                  FontAwesomeIcons.solidCircleQuestion,
                  color: ColorConstants.buttonPink,
                  size: 40,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: UserInfoHelper.getProfilePictureByPath(
                  conversationCardView.otherParticipantPhoto),
            ),
          ),
        ],
        title: Text(
          conversationCardView.otherParticipantFullName,
          style: GoogleFonts.nunito(
            textStyle: const TextStyle(
              color: ColorConstants.textwhite,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: CustomMaterial.backgroundBoxDecoration,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemBuilder: (context, index) {
                  if (index + 1 < messagesList.length &&
                      messagesList[(index + 1)].getSenderUserId()!.compareTo(
                              messagesList[index].getSenderUserId()!) ==
                          0) {
                    return createChatBox(
                        messagesList[(index + 1)], messagesList[index]);
                  } else {
                    return createChatBox(null, messagesList[index]);
                  }
                },
                itemCount: messagesList.length,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 8, left: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) => setMessage(context),
                      controller: _messageController,
                      focusNode: _messagesFocusNode,
                      cursorColor: Colors.blueGrey,
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          fontSize: 15.0,
                          color: ColorConstants.textwhite,
                        ),
                      ),
                      decoration: InputDecoration(
                        fillColor: ColorConstants.darkBack,
                        filled: true,
                        hintText: "Mesajınızı Yazın",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(4),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    child: FloatingActionButton(
                      mini: true,
                      shape: const CircleBorder(),
                      elevation: 0,
                      backgroundColor: ColorConstants.buttonPurple,
                      child: const FaIcon(
                        FontAwesomeIcons.solidPaperPlane,
                        color: ColorConstants.textwhite,
                        size: 22,
                      ),
                      onPressed: () async {
                        setMessage(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      MessagesRepository()
          .getMessagesList(
              conversationCardView.id, 20, messagesList.last.getCreateDate()!)
          .then((oldMessageList) {
        if (oldMessageList.isNotEmpty) {
          messagesList.addAll(oldMessageList);
          setState(() {});
        }
      });
    }
  }

  void getMessagesList(ConversationCardView conversationCardView) async {
    if (!_checkMessagesControl) {
      messagesList = await MessagesRepository()
          .getMessagesList(conversationCardView.id, 20, null);

      if (messagesList.isNotEmpty) {
        _checkMessagesControl = true;
        setState(() {});
      }

      MessagesRepository()
          .getLastMessagesStream(
              conversationCardView.id, conversationCardView.myUserId)
          .listen((event) {
        if (event.isNotEmpty && event.first.getId() != null) {
          Messages messages = event.first;
          bool isContains = false;
          for (var mes in messagesList) {
            if (messages.getId()!.compareTo(mes.getId()!) == 0) {
              isContains = true;
              break;
            }
          }
          if (!isContains) {
            messagesList.insert(0, messages);
            setState(() {});
          }
        }
      });
    }
  }

  Widget createChatBox(
      Messages? previousMessagesModel, Messages messagesModel) {
    Color comingMessageColor = ColorConstants.background;
    LinearGradient sentMessagesLinear = const LinearGradient(colors: [
      ColorConstants.conversationPurple,
      ColorConstants.conversationBlue
    ]);
    var hourMinuteText = "";
    bool timeIsSame = false;

    try {
      hourMinuteText = _convertToHourMinuteText(
          messagesModel.getCreateDate() ?? DateTime.now());
      if (previousMessagesModel != null) {
        var previous = _convertToHourMinuteText(
            previousMessagesModel.getCreateDate() ?? DateTime.now());
        timeIsSame = hourMinuteText.compareTo(previous) == 0;
      }
    } catch (e) {
      print("hata var:" + e.toString());
    }
    bool messageIsMine;
    if (messagesModel
            .getSenderUserId()!
            .compareTo(conversationCardView.myUserId) ==
        0) {
      messageIsMine = true;
    } else {
      messageIsMine = false;
    }
    if (messageIsMine) {
      return Padding(
        padding: timeIsSame
            ? const EdgeInsets.fromLTRB(8, 0, 8, 0)
            : const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: sentMessagesLinear,
                    ),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(4),
                    child: Text(
                      messagesModel.getContent() ?? "",
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: ColorConstants.textwhite,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  hourMinuteText,
                  style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                      fontSize: 10,
                      color: timeIsSame
                          ? Colors.transparent
                          : ColorConstants.textGray,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: timeIsSame
            ? const EdgeInsets.fromLTRB(8, 0, 8, 0)
            : const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Visibility(
                  visible: !timeIsSame,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.withAlpha(40),
                    backgroundImage: UserInfoHelper.getProfilePictureByPath(
                        conversationCardView.otherParticipantPhoto),
                  ),
                ),
                Visibility(
                    visible: timeIsSame,
                    child: const Padding(padding: EdgeInsets.all(20))),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: comingMessageColor,
                    ),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(4),
                    child: Text(
                      messagesModel.getContent() ?? "",
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: ColorConstants.textwhite,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  hourMinuteText,
                  style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                      fontSize: 10,
                      color: timeIsSame
                          ? Colors.transparent
                          : ColorConstants.textGray,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }
  }

  String _convertToHourMinuteText(DateTime date) {
    var formatter = DateFormat.Hm();
    var formattedDate = formatter.format(date);
    return formattedDate;
  }

  void setMessage(BuildContext context) async {
    if (_messageController.text.trim().isNotEmpty) {
      Messages messageModel = Messages();
      messageModel.setSenderUserId(conversationCardView.myUserId);
      messageModel
          .setReceiverUserId(conversationCardView.otherParticipantUserId);
      messageModel.setConversationId(conversationCardView.id);
      messageModel.setContent(_messageController.text.trim());

      var sonuc =
          await MessagesService().add(messageModel, conversationCardView);
      if (sonuc.getId() != null) {
        _messageController.clear();
        FocusScope.of(context).requestFocus(_messagesFocusNode);
        /*_scrollController.animateTo(
                        0,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 10),
                      );*/
      }
    }
  }

  void showMentorDialog(BuildContext context) async {
    //List<Category> categoryList=[];
    Category? cat;
    UserCategoriesService()
        .getUserCategoriesList(conversationCardView.myUserId,0)
        .then((categoryList) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Mentorluk teklifi",
              style: GoogleFonts.nunito(
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: Column(
              children: [
                Text(
                  "Karşıdaki kişiye mentoru olmak için bir teklif göndermek üzeresiniz. Onaylıyorsanız kategoriyi seçerek teklifi gönderebilirsiniz.",
                  style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                DropdownButton<Category>(
                  focusColor: ColorConstants.buttonPurple,
                  value: cat,
                  iconSize: 40,
                  style: GoogleFonts.nunito(color: ColorConstants.buttonPurple),
                  dropdownColor: ColorConstants.background,
                  iconEnabledColor: ColorConstants.background,
                  isExpanded: true,
                  onChanged: (Category? cat) {
                    if (cat != null) {
                      MentorPriceProposal proposal = MentorPriceProposal();
                      proposal.setMentorId(_myMentor!.getId()!);
                      proposal.setUserId(
                          conversationCardView.otherParticipantUserId);
                      proposal.setPriceProposal("0");
                      proposal.setCategoryId(cat.getId()!);
                      MentorPriceProposalRepository()
                          .add(proposal)
                          .then((value) {
                        _checkProposalControl = false;
                        setState(() {});
                        Navigator.pop(context);
                      });
                    }
                    setState(() {});
                  },
                  items: categoryList
                      .map<DropdownMenuItem<Category>>((Category value) {
                    return DropdownMenuItem<Category>(
                      value: value,
                      child: Text(value.getName()!),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'İptal',
                  style: GoogleFonts.nunito(),
                ),
              ),
            ],
          );
        },
      );
    });
  }

  void showMenteeDialog(BuildContext context) {
    CategoryRepository().get(_proposal!.getCategoryId()!).then((cat) {
      if (cat != null) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Mentorluk teklifi",
                style: GoogleFonts.nunito(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              content: Text(
                "Karşıdaki kişi size ${cat.getName()} alanında mentorluk etmek istiyor. Onaylıyor musnuz?",
                style: GoogleFonts.nunito(
                  textStyle: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'İptal',
                    style: GoogleFonts.nunito(),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _proposal!.setApproval(true);
                    MentorPriceProposalRepository()
                        .update(_proposal!)
                        .then((value) {
                      Mentee mentee = Mentee();
                      mentee.setUserId(conversationCardView.myUserId);
                      mentee.setName(conversationCardView.myName);
                      mentee.setSurname(conversationCardView.mySurname);
                      mentee.setPhoto(conversationCardView.myPhoto ?? "");
                      mentee.setMentorId(_otherMentor!.getId()!);
                      mentee.setStartDate(DateTime.now());
                      mentee.setCategoryId(_proposal!.getCategoryId()!);
                      mentee.setPrice(_proposal!.getPriceProposal()!);
                      MenteeRepository().add(mentee).then((value) {
                        _checkProposalControl = false;
                        setState(() {});
                        Navigator.pop(context);
                      });
                    });
                  },
                  child: Text(
                    'Gönder',
                    style: GoogleFonts.nunito(),
                  ),
                ),
              ],
            );
          },
        );
      }
    });
  }

  void getStatus() async {
    if (!_checkProposalControl) {
      _checkProposalControl = true;
      if (conversationCardView.myIsMentor) {
        _myMentor = await MentorRepository()
            .getMentorByUserId(conversationCardView.myUserId);
        if (_myMentor != null) {
          MentorPriceProposal? proposal = await MentorPriceProposalRepository()
              .getByMentorAndUserId(_myMentor!.getId()!,
                  conversationCardView.otherParticipantUserId);

          if (proposal != null) {
            enMenteeStatus = EnMenteeStatus.hidden;
            setState(() {});
          } else {
            Mentee? mentee = await MenteeRepository()
                .getMenteeByUserIdAndMentorId(
                    conversationCardView.otherParticipantUserId,
                    _myMentor!.getId()!);
            if (mentee != null && mentee.getEndDate() == null) {
              enMenteeStatus = EnMenteeStatus.hidden;
              setState(() {});
            } else {
              enMenteeStatus = EnMenteeStatus.myHaveProposalSuite;
              setState(() {});
            }
          }
        }
      }
      if (conversationCardView.otherIsMentor) {
        _otherMentor = await MentorRepository()
            .getMentorByUserId(conversationCardView.otherParticipantUserId);
        if (_otherMentor != null) {
          _proposal = await MentorPriceProposalRepository()
              .getByMentorAndUserId(
                  _otherMentor!.getId()!, conversationCardView.myUserId);

          if (_proposal != null) {
            enMenteeStatus = EnMenteeStatus.myHaveProposalWait;
            setState(() {});
          } else {
            Mentee? mentee = await MenteeRepository()
                .getMenteeByUserIdAndMentorId(
                    conversationCardView.myUserId, _otherMentor!.getId()!);
            if (mentee != null && mentee.getEndDate() == null) {
              enMenteeStatus = EnMenteeStatus.hidden;
              setState(() {});
            }
          }
        }
      }
    }
  }
}
