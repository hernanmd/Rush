Class {
	#name : #RushASTBrowser,
	#superclass : #RushBrowser,
	#instVars : [
		'rbAst'
	],
	#category : #Rush
}

{ #category : #'instance creation' }
RushASTBrowser class >> open [ 
	<script>
	
	^ self new open
]

{ #category : #'private-instance side' }
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

{ #category : #initialization }
RushASTBrowser >> initializePresenters [

	super initializePresenters.
	self initializeRBAst
]

{ #category : #initialization }
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

{ #category : #initialization }
RushASTBrowser >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'AST Browser';
		initialExtent: 800 @ 600
]

{ #category : #layout }
RushASTBrowser >> lowerPaneLayout [

	^  SpBoxLayout newLeftToRight
			spacing: self spacingBetweenPanes;
			add: classComment;
			add: mthSrcPresenter;
			add: rbAst;
			yourself
]
