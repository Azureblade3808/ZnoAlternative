workspace 'ZnoAlternative'

# project 'app'

target 'app' do
	project 'app/app'
	
	platform :ios, '11.0'
	
	use_frameworks!
	inhibit_all_warnings!
end

# project 'ui'

target 'ui' do
	project 'ui/ui'
	
	platform :ios, '11.0'
	
	use_frameworks!
	inhibit_all_warnings!
	
	pod 'KMSOrientationPatch'
end

target 'ui tests' do
	project 'ui/ui'
	
	platform :ios, '11.0'
	
	use_frameworks!
	inhibit_all_warnings!
	
	pod 'Nimble'
	pod 'Quick'
end
