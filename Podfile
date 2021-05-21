platform :ios, '12.0'

def rx_swift
  pod 'RxSwift', '~> 5.1.0'
  pod 'RxOptional'
  pod 'Alamofire'
  pod 'RxAlamofire'
end

def rx_cocoa
  pod 'RxCocoa'
  pod 'RxDataSources'
end


# CocoaLumberjack is a fast & simple, yet powerful & flexible logging framework for Mac and iOS.
def cocoaLumberjack
  pod 'CocoaLumberjack/Swift'
end

target 'Rijksmuseum' do
  use_frameworks!

  rx_cocoa
  rx_swift
  cocoaLumberjack
  pod 'PKHUD', '~> 5.0'
  pod 'Nuke'

  target 'RijksmuseumTests' do
    inherit! :search_paths
    pod 'RxBlocking'
    pod 'RxTest'
  end

  target 'RijksmuseumUITests' do
    # Pods for testing
  end

end
