Class {
	#name : #LRPNewPublisherUI,
	#superclass : #LRPNewPhaROSBridgeElemUI,
	#category : #'LiveRobotics-UI-PhaROS'
}

{ #category : #specs }
LRPNewPublisherUI class >> title [	
	^ 'LRP PhaROS : New Publisher'
]

{ #category : #creating }
LRPNewPublisherUI >> createBridgeElem [
	lrpPhaROSUI phaROSBridge 
				addPublisher: textName getText
				topicID: textTopic getText
				type: textType getText.
]
