var express = require('express');
var mysql = require('mysql');
var bodyParser = require('body-parser');
var app = express();

app.set("view engine", "ejs");
app.use(bodyParser.urlencoded({extended: true}));
app.use(express.static(__dirname +"/public"));

var con = mysql.createConnection({
    host: "localhost",
    user: "sqluser",
    password: "password",
    database: "join_us"
  });
  

app.get('/', function(req,res){
    var q = 'SELECT COUNT(*) AS count FROM users';
    con.query(q, function (err,result){
        if(err) throw err;
        var count = result[0].count;
        //res.send('someone is calling ' + count + ' times');
        res.render('home', {data: count});
    })
})


app.post("/register", function(req, res){
    var person = {email: req.body.email};
    con.query('INSERT INTO users SET ?', person, function(err, result){
        if (err) throw err;
        res.redirect('/');
    })
})


app.get('/random_number', function(req,res){
    var num = Math.floor(Math.random() * 10) + 1;
    res.send('Your lucky number is '+ num);
})

app.listen(8080, function() {
    console.log('app is running on port 8080');
});
