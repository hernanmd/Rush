"
Abstract class which provides a code presenter to subclasses.

"
Class {
	#name : 'RushMinimalBrowser',
	#superclass : 'RushAbstractBrowser',
	#instVars : [
		'srcCodePresenter'
	],
	#category : 'Rush',
	#package : 'Rush'
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
