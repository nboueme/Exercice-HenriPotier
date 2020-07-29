platform :ios, '10.0'
use_frameworks!

target 'HenriPotier' do
  pod 'Alamofire', '~> 5.2'
  pod 'DZNEmptyDataSet'
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'Swinject'
  pod 'SwinjectAutoregistration'
  pod 'SwinjectStoryboard', :git => 'https://github.com/Swinject/SwinjectStoryboard.git', :commit => '0ca45c83a8aa398c153d8a036c95abb4343cfa0c'
  
  target 'HenriPotierTests' do
      inherit! :search_paths
      pod 'RxBlocking', '~> 5'
      pod 'RxTest', '~> 5'
  end
end
