(function(exports) {
  // bundle id
  exports.appId = function() {
    return NSBundle.mainBundle.bundleIdentifier;
  }

  // main bundle path
  exports.appPath = function() {
    return NSBundle.mainBundle.bundlePath;
  }

  // keyWindows
  exports.keyWindow = function() {
    return UIApp.keyWindow;
  }

  // 打印所有的视图
  exports.views = function() {
    return [[UIApp keyWindow] recursiveDescription].toString();
  }

  // 查找指定视图的控制器
  exports.findVc = function(view) {
    var curView = view;
    while ([curView isKindOfClass:[NSClassFromString(@"UIViewController")]]!= true) {
      curView = curView.nextResponder;
    }
    return curView;
  }

  // 打印对象的所有属性
  exports.printIvars = function(obj) {
    var ivars = [];
    for (i in *obj) {
      try {
        ivars[i] = (*obj)[i];
      } catch (e) {}
    }
    return ivars;
  }

  // 根控制器
  exports.rootVc = function() {
    UIApp.keyWindow.rootViewController;
  }
  
})(exports);