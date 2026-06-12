extends Node

enum DurationType {
	PERMANENT,
	THIS_COMBAT,
	TURNS,
	SPECIAL
}

const DurationType_Labels:Dictionary[int, String] = {
	DurationType.PERMANENT : "Permanent",
	DurationType.THIS_COMBAT : "This combat",
	DurationType.TURNS : "Turns",
	DurationType.SPECIAL : "Special",
}
