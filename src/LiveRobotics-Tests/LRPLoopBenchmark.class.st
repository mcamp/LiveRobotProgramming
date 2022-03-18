"
I represent benchmark.
I execute a loop program  for secondsPerTime seconds, 'times' times. Then I can calculate the how many times does it loop. the mean  and standard deviation.
"
Class {
	#name : #LRPLoopBenchmark,
	#superclass : #Object,
	#instVars : [
		'loopValues',
		'times',
		'secondsPerTime',
		'program'
	],
	#category : #'LiveRobotics-Tests'
}

{ #category : #'programs - loop' }
LRPLoopBenchmark class >> programLoop1 [

	^'
(var counter := [-1])
(machine benchmark1
  (state one
    (onentry [counter := counter + 1])
    (onexit [1+2])
  )
  (state two
    (onentry [2+3])
    (onexit [2+4])
  )
  (state three
    (onentry [3+1])
    (onexit [3+2])
  )
  (state four
    (onentry [4+1])
    (onexit [4+2])
  )
  (state five
    (onentry [5+1])
    (onexit [5+2])
  )
  
  ;;true s
  (on trueEvent one -> two txTrue1)
  (on trueEvent two -> three txTrue2)
  (on trueEvent three -> four txTrue3)
  (on trueEvent four -> five txTrue4)
  (on trueEvent five -> one txTrue5)  
    
  ;;false s
  (on falseEvent one -> two txFalse12)
  (on falseEvent one -> three txFalse13)
  (on falseEvent one -> four txFalse14)
  (on falseEvent one -> five txFalse15)

  (on falseEvent two -> one txFalse21)
  (on falseEvent two -> three txFalse23)
  (on falseEvent two -> four txFalse24)
  (on falseEvent two -> five txFalse25)
  
  (on falseEvent three -> one txFalse31)
  (on falseEvent three -> two txFalse32)
  (on falseEvent three -> four txFalse34)
  (on falseEvent three -> five txFalse35)
  
  (on falseEvent four -> one txFalse41)
  (on falseEvent four -> two txFalse42)
  (on falseEvent four -> three txFalse43)
  (on falseEvent four -> five txFalse45)
  
  (on falseEvent five -> one txFalse51)
  (on falseEvent five -> two txFalse52)
  (on falseEvent five -> three txFalse53)
  (on falseEvent five -> four txFalse54)
  
  ;;events
  (event trueEvent [true])
  (event falseEvent [false])
)
(spawn benchmark1 one)
'
]

{ #category : #'programs - loop' }
LRPLoopBenchmark class >> programLoop2 [
^'
(var counter := [-1])
(machine benchmark2
  (state one
    (onentry [counter := counter + 1])
    (onexit [1+2])
  )
  (state two
    (onentry [2+3])
    (onexit [2+4])
  )
  (state three
    (onentry [3+1])
    (onexit [3+2])
  )
  (state four
    (onentry [4+1])
    (onexit [4+2])
  )
  (state five
    (onentry [5+1])
    (onexit [5+2])
  )
  

    
  ;;false s
  (on falseEvent one -> two txFalse12)
  (on falseEvent one -> three txFalse13)
  (on falseEvent one -> four txFalse14)
  (on falseEvent one -> five txFalse15)

  (on falseEvent two -> one txFalse21)
  (on falseEvent two -> three txFalse23)
  (on falseEvent two -> four txFalse24)
  (on falseEvent two -> five txFalse25)
  
  (on falseEvent three -> one txFalse31)
  (on falseEvent three -> two txFalse32)
  (on falseEvent three -> four txFalse34)
  (on falseEvent three -> five txFalse35)
  
  (on falseEvent four -> one txFalse41)
  (on falseEvent four -> two txFalse42)
  (on falseEvent four -> three txFalse43)
  (on falseEvent four -> five txFalse45)
  
  (on falseEvent five -> one txFalse51)
  (on falseEvent five -> two txFalse52)
  (on falseEvent five -> three txFalse53)
  (on falseEvent five -> four txFalse54)
  
  ;;true s
  (on trueEvent one -> two txTrue1)
  (on trueEvent two -> three txTrue2)
  (on trueEvent three -> four txTrue3)
  (on trueEvent four -> five txTrue4)
  (on trueEvent five -> one txTrue5)  

  ;;events
  (event trueEvent [true])
  (event falseEvent [false])
)
(spawn benchmark2 one)
'
]

{ #category : #'programs - loop' }
LRPLoopBenchmark class >> programLoop3 [
^'
(var counter := [-1])
(machine benchmark3
  (state one
    (onentry [counter := counter + 1])
    (onexit [1+2])
  )
  (state two
    (onentry [2+3])
    (onexit [2+4])
  )
  (state three
    (onentry [3+1])
    (onexit [3+2])
  )
  (state four
    (onentry [4+1])
    (onexit [4+2])
  )
  (state five
    (onentry [5+1])
    (onexit [5+2])
  )
  

    
  ;;false s
  (on trueEvent one -> two txTrue1)
  (on falseEvent one -> two txFalse12)
  (on falseEvent one -> three txFalse13)
  (on falseEvent one -> four txFalse14)
  (on falseEvent one -> five txFalse15)

  (on falseEvent two -> one txFalse21)
  (on trueEvent two -> three txTrue2)
  (on falseEvent two -> three txFalse23)
  (on falseEvent two -> four txFalse24)
  (on falseEvent two -> five txFalse25)
  
  (on falseEvent three -> one txFalse31)
  (on falseEvent three -> two txFalse32)
  (on trueEvent three -> four txTrue3)
  (on falseEvent three -> four txFalse34)
  (on falseEvent three -> five txFalse35)
  
  (on falseEvent four -> one txFalse41)
  (on falseEvent four -> two txFalse42)
  (on falseEvent four -> three txFalse43)
  (on trueEvent four -> five txTrue4)
  (on falseEvent four -> five txFalse45)
  
  (on falseEvent five -> one txFalse51)
  (on falseEvent five -> two txFalse52)
  (on falseEvent five -> three txFalse53)
  (on falseEvent five -> four txFalse54)
  (on trueEvent five -> one txTrue5)  
  
  ;;events
  (event trueEvent [true])
  (event falseEvent [false])
)
(spawn benchmark3 one)
'
]

{ #category : #'instance creation - running' }
LRPLoopBenchmark class >> runProgram: aSymbol times: aNumber withSeconds: anotherNumber [
	|benchmark|
		
	benchmark := self new.
	benchmark times: aNumber; 
				secondsPerTime: anotherNumber;
				program: (self perform: aSymbol).
	
	^benchmark run.
]

{ #category : #benchmarking }
LRPLoopBenchmark class >> standardBenchmark [

	^self runProgram: #programLoop1 times: 10 withSeconds: 60.
]

{ #category : #adding }
LRPLoopBenchmark >> addLoopValue: aFloat [

	loopValues add: aFloat.
]

{ #category : #initialization }
LRPLoopBenchmark >> initialize [
	super initialize.
	loopValues := OrderedCollection new.
]

{ #category : #accessing }
LRPLoopBenchmark >> loopValues [
	^ loopValues
]

{ #category : #accessing }
LRPLoopBenchmark >> loopValues: anObject [
	loopValues := anObject
]

{ #category : #calculating }
LRPLoopBenchmark >> mean [
	"Get the average value of the loops count"
	 ^loopValues average
]

{ #category : #accessing }
LRPLoopBenchmark >> program [
	^ program
]

{ #category : #accessing }
LRPLoopBenchmark >> program: anObject [
	program := anObject
]

{ #category : #running }
LRPLoopBenchmark >> run [
	| interpreter |
	1 to: times do: [ :i | 
			interpreter := LRPInterpreter new.
			interpreter rate: 0.
			interpreter newProgram: (LRPParser new parse: (self program)).
			interpreter stepRun.
			interpreter stepRun.
			interpreter stepRun.
			interpreter stepRun.
			interpreter stepRun.
			interpreter withLoop: true.
			interpreter runMainLoop.
			secondsPerTime seconds wait.
			interpreter terminateProcess.
			self addLoopValue: (interpreter mainMachine scope getVar: #counter) 
	].
	
]

{ #category : #accessing }
LRPLoopBenchmark >> secondsPerTime [
	^ secondsPerTime
]

{ #category : #accessing }
LRPLoopBenchmark >> secondsPerTime: anObject [
	secondsPerTime := anObject
]

{ #category : #calculating }
LRPLoopBenchmark >> standardDeviation [
	"get the standard deviation of the loop values"
	|mean size|
	mean := self mean.
	size := loopValues size.
	^(loopValues collect: [ :aValue|
		(aValue - mean) ** 2 / size
	] )average sqrt.
]

{ #category : #calculating }
LRPLoopBenchmark >> timePerLoop [
	
	^ self secondsPerTime / self mean.
]

{ #category : #calculating }
LRPLoopBenchmark >> timePerStateInLoop [
	"get the time per state, in this case, every program has 5 states"
	^self timePerLoop / 5.
]

{ #category : #accessing }
LRPLoopBenchmark >> times [
	^ times
]

{ #category : #accessing }
LRPLoopBenchmark >> times: anObject [
	times := anObject
]
