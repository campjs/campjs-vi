var path = require('path');
var fs = require('fs');
var jade = require('jade');
var template = process.argv[2];
var templateName = path.basename(template, '.jade');
var compiled = jade.compileFile(path.resolve(__dirname, template));

// initialise data (quick and dirty)
var data = {};

try {
  data = require('./' + templateName + '.json');
}
catch (e) {

}
console.log(compiled({ data: data }));