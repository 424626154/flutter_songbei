class QiniuScuess {
  String file_path = '';
  String qiniu_key = '';
  QiniuScuess(this.file_path,this.qiniu_key);
  @override
  String toString() {
    return {
      'file_path':file_path,
      'qiniu_key':qiniu_key
    }.toString();
  }
}