Class {
	#name : 'RushASTBrowser',
	#superclass : 'RushClassBrowser',
	#instVars : [
		'rbAst'
	],
	#category : 'Rush',
	#package : 'Rush'
}

{ #category : 'instance creation' }
RushASTBrowser class >> open [ 
	<script>
	
	^ self new open
]

{ #category : 'private-instance side' }
RushASTBrowser >> connectInstMethodsPresenter [

	super connectInstMethodsPresenter.

	instMethods
		transmitTo: rbAst
		transform: [ : aMethod |
			aMethod
				ifNil: [ Array empty ]
				ifNotNil: [ { aMethod ast } ] ]
		postTransmission: [ : m | rbAst expandAll ]
]

{ #category : 'initialization' }
RushASTBrowser >> initializePresenters [

	super initializePresenters.
	self initializeRBAst
]

{ #category : 'initialization' }
RushASTBrowser >> initializeRBAst [

	rbAst := self newTree.
	rbAst
		display: [ :each |
			String
				streamContents: [ :stream |
					stream
						nextPutAll: each class name;
						nextPut: $(;
						nextPutAll: ((each formattedCode truncateTo: 50) copyReplaceAll: String cr with: String space);
						nextPut: $)
			 ] ];
		items: OrderedCollection new;
		children: [ :each | each children ]
]

{ #category : 'initialization' }
RushASTBrowser >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'AST Browser';
		initialExtent: 800 @ 600
]

{ #category : 'layout' }
RushASTBrowser >> lowerPaneLayout [

	^  SpBoxLayout newLeftToRight
			spacing: self spacingBetweenPanes;
			add: classComment;
			add: srcCodePresenter;
			yourself
]

{ #category : 'layout' }
RushASTBrowser >> upperPaneLayout [

	^ SpBoxLayout newTopToBottom 
		add: classPathBreadcrumb expand: false;
		add: (SpBoxLayout newLeftToRight
			spacing: self spacingBetweenPanes;
			add: self classesLayout;

			add: (SpBoxLayout newTopToBottom
				spacing: self spacingBetweenPanes;
				add: self classVarsLayout;
				add: self classProtocolsLayout;				
				add: self classMethodsLayout;
				yourself);

			add: (SpBoxLayout newTopToBottom
				spacing: self spacingBetweenPanes;
				add: self instProtocolsLayout;
				add: self instVarsLayout;
				yourself);
			add: self instMethodsLayout;
			add: rbAst;			
			yourself);
		yourself
]
