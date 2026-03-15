extends InteractableObject
class_name SubInteractObject

@export var master:Node2D

func interact(player:Player):
	master.interact(player)
	
