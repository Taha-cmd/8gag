app.post('/login', function (req, res) {
    const pool = new pg.Pool({
        user: 'user',
        host: 'host.example.com',
        database: 'exampleDatabase',
        password: '1234',
        port: '4321'
    });

    var pwd = null;
    pool.query("select password from userdata where mail = '" + req.body.user_name + "'", (err, resp) => {
        pwd = resp.rows[0]["password"];
        res.set('Content-Type', 'text/html');
        var ok = false;

        password(req.body.user_password).verifyAgainst(pwd, function(error, verified) {
            if(error)
                console.log(error);
            if(!verified) {
                res.sendStatus(401);
            } else {
                ok = true;
            }
        });
        axios.post('http://localhost:3000/api/v1/login', {
            user: req.body.user_name,
            password: req.body.user_password,
        }).then(function (response) {
            req.session.user = response.data.data.authToken;
            console.log(response.data.data.authToken);
            if (response.data.status === 'success' && ok) {
                res.status(200).send({"token": response.data.data.authToken, "id": response.data.data.userId});
            }
        }).catch(function (error) {
            res.sendStatus(401);
        });
        pool.end()
    });
});
app.post('/register', function (req, res) {
    const pool = new pg.Pool({
        user: 'user',
        host: 'host.example.com',
        database: 'exampleDatabase',
        password: '1234',
        port: '4321'
    });

    var pwd;

    axios.post('http://localhost:3000/api/v1/users.register', {
        username: req.body.input_first_name + req.body.input_last_name,
        email: req.body.input_mail,
        pass: req.body.input_password,
        name: req.body.input_first_name
    }).then(function (response) {
        if (response.data.success) {
            return axios.post('http://localhost:3000/api/v1/login', {
                user: req.body.input_mail,
                password: req.body.input_password
            });
        }
    }).then(function (response) {
        if (response.data.status === 'success') {
            password(req.body.input_password).hash(function(error, hash) {
                    if(error)
                throw new Error('Something went wrong!');

                pwd = hash;

                pool.query("insert into userdata(user_id, mail, password, first_name, last_name, day_of_birth, username) values(
                'user" + response.data.data.userId + "', '" + req.body.input_mail + "', '" + pwd + "', 
                '" + req.body.input_first_name + "', '" + req.body.input_last_name + "', '" + req.body.input_day_of_birth + "', 
                '" + req.body.input_first_name + req.body.input_last_name + "')", (err, res) => {
                    pool.end();
                });
            });
            res.set('Content-Type', 'text/html');
        }
    }).catch(function (error) {
    console.log(error);
    }); 
    res.redirect('http://127.0.0.1/%27);
});