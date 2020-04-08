import 'package:flutter/material.dart';
import 'package:minhas_anotacoes/helper/AnotacaoHelper.dart';
import 'package:minhas_anotacoes/modelo/Anotacao.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();

  //Aqui estou criando uma instancia para poder salvar os dados, pois quem
  // executa os camondos no banco de dados é a classe AnotacaoHelper()
  var _db = AnotacaoHelper();
  //criando uma lista que irá guardar as anotações recuperadas no banco de dados
  List<Anotacao> _anotacoes = List<Anotacao>();

  _exibirTelaCadastro() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("add anotação"),
            content: SingleChildScrollView( // adicionado para evite erro de quebra de pixel na tela
              child: Column(
                mainAxisSize: MainAxisSize.min,
                //determina que o conteúdo da coluna (neste caso o AlertDialog()) vai ocupar o estaço minimo disponivel da tela
                children: <Widget>[
                  TextField(
                    controller: _tituloController,
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: "Título", hintText: "Digite título..."),
                  ),
                  TextField(
                    controller: _descricaoController,
                    decoration: InputDecoration(
                        labelText: "Descrição", hintText: "Digite descrição..."),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
              FlatButton(
                onPressed: () {
                  // código para salvar
                  _salvarAnotacao();
                  Navigator.pop(context);
                },
                child: Text("Salvar"),
              )
            ],
          );
        });
  }

  _recuperarAnotacoes() async{
    //apenas lembrando que o _db esta criado na classe AnotacaoHelper e instaciado neste arquivo
    List anotacoesRecuperadas = await _db.recuperarAnotacoes();

    //foi criada a lista listaTemporaria para evitar de ter que limpar a lista _anotacoes a cada chamada
    List<Anotacao> listaTemporaria = List<Anotacao>();
    for(var item in anotacoesRecuperadas){
      Anotacao anotacao = Anotacao.fromMap(item);
      listaTemporaria.add(anotacao);
    }

    setState(() {
      _anotacoes = listaTemporaria;
    });

    listaTemporaria = null;
    print("anotações recuperadas: " + anotacoesRecuperadas.toString());
  }

  _salvarAnotacao() async {

    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    //classe criada em lib/modelo/Anotacao.dart
    // Aqui é necessário passar os paremetos para o construtor
    Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString());
    //aqui está sendo passado como parâmetro a anotacao que acabou de ser criada acima
    int resultado = await _db.salvarAnotacao(anotacao);
    print("salvando: " + resultado.toString());
    _tituloController.clear();
    _descricaoController.clear();

    _recuperarAnotacoes();

  }

  _formatarData(String data){
    initializeDateFormatting('pt_BR');
    //var formatador = DateFormat("y/MMMM/d H:m:s");
    var formatador = DateFormat.yMMMd("pt_BR");

    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);
    return dataFormatada;
  }

  //chamando o initState() no lugar da funcão _recuperarAnotacoes() que estava sendo chamada dentro do build
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {
    //_recuperarAnotacoes();
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas anotações"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: <Widget>[
          Expanded( //Expanded -> permite que seja usado todo o espaço disponível
            child: ListView.builder(
                itemCount: _anotacoes.length,
                itemBuilder: (context, index){

                  final itemAnotacao = _anotacoes[index];

                  return Card( //Card -> seria um cartão que da o efeito de separar os itens da lista
                    child: ListTile(
                      title: Text(itemAnotacao.titulo),
                      subtitle: Text("${_formatarData(itemAnotacao.data)} - ${itemAnotacao.descricao}"),
                    ),
                  );
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          _exibirTelaCadastro();
        },
      ),
    );
  }
}
