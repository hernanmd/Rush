Extension { #name : 'RushAbstractBrowser' }

{ #category : '*Rush-Slang' }
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
