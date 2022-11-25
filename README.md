# NASAImageAndVideosApp

Libraries used:
1. Used Alamofire library for network requests. I choose this as this is popular one and has great support from open source contributors. Last commit was 3 days ago which means people are actively contributing to this.
2. Used Kingfisher library for image downloads. I choose this as this is popular one and has great support from open source contributors.

App architecture:
1. I used autolayout with constraints to build this app. 
2. Inital view controller was setup with storyboard. 
4. After that all viewcontoller are programatically created and added to navigation stack. 
4. I followed MVVM pattern to make that all functinal logic is in viewmodel and view controller only took care of views setup. 
5. I injected dependencies through initializers so that they can be mocked whererver necessary to write unit tests.
6. In order to mock Alamofire we could can use https://github.com/WeTransfer/Mocker so that can write unit/integration tests.

Setup:
1. Download the zipfile. Unzip it and goto NASAImagesAndVideo folder. Now open NASAImagesAndVideo.xcworkspace file.(Please ignore the name NASAImagesAndVideo. It should be NASAImages. I will update it soon). Now run the app with NASAImagesAndVideo target and iPhone simulator of your choice.
