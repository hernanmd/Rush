Class {
	#name : 'BaselineOfRush',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfRush',
	#package : 'BaselineOfRush'
}

{ #category : 'baselines' }
BaselineOfRush >> baseline: spec [
  <baseline>
	spec
		for: #(common)
		do: [ 
			spec 
				package: 'Rush';
				package: 'Rush-Packages'  with: [ spec requires: #(Rush) ];
				package: 'Rush-Slang'     with: [ spec requires: #(Rush) ];
				package: 'Rush-Druid'     with: [ spec requires: #(Rush) ];
				package: 'Rush-Tests'	     with: [ spec requires: #(Rush) ].

			spec 
				group: 'Core' 						with: #('Rush');
				group: 'Slang'                 with: #('Rush' '');
				group: 'Packages'              with: #('Rush');
				group: 'Druid'                 with: #('Rush');
				group: 'Tests' 						with: #('Rush' 'Rush-Tests');
				group: 'default' 					with: #('Core' 'Tests') ]
]
