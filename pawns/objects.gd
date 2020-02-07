extends Area2D

class_name StaticObject

enum CELL_TYPES{ EMPTY=-1, PLAYER, OBSTACLE, PATH, NPC, ATTACKER, COIN}
export(CELL_TYPES) var type = CELL_TYPES.NPC
