import 'package:flutter/material.dart';
import 'package:pam_perpustakaan/controller/api_services.dart';
import 'package:pam_perpustakaan/model/member.dart';
import 'package:pam_perpustakaan/view/member_form.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BuildContext context;
  ApiService apiService;
  Future<List<Member>> _member;
  String _title = "Anggota Perpustakaan";

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
  }

  _addProduct() {
    setState(() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => MemberForm()),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: <Widget>[
          FlatButton(
            onPressed: _addProduct,
            child: Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _member = apiService.getMember(null),
          builder:
              (BuildContext context, AsyncSnapshot<List<Member>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: AlertDialog(
                  title: Text('An Error Has Occurred'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text("${snapshot.error.toString()}"),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('close'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
                if(snapshot.data==[]){
                  return Center(
                    child: Text("Anggota tidak terdaftar"),
                  );
                }else {
                  List<Member> member = snapshot.data;
                  return _buildListView(member);
                }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildListView(List<Member> members) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          Member member = members[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      member.nama,
                      style: Theme.of(context).textTheme.title,
                    ),
                    Text(
                      "NIM " + member.nim,
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      member.jurusan,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return MemberForm(member: member);
                            }));
                          },
                          child: Text(
                            "Edit",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Hapus Anggota"),
                                    content: Text(
                                        "Apakah anda yakin ingin menghapus data ${member.nama}"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Yes"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          apiService
                                              .deleteMember(member.id)
                                              .then((isSuccess) {
                                            if (isSuccess) {
                                              setState(() {});
                                              Scaffold.of(this.context).showSnackBar(SnackBar(
                                                content: Text(
                                                    "Terhapus"),
                                              ));
                                            } else {
                                              Scaffold.of(this.context).showSnackBar(SnackBar(
                                                content: Text(
                                                    "Gagal terhapus"),
                                              ));
                                            }
                                          });
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("No"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: members.length,
      ),
    );
  }
}
