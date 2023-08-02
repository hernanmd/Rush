Class {
	#name : #RushMinimalBrowser,
	#superclass : #RushAbstractBrowser,
	#instVars : [
		'srcCodePresenter'
	],
	#category : #Rush
}

{ #category : #initialization }
RushMinimalBrowser >> initializeCodePresenter [

	srcCodePresenter := self newCode
]
