Class {
	#name : #LRPAbstractInterpretationTests,
	#superclass : #TestCase,
	#instVars : [
		'parser',
		'interpreter',
		'scope',
		'program'
	],
	#category : #'LiveRobotics-Tests'
}

{ #category : #running }
LRPAbstractInterpretationTests >> setUp [

	parser := LRPParser compiledParser.

	"candidates for extraction into a resource"
	interpreter := LRPInterpreter new.

	scope := nil.
]

{ #category : #running }
LRPAbstractInterpretationTests >> tearDown [
	super tearDown.
	interpreter stop.
	LRPCodeGenerator removeAllClasses
]
