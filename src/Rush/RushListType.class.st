Class {
	#name : 'RushListType',
	#superclass : 'SpPresenter',
	#classTraits : '{} + TraitedClass',
	#instVars : [
		'list',
		'model'
	],
	#category : 'Rush',
	#package : 'Rush'
}

{ #category : 'accessing' }
RushListType class >> defaultFirstListType [

	^ RushClassListType 
]

{ #category : 'initialization' }
RushListType >> connectToSourcePresenter [

	self subclassResponsibility
]

{ #category : 'layout' }
RushListType >> defaultLayout [ 

	^ SpBoxLayout newTopToBottom 
		add: list;
		yourself
]

{ #category : 'ports' }
RushListType >> defaultOutputPort [

	^ list defaultOutputPort
]

{ #category : 'initialization' }
RushListType >> initializePresenters [

	list := self newFilteringList
]

{ #category : 'accessing' }
RushListType >> list [

	^ list
]

{ #category : 'accessing' }
RushListType >> list: anObject [

	list := anObject
]

{ #category : 'accessing' }
RushListType >> listPresenter [

	^ list listPresenter
]

{ #category : 'accessing' }
RushListType >> model [

	^ model
]

{ #category : 'accessing - model' }
RushListType >> setModelBeforeInitialization: aRushBrowser [

	model := aRushBrowser
]

{ #category : 'accessing - model' }
RushListType >> srcCodePresenter [
	"Answer the receiver's browser <SpCodePresenter>"

	^ self model srcCodePresenter 
]
