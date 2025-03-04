import click
from database import MySQLDB
from werkzeug.security import generate_password_hash

@click.command()
@click.option('--username', prompt=True, help='The username used to login.')
@click.option('--password', prompt=True, hide_input=True, confirmation_prompt=True, help='The password used to login.')
def create_admin(username, password):
    """Create an admin
    """
    password_hash = generate_password_hash(password)
    db = MySQLDB()
    db.use_database("leathershoesuser")
    db.execute_query("INSERT INTO users (username, password_hash) VALUES (%s, %s) ON DUPLICATE KEY UPDATE password_hash = VALUES(password_hash)", (username, password_hash))
    db.commit()
    db.close()
    click.echo("Admin created.")

if __name__ == '__main__':
    create_admin()