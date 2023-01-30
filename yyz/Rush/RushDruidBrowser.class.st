Class {
	#name : #RushDruidBrowser,
	#superclass : #RushCompiledCodeBrowser,
	#instVars : [
		'druidPresenter',
		'methodCompiler'
	],
	#category : #Rush
}

{ #category : #opening }
RushDruidBrowser class >> openOn: aClass [ 

	self new
		selectClass: aClass;
		open
]

{ #category : #'private-instance side' }
RushDruidBrowser >> connectInstMethodsPresenter [

	super connectInstMethodsPresenter.

	instMethods whenSelectionChangedDo: [ : selection | 
		selection selectedItem
			ifNotNil: [ : mth | 
				druidPresenter script: [ : aCanvas |
					self renderCfg: aCanvas for: selection selectedItem ] ] ].
]

{ #category : #initialization }
RushDruidBrowser >> defaultMethodCompiler [

	^ DRMethodCompilerCompiler new
		interpreter: DruidTestInterpreter basicNew;
		irGenerator: DRMethodIRGenerator new;
		yourself
]

{ #category : #initialization }
RushDruidBrowser >> initializeDruidPresenter [

	druidPresenter := self newRoassal.

]

{ #category : #initialization }
RushDruidBrowser >> initializePresenters [

	super initializePresenters.
	self
		initializeDruidPresenter
]

{ #category : #layout }
RushDruidBrowser >> lowerPaneLayout [

	^ SpPanedLayout newLeftToRight
		positionOfSlider: 0.3;
		add: (	SpPanedLayout newTopToBottom
			positionOfSlider: 0.5;
			add: classComment;
			add: classDefinition;
			yourself);
		add: (SpBoxLayout newLeftToRight
			spacing: 5;		
			add: code;
			add: (SpPanedLayout newTopToBottom
				positionOfSlider: 0.3;
				add: headerDescription;
				add: bytecodesPresenter;
				yourself);
			add: druidPresenter;
			yourself);
		yourself
]

{ #category : #initialization }
RushDruidBrowser >> methodCompiler [

	^ methodCompiler
		ifNil: [ methodCompiler := self defaultMethodCompiler ]
]

{ #category : #'private-instance side' }
RushDruidBrowser >> renderCfg: aCanvas for: aMethod [

	| canvasController |
	
	(self methodCompiler generateDruidIRFor: aMethod) showIn: aCanvas "inspectionCFG".
	canvasController := RSCanvasController new.
	canvasController configuration useBasicZoom.
	aCanvas @ canvasController
]
