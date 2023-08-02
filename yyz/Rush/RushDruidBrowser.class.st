Class {
	#name : #RushDruidBrowser,
	#superclass : #RushBasicClassBrowser,
	#instVars : [
		'druidPresenter',
		'methodCompiler',
		'currentInstalledClass'
	],
	#category : #Rush
}

{ #category : #private }
RushDruidBrowser class >> menuRushPBBrowserOn: aBuilder [
	<worldMenu>

	(aBuilder item: #RushDruid)
		parent: #Tools;
		label: 'Rush Druid Browser';
		icon: (self iconNamed: #catalog);
		action: [ RushDruidBrowser new open ];
		help: 'Rush Druid Browser';
		order: 628
]

{ #category : #opening }
RushDruidBrowser class >> openOn: aClass [ 

	self new
		selectClass: aClass;
		open
]

{ #category : #private }
RushDruidBrowser >> connectInstMethodsPresenter [

	super connectInstMethodsPresenter.

	classes
		transmitTo: instProtocols
		transform: [ :aClass |
			self updateInterpreterFor: aClass.
			self buildOrganizationProtocols: aClass ]
		postTransmission: [ :destination :origin | self selectAllProtocolIn: destination ].

	instMethods whenSelectionChangedDo: [ : selection |
		selection selectedItem
			ifNotNil: [ : mth |
				druidPresenter script: [ : aCanvas |
					self renderCfg: aCanvas for: selection selectedItem ] ] ]
]

{ #category : #private }
RushDruidBrowser >> createClassNamed: aClassName instVars: instVarCollection [

	^ self class classInstaller make: [ :aClassBuilder |
		aClassBuilder
			name: aClassName;
			superclass: DruidTestInterpreter;
			slots: instVarCollection;
			package: 'ToDelete' ]
]

{ #category : #accessing }
RushDruidBrowser >> currentInstalledClass [

	^ currentInstalledClass
]

{ #category : #accessing }
RushDruidBrowser >> currentInstalledClass: anObject [

	currentInstalledClass := anObject
]

{ #category : #initialization }
RushDruidBrowser >> defaultMethodCompiler [

	^ DRMethodCompilerCompiler new
		interpreter: DruidTestInterpreter basicNew;
		irGenerator: DRMethodIRGenerator new;
		yourself
]

{ #category : #accessing }
RushDruidBrowser >> druidPresenter [

	^ druidPresenter
]

{ #category : #accessing }
RushDruidBrowser >> druidPresenter: anObject [

	druidPresenter := anObject
]

{ #category : #initialization }
RushDruidBrowser >> initializeDruidPresenter [

	druidPresenter := self newRoassal
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
		add: classDefinition;
		add: (SpBoxLayout newLeftToRight
			spacing: 5;
			add: srcCodePresenter;
			yourself);
		yourself
]

{ #category : #initialization }
RushDruidBrowser >> methodCompiler [

	^ methodCompiler
		ifNil: [ methodCompiler := self defaultMethodCompiler ]
]

{ #category : #accessing }
RushDruidBrowser >> methodCompiler: anObject [

	methodCompiler := anObject
]

{ #category : #private }
RushDruidBrowser >> renderCfg: aCanvas for: aMethod [

	| canvasController |
	
	(self methodCompiler generateDruidIRFor: aMethod) configureVisualization: aCanvas "inspectionCFG".
	canvasController := RSCanvasController new.
	canvasController configuration useBasicZoom.
	aCanvas @ canvasController
]

{ #category : #private }
RushDruidBrowser >> updateInterpreterFor: aClass [

	| newClassName |
	
	self methodCompiler interpreter class = aClass ifTrue: [ ^ self ].

	self halt.
	self currentInstalledClass ifNotNil: [ 
		Smalltalk at: self currentInstalledClass asSymbol
			ifPresent: [ Smalltalk removeClassNamed: self currentInstalledClass ] ].
	newClassName := 'Interp' , aClass name.
	self createClassNamed: newClassName instVars: aClass instVarNames.
	self currentInstalledClass: newClassName.
	self methodCompiler interpreter: self currentInstalledClass.
	^ { aClass }
]

{ #category : #layout }
RushDruidBrowser >> upperPaneLayout [

	^ SpBoxLayout newTopToBottom 
		add: classPathBreadcrumb expand: false;
		add: (SpBoxLayout newLeftToRight
			spacing: self spacingBetweenPanes;
			add: self classesLayout width: 150;
			add: self classMethodsLayout width: 150;
			add: self instMethodsLayout width: 190;
			add: druidPresenter;
			yourself);
		yourself
]
