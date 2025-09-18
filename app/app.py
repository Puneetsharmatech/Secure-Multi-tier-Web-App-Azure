import os
import psycopg2
from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

# Retrieve database connection string from environment variable (injected via App Service/Key Vault)
DB_CONNECTION_STRING = os.environ.get("DB_CONNECTION_STRING")

def get_db_connection():
    conn = psycopg2.connect(DB_CONNECTION_STRING)
    return conn

# Create the tasks table if it doesn't exist
def create_table():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS tasks (
            id SERIAL PRIMARY KEY,
            content TEXT NOT NULL
        )
    ''')
    conn.commit()
    conn.close()

# Call create_table() on startup to ensure the table exists
with app.app_context():
    create_table()

@app.route('/')
def index():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM tasks;')
    tasks = cursor.fetchall()
    conn.close()
    return render_template('index.html', tasks=tasks)

@app.route('/create', methods=('POST',))
def create():
    content = request.form['content']
    if not content:
        return 'Content is required!', 400
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('INSERT INTO tasks (content) VALUES (%s)', (content,))
    conn.commit()
    conn.close()
    return redirect(url_for('index'))

@app.route('/delete/<int:id>')
def delete(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('DELETE FROM tasks WHERE id = %s', (id,))
    conn.commit()
    conn.close()
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')