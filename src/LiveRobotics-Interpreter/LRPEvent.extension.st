Extension { #name : #LRPEvent }

{ #category : #'*LiveRobotics-Interpreter' }
LRPEvent >> interpretWith: anInterpreter scope: aScope [

	anInterpreter interpretEvent: self withScope: aScope.
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPEvent >> triggerBlock [
	^ triggerBlock
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPEvent >> triggerBlock: anObject [
	triggerBlock := anObject
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPEvent >> weakEqualNode: anEvent [

	^self name = anEvent name.
]
