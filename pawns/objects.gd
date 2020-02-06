extends Area2D

class_name StaticObject

enum CELL_TYPES{ PLAYER, WALL, NPC, ATTACKER, COIN}
export(CELL_TYPES) var type = CELL_TYPES.NPC
