Class {
	#name : #BaselineOfRush,
	#superclass : #BaselineOf,
	#category : #BaselineOfRush
}

{ #category : #baselines }
BaselineOfRush >> baseline: spec [
  <baseline>
	spec
		for: #(common)
		do: [ 
			spec 
				package: 'Rush';
				package: 'Rush-Tests'	with: [ spec requires: #(Rush) ].
			spec 
				group: 'Core' 						with: #('Rush');
				group: 'Tests' 						with: #('Rush' 'Rush-Tests');
				group: 'default' 					with: #('Core' 'Tests') ]
]
