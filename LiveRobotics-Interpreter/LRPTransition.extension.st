Extension { #name : #LRPTransition }

{ #category : #'*LiveRobotics-Interpreter' }
LRPTransition >> checkWith: aMachine [
	|event returnVal|	

	event:= aMachine event: self eventname.

	event ifNil:[LRPErrorHandler instance eventNotFound: self eventname machine: aMachine. ^false].
	
	returnVal := event triggerBlock value.
	returnVal isBoolean
		ifTrue:[ ^returnVal]
		ifFalse:[ LRPErrorHandler instance eventHasNotBool: event value: returnVal. ^false]
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPTransition >> equalEvent: aTransition [

	^self eventname = aTransition eventname.
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPTransition >> equalStates: aTransition [

	^self from = aTransition from and: [ self to = aTransition to ]
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPTransition >> interpretWith: anInterpreter scope: aScope [

	anInterpreter interpretTransition: self withScope: aScope.
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPTransition >> isFromState: aState [

	^self from = aState name
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPTransition >> weakEqualNode: aTransition [

	^self identifier = aTransition identifier.
]
