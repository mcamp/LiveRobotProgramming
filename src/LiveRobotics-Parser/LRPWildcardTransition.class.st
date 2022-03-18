Class {
	#name : #LRPWildcardTransition,
	#superclass : #LRPTransition,
	#category : #'LiveRobotics-Parser'
}

{ #category : #'syntax highlighting' }
LRPWildcardTransition >> arrowRangeFor: aTokenArray [
	^((aTokenArray at: 3) stop + 1 to: (aTokenArray at: 6) start -1)

]

{ #category : #printing }
LRPWildcardTransition >> printOn: aStream [

	aStream nextPutAll: 'LRPWildcardTransition '.
	aStream nextPutAll: self name.
	aStream nextPutAll: ' : *->'.
	aStream nextPutAll: self to.
	aStream nextPutAll: ' on '.
	aStream nextPutAll: self eventname.
	
]
