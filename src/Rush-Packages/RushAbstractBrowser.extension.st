Extension { #name : 'RushAbstractBrowser' }

{ #category : '*Rush-Packages' }
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
