Class {
	#name : 'RushAbstractBrowser',
	#superclass : 'SpPresenter',
	#category : 'Rush-Core',
	#package : 'Rush',
	#tag : 'Core'
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

{ #category : 'instance creation' }
RushAbstractBrowser class >> open [ 
	<script>
	
	^ self new open
]

{ #category : 'opening' }
RushAbstractBrowser class >> openOnClass: aClass [

	self open selectClass: aClass
]

{ #category : 'initialization' }
RushAbstractBrowser >> browserTitle [
		
	self shouldBeImplemented
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
