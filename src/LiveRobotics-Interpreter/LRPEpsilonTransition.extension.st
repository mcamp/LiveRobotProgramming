Extension { #name : #LRPEpsilonTransition }

{ #category : #'*LiveRobotics-Interpreter' }
LRPEpsilonTransition >> checkWith: aMachine [

	^true.
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPEpsilonTransition >> interpretWith: anInterpreter scope: aScope [

	anInterpreter interpretEpsilonTransition: self withScope: aScope.
]
