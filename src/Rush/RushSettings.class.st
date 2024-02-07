Class {
	#name : 'RushSettings',
	#superclass : 'Object',
	#classVars : [
		'ComputeSenders',
		'InlineMethods'
	],
	#category : 'Rush',
	#package : 'Rush'
}

{ #category : 'accessing' }
RushSettings class >> computeSenders [

	^ ComputeSenders
		ifNil: [ false ]
]

{ #category : 'accessing' }
RushSettings class >> computeSenders: aBoolean [

	ComputeSenders := aBoolean
]

{ #category : 'accessing' }
RushSettings class >> inlineMethods [

	^ InlineMethods
		ifNil: [ true ]
]

{ #category : 'accessing' }
RushSettings class >> inlineMethods: aBoolean [

	InlineMethods := aBoolean
]
