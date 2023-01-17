Class {
	#name : #RushClassPathPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'topClass'
	],
	#category : #Rush
}

{ #category : #examples }
RushClassPathPresenter class >> example1 [
	^ (self on: SystemDictionary) open
]

{ #category : #examples }
RushClassPathPresenter class >> example2 [
	^ (self on: String empty) open
]

{ #category : #adding }
RushClassPathPresenter >> addPathDelimiter [

	self layout isEmpty ifFalse: [
		self layout 
			add: (self newLabel label: ' > ') 
			expand: false
			fill: false ]
]

{ #category : #adding }
RushClassPathPresenter >> addPathElement: cls [

	self layout
		add: (self newLink
			label: cls asString;
			help: cls comment;
			action: [ cls browse ])
		expand: false
		fill: false
]

{ #category : #transmission }
RushClassPathPresenter >> defaultInputPort [

	^ self inputTextPort
	
]

{ #category : #initialization }
RushClassPathPresenter >> initializePresenters [

	self layout: SpBoxLayout newLeftToRight.
	self topClass isClassOrTrait
		ifTrue: [
			self topClass withAllSuperclasses reversed do: [ : cls |.
			self
				addPathDelimiter;
				addPathElement: cls ] ]
		ifFalse: [
			self layout
				add: (self newLabel label: 'no selection')
				expand: false
				fill: false ]
]

{ #category : #transmission }
RushClassPathPresenter >> inputTextPort [

	^ SpLabelPort newPresenter: self
]

{ #category : #adding }
RushClassPathPresenter >> label: aClass [

	topClass := aClass.
	self initializePresenters.	

]

{ #category : #'accessing - model' }
RushClassPathPresenter >> setModelBeforeInitialization: aClass [

	topClass := aClass
]

{ #category : #initialization }
RushClassPathPresenter >> topClass [

	^ topClass
]
