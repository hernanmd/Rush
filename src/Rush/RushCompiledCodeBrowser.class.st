Class {
	#name : 'RushCompiledCodeBrowser',
	#superclass : 'RushClassBrowser',
	#instVars : [
		'bytecodesPresenter',
		'headerDescription'
	],
	#category : 'Rush',
	#package : 'Rush'
}

{ #category : 'instance creation' }
RushCompiledCodeBrowser class >> open [ 
	<script>
	
	^ self new open
]

{ #category : 'private-instance side' }
RushCompiledCodeBrowser >> connectInstMethodsPresenter [

	super connectInstMethodsPresenter.

	instMethods
		transmitTo: bytecodesPresenter
		transform: [ : aMethod |
			aMethod
				ifNil: [ Array empty ]
				ifNotNil: [ aMethod symbolicBytecodes ] ].

	instMethods
		transmitTo: headerDescription
		transform: [ : aMethod |
			aMethod
				ifNil: [ String empty ]
				ifNotNil: [ aMethod headerDescription ] ]
]

{ #category : 'initialization' }
RushCompiledCodeBrowser >> initializeBytecodePresenter [

	bytecodesPresenter := self newList.
	bytecodesPresenter
		items: OrderedCollection new
]

{ #category : 'initialization' }
RushCompiledCodeBrowser >> initializeHeaderPresenter [

	headerDescription := self newText.
	headerDescription
		placeholder: 'Description';
		text: '';
		beNotEditable;
		addStyle: 'iceTipReadonly';
		addStyle: 'iceTipText4Lines';
		beWrapWord
]

{ #category : 'initialization' }
RushCompiledCodeBrowser >> initializePresenters [

	super initializePresenters.
	self
		initializeBytecodePresenter;
		initializeHeaderPresenter
]

{ #category : 'initialization' }
RushCompiledCodeBrowser >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Compiled Code Browser';
		initialExtent: 800 @ 600
]

{ #category : 'layout' }
RushCompiledCodeBrowser >> lowerPaneLayout [

	^ SpPanedLayout newLeftToRight
		positionOfSlider: 0.3;
		add: (	SpPanedLayout newTopToBottom
			positionOfSlider: 0.5;
			add: classComment;
			add: classDefinition;
			yourself);
		add: (SpPanedLayout newLeftToRight
			positionOfSlider: 0.3;
			add: srcCodePresenter;
			add: (SpPanedLayout newTopToBottom
				positionOfSlider: 0.3;
				add: headerDescription;
				add: bytecodesPresenter;
				yourself);
			yourself);
		yourself
]
