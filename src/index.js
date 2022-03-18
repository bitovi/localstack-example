const dayjs = require('dayjs');

exports.handler =  async function(event, context) {
    var now = dayjs();
    console.log('+*+++*+*+*+*+*+*+*+*+*+**+*++*+*');
    console.log('EVENT OCCURRED!');
    console.log(`Message created at ${now}`);
    console.log("EVENT: \n" + JSON.stringify(event, null, 2));
    console.log('+*+++*+*+*+*+*+*+*+*+*+**+*++*+*');
    return context.logStreamName
}

