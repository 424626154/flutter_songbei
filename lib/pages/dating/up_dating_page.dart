import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/models/dating_model.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:provider/provider.dart';

class UpDatingPage extends StatefulWidget {

  DatingModel datingModel;

  UpDatingPage(this.datingModel);

  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }
}

class _PageState extends State<UpDatingPage> {
  DatingModel _datingModel = DatingModel.init();

  List citys;

  TextEditingController _describeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/data/citys.json').then(
        (value) => {citys = json.decode(value), print('-----citys:${citys}')});
    if(widget.datingModel != null ){
      _datingModel = widget.datingModel;
      _describeController.text = _datingModel.self_describe;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑个人信息'),
        centerTitle: true,
        actions: [
          FlatButton(
            child: Text(
              '保存',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _onSave();
            },
          )
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildItem('性别', UIManager.getDatingGenderStr(_datingModel), _onGender),
              _buildItem('年龄', UIManager.getDatingAgeStr(_datingModel), _onBirthDate),
              _buildItem('身高', UIManager.getDatingHeightStr(_datingModel), _onHeight),
              _buildItem('体重', UIManager.getDatingWeightStr(_datingModel), _onWeight),
              _buildItem('学历', UIManager.getDatingDegreeStr(_datingModel), _onDegree),
              _buildItem('所在地', UIManager.getDatingLocationStr(_datingModel), _onLocation),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.grey.shade300, width: 1.0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '自我描述',
                      style: TextStyle(fontSize: 18),
                    ),
                    TextField(
                      controller: _describeController,
                      decoration: InputDecoration(
                        hintText: '编辑自我描述',
                        border: InputBorder.none,
                      ),
                      minLines: 3,
                      maxLines: 5,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(String title, String content, Function onItem) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 1.0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${title}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '${content}',
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
      onTap: () {
        if (onItem != null) onItem();
      },
    );
  }



  void _onGender() {
    var list_data = ['男', '女'];
    Picker(
        adapter: PickerDataAdapter<String>(pickerdata: list_data),
        changeToFirst: true,
        hideHeader: false,
        title: Text('性别'),
        cancelText: '取消',
        confirmText: '确认',
        onConfirm: (Picker picker, List value) {
          var index = value[0];
          var slect = list_data[index];
          print(slect);
          if(slect == '男'){
            _datingModel.gender = 1;
          }else if(slect == '女'){
            _datingModel.gender = 0;
          }
          setState(() {

          });
        }).showModal(this.context);
  }



  void _onBirthDate() {
    Picker(
        adapter: DateTimePickerAdapter(
            yearBegin: 1921,
            yearEnd: 2002,
            type: 7,
            months: [
              '1',
              '2',
              '3',
              '4',
              '5',
              '6',
              '7',
              '8',
              '9',
              '10',
              '11',
              '12'
            ]),
        changeToFirst: true,
        hideHeader: false,
        title: Text('年龄'),
        cancelText: '取消',
        confirmText: '确认',
        onConfirm: (Picker picker, List value) {
          // print(value.toString());
          print(picker.adapter.text);
          // print(picker.getSelectedValues());
          var birth_date = picker.adapter.text.substring(0,'0000-00-00'.length);
          print(birth_date);
          _datingModel.birth_date = birth_date;
          setState(() {
            
          });
        }).showModal(this.context);
  }


  void _onHeight() {
    var list_data = [
      '130cm',
      '131cm',
      '132cm',
      '133cm',
      '134cm',
      '135cm',
      '136cm',
      '137cm',
      '138cm',
      '139cm',
      '140cm',
      '141cm',
      '142cm',
      '143cm',
      '144cm',
      '145cm',
      '146cm',
      '147cm',
      '148cm',
      '149cm',
      '150cm',
      '151cm',
      '152cm',
      '153cm',
      '154cm',
      '155cm',
      '156cm',
      '157cm',
      '158cm',
      '159cm',
      '160cm',
      '161cm',
      '162cm',
      '163cm',
      '164cm',
      '165cm',
      '166cm',
      '167cm',
      '168cm',
      '169cm',
      '170cm',
      '171cm',
      '172cm',
      '173cm',
      '174cm',
      '175cm',
      '176cm',
      '177cm',
      '178cm',
      '179cm',
      '180cm',
      '181cm',
      '182cm',
      '183cm',
      '184cm',
      '185cm',
      '186cm',
      '187cm',
      '188cm',
      '189cm',
      '190cm',
      '191cm',
      '192cm',
      '193cm',
      '194cm',
      '195cm',
      '196cm',
      '197cm',
      '198cm',
      '199cm',
      '200cm',
      '201cm',
      '202cm',
      '203cm',
      '204cm',
      '205cm',
      '206cm',
      '207cm',
      '208cm',
      '209cm',
      '210cm',
      '211cm',
      '212cm',
      '213cm',
      '214cm',
      '215cm',
      '216cm',
      '217cm',
      '218cm',
      '219cm',
      '220cm',
    ];
    Picker(
        adapter: PickerDataAdapter<String>(pickerdata: list_data),
        changeToFirst: true,
        hideHeader: false,
        title: Text('身高'),
        cancelText: '取消',
        confirmText: '确认',
        onConfirm: (Picker picker, List value) {
          var index = value[0];
          var slect = list_data[index];
          print(slect);
          print(slect.substring(0,slect.indexOf('cm')));
          var temp_hight = int.tryParse(slect.substring(0,slect.indexOf('cm')));
          _datingModel.height = temp_hight;
          setState(() {

          });
        }).showModal(this.context);
  }

  void _onWeight() {
    var list_data = [
      '30kg',
      '31kg',
      '32kg',
      '33kg',
      '34kg',
      '35kg',
      '36kg',
      '37kg',
      '38kg',
      '39kg',
      '40kg',
      '41kg',
      '42kg',
      '43kg',
      '44kg',
      '45kg',
      '46kg',
      '47kg',
      '48kg',
      '49kg',
      '50kg',
      '51kg',
      '52kg',
      '53kg',
      '54kg',
      '55kg',
      '56kg',
      '57kg',
      '58kg',
      '59kg',
      '60kg',
      '61kg',
      '62kg',
      '63kg',
      '64kg',
      '65kg',
      '66kg',
      '67kg',
      '68kg',
      '69kg',
      '70kg',
      '71kg',
      '72kg',
      '73kg',
      '74kg',
      '75kg',
      '76kg',
      '77kg',
      '78kg',
      '79kg',
      '80kg',
      '81kg',
      '82kg',
      '83kg',
      '84kg',
      '85kg',
      '86kg',
      '87kg',
      '88kg',
      '89kg',
      '90kg',
      '91kg',
      '92kg',
      '93kg',
      '94kg',
      '95kg',
      '96kg',
      '97kg',
      '98kg',
      '99kg',
      '100kg',
      '101kg',
      '102kg',
      '103kg',
      '104kg',
      '105kg',
      '106kg',
      '107kg',
      '108kg',
      '109kg',
      '100kg',
      '101kg',
      '102kg',
      '103kg',
      '104kg',
      '105kg',
      '106kg',
      '107kg',
      '108kg',
      '109kg',
      '110kg',
      '111kg',
      '112kg',
      '113kg',
      '114kg',
      '115kg',
      '116kg',
      '117kg',
      '118kg',
      '119kg',
      '120kg'
    ];
    Picker(
        adapter: PickerDataAdapter<String>(pickerdata: list_data),
        changeToFirst: true,
        hideHeader: false,
        title: Text('体重'),
        cancelText: '取消',
        confirmText: '确认',
        onConfirm: (Picker picker, List value) {
          var index = value[0];
          var slect = list_data[index];
          print(slect);
          print(slect.indexOf('kg'));
          print(slect.substring(0,slect.indexOf('kg')));
          var temp_weight = int.tryParse(slect.substring(0,slect.indexOf('kg')));
          _datingModel.weight = temp_weight;
          setState(() {

          });
        }).showModal(this.context);
  }

  String _onDegree() {
    var list_data = ['高中中专及以下', '大专', '本科', '双学士', '硕士', '博士'];
    Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: list_data),
        changeToFirst: true,
        hideHeader: false,
        title: Text('学历'),
        cancelText: '取消',
        confirmText: '确认',
        onConfirm: (Picker picker, List value) {
          var index = value[0];
          var select = list_data[index];
          print(select);
          _datingModel.degree = select;
          setState(() {

          });
        }).showModal(this.context);
  }

  void _onLocation() {
    Picker(
        adapter: PickerDataAdapter(
            data: citys.asMap().keys.map((index) {
          var city = citys[index];
          List children = city['children'];
          // print(city);
          return PickerItem(
              text: Text('${city['name']}'),
              value: '${city['name']}',
              children: children.asMap().keys.map((cindex) {
                print('-----cindex');
                print(children[cindex]);
                return PickerItem(
                    text: Text('${children[cindex]['name']}'),
                    value: '${children[cindex]['name']}');
              }).toList());
        }).toList()),
        changeToFirst: true,
        hideHeader: false,
        title: Text('所在地'),
        cancelText: '取消',
        confirmText: '确认',
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.adapter.text);
          var city0 = picker.getSelectedValues()[0];
          var city1 = picker.getSelectedValues()[1];
          _datingModel.location = '${city0}-${city1}';
          setState(() {

          });
        }).showModal(this.context);
  }

  _onSave(){
    if(_datingModel.gender != 0&&_datingModel.gender != 1){
      ToastUtil.showToast(context, '请选择性别');
    }
    if(_datingModel.birth_date == null||(_datingModel.birth_date != null&&_datingModel.birth_date.isEmpty)){
      ToastUtil.showToast(context, '请选择年龄');
    }
    if(_datingModel.height == null){
      ToastUtil.showToast(context, '请选择身高');
    }
    if(_datingModel.weight == null){
      ToastUtil.showToast(context, '请选择体重');
    }
    if(_datingModel.degree == null||(_datingModel.degree != null&&_datingModel.degree.isEmpty)){
      ToastUtil.showToast(context, '请选择学历');
    }
    if(_datingModel.location == null||(_datingModel.location != null&&_datingModel.location.isEmpty)){
      ToastUtil.showToast(context, '请选择所在地');
    }
    _datingModel.self_describe = _describeController.text;
    _reqUpDating();
  }

  void _reqUpDating(){
    CHttp.post(
        CHttp.DATING_UPINFO,
            (data) {
          LogUtil.v(data);
          ToastUtil.showToast(context, '修改成功');
          Navigator.of(context).pop(_datingModel);
        },
        params: PUpDating(
            Provider.of<App>(context, listen: false).userid,
          _datingModel.gender,
            _datingModel.birth_date,
            _datingModel.height,
            _datingModel.weight,
            _datingModel.degree,
            _datingModel.location,
            _datingModel.self_describe
            )
            .toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        });
  }
}
