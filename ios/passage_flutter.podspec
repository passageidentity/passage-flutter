Pod::Spec.new do |s|
  s.name             = 'passage_flutter'
  s.version          = '1.0.1'
  s.summary          = 'Passkey Complete for Flutter - Go completely passwordless with a standalone auth solution in your Flutter app with Passage by 1Password'
  s.description      = <<-DESC
Passkey Complete for Flutter - Go completely passwordless with a standalone auth solution in your Flutter app with Passage by 1Password
                       DESC
  s.homepage         = 'https://docs.passage.id/complete'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Passage by 1Password' => 'support@passage.id' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'PassageSwift', '1.0.2'
  s.platform = :ios, '14.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
