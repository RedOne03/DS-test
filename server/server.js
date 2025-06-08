const express = require('express');
const mysql = require('mysql');
const bcrypt = require('bcrypt');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(express.json());
app.use(cors());

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'renace_db'
});

db.connect(err => {
    if (err) {
        console.error('❌ Error al conectar con MySQL:', err);
        return;
    }
    console.log('✅ Conectado a MySQL');
});

// Registro de usuario
app.post('/register', async (req, res) => {
    const { usuario, correo, password } = req.body;
    
    if (!usuario || !correo || !password) {
        return res.status(400).json({ error: 'Todos los campos son obligatorios' });
    }

    try {
        const hashedPassword = await bcrypt.hash(password, 10);
        const sql = "INSERT INTO renace (usuario, correo, password_hash) VALUES (?, ?, ?)";
        db.query(sql, [usuario, correo, hashedPassword], (err, result) => {
            if (err) {
                console.error(err);
                return res.status(500).json({ error: 'Error al registrar usuario' });
            }
            res.status(201).json({ message: 'Usuario registrado exitosamente' });
        });
    } catch (error) {
        res.status(500).json({ error: 'Error en el servidor' });
    }
});

// Inicio de sesión
app.post('/login', (req, res) => {
    const { correo, password } = req.body;
    
    if (!correo || !password) {
        return res.status(400).json({ error: 'Todos los campos son obligatorios' });
    }

    const sql = "SELECT * FROM renace WHERE correo = ?";
    db.query(sql, [correo], async (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).json({ error: 'Error en el servidor' });
        }
        if (results.length === 0) {
            return res.status(401).json({ error: 'Correo o contraseña incorrectos' });
        }
        
        const user = results[0];
        const isMatch = await bcrypt.compare(password, user.password_hash);
        
        if (!isMatch) {
            return res.status(401).json({ error: 'Correo o contraseña incorrectos' });
        }

        res.status(200).json({ message: 'Inicio de sesión exitoso' });
    });
});

app.listen(3000, () => {
    console.log('✅ Servidor corriendo en el puerto 3000');
});


app.post('/register', async (req, res) => {
    const { usuario, correo, password } = req.body;

    if (!usuario || !correo || !password) {
        return res.status(400).json({ error: 'Todos los campos son obligatorios' });
    }

    try {
        // Verificar si el usuario o correo ya existen
        const checkUserQuery = "SELECT * FROM renace WHERE usuario = ? OR correo = ?";
        db.query(checkUserQuery, [usuario, correo], async (err, results) => {
            if (err) {
                console.error(err);
                return res.status(500).json({ error: 'Error al verificar usuario' });
            }
            if (results.length > 0) {
                return res.status(400).json({ error: 'El usuario o correo ya están registrados' });
            }

            // Si no existe, proceder con la inserción
            const hashedPassword = await bcrypt.hash(password, 10);
            const sql = "INSERT INTO renace (usuario, correo, password_hash) VALUES (?, ?, ?)";
            db.query(sql, [usuario, correo, hashedPassword], (err, result) => {
                if (err) {
                    console.error(err);
                    return res.status(500).json({ error: 'Error al registrar usuario' });
                }
                res.status(201).json({ message: 'Usuario registrado exitosamente' });
            });
        });

    } catch (error) {
        res.status(500).json({ error: 'Error en el servidor' });
    }
});
