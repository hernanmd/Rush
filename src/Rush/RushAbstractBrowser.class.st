Class {
	#name : 'RushAbstractBrowser',
	#superclass : 'SpPresenter',
	#category : 'Rush',
	#package : 'Rush'
}

{ #category : 'private' }
RushAbstractBrowser class >> menuRushBasicBrowserOn: aBuilder [
	<worldMenu>

	(aBuilder item: #Rush)
		parent: #Tools;
		label: 'Rush Basic Class Browser';
		icon: (self iconNamed: #catalog);
		action: [ RushBasicClassBrowser new open ];
		help: 'Basic Class Hierarchy Browser';
		order: 626
]

{ #category : 'private' }
RushAbstractBrowser class >> menuRushBrowserOn: aBuilder [
	<worldMenu>

	(aBuilder item: #RushCB)
		parent: #Tools;
		label: 'Rush Class Browser';
		icon: (self iconNamed: #catalog);
		action: [ RushClassBrowser new open ];
		help: 'Rush Class Hierarchy Browser';
		order: 627
]

{ #category : 'private' }
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

{ #category : 'private' }
RushAbstractBrowser class >> menuRushSlangBrowserOn: aBuilder [
	<worldMenu>

	(aBuilder item: #RushSB)
		parent: #Tools;
		label: 'Rush Slang Browser';
		icon: (self iconNamed: #catalog);
		action: [ RushSlangBrowser new open ];
		help: 'Slang Browser';
		order: 625
]

{ #category : 'instance creation' }
RushAbstractBrowser class >> open [ 
	<script>
	
	^ self new open
]

{ #category : 'initialization' }
RushAbstractBrowser >> browserTitle [
		
	self shouldBeImplemented
]

{ #category : 'initialization' }
RushAbstractBrowser >> connectPresenters [

	self subclassResponsibility
]

{ #category : 'layout' }
RushAbstractBrowser >> defaultLayout [

	^ SpPanedLayout newTopToBottom
		  add: self upperPaneLayout;
		  add: self lowerPaneLayout;
		  yourself
]

{ #category : 'initialization' }
RushAbstractBrowser >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self browserTitle;
		initialExtent: 1000 @ 700;
		centered
]

{ #category : 'layout' }
RushAbstractBrowser >> lowerPaneLayout [

	self subclassResponsibility
]

{ #category : 'accessing' }
RushAbstractBrowser >> spacingBetweenPanes [
	
	^ 5
]

{ #category : 'layout' }
RushAbstractBrowser >> upperPaneLayout [

	self subclassResponsibility
]
