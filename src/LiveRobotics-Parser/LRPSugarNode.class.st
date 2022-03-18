"
I am a node that represents a syntactic sugar expression. 
My evaluation does nothing, and I exist mainly for syntax highlighting of sugar.
"
Class {
	#name : #LRPSugarNode,
	#superclass : #LRPContainedElement,
	#category : #'LiveRobotics-Parser'
}

{ #category : #visiting }
LRPSugarNode >> acceptVisitor: aLRPNodeVisitor [
	aLRPNodeVisitor visitSugarNode: self.
]
