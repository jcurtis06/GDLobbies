from flask import Flask, request
from subprocess import Popen
import random, uuid
import argparse

parser = argparse.ArgumentParser(description='Start the server with the given server executable.')
parser.add_argument("--server-executable", type=str, help="The path to the server executable.", default="./builds/GDLobbies.app/Contents/MacOS/GDLobbies")

app = Flask(__name__)

rooms = {}

@app.route('/create_room')
def create_room():
  port = random.randint(8000, 9000)
  room_key = str(uuid.uuid4())[:8]

  Popen([parser.parse_args().server_executable, "--headless", "--port=" + str(port), "--key=" + room_key])

  rooms[room_key] = {"port": port, "players": []}

  return {"status": "success", "port": port, "key": room_key}

@app.route('/join_room', methods=['POST'])
def join_room():
    data = request.json
    room_key = data.get('key')

    if room_key in rooms:
        port = rooms[room_key]['port']
        return {"status": "success", "port": port, "key": room_key}
    else:
        return {"status": "failed", "message": "Invalid room key"}, 400

if __name__ == '__main__':
  app.run(host='0.0.0.0', port=25565)