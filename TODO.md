Test that exit roles return exits.
TODO tests for player methods
Make missions a plugin-style folder structure.
Missions can have their own roles

See notes in actioncastle.yaml

Missions or area descriptions as YAML
Immutable objects
Actors: items, characters, NPCs, etc.

Separate namespace for game plugins/modules? Can distribute code and config file in one structure.
Game actions live in existing namespace

Parsely.pm - Game engine
Parsely/Item, Actor, Location, etc: Objects that represent in game things
Parsely/Role/Item, Actor, etc: Implements items in game engine
Parsely/Mission: a mission. has a YAML config file
missions/actioncastle, etc.: mission data
missions/actioncastle/roles: custom roles
saves/ - one YAML file per saved game. YAML is name of saved game.

Mission->load(), save(), validate(), etc.

Goals:
- Easy for non-techies to make content for
- Easy to run and play
- Few dependencies as possible
- Get a little out of my comfort zone (YAML, Mojo)

Expansion ideas:
- Multiplayer? (multiple people playing single-player games)
- Chat?

Add docs for mission building.

