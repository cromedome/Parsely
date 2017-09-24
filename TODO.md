Make missions a plugin-style folder structure.
Missions can have their own roles

Separate namespace for game plugins/modules? Can distribute code and config file in one structure.
Game actions live in existing namespace

TODO: visited properties in locations. Save them!
TODO: Score!
TODO: item, actor, thing state

ACTIONS: talk, look, attack, unlock, light, take, move, open, block

Goals:
- Easy for non-techies to make content for
- Easy to run and play
- Few dependencies as possible
- Get a little out of my comfort zone (YAML, Mojo)

Needs:
- more testing
- more validation
- less validation boilerplate

Expansion ideas:
- Multiplayer? (multiple people playing single-player games)
- Chat?
- Multiple things per location
- Deployment
- All-in-one client and game in Electron

Add docs for mission building.

Tests:
- thing.t set_state() croak
- valid mission
- invalid mission. Then test for everything wrong with it.
- no duplicate slugs
- everything has a default state
- Test that exit roles return exits (?)

Player: 
- Part of game, not mission

Add base object with name, description, looks, properties, save(), load() (DONE)
Slugs should be needed for creating new Things (DONE)
gamestate should be sent to all game actions

move = run = walk = go

May not need item properties as I envisioned them. Will have to see how restoring gamestate works.
look at differences between guard and door and see what works better.

Talk: 
- Didn't take long to make a base Thing
- Immutable actors, or complex definition?

