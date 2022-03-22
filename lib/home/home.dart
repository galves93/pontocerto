import 'package:flutter/material.dart';
import 'package:pontocerto/global.dart';
import 'package:pontocerto/home/banco_horas/banco_horasDAO.dart';
import 'package:pontocerto/home/banco_horas/banco_horasVO.dart';
import 'package:pontocerto/home/marcar_ponto/marcar_pontoDAO.dart';
import 'package:pontocerto/login/UsuarioVO.dart';
import 'package:pontocerto/tools.dart';
import '../detalhado/detalhadoUI.dart';
import '../format.dart';
import '../login/loginUI.dart';
import 'codigo_gerente.dart';

class HomeUI extends StatefulWidget {
  final UsuarioLogadoVO? usuarioVO;
  final SaldoTotal? saldoLogin;
  final int? qtdMarcacoes;

  const HomeUI({Key? key, this.usuarioVO, this.saldoLogin, this.qtdMarcacoes})
      : super(key: key);
  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> with SingleTickerProviderStateMixin {
  AnimationController? _animController;
  Animation? _animSaldo;
  double? saldoTotal = 0.0;
  int? qtdMarcados;

  @override
  void initState() {
    _animController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    WidgetsBinding.instance!.addPostFrameCallback((_) {});
    qtdMarcados = widget.qtdMarcacoes ?? 0;
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    saldoTotal = widget.saldoLogin == null
        ? 0.0
        : double.parse(widget.saldoLogin!.saldoTotal!);
    _animSaldo =
        Tween<double>(begin: 0, end: saldoTotal).animate(CurvedAnimation(
      parent: _animController!,
      curve: Interval(0, 1, curve: Curves.easeInOut),
    ));

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Drawer _drawer = Drawer(
        child: Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Colors.orangeAccent,
                    Colors.orange,
                  ])),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            "${widget.usuarioVO!.nome!.toUpperCase()}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.035,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                widget.usuarioVO!.gerente! == 0
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading:
                                Icon(Icons.exit_to_app, color: Colors.grey),
                            title: Text("Sair",
                                style: TextStyle(color: Colors.grey)),
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginUI(),
                                  ));
                            },
                          ),
                        ),
                      )
                    : Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: Icon(Icons.account_circle_outlined,
                                    color: Colors.grey),
                                title: Text("Código de gerente",
                                    style: TextStyle(color: Colors.grey)),
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CodigoGerente(
                                          usuarioVO: widget.usuarioVO,
                                        ),
                                      ));
                                },
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: Icon(Icons.exit_to_app,
                                      color: Colors.grey),
                                  title: Text("Sair",
                                      style: TextStyle(color: Colors.grey)),
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginUI(),
                                        ));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0 * 2),
                  child: Column(
                    children: const [
                      Expanded(
                          child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Versão: 0.1",
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              )),
        ],
      ),
    ));

    double _sizeSaldo = 70.0;
    _animController!.forward();

    return WillPopScope(
      onWillPop: () async {
        Tools().goTo(context, LoginUI());
        return true;
      },
      child: Scaffold(
        appBar: gappBar,
        drawer: _drawer,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child: Center(
                          child: Text('Saldo Banco de Horas',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                        animation: _animController!,
                        builder: (BuildContext context, child) {
                          return Container(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: Center(
                                child: Text(
                                    Format().decimal2(_animSaldo!.value),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: _sizeSaldo)),
                              ),
                            ),
                          );
                        }),
                    Divider(),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: MaterialButton(
                      color: Colors.orange,
                      onPressed: () {
                        MarcarPontoDAO().setMarcarPonto(widget.usuarioVO!.id!);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "Marcar Ponto",
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Marcações do dia anterior:",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: qtdMarcados == 0
                                ? Text("Não houve marcações no dia anterior")
                                : Text(
                                    "Quantidade de marcações: $qtdMarcados",
                                    style: TextStyle(
                                        color: qtdMarcados! % 2 == 0
                                            ? Colors.greenAccent
                                            : Colors.red),
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(gpadding),
                child: GestureDetector(
                  onTap: () {
                    Tools().goTo(
                        context,
                        DetalhadoUI(
                          usuarioVO: widget.usuarioVO,
                        ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(gcircularRadius),
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(gpadding),
                          child: Container(
                            child: Text('Analisar Ponto Detalhado',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                          ),
                        ),
                        Icon(
                          Icons.search,
                          size: 40,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
