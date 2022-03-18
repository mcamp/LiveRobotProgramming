"
I am a class variable slot that notifies on write. My defining class needs to have a collection of  observers , whom I notify.
"
Class {
	#name : #LRPNotifyingClassVar,
	#superclass : #LiteralVariable,
	#category : #'LiveRobotics-Interpreter'
}

{ #category : #'meta-object-protocol' }
LRPNotifyingClassVar >> write: aValue [
	super write: aValue.

	self definingClass observers do:[:observer |observer varChanged: self]
]
