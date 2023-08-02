Class {
	#name : #RushAbstractBrowser,
	#superclass : #SpPresenter,
	#category : #Rush
}

{ #category : #private }
RushAbstractBrowser class >> menuRushBrowserOn: aBuilder [
	<worldMenu>

	(aBuilder item: #Rush)
		parent: #Tools;
		label: 'Rush Class Browser';
		icon: (self iconNamed: #catalog);
		action: [ RushClassBrowser new open ];
		help: 'Rush Class Hierarchy Browser';
		order: 627
]

{ #category : #private }
RushAbstractBrowser class >> menuRushPBBrowserOn: aBuilder [
	<worldMenu>

	(aBuilder item: #RushPB)
		parent: #Tools;
		label: 'Rush Packages Browser';
		icon: (self iconNamed: #catalog);
		action: [ RushPackagesBrowser new open ];
		help: 'Rush Class Hierarchy Browser';
		order: 628
]

{ #category : #'instance creation' }
RushAbstractBrowser class >> open [ 
	<script>
	
	^ self new open
]

{ #category : #initialization }
RushAbstractBrowser >> browserTitle [
		
	self shouldBeImplemented
]

{ #category : #initialization }
RushAbstractBrowser >> connectPresenters [

	self subclassResponsibility
]

{ #category : #layout }
RushAbstractBrowser >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: self spacingBetweenPanes;
		  add: self upperPaneLayout;
		  add: self lowerPaneLayout;
		  yourself
]

{ #category : #initialization }
RushAbstractBrowser >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self browserTitle;
		initialExtent: 1000 @ 700;
		centered
]

{ #category : #layout }
RushAbstractBrowser >> lowerPaneLayout [

	self subclassResponsibility
]

{ #category : #accessing }
RushAbstractBrowser >> spacingBetweenPanes [
	
	^ 5
]

{ #category : #layout }
RushAbstractBrowser >> upperPaneLayout [

	self subclassResponsibility
]
