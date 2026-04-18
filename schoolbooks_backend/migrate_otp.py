import sqlite3
import sys

try:
    conn = sqlite3.connect('schoolbooks.db')
    cursor = conn.cursor()

    cursor.execute("PRAGMA table_info(users)")
    columns = [col[1] for col in cursor.fetchall()]

    if 'otp_code' not in columns:
        cursor.execute("ALTER TABLE users ADD COLUMN otp_code VARCHAR(6)")
        print("Added column: otp_code")

    if 'otp_expires_at' not in columns:
        cursor.execute("ALTER TABLE users ADD COLUMN otp_expires_at DATETIME")
        print("Added column: otp_expires_at")

    conn.commit()
    print("Migration completed successfully!")

except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)
finally:
    conn.close()