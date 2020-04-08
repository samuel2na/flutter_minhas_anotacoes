import 'package:flutter/foundation.dart';
import 'package:minhas_anotacoes/modelo/Anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoHelper{
  static final nomeTabela = "anotacao";
  static final colunaId = "id";

  //utilizando o padrão Sington para sempre retornar uma unica instacia da classe
  //pois estou manipulando o banco inteiro salvando sempre no mesmo arquivo
  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();
  Database _db;

  factory AnotacaoHelper(){
    return _anotacaoHelper;
  }

  //este abaixo é o construtor
  AnotacaoHelper._internal(){}

  get db async{
    if( _db != null){
      return _db;
    }else{
      _db = await inicializarDB();
      return _db;
    }
  }

  _onCreate(Database db, int version) async{
    String sql = "CREATE TABLE $nomeTabela ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "titulo VARCHAR, "
        "descricao TEXT, "
        "data DATETIME)";
    await db.execute(sql);
  }

  inicializarDB() async{

    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco_minhas_anotacoes");

    var db = await openDatabase(localBancoDados, version: 1, onCreate: _onCreate);
    return db;
  }

  //esta sendo passado o objeto que está criado dentro da pasta lib/modelo/anotacao.dart - que é uma classe
  //para utilizar essa classe foi necessário fazer o import dela tbm
  //retorno um Future<int> e é async
  Future<int> salvarAnotacao(Anotacao anotacao) async{
    var bancoDados = await db;

    //o metodo insert recebe dois parametros: o Nome da Tabela e um Map()
    int resultado = await bancoDados.insert(nomeTabela, anotacao.toMap());
    return resultado;
  }

  recuperarAnotacoes()async{
    var bancoDados = await db;
    String sql = "SELECT * FROM $nomeTabela ORDER BY data DESC";
    List anotacoes = await bancoDados.rawQuery(sql);
    return anotacoes;
  }
}

/*
*
* */