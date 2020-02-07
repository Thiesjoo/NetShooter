extends Area2D

class_name StaticObject

enum CELL_TYPES { EMPTY = -1, 
PLAYER, OBSTACLE, 
NPC, ATTACKER, 
COLLECTABLE,
}
export(CELL_TYPES) var type = CELL_TYPES.NPC


enum TILE_TYPES { EMPTY = -1, 
GYM
TILE }
