Class {
	#name : #LRPChangeStateAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'currentState'
	],
	#category : #'LiveRobotics-Interpreter-Announcement'
}

{ #category : #accessing }
LRPChangeStateAnnouncement >> currentState [
	^ currentState
]

{ #category : #accessing }
LRPChangeStateAnnouncement >> currentState: anObject [
	currentState := anObject
]
