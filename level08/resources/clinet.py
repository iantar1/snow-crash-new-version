
import socket
import struct

SOCK_PATH = "/run/blacksun/blacksun.sock"

def checksum(payload: bytes) -> int:
    result = 0
    for i, byte in enumerate(payload):
        result ^= byte ^ (i & 0xFF)
    return result

def send_command(sock, command, payload=b""):
    # Version = 1 (3 bits); command occupies the upper 3 bits.
    first_byte = 1 | (command << 5)

    header = (
        bytes([first_byte])
        + struct.pack("<I", len(payload))
        + struct.pack("<H", checksum(payload))
        + b"\x00"
    )

    sock.sendall(header + payload)
    return sock.recv(512).decode(errors="replace")

with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
    sock.connect(SOCK_PATH)

    # Initialize the protocol session.
    print(send_command(sock, 0, struct.pack("<H", 0xDEAD)))

    # Request the flag through the server's admin handler.
    print(send_command(sock, 2))




# import socket
# import struct

# SOCK_PATH = "/run/blacksun/blacksun.sock"

# CMD_HELLO = 0
# CMD_ADMIN = 2


# def send_command(client, cmd, payload=b""):
#     first_byte = 1 | (cmd << 5)

#     checksum = 0
#     for i, byte in enumerate(payload):
#         checksum ^= byte ^ (i & 0xFF)

#     header = struct.pack("<BIH", first_byte, len(payload), checksum) + b"\x00"

#     client.sendall(header + payload)


# def receive_response(client):
#     response = client.recv(1024)
#     print("Server:", response.decode(errors="replace"))


# client = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
# client.connect(SOCK_PATH)

# # 1. HELLO
# send_command(client, CMD_HELLO, b"\xAD\xDE")
# receive_response(client)

# # 2. ADMIN
# send_command(client, CMD_ADMIN)
# receive_response(client)

# client.close()