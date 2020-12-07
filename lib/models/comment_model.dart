
class CommentModel {
  int id = 0;
  String userid = '';
  String nickname = '';
  String head = '';
  int cid = 0;
  String cuserid = '';
  String cnickname = '';
  String chead = '';
  String comment = '';
  int iid = 0;
  int time = 0;
  int love = 0;
  int lovenum = 0;
  CommentModel(data){
    id = data['id'];
    userid = data['userid'];
    nickname = data['nickname'];
    head = data['head'];
    cid = data['cid'];
    cuserid = data['cuserid'];
    cnickname = data['cnickname'];
    chead = data['chead'];
    comment = data['comment'];
    iid = data['iid'];
    time = data['time'];
    love = data['love'];
    lovenum = data['lovenum'];
  }

  CommentModel.initV2(data,nickname,head){
    id = data['id'];
    userid = data['userid'];
    this.nickname = nickname;
    this.head = head;
    cid = data['cid'];
    cuserid = data['cuserid'];
    cnickname = data['cnickname'];
    chead = data['chead'];
    comment = data['comment'];
    iid = data['iid'];
    time = data['time'];
    love = data['love'];
    lovenum = data['lovenum'];
  }

  @override
  String toString() {
    return {
      'id':id,
      'userid':userid,
      'nickname':nickname,
      'head':head,
      'cid':cid,
      'cuserid':cuserid,
      'cnickname':cnickname,
      'chead':chead,
      'comment':comment,
      'iid':iid,
      'love':love,
      'lovenum':lovenum,
    }.toString();
  }
}