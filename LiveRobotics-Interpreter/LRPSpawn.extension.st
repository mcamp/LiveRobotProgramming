Extension { #name : #LRPSpawn }

{ #category : #'*LiveRobotics-Interpreter' }
LRPSpawn >> interpretWith: anInterpreter scope: aScope [
	"I am a top-level spawn"
	anInterpreter spawn: self machine in: self state withScope: aScope.
]
