Extension { #name : #LRPOnExit }

{ #category : #'*LiveRobotics-Interpreter' }
LRPOnExit >> interpretWith: anInterpreter scope: aScope [

	anInterpreter interpretAction: self withScope: aScope type: #onexit.
]
