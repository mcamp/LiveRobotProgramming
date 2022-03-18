Extension { #name : #LRPContainedElement }

{ #category : #'*LiveRobotics-Interpreter' }
LRPContainedElement >> findInnerChild: aNamesCollection [
	"To use with LRPMachine and LRPState"
	
	(aNamesCollection size = 1) 
		ifTrue:[ (self name = aNamesCollection first)
						ifTrue: [ ^self ] ifFalse: [ self error: 'Element Not Find' ]]
		ifFalse:[|childState|
			childState := self elementsToSearchFullName detect: [ :anElement| anElement name = aNamesCollection second ].
			^childState findInnerChild: aNamesCollection allButFirst.	 
		]
]
