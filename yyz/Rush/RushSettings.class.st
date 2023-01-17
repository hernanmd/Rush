Class {
	#name : #RushSettings,
	#superclass : #Object,
	#classVars : [
		'ComputeSenders'
	],
	#category : #Rush
}

{ #category : #accessing }
RushSettings class >> computeSenders [

	^ ComputeSenders
		ifNil: [ false ]
]

{ #category : #accessing }
RushSettings class >> computeSenders: aBoolean [

	ComputeSenders := aBoolean
]
