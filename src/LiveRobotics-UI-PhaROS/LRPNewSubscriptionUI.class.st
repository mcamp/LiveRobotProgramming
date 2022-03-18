Class {
	#name : #LRPNewSubscriptionUI,
	#superclass : #LRPNewPhaROSBridgeElemUI,
	#category : #'LiveRobotics-UI-PhaROS'
}

{ #category : #specs }
LRPNewSubscriptionUI class >> title [
	^ 'LRP PhaROS : New Subscription'
]

{ #category : #creating }
LRPNewSubscriptionUI >> createBridgeElem [
	lrpPhaROSUI phaROSBridge 
				addSubscription: textName getText
				topicID: textTopic getText
				type: textType getText.
]
