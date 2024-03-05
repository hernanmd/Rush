"
Abstract class which provides a code presenter to subclasses.

"
Class {
	#name : 'RushMinimalBrowser',
	#superclass : 'RushAbstractBrowser',
	#instVars : [
		'srcCodePresenter'
	],
	#category : 'Rush-Core',
	#package : 'Rush',
	#tag : 'Core'
}

{ #category : 'initialization' }
RushMinimalBrowser >> initializeCodePresenter [

	srcCodePresenter := self newCode
]

{ #category : 'accessing' }
RushMinimalBrowser >> srcCodePresenter [

	^ srcCodePresenter
]

{ #category : 'accessing' }
RushMinimalBrowser >> srcCodePresenter: anObject [

	srcCodePresenter := anObject
]
