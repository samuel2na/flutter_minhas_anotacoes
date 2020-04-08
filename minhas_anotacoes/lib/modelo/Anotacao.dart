import 'package:minhas_anotacoes/helper/AnotacaoHelper.dart';

class Anotacao{

  int id;
  String titulo;
  String descricao;
  String data;

  Anotacao(this.titulo, this.descricao, this.data);

  //Esse construtor recebe um Map e devolve obejto. Obs.: não precisa usar o return pois o this. ja está fazendo a instancia ao devolver
  Anotacao.fromMap(Map map){
    this.id = map[AnotacaoHelper.colunaId]; //maneira sugerida para evitar de ficar repetindo os nomes dos campos e errar na digitação
    this.titulo = map["titulo"];
    this.descricao = map["descricao"];
    this.data = map["data"];
  }

  //convert para o tipo Map e retorna para onde foi chamada
  Map toMap(){
    Map<String, dynamic> map = {
      "titulo": this.titulo,
      "descricao": this.descricao,
      "data": this.data
    };
    //caso tenhamos o ID então adiciona ele no map, mas não são todos os casos que teremos.
    // ex.: quando for fazer um insert na tabela não teremos pois ele é criado automaticamente
    if(this.id != null){
      map["id"] = this.id;
    }
    return map;
  }

}