Pod::Spec.new do |s|
  s.name      = 'HDLibraries'
  s.version   = '0.1'
  s.summary   = 'An iOS utility framework.'
  s.homepage  = 'https://github.com/TrahDivad/HDLibraries/'
  s.author    = { 'David Hart' => 'david@hart-dev.com' }
  s.source    = { :git => 'https://github.com/TrahDivad/HDLibraries' }

  s.platform      = :ios, '5.0'
  s.requires_arc  = true
  
  s.subspec 'HDFoundation' do |fo|
    fo.source_files = 'HDFoundation/*.{h,m}'
    fo.frameworks   = ['Foundation', 'CoreGraphics']
    fo.dependency 'Nimbus/Core'
  end
  
  s.subspec 'HDCoreData' do |cd|
    cd.source_files = 'HDCoreData/*.{h,m}'
    cd.frameworks   = ['Foundation', 'CoreData']
    cd.dependency 'Nimbus/Core'
  end
  
  s.subspec 'HDAudio' do |au|
    au.source_files = 'HDAudio/*.{h,m}'
    au.frameworks   = ['Foundation', 'AVFoundation']
    au.dependency 'Nimbus/Core'
  end
 
 s.subspec 'HDKit' do |ki|
   ki.source_files = 'HDKit/*.{h,m}'
   ki.frameworks   = ['Foundation', 'CoreGraphics', 'QuartzCore', 'UIKit']
   ki.dependency 'Nimbus/Core'
 end
 
 s.subspec 'HDGameKit' do |gk|
   gk.source_files = 'HDGameKit/*.{h,m}'
   gk.frameworks   = ['Foundation', 'GameKit']
   gk.dependency 'Nimbus/Core'
 end
end