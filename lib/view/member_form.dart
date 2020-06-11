import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pam_perpustakaan/controller/api_services.dart';
import 'package:pam_perpustakaan/model/member.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class MemberForm extends StatefulWidget {
  final Member member;
  MemberForm({this.member});
  @override
  _MemberFormState createState() => _MemberFormState();
}

class _MemberFormState extends State<MemberForm> {
  int _id;
  String _title = "Tambah Anggota";
  bool _isLoading = false;
  ApiService _apiService = ApiService();
  bool _isNameValid;
  bool _isNimValid;
  bool _isJurusanValid;
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerNim = TextEditingController();
  TextEditingController _controllerJurusan = TextEditingController();

  @override
  void initState() {
    if (widget.member != null) {
      _isNameValid = true;
      _controllerName.text = widget.member.nama;
      _isNimValid = true;
      _controllerNim.text = widget.member.nim.toString();
      _isJurusanValid = true;
      _controllerJurusan.text = widget.member.jurusan;
      _id = widget.member.id;
      _title = "Change Data";
    }
    super.initState();
  }
  _hideKeyboard(){
    FocusScopeNode currentFocus = FocusScope.of(context);
    if(!currentFocus.hasPrimaryFocus){
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text(_title),
        leading: Container(),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.close),
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildFieldName(),
                _buildFieldNim(),
                _buildFieldJurusan(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RaisedButton(
                    child: Text(
                      widget.member == null
                          ? "submit".toUpperCase()
                          : "save".toUpperCase(),
                      style: TextStyle(color: Colors.black),
                    ),
                    color: Colors.yellow,
                    onPressed: () {
                      _hideKeyboard();
                      if (_isNameValid == null ||
                          _isNimValid == null ||
                          _isJurusanValid == null ||
                          !_isNameValid ||
                          !_isNimValid ||
                          !_isJurusanValid) {
                        _scaffoldState.currentState.showSnackBar(SnackBar(
                          content: Text("Please Fill Required Field!"),
                        ));
                        return;
                      }

                      String nama = _controllerName.text.toString();
                      String nim = _controllerNim.text.toString();
                      String jurusan = _controllerJurusan.text.toString();

                      Member member = Member(
                          nama: nama,
                          nim: nim,
                          jurusan: jurusan);
                      setState(() {
                        _isLoading = true;
                      });
                      if (widget.member == null) {
                        _apiService.addMember(member).then((response) {
                          setState(() => _isLoading = false);
                          if (response) {
                            Navigator.pop(_scaffoldState.currentState.context);
                          } else {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text(
                                  "Failed To Input Member, Please try Again!"),
                            ));
                          }
                        });
                      } else {
                        _apiService
                            .updateMember(member, _id)
                            .then((response) {
                          setState(() => _isLoading = false);
                          if (response) {
                            Navigator.pop(_scaffoldState.currentState.context);
                          } else {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text("Failed to update Member data!"),
                            ));
                          }
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          _isLoading
              ? Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.35,
                      child: ModalBarrier(
                        dismissible: false,
                        color: Colors.grey,
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  ],
                )
              : Container()
        ],
      ),
    );
  }

  Widget _buildFieldName() {
    return TextField(
      controller: _controllerName,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Nama Anggota",
        errorText: _isNameValid == null || _isNameValid
            ? null
            : "Isikan Nama Anggota!",
      ),
      onChanged: (value) {
        bool _isValid = value.trim().isNotEmpty;
        if (_isNameValid != _isValid) {
          setState(() {
            _isNameValid = _isValid;
          });
        }
      },
    );
  }

  Widget _buildFieldNim() {
    return TextField(
      controller: _controllerNim,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "NIM",
        errorText: _isNimValid == null || _isNimValid
            ? null
            : "Isikan NIM!",
      ),
      onChanged: (value) {
        bool _isValid = value.trim().isNotEmpty;
        if (_isNimValid != _isValid) {
          setState(() {
            _isNimValid = _isValid;
          });
        }
      },
    );
  }

  Widget _buildFieldJurusan() {
    return TextField(
      controller: _controllerJurusan,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Jurusan",
        errorText: _isJurusanValid == null || _isJurusanValid
            ? null
            : "Isikan Nama Jurusan!",
      ),
      onChanged: (value) {
        bool _isValid = value.trim().isNotEmpty;
        if (_isJurusanValid != _isValid) {
          setState(() {
            _isJurusanValid = _isValid;
          });
        }
      },
    );
  }
}
