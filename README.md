# GDLobbies
A simple way to setup multiple lobbies in Godot 4.x

![image](https://github.com/jcurtis06/GDLobbies/assets/77545656/49337584-2486-4ffb-a512-a6eaab5bba5a)


### About
The goal of this project is to be as simple to use as possible. One of the biggest issues with creating multiplayer games is the need for port forwarding. These scripts attempt
to remove the need for port forwarding in small Godot projects by adding a lobby system.

A player can host a lobby, while another can join that lobby using the provided key. This allows each party to have a private game lobby to themselves.

### How it works
There are 3 files that are important, `master_server.py`, `lobby_manager.gd`, and `server_manager.gd`.

#### `master_server.py`
This is a simple Python 3 script that adds REST endpoints. It's job is to spawn new instances of
your server executable whenever new lobbies are created. Additionally, it routes joining players
to the correct server.

#### `lobby_manager.gd`
This file is where the bulk of the action takes place on the Godot side. It talks to the Master Server to create and join lobbies.

#### `server_manager.gd`
This file manages some basic configuration and handles your server executable. It's main goal is to parse commandline arguments.

### Usage
Coming soon.
