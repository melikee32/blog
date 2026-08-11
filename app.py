import os
from functools import wraps

from flask import Flask, jsonify, request, render_template, flash, redirect, url_for, session
from database import get_connection
from werkzeug.security import generate_password_hash, check_password_hash
from werkzeug.utils import secure_filename

app = Flask( __name__, template_folder="app/templates", static_folder="app/static" )

app.secret_key = os.environ.get("SECRET_KEY", "dev-only-change-me")

# DECORATOR'LAR

def login_required(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        if 'id' not in session:
            flash("Bu sayfayı görmek için giriş yapmalısınız.", "error")
            return redirect(url_for("login"))

        return f(*args, **kwargs)

    return wrapper

def admin_required(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        if session.get('role') != 'admin':
            flash("Yetkisiz erişim!", "error")
            return redirect(url_for("login"))

        return f(*args, **kwargs)

    return wrapper

# ANASAYFA
@app.route("/")
def index():
    return render_template("index.html")

# LOGIN / LOGOUT
@app.route("/login", methods=["GET", "POST"])
def login():

    if request.method == "POST":

        email = request.form.get("email", "").strip()
        password = request.form.get("password", "").strip()

        db = get_connection()
        cursor = db.cursor(dictionary=True)

        cursor.execute(
            """
            SELECT id, username, email, password_hash, role, job, photo
            FROM users
            WHERE email=%s
            """,
            (email,)
        )

        user = cursor.fetchone()

        cursor.close()
        db.close()

        if user and check_password_hash( user["password_hash"], password ):

            session.clear()

            session.update({ "id": user["id"], "username": user["username"], "email": user["email"], "role": user["role"], "job": user["job"], "photo": user["photo"] })

            flash("Giriş başarılı!", "success")

            if user["role"] == "admin":
                return redirect(url_for("admin_panel"))

            return redirect(url_for("posts"))

        else:
            flash("Email veya şifre yanlış!", "error")

    return render_template("login.html")

@app.route("/exit")
def exit_session():

    session.clear()

    flash("Çıkış yapıldı.", "success")

    return redirect(url_for("login"))

# REGISTER
@app.route("/register", methods=["GET", "POST"])
def register():

    if request.method == "POST":

        username = request.form.get("username", "").strip()[:50]
        email = request.form.get("email", "").strip()[:100]
        raw_password = request.form.get("password", "").strip()
        job = request.form.get("job", "")

        if not username or not email or not raw_password:
            flash("Tüm alanları doldurun.", "error")
            return render_template("register.html")

        db = get_connection()
        cursor = db.cursor()

        try:

            hashed_password = generate_password_hash(raw_password)

            cursor.execute(
                """
                INSERT INTO users
                (username, email, password_hash, job)
                VALUES (%s, %s, %s, %s)
                """,
                ( username, email, hashed_password, job )
            )

            db.commit()

            flash( "Kayıt başarılı 😊. Giriş yapabilirsiniz!", "success" )

            return redirect(url_for("login"))

        except Exception:

            db.rollback()

            flash( "Bu email zaten kullanılıyor!", "error" )

        finally:

            cursor.close()
            db.close()

    return render_template("register.html")

# PROFILE
@app.route("/profile", methods=["GET", "POST"])
@login_required
def profile():

    db = get_connection()
    cursor = db.cursor(dictionary=True)

    if request.method == "POST":

        cursor.execute( "SELECT password_hash FROM users WHERE id=%s", (session["id"],) )

        current = cursor.fetchone()

        current_password = request.form.get( "password_hash", "" ).strip()

        if not current or not check_password_hash( current["password_hash"], current_password ):

            cursor.close()
            db.close()

            flash( "Mevcut şifre yanlış.", "error" )

            return redirect(url_for("profile"))

        username = request.form.get( "username", "" ).strip()[:50]

        email = request.form.get( "email", "" ).strip()[:100]

        new_password = request.form.get( "new_password", "" ).strip()

        photo_filename = None

        photo_file = request.files.get("photo")

        if photo_file and photo_file.filename:

            allowed_ext = { ".png", ".jpg", ".jpeg", ".gif", ".webp" }

            ext = os.path.splitext( photo_file.filename )[1].lower()

            if ext not in allowed_ext:

                cursor.close()
                db.close()

                flash( "Geçersiz dosya türü. " "Sadece resim dosyaları yükleyebilirsin.", "error" )

                return redirect(url_for("profile"))

            upload_dir = os.path.join( app.static_folder, "uploads" )

            os.makedirs( upload_dir, exist_ok=True )

            photo_filename = secure_filename( f"user_{session['id']}{ext}" )

            photo_file.save( os.path.join( upload_dir, photo_filename ) )

        update_cursor = db.cursor()

        try:

            if new_password and photo_filename:

                update_cursor.execute(
                    """
                    UPDATE users
                    SET username=%s,
                        email=%s,
                        password_hash=%s,
                        photo=%s
                    WHERE id=%s
                    """,
                    ( username, email, generate_password_hash(new_password), photo_filename, session["id"] )
                )

            elif new_password:

                update_cursor.execute(
                    """
                    UPDATE users
                    SET username=%s,
                        email=%s,
                        password_hash=%s
                    WHERE id=%s
                    """,
                    ( username, email, generate_password_hash(new_password), session["id"] )
                )

            elif photo_filename:

                update_cursor.execute(
                    """
                    UPDATE users
                    SET username=%s,
                        email=%s,
                        photo=%s
                    WHERE id=%s
                    """,
                    ( username, email, photo_filename, session["id"] )
                )

            else:

                update_cursor.execute(
                    """
                    UPDATE users
                    SET username=%s,
                        email=%s
                    WHERE id=%s
                    """,
                    ( username, email, session["id"] )
                )

            db.commit()

            session["username"] = username
            session["email"] = email

            flash( "Profil güncellendi!", "success" )

        except Exception:

            db.rollback()

            flash( "Profil güncellenirken hata oluştu.", "error" )

        finally:

            update_cursor.close()
            cursor.close()
            db.close()

        return redirect(url_for("profile"))

    cursor.execute(
        """
        SELECT username, email, job, photo
        FROM users
        WHERE id=%s
        """,
        (session["id"],)
    )

    user = cursor.fetchone()

    cursor.close()
    db.close()

    if not user:

        flash( "Kullanıcı bulunamadı.", "error" )

        return redirect(url_for("posts"))

    return render_template( "profile.html", user=user )

# =========================================================
# ADMIN
# =========================================================

@app.route("/admin")
@login_required
@admin_required
def admin_panel():

    db = get_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute( "SELECT id, username, email, role FROM users" )

    users = cursor.fetchall()

    cursor.execute( "SELECT id, title, user_id FROM posts" )

    posts = cursor.fetchall()

    cursor.close()
    db.close()

    return render_template( "admin.html", users=users, posts=posts )

# POSTS
@app.route("/posts")
def posts():

    category = request.args.get( "category", "" ).strip()

    db = get_connection()
    cursor = db.cursor(dictionary=True)

    if category:

        cursor.execute(
            """
            SELECT posts.*, users.username, users.photo
            FROM posts
            JOIN users
                ON posts.user_id = users.id
            WHERE posts.category = %s
            """,
            (category,)
        )

    else:

        cursor.execute(
            """
            SELECT posts.*, users.username, users.photo
            FROM posts
            JOIN users
                ON posts.user_id = users.id
            """
        )

    result = cursor.fetchall()

    cursor.close()
    db.close()

    return render_template( "blog.html", posts=result, current_category=category )

# YENİ POST
@app.route("/posts/new", methods=["GET", "POST"])
@login_required
def new_post():

    if request.method == "POST":

        title = request.form.get( "title", "" ).strip()

        content = request.form.get( "content", "" ).strip()

        category = request.form.get( "category", "" ).strip()

        if not title or not content:

            flash( "Başlık ve içerik boş olamaz.", "error" )

            return render_template( "new_post.html" )

        db = get_connection()
        cursor = db.cursor()

        try:

            cursor.execute(
                """
                INSERT INTO posts
                (title, content, category, user_id)
                VALUES (%s, %s, %s, %s)
                """,
                ( title, content, category, session["id"] )
            )

            db.commit()

            flash( "Yazı eklendi!", "success" )

        except Exception as e:

            db.rollback()

            app.logger.error( f"Yazı ekleme hatası: {e}" )

            flash( "Yazı eklenirken bir hata oluştu.", "error" )

        finally:

            cursor.close()
            db.close()

        return redirect(url_for("posts"))

    return render_template( "new_post.html" )

# POST EDIT
@app.route( "/posts/<int:id>/edit", methods=["GET", "POST"] )
@login_required
def edit_post(id):

    db = get_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute( "SELECT * FROM posts WHERE id=%s", (id,) )

    post = cursor.fetchone()

    if not post:

        cursor.close()
        db.close()

        flash( "Yazı bulunamadı.", "error" )

        return redirect(url_for("posts"))

    if post["user_id"] != session.get("id"):

        cursor.close()
        db.close()

        flash( "Bu yazıyı düzenleme yetkiniz yok.", "error" )

        return redirect(url_for("posts"))

    if request.method == "POST":

        title = request.form.get( "title", "" ).strip()

        content = request.form.get( "content", "" ).strip()

        if not title or not content:

            cursor.close()
            db.close()

            flash( "Başlık ve içerik boş olamaz.", "error" )

            return render_template( "edit_post.html", post=post )

        update_cursor = db.cursor()

        try:

            update_cursor.execute(
                """
                UPDATE posts
                SET title=%s,
                    content=%s
                WHERE id=%s
                """,
                ( title, content, id )
            )

            db.commit()

            flash( "Yazı güncellendi!", "success" )

        except Exception:

            db.rollback()

            flash( "Yazı güncellenirken hata oluştu.", "error" )

        finally:

            update_cursor.close()

        cursor.close()
        db.close()

        return redirect( url_for( "post_detail", post_id=id ) )

    cursor.close()
    db.close()

    return render_template( "edit_post.html", post=post )

# POST DELETE
@app.route( "/posts/<int:id>/delete", methods=["POST"] )
@login_required
def delete_post(id):

    db = get_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute( "SELECT * FROM posts WHERE id=%s", (id,) )

    post = cursor.fetchone()

    if not post:

        cursor.close()
        db.close()

        flash( "Yazı bulunamadı.", "error" )

        return redirect(url_for("posts"))

    if ( post["user_id"] != session.get("id") and session.get("role") != "admin" ):

        cursor.close()
        db.close()

        flash( "Bu yazıyı silme yetkiniz yok.", "error" )

        return redirect(url_for("posts"))

    delete_cursor = db.cursor()

    try:

        delete_cursor.execute( "DELETE FROM comments WHERE post_id=%s", (id,) )

        delete_cursor.execute( "DELETE FROM favorites WHERE post_id=%s", (id,) )

        delete_cursor.execute( "DELETE FROM post_categories WHERE post_id=%s", (id,) )

        delete_cursor.execute( "DELETE FROM posts WHERE id=%s", (id,) )

        db.commit()

        flash( "Yazı silindi!", "success" )

    except Exception as e:

        db.rollback()

        app.logger.error( f"Yazı silme hatası: {e}" )

        flash( "Yazı silinirken hata oluştu.", "error" )

    finally:

        delete_cursor.close()
        cursor.close()
        db.close()

    return redirect(url_for("posts"))

# POST DETAY + YORUMLAR
@app.route("/posts/<int:post_id>")
def post_detail(post_id):

    db = get_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute(
        """
        SELECT posts.*, users.username, users.photo
        FROM posts
        JOIN users
            ON posts.user_id = users.id
        WHERE posts.id=%s
        """,
        (post_id,)
    )

    post = cursor.fetchone()

    cursor.execute(
        """
        SELECT comments.*, users.username, users.photo
        FROM comments
        JOIN users
            ON comments.user_id = users.id
        WHERE comments.post_id = %s
        ORDER BY comments.created_at DESC
        """,
        (post_id,)
    )

    comments = cursor.fetchall()

    cursor.close()
    db.close()

    return render_template( "post_detail.html", post=post, comments=comments )

# YORUM EKLE
@app.route( "/posts/<int:post_id>/comment", methods=["POST"] )
@login_required
def add_comment(post_id):

    comment_text = request.form.get( "comment_text", "" ).strip()

    if not comment_text:

        flash( "Yorum boş olamaz.", "error" )

        return redirect( url_for( "post_detail", post_id=post_id ) )

    db = get_connection()
    cursor = db.cursor()

    try:

        cursor.execute(
            """
            INSERT INTO comments
            (comment_text, post_id, user_id)
            VALUES (%s, %s, %s)
            """,
            ( comment_text, post_id, session["id"] )
        )

        db.commit()

        flash( "Yorum eklendi!", "success" )

    except Exception:

        db.rollback()

        flash( "Yorum eklenirken hata oluştu.", "error" )

    finally:

        cursor.close()
        db.close()

    return redirect( url_for( "post_detail", post_id=post_id ) )

# YORUM SİL
@app.route( "/comments/<int:id>/delete", methods=["POST"] )
@login_required
def delete_comment(id):

    db = get_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute( "SELECT * FROM comments WHERE id=%s", (id,) )

    comment = cursor.fetchone()

    if not comment:

        cursor.close()
        db.close()

        flash( "Yorum bulunamadı.", "error" )

        return redirect(url_for("posts"))

    if ( comment["user_id"] != session.get("id") and session.get("role") != "admin" ):

        cursor.close()
        db.close()

        flash( "Bu yorumu silme yetkiniz yok.", "error" )

        return redirect( url_for( "post_detail", post_id=comment["post_id"] ) )

    delete_cursor = db.cursor()

    try:

        delete_cursor.execute( "DELETE FROM comments WHERE id=%s", (id,) )

        db.commit()

        flash( "Yorum silindi!", "success" )

    except Exception:

        db.rollback()

        flash( "Yorum silinirken hata oluştu.", "error" )

    finally:

        delete_cursor.close()
        cursor.close()
        db.close()

    return redirect( url_for( "post_detail", post_id=comment["post_id"] ) )

# =========================================================
# FAVORİLER
# =========================================================

@app.route("/favorites")
@login_required
def favorites():

    db = get_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute(
        """
        SELECT
            p.id,
            p.title,
            p.content,
            u.username,
            u.photo
        FROM posts p
        JOIN favorites f
            ON p.id = f.post_id
        JOIN users u
            ON p.user_id = u.id
        WHERE f.user_id = %s
        """,
        (session["id"],)
    )

    fav_posts = cursor.fetchall()

    cursor.close()
    db.close()

    return render_template( "favorites.html", posts=fav_posts )

# FAVORİ EKLE
@app.route( "/favorites/add/<int:post_id>", methods=["POST"] )
@login_required
def add_favorite(post_id):

    db = get_connection()
    cursor = db.cursor()

    try:

        cursor.execute(
            """
            INSERT INTO favorites
            (user_id, post_id)
            VALUES (%s, %s)
            """,
            ( session["id"], post_id )
        )

        db.commit()

        flash( "Favorilere eklendi! ★", "success" )

    except Exception:

        db.rollback()

        flash( "Favori eklenirken hata oluştu.", "error" )

    finally:

        cursor.close()
        db.close()

    return redirect( url_for("posts") )

# FAVORİ SİL
@app.route( "/favorites/delete/<int:post_id>", methods=["POST"] )
@login_required
def delete_favorite(post_id):

    db = get_connection()
    cursor = db.cursor()

    try:

        cursor.execute(
            """
            DELETE FROM favorites
            WHERE user_id=%s
            AND post_id=%s
            """,
            ( session["id"], post_id )
        )

        db.commit()

        flash( "Favoriden çıkarıldı ☆", "success" )

    except Exception:

        db.rollback()

        flash( "Favori silinirken hata oluştu.", "error" )

    finally:

        cursor.close()
        db.close()

    return redirect( url_for("favorites") )

# ARAMA
@app.route("/search")
def search():

    query = request.args.get( "q", "" ).strip()

    db = get_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute(
        """
        SELECT *
        FROM posts
        WHERE title LIKE %s
        OR content LIKE %s
        """,
        ( f"%{query}%", f"%{query}%" )
    )

    results = cursor.fetchall()

    cursor.close()
    db.close()

    return render_template( "search.html", posts=results, query=query )

# UYGULAMAYI ÇALIŞTIR
if __name__ == "__main__":
    app.run( debug=os.environ.get( "FLASK_DEBUG", "1" ) == "1" )