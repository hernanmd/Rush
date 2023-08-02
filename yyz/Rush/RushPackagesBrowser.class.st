Class {
	#name : #RushPackagesBrowser,
	#superclass : #RushBasicClassBrowser,
	#instVars : [
		'packages',
		'packagesPresenter'
	],
	#category : #Rush
}

{ #category : #layout }
RushPackagesBrowser >> classTemplateFor: aPackage [

	aPackage ifNil: [ ^ '' ].

	^ 'Object subclass: #NameOfSubclass
	slots: {}
	classVariables: {}
	package: ''' , aPackage name , ''' '
]

{ #category : #initialization }
RushPackagesBrowser >> connectPackagesPresenter [

	packagesPresenter
		transmitTo: classes
		transform: [ :aPackage |
			aPackage
				ifNotNil: [ aPackage definedClasses asArray ]
				ifNil: [ #(  ) ] ].

	packagesPresenter
		transmitTo: classDefinition
		transform: [ :aPackage | self classTemplateFor: aPackage ]
]

{ #category : #initialization }
RushPackagesBrowser >> connectPresenters [

	self connectPackagesPresenter.
	super connectPresenters.
]

{ #category : #initialization }
RushPackagesBrowser >> defaultClasses [

	^ Array empty
]

{ #category : #initialization }
RushPackagesBrowser >> defaultPackages [

	^ RPackageOrganizer default packages
]

{ #category : #initialization }
RushPackagesBrowser >> initializePackagesPresenter [

	packagesPresenter := self newFilteringList.
	packagesPresenter listPresenter
		display: [ :package | package name ];
		displayIcon: [ self iconNamed: #package ];
		sortingBlock: [ :a :b | a name < b name ];
		items: self packages
]

{ #category : #initialization }
RushPackagesBrowser >> initializePresenters [ 

	super initializePresenters.
	self initializePackagesPresenter.
]

{ #category : #opening }
RushPackagesBrowser >> openOnClass: aClass [

	packagesPresenter items: self defaultPackages.
	packagesPresenter selectItem: (RPackageOrganizer default packageOf: aClass).
	super openOnClass: aClass
]

{ #category : #opening }
RushPackagesBrowser >> openOnMethod: aMethod [ 

	packagesPresenter selectItem: (RPackageOrganizer default packageOf: aMethod methodClass) packageName.
	super openOnMethod: aMethod.
]

{ #category : #initialization }
RushPackagesBrowser >> packages [

	^ packages
		ifNil: [ packages := self defaultPackages ]
]

{ #category : #layout }
RushPackagesBrowser >> packagesLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Packages' expand: false;
		  add: packagesPresenter;
		  yourself
]

{ #category : #layout }
RushPackagesBrowser >> upperPaneLayout [

	^ SpBoxLayout newTopToBottom 
		add: classPathBreadcrumb expand: false;
		add: (SpBoxLayout newLeftToRight
			spacing: self spacingBetweenPanes;
			add: self packagesLayout;
			add: self classesLayout;

			add: (SpBoxLayout newTopToBottom
				spacing: self spacingBetweenPanes;
				add: self classProtocolsLayout;
				add: self classVarsLayout;
				yourself);
			add: self classMethodsLayout;

			add: (SpBoxLayout newTopToBottom
				spacing: self spacingBetweenPanes;
				add: self instProtocolsLayout;
				add: self instVarsLayout;
				yourself);
			add: self instMethodsLayout;
			yourself);
		yourself
]
