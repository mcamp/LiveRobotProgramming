Extension { #name : #Collection }

{ #category : #'*LiveRobotics-Interpreter' }
Collection >> minusWithWeakFunction: aCollection [
	"Minus set operator. The comparison functions is special for LRP
	self\aCollection"
	
	^self select: [ :item| 
		(aCollection select:[ :anotherItem|
				item weakEqualNode: anotherItem.
		]) isEmpty.
	].
]
