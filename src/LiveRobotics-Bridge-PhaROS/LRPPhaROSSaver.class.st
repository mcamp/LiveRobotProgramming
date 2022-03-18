"
Im in charge of saving and loading a file with PhaROS subscriptions and publishers
"
Class {
	#name : #LRPPhaROSSaver,
	#superclass : #Object,
	#instVars : [
		'subscriptions',
		'publishers'
	],
	#category : #'LiveRobotics-Bridge-PhaROS'
}

{ #category : #adding }
LRPPhaROSSaver >> addPublisher: aVarName topicID: aTopicID type: aType [
	|lrpPublisher|
	lrpPublisher := LRPPhaROSPublisher new.
	lrpPublisher 
		topicID: aTopicID;
		type: aType;
		varName: aVarName.
		
	publishers add: lrpPublisher.
	^lrpPublisher.
]

{ #category : #adding }
LRPPhaROSSaver >> addSubscription: aVarName topicID: aTopicID type: aType [
	|lrpSubscription|
	lrpSubscription := LRPPhaROSSubscription new.
	lrpSubscription 
		topicID: aTopicID;
		type: aType;
		varName: aVarName.
		
	subscriptions add: lrpSubscription.
	^lrpSubscription.
]

{ #category : #initialization }
LRPPhaROSSaver >> initialize [
	super initialize.
	subscriptions := OrderedCollection new.
	publishers := OrderedCollection new.
]

{ #category : #actions }
LRPPhaROSSaver >> loadTopics: aFileRef [
	| stream json|
	
	stream := aFileRef readStream.
	json := STONJSON fromString: stream upToEnd.
	stream close.
	
	(json at: #subscriptions) do: [ :sub|
		subscriptions add: (
			LRPPhaROSSubscription new
				topicID: (sub at: #topic);
				varName: (sub at: #name);
				type: (sub at: #type);
				yourself
		)
	].

	(json at: #publishers) do: [ :sub|
		publishers add: (
			LRPPhaROSSubscription new
				topicID: (sub at: #topic);
				varName: (sub at: #name);
				type: (sub at: #type);
				yourself
		)
	].

	^aFileRef.
]

{ #category : #accessing }
LRPPhaROSSaver >> publishers [
	^ publishers
]

{ #category : #accessing }
LRPPhaROSSaver >> publishers: anObject [
	publishers := anObject
]

{ #category : #actions }
LRPPhaROSSaver >> saveTopics: aFileRef [
	|file stream |
	
	file := aFileRef.
	stream := file writeStream.
	stream nextPutAll: (STONJSON toString: self topics).
	stream close.
	^aFileRef.
]

{ #category : #accessing }
LRPPhaROSSaver >> subscriptions [
	^ subscriptions
]

{ #category : #accessing }
LRPPhaROSSaver >> subscriptions: anObject [
	subscriptions := anObject
]

{ #category : #accessing }
LRPPhaROSSaver >> topics [
	|dict|
	dict := Dictionary new.
	dict at: #publishers put: publishers.
	dict at: #subscriptions put: subscriptions.
	^dict.
]
