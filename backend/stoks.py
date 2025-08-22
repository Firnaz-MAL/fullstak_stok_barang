from flask import Flask, request, jsonify
import sqlite3
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

DB_NAME = 'stoks.db'

def get_db_connection():
    conn = sqlite3.connect(DB_NAME)
    conn.row_factory = sqlite3.Row  # ✅ fix typo
    return conn

@app.route('/api/barang', methods=['GET'])
def get_barang():
    conn = get_db_connection()
    barang = conn.execute('SELECT * FROM barang').fetchall()
    conn.close()
    return jsonify([dict(row) for row in barang])

@app.route('/api/barang', methods=['POST'])
def tambah_barang():
    data = request.get_json()
    nama = data.get('nama')
    jumlah = data.get('jumlah')
    harga = data.get('harga')

    if not nama or not jumlah or not harga:
        return jsonify({'error': 'Data Tidak ada'}), 400
    
    conn = get_db_connection()
    conn.execute(
        'INSERT INTO barang (nama, jumlah, harga) VALUES (?, ?, ?)',
        (nama, jumlah, harga)
    )
    conn.commit()
    conn.close()

    return jsonify({'message': 'DATA barang berhasil ditambahkan'}), 201

@app.route('/api/barang/<int:id>', methods=['PUT'])
def update_barang(id):
    data = request.get_json()
    nama = data.get('nama')
    jumlah = data.get('jumlah')
    harga = data.get('harga')

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM barang WHERE id = ?', (id,))
    barang = cursor.fetchone()
    if barang is None:
        conn.close()
        return jsonify({'error': 'barang tidak ditemukan'}), 404

    cursor.execute(
        'UPDATE barang SET nama=?, jumlah=?, harga=? WHERE id=?',
        (nama, jumlah, harga, id)
    )
    conn.commit()
    conn.close()
    return jsonify({'message': 'barang berhasil diperbarui'})


@app.route('/api/barang/<int:id>', methods=['DELETE'])
def delete_barang(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM barang WHERE id = ?', (id,))
    barang = cursor.fetchone()
    if barang is None:
        conn.close()
        return jsonify({'message': 'barang tidak ditemukan'}), 404

    cursor.execute('DELETE FROM barang WHERE id = ?', (id,))
    conn.commit()
    conn.close()
    return jsonify({'message': 'barang berhasil dihapus'})

if __name__ == '__main__':
    app.run(host='192.168.1.130', port=5000)