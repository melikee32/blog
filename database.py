import mysql.connector

def get_connection():
    
    try:
        connection = mysql.connector.connect(
            host = "localhost",
            user = "root",
            password = "",
            database = "blog"
    )
        return connection

    except mysql.connector.Error as err:
        print(f"Veritabanı bağlantı hatası: {err}")
        return None