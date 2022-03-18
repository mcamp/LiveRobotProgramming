Class {
	#name : #LRPPhaROSTopic,
	#superclass : #Object,
	#instVars : [
		'topicID',
		'type',
		'varName'
	],
	#category : #'LiveRobotics-Bridge-PhaROS'
}

{ #category : #testing }
LRPPhaROSTopic >> isEmpty [
	^false
]

{ #category : #enumerating }
LRPPhaROSTopic >> keysAndValuesDo: aBlock [
	aBlock value: 'name' value: varName.
	aBlock value: 'topic' value: topicID.
	aBlock value: 'type' value: type.
]

{ #category : #converting }
LRPPhaROSTopic >> stonOn: stonWriter [
	stonWriter writeMap: self
]

{ #category : #accessing }
LRPPhaROSTopic >> topicID [
	^ topicID
]

{ #category : #accessing }
LRPPhaROSTopic >> topicID: anObject [
	topicID := anObject
]

{ #category : #accessing }
LRPPhaROSTopic >> type [
	^ type
]

{ #category : #accessing }
LRPPhaROSTopic >> type: anObject [
	type := anObject
]

{ #category : #accessing }
LRPPhaROSTopic >> varName [
	^ varName
]

{ #category : #accessing }
LRPPhaROSTopic >> varName: anObject [
	varName := anObject
]
