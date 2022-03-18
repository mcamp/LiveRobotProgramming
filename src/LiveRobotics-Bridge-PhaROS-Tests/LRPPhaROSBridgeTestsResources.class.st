Class {
	#name : #LRPPhaROSBridgeTestsResources,
	#superclass : #TestResource,
	#category : #'LiveRobotics-Bridge-PhaROS-Tests'
}

{ #category : #running }
LRPPhaROSBridgeTestsResources >> setUp [

	OSProcess command: 'roscore'.
	5 seconds wait.
]

{ #category : #running }
LRPPhaROSBridgeTestsResources >> tearDown [

	OSProcess command: 'killall roscore'.
]
