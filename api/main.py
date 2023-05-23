import sqlite3
from fastapi import FastAPI

app = FastAPI()

# Connect to the SQLite database
conn = sqlite3.connect('messages.db')
cursor = conn.cursor()

# Create a table for messages if it doesn't exist
cursor.execute('''
    CREATE TABLE IF NOT EXISTS messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        message TEXT
    )
''')
conn.commit()

@app.post("/store_message")
async def store_messages(message: str):
    # Insert the message into the database
    cursor.execute("INSERT INTO messages (message) VALUES (?)", (message,))
    conn.commit()
    return {"message": "Message stored successfully"}

@app.get("/")
async def get_messages():
    # Retrieve all messages from the database
    cursor.execute("SELECT id, message FROM messages")
    rows = cursor.fetchall()
    messages = []
    for row in rows:
        message = {
            "id": row[0],
            "message": row[1],
        }
        messages.append(message)
    return messages
    

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=6379)
