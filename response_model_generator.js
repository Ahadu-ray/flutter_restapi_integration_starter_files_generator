if(pm.response.code==200)
{
  const responseJson = pm.response.json();
  if(responseJson.data){
    var data=responseJson.data;
    console.log(modelTemplate(toClassName(this.request.name),data));
  }
}

function modelTemplate(modelName,data) {
  let dataTypes = "";
  let extras = "";
for(var key in data){
    let value=data[key]
    let type=typeof(value);
    if (type == undefined)
      ;
    else if (type ==
        "object"){
            
           if(value==null){
                dataTypes = dataTypes + `dynamic ${key},\n`;
            } 
    else  if(!Array.isArray(value)) {
      extras = extras +
          modelTemplate(`${toClassName(key)}Model`, value);
      dataTypes = dataTypes + `${toClassName(key)}Model? ${key},\n`;
    }
            else{
        dataTypes = dataTypes + `List<dynamic>? ${key},\n`;
    } 
        }else {
      dataTypes = dataTypes + `${getDartClass(type)}? ${key},\n`;
    }
  };
  return `@freezed\nabstract class ${modelName} with _\$${modelName} {\nfactory ${modelName}({\n${dataTypes}\n}) = _${modelName};\nfactory ${modelName}.fromJson(Map<String, dynamic> json) => _\$${modelName}FromJson(json);\n}\n${extras}\n`;
}

 function toClassName(name) {
  var temp = name.split(/[\s_]/);
  var fileName = "";
  temp.forEach((element)=> {
    fileName = fileName + element[0].toUpperCase() + element.substring(1);
  });
  return fileName;
}

function getDartClass(name){
    switch (name){
      case "string":
        return "String";
      case "number":
        return "int";
      case "boolean":
        return "bool";
      case "":
        return "String";
    }
}