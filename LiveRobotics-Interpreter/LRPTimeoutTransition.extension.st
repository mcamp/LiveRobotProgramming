Extension { #name : #LRPTimeoutTransition }

{ #category : #'*LiveRobotics-Interpreter' }
LRPTimeoutTransition >> checkWith: aMachine [
	|time result now calctime|	
		
	time := aMachine startTimeRunningState.
	now := Time now asMilliSeconds.
	
	maxTime isNumber
		ifTrue: [calctime := maxTime ]
		ifFalse: [calctime := aMachine scope getVar: maxTime].
	calctime
		ifNil: [ result := false ]
		ifNotNil: [result := (calctime <= (now - time))]	.
	^result
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPTimeoutTransition >> interpretWith: anInterpreter scope: aScope [

	anInterpreter interpretTimeoutTransition: self withScope: aScope.
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPTimeoutTransition >> maxTime [
	^ maxTime
]

{ #category : #'*LiveRobotics-Interpreter' }
LRPTimeoutTransition >> maxTime: anObject [
	maxTime := anObject
]
