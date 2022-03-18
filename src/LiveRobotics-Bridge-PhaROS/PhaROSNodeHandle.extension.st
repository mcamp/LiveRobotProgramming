Extension { #name : #PhaROSNodeHandle }

{ #category : #'*LiveRobotics-Bridge-PhaROS' }
PhaROSNodeHandle >> removeInterestIn: aTopicName typedAs: aTypeId for: aCallback [
	
	topicHandle at: (self subscriber: aTopicName  typedAs:  aTypeId) ifPresent: [ :aCollectionOfCallbacks | 
		aCollectionOfCallbacks remove: aCallback ifAbsent: [  ].
	] 
	
]
